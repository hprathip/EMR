-- Basic Functions 

-- Q1. Find a patient with name and address – the script should return patient_id 
SELECT patientId FROM Patient
WHERE patientName="Max Hamilton" AND patientAddress = "934 Glen Apt, North Dougtown, WY 71062-1346";
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Q2. Find all patients who visited the clinic on a particular date – list patient name and diagnoses
 SELECT patientName, diseaseDignosed, clinicalNotes, CONVERT(a.appointmentSlot, DATE) AS 'dateOfDiagnosis'
 FROM Patient p 
 JOIN Appointment a ON p.patientId = a.patientId
 JOIN MedicalRecord r ON a.appointmentId = r.appointmentId
 WHERE CONVERT(a.appointmentSlot, DATE) = '2022-12-04';
-- ----------------------------------------------------------------------------------------------------------------------------------------------- 
-- Q3. Find the most prevalent illness (i.e. the diagnosis that occurred the most) of patients who 
-- visited the clinic during a given week and the most popular treatment prescribed for this illness 
 
SELECT diseaseDignosed, treatmentSuggested
FROM medicalrecord 
WHERE appointmentId IN
(SELECT appointmentId from appointment where convert(appointmentSlot, date) between '2022-11-03' AND '2022-12-04')
GROUP BY diseaseDignosed
HAVING COUNT(*)=
(SELECT COUNT(*) FROM medicalrecord 
GROUP BY diseaseDignosed 
ORDER BY COUNT(*) DESC LIMIT 1)
ORDER BY COUNT(*);
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Q4. Find the diagnoses of the patient(s) who visited the clinic twice within the shortest time interval 

SELECT a1.patientId as 'PatientId', diseaseDignosed as 'Disease Diagnosed'
from appointment a1
inner join appointment a2
on a1.patientId=a2.patientId
inner join medicalrecord mr
on a1.patientId = mr.patientId
where a1.appointmentSlot<>a2.appointmentSlot
and a1.appointmentId = mr.appointmentId
and a1.patientId in (SELECT patientId
from appointment
group by patientId
having count(*) = 2)
and datediff(a1.appointmentSlot, a2.appointmentSlot) = (select datediff(aa1.appointmentSlot, aa2.appointmentSlot) as 'diff' 
from appointment aa1
inner join appointment aa2
on aa1.patientId=aa2.patientId
where aa1.appointmentSlot<>aa2.appointmentSlot
and aa1.appointmentSlot>aa2.appointmentSlot
order by diff limit 1)
group by a1.patientId
order by a1.patientId;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Q5. Modify the insurance (insurance name, address, insurance group number) of a patient – if the 
-- insurance is not associated with the patient, then add the insurance, but if the insurance name is 
-- already associated with the patient, then update the rest of the information (address, group 
-- number etc.) 

-- Insurance code is obtained using the query below and stored. 
SELECT insuranceCompanyCode from insurancecompany where insuranceCompanyName = "Trace Suite Health Ltd.";
-- insuranceCode = INSP00005, which is used in the below query
-- if the insurance is not present for this patient, it's inserted, else the group number is updated. 

-- the insurance for patient "AEHP00001" already exists, so the group number is updated
INSERT INTO insurancecover (insuranceCompanyCode,policyNo, patientId, coPay, coInsurance, policyExpiryDate, insuranceGroupNumber) 
VALUES ("INSP00005", "CF6D4A45", "AEHP00001", 350, 100, '2025-01-07', 60111495)
ON DUPLICATE KEY UPDATE insuranceGroupNumber = 60211495;

-- the insurance for patient "AEHP00006" doesn't exist, so new record is inserted
INSERT INTO insurancecover (insuranceCompanyCode,policyNo, patientId, coPay, coInsurance, policyExpiryDate, insuranceGroupNumber) 
VALUES ("INSP00003", "64BDCBB4", "AEHP00006", 350, 100, '2025-01-07', 60111777)
ON DUPLICATE KEY UPDATE insuranceGroupNumber = 60111777;

-- Similarly, the address of the insurance company can be updated if exists or inserted if it doesn't exist
INSERT INTO insurancecompany (insuranceCompanyCode, insuranceCompanyName, insuranceCompanyAddress) 
VALUES ("INSP00004","Throughway ReAssurance","5220 Vincentchester, NV 55486")
ON DUPLICATE KEY UPDATE insuranceCompanyAddress = "5220 Vincentchester, NV 5555";
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Advanced Functions

-- Q6. The system will provide the details about the doctor’s experience and their specializations, 
-- which can be added or updated periodically

-- Querying the database to get the doctor, "Luca Walker" details of experience and her specializations 
select d.doctorId, d.doctorName, d.doctorExperience, GROUP_CONCAT(specializationName  separator ',') AS 'Specializations'
from doctor d
inner join doctor_has_specialization dhs
on d.doctorId = dhs.doctorId
inner join specialization s
on s.specializationId = dhs.specializationId
WHERE d.doctorId = 
(SELECT doctorId from doctor where doctorName = "Luca Walker");

-- Updating the doctor's specialization, doctorId = "AEHD00004"
insert into doctor_has_specialization values ("AEHD00004", 2);
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Q7. The system allows searching patient records efficiently based on the patientID, those who 
-- have taken a specific treatment or are being treated by a specific doctor

-- Querying the patient details who are undergoing specific treatment, "Corneal Grafts" under doctor, "Anna Davidson"
select p.patientId, p.patientName, p.patientGender
from patient p
inner join patient_undergoes_treatment put
on p.patientId = put.patientId
inner join treatment t
on t.treatmentId = put.treatmentId
inner join doctor d
on d.doctorId = put.doctorId
where t.treatmentId = (select treatmentId from treatment where treatmentName = "Corneal Grafts")
and d.doctorId = (select doctorId from doctor where doctorName = "Anna Davidson");

-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Q8.  The system can track the equipment data and mapping of each equipment with respective room. 
-- Querying the database to fetch the rooms with equipment number = 2
select e.equipmentId, e.equipmentName, r.roomId, r.roomName
from equipment e
inner join room_has_equipment rhe
on e.equipmentId = rhe.equipmentId
inner join room r
on r.roomId=rhe.roomId
where rhe.equipmentNo = 2;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Q9. Find the doctors who specializa in only 1 area
select d.doctorId, d.doctorName
from doctor d
inner join doctor_has_specialization dhs
on d.doctorId = dhs.doctorId
where d.doctorId in
(select doctorId from doctor_has_specialization group by doctorId having count(*)=1);
-- -----------------------------------------------------------------------------------------------------------------------------------------------
--  Q10. List all the prescriptions where there are more than 1 medicines and each medicine's quantity is greater than 1

select phm.prescriptionId, GROUP_CONCAT(m.medicineName  separator ',') as "List of Medicines"
from prescription_has_medicine phm
inner join medicine m
on m.medicineId = phm.medicineId
where phm.quantity>1
group by phm.prescriptionId
having count(*)>1;

-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Supplier Values: 
-- CHAIRSUP20, MACHSUP510, GENSUPP120, MACHSUP510, GENSUPP120
-- DROPSUPP01, ANESTSUP36, REGSUPP36, OintSUPP33, ANESTSUP36, DROPSUPP03, DROPSUPP01

INSERT INTO Room (treatmentId, roomName, roomLocation) VALUES (treatId, rName, rLocation);

INSERT INTO Room (treatmentId, roomName, roomLocation)
VALUES (2, "GreenRoom","5220 Vincentchester")
ON DUPLICATE KEY UPDATE treatmentId = 2, roomLocation= "5220 Vincentchester";
	INSERT INTO Room (treatmentId, roomName, roomLocation) VALUES (treatId, rName, rLocation);