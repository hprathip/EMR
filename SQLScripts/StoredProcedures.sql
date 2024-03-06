-- add_doctor ---> To add doctor
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_doctor`(IN doctorId VARCHAR(10), IN doctorName VARCHAR(50), IN doctorGender VARCHAR(10), IN doctorContactNo VARCHAR(10),
IN doctorDOB DATE, IN doctorAddress VARCHAR(50), IN doctorEmailId VARCHAR(50), IN doctorSalary DECIMAL(10,2), IN doctorExperience INT, 
IN specIdArray VARCHAR(100))
BEGIN
DECLARE specId INT;
    DECLARE front TEXT DEFAULT NULL;
    DECLARE frontlen INT DEFAULT NULL;
    DECLARE TempValue TEXT DEFAULT NULL;

	INSERT INTO Doctor values(doctorId, doctorName, doctorGender, doctorContactNo, doctorDOB, 
	doctorAddress, doctorEmailId, doctorSalary, doctorExperience);
iterator:
    LOOP  
    IF LENGTH(TRIM(specIdArray)) = 0 OR specIdArray IS NULL THEN
    LEAVE iterator;
    END IF;
    SET front = SUBSTRING_INDEX(specIdArray,',',1);
    SET frontlen = LENGTH(front);
    SET TempValue = TRIM(front);
    INSERT INTO Doctor_Has_Specialization VALUES (doctorId, CAST(TempValue AS UNSIGNED));
    SET specIdArray = INSERT(specIdArray,1,frontlen + 1,'');
    END LOOP;
   
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- add_equipment ---> To add equipment
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_equipment`(IN equipName VARCHAR(20), IN suppId VARCHAR(10))
BEGIN
INSERT INTO Equipment (equipmentName, supplierId) VALUES (equipName, suppId);
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- add_insuranceProvider ---> To add Insurance Provider
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_insuranceProvider`(IN insuranceCompanyCode VARCHAR(10), IN insuranceCompanyName VARCHAR(50), 
IN insuranceCompanyAddress VARCHAR(50))
BEGIN
	INSERT INTO InsuranceCompany VALUES (insuranceCompanyCode,insuranceCompanyName,insuranceCompanyAddress);
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- add_medicalrecord  ---> To add Medical Record
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_medicalrecord`(IN MRId VARCHAR(30), IN patientId VARCHAR(10), IN appointmentId INT, IN signs VARCHAR(50),
IN symptoms VARCHAR(100), IN diseaseDignosed VARCHAR(100), IN treatmentSuggested VARCHAR(50), IN clinicalNotes VARCHAR(300), IN doctorId VARCHAR(10))
BEGIN
	DECLARE treatId INT;
	SET treatId = 0;
    
    INSERT INTO MedicalRecord VALUES (MRId, patientId, appointmentId, signs,
	symptoms, diseaseDignosed,treatmentSuggested, clinicalNotes);
    
    IF treatmentSuggested!='No Facility' THEN
    SELECT treatmentId INTO treatId from treatment
    WHERE treatmentName = treatmentSuggested;
    END IF;
    
    IF treatId!=0 THEN
    INSERT INTO Patient_Undergoes_Treatment VALUES (patientId, treatId, doctorId, appointmentId);
    END IF;
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- add_medicine ---> To add Medicine
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_medicine`(IN medName VARCHAR(30), IN medPrice DECIMAL(10, 2), IN expDate DATE, IN suppId VARCHAR(10))
BEGIN
	INSERT INTO Medicine (medicineName, medicinePrice, expiryDate, supplierId) VALUES (medName, medPrice, expDate, suppId);
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- add_room ---> TO add Room
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_room`(IN treatName VARCHAR(50), IN rName VARCHAR(30), IN rLocation VARCHAR(30))
BEGIN
	DECLARE treatId INT;
    
    IF treatName!='None' THEN
    SELECT treatmentId INTO treatId
    FROM Treatment
    WHERE treatmentName = treatName;
    ELSE 
    SET treatId = NULL;
    END IF;

	INSERT INTO Room (treatmentId, roomName, roomLocation)
	VALUES (treatId, rName, rLocation)
	ON DUPLICATE KEY UPDATE treatmentId = treatId, roomLocation= rLocation;
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- add_treatment  ---> TO add Treatment
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_treatment`(IN treatName VARCHAR(50), IN treatCost DECIMAL(10,2))
BEGIN
	INSERT INTO Treatment(treatmentName, treatmentCost) VALUES (treatName, treatCost);
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- book_apt ---> TO Book Appointment
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `book_apt`(IN doc_id VARCHAR(10), IN pat_id VARCHAR(10), IN aptSlot DATETIME)
BEGIN
INSERT INTO APPOINTMENT(doctorId, patientId, appointmentSlot) VALUES 
	(doc_id, pat_id, aptSlot);
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- did_generator ---> To generate Doctor Id
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `did_generator`(OUT did VARCHAR(10))
BEGIN
	SELECT doctorId INTO did
    FROM Doctor ORDER BY doctorId DESC LIMIT 1;
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- get_appointments ---> To get all Appointments in order
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_appointments`()
BEGIN
	SELECT a.appointmentId, DATE(a.appointmentSlot), TIME(a.appointmentSlot), p.patientId, p.patientName, d.doctorName, m.diseaseDignosed 
    FROM Appointment a
    INNER JOIN Patient p
    ON p.patientId = a.patientId
    INNER JOIN Doctor d
    ON d.doctorId = a.doctorId
    LEFT JOIN MedicalRecord m
    ON m.appointmentId=a.appointmentId
    ORDER BY a.appointmentSlot DESC;
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- get_doctors ---> To get all doctors
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_doctors`()
BEGIN
	SELECT CONCAT(d.doctorId,",", d.doctorName) AS 'DoctorInfo'
	FROM doctor d;
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- get_medicine ---> To get search key medicine
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_medicine`(IN searchType VARCHAR(50), IN keyword VARCHAR(50))
BEGIN
	IF searchType='Medicine Id' THEN SELECT * FROM Medicine WHERE medicineId LIKE CONCAT('%',keyword,'%');
	ELSEIF searchType='Name' THEN SELECT * FROM Medicine WHERE medicineName LIKE CONCAT('%',keyword,'%');
    ELSEIF searchType='Supplier' THEN SELECT * FROM Medicine WHERE supplierId LIKE CONCAT('%',keyword,'%');
    END IF;
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- get_medicines ---> To get all medicines with id and name speperated by coma
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_medicines`()
BEGIN
	SELECT CONCAT(m.medicineId,",", m.medicineName) AS 'Medicines'
	FROM Medicine m;
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- get_specs ---> To get all specializations
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_specs`()
BEGIN
	SELECT CONCAT(s.specializationId,",", s.specializationName) AS 'Specs'
	FROM Specialization s;
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- getAll_equipment ---> To get all equipment
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAll_equipment`()
BEGIN
	SELECT *
	FROM Equipment;
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- getAll_insuranceCompsList ---> To get all insuance providers list
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAll_insuranceCompsList`()
BEGIN
	SELECT CONCAT(insuranceCompanyCode,",",insuranceCompanyName) as 'ProviderInfo'
    FROM InsuranceCompany;
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- getAll_medicines ---> To get all the medicines
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAll_medicines`()
BEGIN
	SELECT *
	FROM Medicine;
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- getAll_treatments ---> To get all treatments
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAll_treatments`()
BEGIN
	SELECT treatmentName from Treatment;
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- getKey_equipment ---> To get the search key equipment
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getKey_equipment`(IN searchType VARCHAR(50), IN keyword VARCHAR(50))
BEGIN
	IF searchType='Equipment Id' THEN SELECT * FROM Equipment WHERE equipmentId LIKE CONCAT('%',keyword,'%');
	ELSEIF searchType='Name' THEN SELECT * FROM Equipment WHERE equipmentName LIKE CONCAT('%',keyword,'%');
    ELSEIF searchType='Supplier' THEN SELECT * FROM Equipment WHERE supplierId LIKE CONCAT('%',keyword,'%');
    END IF;
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- getPatients_insuranceCover ---> To get patient's insurance cover details
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getPatients_insuranceCover`(IN pId VARCHAR(10))
BEGIN
	select * from insurancecover where patientId=pId;
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- getSpecific_MR ---> To get a specific medical record
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getSpecific_MR`(IN patId VARCHAR(10), IN aptId INT)
BEGIN
	SELECT * 
    FROM MedicalRecord
    WHERE patientId = patId AND appointmentId = aptId;
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- insert_insuranceCover ---> To add insurance to patient
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_insuranceCover`(IN insCompCode VARCHAR(10), IN policyNoInp VARCHAR(20), IN patientId VARCHAR(10), IN coPay DECIMAL(10,2),
IN coInsurance DECIMAL(10,2), IN policyExpiryDate DATE, IN insuranceGroupNumber INT)
BEGIN
	INSERT INTO InsuranceCover VALUES (insCompCode, policyNoInp, patientId, coPay, coInsurance, policyExpiryDate, insuranceGroupNumber);
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- mr_validator ---> To validate the medical record
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mr_validator`(IN patId VARCHAR(10), IN aptId INT)
BEGIN
	SELECT COUNT(MRId) AS 'Indicator' 
    FROM MedicalRecord
    WHERE patientId = patId AND appointmentId = aptId;
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- pid_generator ---> To generate Patient Id
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `pid_generator`(OUT pid VARCHAR(10))
BEGIN
SELECT patientId INTO pid
    FROM Patient ORDER BY patientId DESC LIMIT 1;
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- prescribe ---> TO add prescription for patient
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `prescribe`(IN patId VARCHAR(10), IN docId VARCHAR(10), 
IN medicineArray VARCHAR(1000), IN quantityArray VARCHAR(1000))
BEGIN
    DECLARE presId INT;
    DECLARE curDT DATETIME;
    
    DECLARE front TEXT DEFAULT NULL;
    DECLARE frontlen INT DEFAULT NULL;
    DECLARE TempValue TEXT DEFAULT NULL;
    
    DECLARE front1 TEXT DEFAULT NULL;
    DECLARE frontlen1 INT DEFAULT NULL;
    DECLARE TempValue1 TEXT DEFAULT NULL;
    
    SET curDT = CONCAT(current_date()," ",current_time());
	INSERT INTO Prescription (patientId,doctorId,prescriptionDate) VALUES (patId,docId, curDT);
    
    SELECT prescriptionId INTO presId
    FROM Prescription WHERE prescriptionDate=curDT AND patientId = patId;
    
    iterator:
    LOOP  
    IF LENGTH(TRIM(medicineArray)) = 0 OR medicineArray IS NULL THEN
    LEAVE iterator;
    END IF;
    SET front = SUBSTRING_INDEX(medicineArray,',',1);
    SET frontlen = LENGTH(front);
    SET TempValue = TRIM(front);
    SET front1 = SUBSTRING_INDEX(quantityArray,',',1);
    SET frontlen1 = LENGTH(front1);
    SET TempValue1 = TRIM(front1);
    INSERT INTO Prescription_Has_Medicine VALUES (presId, CAST(TempValue AS UNSIGNED), CAST(TempValue1 AS UNSIGNED));
    SET medicineArray = INSERT(medicineArray,1,frontlen + 1,'');
    SET quantityArray = INSERT(quantityArray,1,frontlen + 1,'');
    END LOOP;
    
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- register_patient ---> TO register new patient
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_patient`(IN patientId VARCHAR(10), IN patientName VARCHAR(50), IN  patientGender VARCHAR(10), 
IN patientContactNo VARCHAR(10), IN patientEmailId VARCHAR(30), IN patientDOB DATE, IN patientAddress VARCHAR(50))
BEGIN
INSERT INTO Patient values(patientId, patientName, patientGender, patientContactNo, 
	patientEmailId, patientDOB, patientAddress);
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- room_allocations ---> To view all the rooms allocation details
DELIMITER $
CREATE DEFINER=`root`@`localhost` PROCEDURE `room_allocations`()
BEGIN
	SELECT r.roomId, r.roomName, t.treatmentName, r.roomlocation
    FROM Room r
    LEFT JOIN Treatment t
    ON t.treatmentId = r.treatmentId;
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- search_patient ---> To fetch all details of patients based on key
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `search_patient`(IN searchType VARCHAR(50), IN keyword VARCHAR(50))
BEGIN
IF searchType='Patient Id' THEN SELECT * FROM Patient WHERE patientId LIKE CONCAT('%',keyword,'%');
	ELSEIF searchType='Patient Name' THEN SELECT * FROM Patient WHERE patientName LIKE CONCAT('%',keyword,'%');
    ELSEIF searchType='Patient PhoneNumber' THEN SELECT * FROM Patient WHERE patientContactNo LIKE CONCAT('%',keyword,'%');
    ELSEIF searchType='Patient Address' THEN SELECT * FROM Patient WHERE patientAddress LIKE CONCAT('%',keyword,'%');
    END IF;
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- treatment_analysis ---> To derive insights on the treatments suggested
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `treatment_analysis`()
BEGIN
SELECT treatmentSuggested, COUNT(*) AS 'Frequency'
    FROM MedicalRecord
    GROUP BY treatmentSuggested;
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- update_ic ---> To update insurance details of a patient
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_ic`(IN insuranceCompanyCodeInp varchar(10), IN policyNoInp varchar(20), IN patientIdInp varchar(10),
IN coPayInp decimal(10,2), IN coInsuranceInp decimal(10,2), IN policyExpiryDateInp date,IN insuranceGroupNumberInp int)
BEGIN
update insurancecover
set coPay = coPayInp, coInsurance = coInsuranceInp, policyExpiryDate = policyExpiryDateInp, insuranceGroupNumber= insuranceGroupNumberInp
where insuranceCompanyCode = insuranceCompanyCodeInp and policyNo = policyNoInp and patientId = patientIdInp;
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- update_mr ---> To update the medical record of a patient at particular visit
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_mr`(IN MRIdInp VARCHAR(30), IN patientIdInp VARCHAR(10), IN appointmentIdInp INT, IN signsInp VARCHAR(50),
IN symptomsInp VARCHAR(100), IN diseaseDignosedInp VARCHAR(100), IN treatmentSuggestedInp VARCHAR(50), IN clinicalNotesInp VARCHAR(300))
BEGIN
UPDATE MedicalRecord
    SET signs = signsInp, symptoms = symptomsInp, diseaseDignosed = diseaseDignosedInp, clinicalNotes = clinicalNotesInp
    WHERE MRId = MRIdInp AND patientId = patientIdInp AND appointmentId = appointmentIdInp;
END$$

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------