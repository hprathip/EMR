CREATE DATABASE eyeclinicemr;
USE eyeclinicemr;
-- DROP database eyeclinicemr;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Doctor
(
 doctorId VARCHAR(10),
 doctorName VARCHAR(50) NOT NULL,
 doctorGender VARCHAR(10) NOT NULL,
 doctorContactNo VARCHAR(10) NOT NULL UNIQUE,
 doctorDOB DATE NOT NULL,
 doctorAddress VARCHAR(50) NOT NULL,
 doctorEmailId VARCHAR(50) NOT NULL UNIQUE,
 doctorSalary DECIMAL(10,2) NOT NULL,
 doctorExperience INT NOT NULL,
 CONSTRAINT doctorPK PRIMARY KEY (doctorId)
);

INSERT INTO Doctor values("AEHD00001", "Kyrie Stewart", "Male", "8589472399", '1965-03-10', 
"54508 Goldner Apt. Madelynnmouth, NH 92387", "oabbott@lind.net", 28244.50, 10);
INSERT INTO Doctor values("AEHD00002", "Anna Davidson", "Female", "7033130522", '1976-12-06', 
"13127 DeclanSuite Carsonburgh, TX 65032", "renee.sauer@yahoo.com", 20909.41, 7);
INSERT INTO Doctor values("AEHD00003", "Mariana Ross", "Female", "3422985685", '1987-10-15', 
"Reuben Motorway Apt, WI 08493-4243", "jerel96@purdy.com", 35909.23, 12);
INSERT INTO Doctor values("AEHD00004", "Luca Walker", "Male", "8473574212", '1945-02-15', 
"755 Karlee Glen Suite, MI 07400-1175", "rwintheiser@parisian.info", 55109.23, 20);
INSERT INTO Doctor values("AEHD00005", "Vincent Lambert", "Male", "6072870568", '1998-02-15', 
"980 Orn Trafficway Cristfort, UT 75068", "favian.stark@langworth.org", 10109.23, 5);

-- ----------------------------------------------------------------------------------------------------------------------------------------------- 
CREATE TABLE Specialization
(
 specializationId INT AUTO_INCREMENT,
 specializationName VARCHAR(30) NOT NULL UNIQUE,
 CONSTRAINT specializationPK PRIMARY KEY (specializationId)
);

INSERT INTO Specialization(specializationName) VALUES ("Ophthalmologist");
INSERT INTO Specialization(specializationName) VALUES ("Optometrist");
INSERT INTO Specialization(specializationName) VALUES ("Low Vision Specialist");
INSERT INTO Specialization(specializationName) VALUES ("Orthoptist");
INSERT INTO Specialization(specializationName) VALUES ("Optician");

DESC Specialization;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Doctor_Has_Specialization
(
 doctorId VARCHAR(10) NOT NULL,
 specializationId INT NOT NULL,
 CONSTRAINT doctor_specializationPK PRIMARY KEY (doctorId, specializationId),
 CONSTRAINT doctorFK FOREIGN KEY (doctorId) REFERENCES Doctor(doctorId)
 ON DELETE CASCADE,
 CONSTRAINT specializationFK FOREIGN KEY (specializationId) REFERENCES Specialization(specializationId)
 ON DELETE CASCADE
);

INSERT INTO Doctor_Has_Specialization VALUES ("AEHD00004", 1);
INSERT INTO Doctor_Has_Specialization VALUES ("AEHD00001", 3);
INSERT INTO Doctor_Has_Specialization VALUES ("AEHD00003", 2);
INSERT INTO Doctor_Has_Specialization VALUES ("AEHD00005", 2);
INSERT INTO Doctor_Has_Specialization VALUES ("AEHD00004", 5);
INSERT INTO Doctor_Has_Specialization VALUES ("AEHD00002", 4);

desc Doctor_Has_Specialization;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Patient
(
 patientId VARCHAR(10),
 patientName VARCHAR(50) NOT NULL,
 patientGender VARCHAR(10) NOT NULL,
 patientContactNo VARCHAR(10) NOT NULL UNIQUE,
 patientEmailId VARCHAR(30) NOT NULL UNIQUE,
 patientDOB DATE NOT NULL,
 patientAddress VARCHAR(50) NOT NULL,
 CONSTRAINT patientPK PRIMARY KEY (patientId)
);

INSERT INTO Patient values("AEHP00001", "Aurora Williams", "Female", "4786873226", 
"zackary.reichert@gmail.com", '2000-03-14', "83410 Floyd Roads North Margret, OK 17161-2122");
INSERT INTO Patient values("AEHP00002", "Allison Taylor", "Female", "6987628317", 
"paige44@hotmail.com", '1976-12-14', "56612 Renner Suite, Conroyview, WY 54959");
INSERT INTO Patient values("AEHP00003", "Max Hamilton", "Male", "8413599047", 
"hzemlak@pollich.com", '2010-05-13', "934 Glen Apt, North Dougtown, WY 71062-1346");
INSERT INTO Patient values("AEHP00004", "Jared Howard", "Male", "2876973187", 
"xbernier@yahoo.com", '1989-11-07', "3360 Eve Course Lake Abbiefurt, ND 66167");
INSERT INTO Patient values("AEHP00005", "Callie Perez", "Female", "5053139071", 
"tdickinson@keebler.biz", '1993-11-11', "64037 Alia Glen Port Pasqualeburgh, MN 72415-5820");
INSERT INTO Patient values("AEHP00006", "Jaxson Floyd", "Male", "8908107581", 
"efren.schneider@orn.com", '1995-06-12', "7696 Larkin SpringsNatashachester, OK 38797");

desc Patient;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Appointment
(
 appointmentId INT AUTO_INCREMENT,
 doctorId VARCHAR(10) NOT NULL,
 patientId VARCHAR(10) NOT NULL,
 appointmentSlot DATETIME NOT NULL,
 CONSTRAINT appointmentPK PRIMARY KEY (appointmentId),
 CONSTRAINT doctorAptFK FOREIGN KEY (doctorId) REFERENCES Doctor(doctorId)
 ON DELETE CASCADE,
 CONSTRAINT patientAptFK FOREIGN KEY (patientId) REFERENCES Patient(patientId)
 ON DELETE CASCADE
);

INSERT INTO APPOINTMENT(doctorId, patientId, appointmentSlot) VALUES 
("AEHD00004", "AEHP00005", '2015-06-07 17:30:00');
INSERT INTO APPOINTMENT(doctorId, patientId, appointmentSlot) VALUES 
("AEHD00003", "AEHP00001", '2020-01-17 09:45:00');
INSERT INTO APPOINTMENT(doctorId, patientId, appointmentSlot) VALUES 
("AEHD00003", "AEHP00001", '2022-01-13 09:45:00');
INSERT INTO APPOINTMENT(doctorId, patientId, appointmentSlot) VALUES 
("AEHD00001", "AEHP00002", '2022-08-16 16:00:00');
INSERT INTO APPOINTMENT(doctorId, patientId, appointmentSlot) VALUES 
("AEHD00002", "AEHP00003", '2021-12-02 15:00:00');
INSERT INTO APPOINTMENT(doctorId, patientId, appointmentSlot) VALUES 
("AEHD00003", "AEHP00003", '2022-12-03 10:15:00');
INSERT INTO APPOINTMENT(doctorId, patientId, appointmentSlot) VALUES 
("AEHD00002", "AEHP00003", '2022-11-03 16:15:00');
INSERT INTO APPOINTMENT(doctorId, patientId, appointmentSlot) VALUES 
("AEHD00005", "AEHP00004", '2022-11-29 18:30:00');
INSERT INTO APPOINTMENT(doctorId, patientId, appointmentSlot) VALUES 
("AEHD00004", "AEHP00004", '2022-11-28 11:30:00');
INSERT INTO APPOINTMENT(doctorId, patientId, appointmentSlot) VALUES 
("AEHD00002", "AEHP00002", '2022-11-30 09:30:00');
INSERT INTO APPOINTMENT(doctorId, patientId, appointmentSlot) VALUES 
("AEHD00001", "AEHP00001", '2022-12-01 18:30:00');
INSERT INTO APPOINTMENT(doctorId, patientId, appointmentSlot) VALUES 
("AEHD00001", "AEHP00006", "2022-12-04 17:30:00");


desc Appointment;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE MedicalRecord
(
 MRId VARCHAR(30) NOT NULL,
 patientId VARCHAR(10) NOT NULL,
 appointmentId INT NOT NULL,
 signs VARCHAR(50),
 symptoms VARCHAR(100),
 diseaseDignosed VARCHAR(100),
 treatmentSuggested VARCHAR(50),
 clinicalNotes VARCHAR(300) NOT NULL,
 CONSTRAINT medicalRecPK PRIMARY KEY (MRId, patientId, appointmentId),
 CONSTRAINT patientRecFK FOREIGN KEY (patientId) REFERENCES Patient(patientId)
 ON DELETE CASCADE,
 CONSTRAINT appointmentRecFK FOREIGN KEY (appointmentId) REFERENCES Appointment(appointmentId)
 ON DELETE CASCADE
);

DELIMITER //
CREATE TRIGGER verify_treat 
before insert on MedicalRecord
for each row
IF new.treatmentSuggested ="None" 
THEN SET new.treatmentSuggested="No Facility";
END IF//
DELIMITER ;

-- DROP TRIGGER verify_treat;

INSERT INTO MedicalRecord VALUES ("AEHMR00001", "AEHP00001", 2, "considerable astigmatism",
 "The cornea instead of being round is shaped like cone", "Glaucoma", "Corneal Grafts", "Suggested Corneal Grafts, recheckup after 3 months");
INSERT INTO MedicalRecord VALUES ("AEHMR00002", "AEHP00002", 4, "cloudy blurring vision",
 "Glasses cannot correct vision", "Cataract", "Laser Cataract Surgery", "Suggested Laser Cataract Surgery");
INSERT INTO MedicalRecord VALUES ("AEHMR00001", "AEHP00001", 3, "reduced astigmatism, but redness exists",
 "Cornea changing colors","Glaucoma", "Corneal Grafts", "Sitting1 Corneal Grafts");
INSERT INTO MedicalRecord VALUES ("AEHMR00003", "AEHP00003", 5, "plenty astigmatism",
 "Cornea is shaped like cone, but not clear. Irritation in eyes", "Macular Degeneration", "Corneal Grafts","Suggested Corneal Grafts");
INSERT INTO MedicalRecord VALUES ("AEHMR00005", "AEHP00005", 1, "Retina stoped receiving oxygen.",
 "Objects appear to float across eye","Diabetic retinopathy", "None", "Can't be treated here");
INSERT INTO MedicalRecord VALUES ("AEHMR00004", "AEHP00003", 6, "slight blur vision",
"far things are not clear","Eyestrain", "General CheckUp", "Suggested glasses post general check up");
INSERT INTO MedicalRecord VALUES ("AEHMR00003", "AEHP00003", 7, "left eye redness",
"eye irritation, swelling", "Eyestrain", "General CheckUp","Suggested glasses after general check up, left sight -0.5 right eye sight 0"); 
INSERT INTO MedicalRecord VALUES ("AEHMR00001", "AEHP00001", 8, "heavy eye lid",
"eye swelling","Detached retina", "General CheckUp", "Prescribed allergy drops for using twice a day");
INSERT INTO MedicalRecord VALUES ("AEHMR00004", "AEHP00004", 9, "astigmatism",
"eye swelling","Macular Degeneration", "Corneal Grafts","Suggested Corneal Grafts");
INSERT INTO MedicalRecord VALUES ("AEHMR00002", "AEHP00002", 11, "astigmatism",
"eye swelling with irritation","Macular Degeneration", "Corneal Grafts","Suggested Corneal Grafts");
INSERT INTO MedicalRecord VALUES ("AEHMR00004", "AEHP00004", 10, "heavy eye lid",
"eye swelling","Detached retina", "General CheckUp", "Prescribed allergy drops for using twice a day"); 
INSERT INTO MedicalRecord VALUES ("AEHMR00001", "AEHP00001", 12, "heavy eye lid",
"eye swelling","Eyestrain", "General CheckUp", "Prescribed allergy drops for using twice a day"); 

desc MedicalRecord;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Treatment
(
 treatmentId INT AUTO_INCREMENT,
 treatmentName VARCHAR(50) NOT NULL UNIQUE,
 treatmentCost DECIMAL(10,2) NOT NULL,
 CONSTRAINT treatmentPK PRIMARY KEY (treatmentId)
);

INSERT INTO Treatment(treatmentName, treatmentCost) VALUES ("General CheckUp", 150.50);
INSERT INTO Treatment(treatmentName, treatmentCost) VALUES ("Laser Cataract Surgery", 1350.30);
INSERT INTO Treatment(treatmentName, treatmentCost) VALUES ("Laser Lens Replacement / Lens Replacement", 2570.85);
INSERT INTO Treatment(treatmentName, treatmentCost) VALUES ("Corneal Grafts", 3598.50);
INSERT INTO Treatment(treatmentName, treatmentCost) VALUES ("Yag Laser Capsulotomy", 5050.20);


desc Treatment;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Patient_Undergoes_Treatment
(
 patientId VARCHAR(10) NOT NULL,
 treatmentId INT NOT NULL,
 doctorId VARCHAR(10) NOT NULL,
 appointmentId INT NOT NULL,
 CONSTRAINT patient_treatmentPK PRIMARY KEY (patientId, treatmentId, doctorId, appointmentId),
 CONSTRAINT patientTreatFK FOREIGN KEY (patientId) REFERENCES Patient(patientId)
 ON DELETE CASCADE,
 CONSTRAINT appointmentTreatFK FOREIGN KEY (appointmentId) REFERENCES Appointment(appointmentId)
 ON DELETE CASCADE,
 CONSTRAINT doctorTreatFK FOREIGN KEY (doctorId) REFERENCES Doctor(doctorId)
 ON DELETE CASCADE,
 CONSTRAINT treatmentTreatFK FOREIGN KEY (treatmentId) REFERENCES Treatment(treatmentId)
 ON DELETE CASCADE
);

INSERT INTO Patient_Undergoes_Treatment VALUES ("AEHP00001", 4,"AEHD00003", 2);
INSERT INTO Patient_Undergoes_Treatment VALUES ("AEHP00002", 2,"AEHD00001", 4);
INSERT INTO Patient_Undergoes_Treatment VALUES ("AEHP00001", 1,"AEHD00003", 3);
INSERT INTO Patient_Undergoes_Treatment VALUES ("AEHP00003", 4,"AEHD00002", 5);
INSERT INTO Patient_Undergoes_Treatment VALUES ("AEHP00004", 1,"AEHD00003", 6);
INSERT INTO Patient_Undergoes_Treatment VALUES ("AEHP00005", 1,"AEHD00004", 1);
INSERT INTO Patient_Undergoes_Treatment VALUES ("AEHP00003", 1,"AEHD00002", 7);

desc Patient_Undergoes_Treatment;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Prescription
(
 prescriptionId INT AUTO_INCREMENT,
 patientId VARCHAR(10) NOT NULL,
 doctorId VARCHAR(10) NOT NULL,
 prescriptionDate DATETIME NOT NULL,
 CONSTRAINT prescriptionPK PRIMARY KEY (prescriptionId),
 CONSTRAINT patientPresFK FOREIGN KEY (patientId) REFERENCES Patient(patientId)
 ON DELETE CASCADE,
 CONSTRAINT doctorPresFK FOREIGN KEY (doctorId) REFERENCES Doctor(doctorId)
 ON DELETE CASCADE
);

INSERT INTO Prescription (patientId,doctorId,prescriptionDate) VALUES ("AEHP00005","AEHD00004",'2015-06-07 18:30:00');
INSERT INTO Prescription (patientId,doctorId,prescriptionDate) VALUES ("AEHP00001","AEHD00003",'2020-01-17 10:30:00');
INSERT INTO Prescription (patientId,doctorId,prescriptionDate) VALUES ("AEHP00002","AEHD00001",'2022-08-16 16:46:00');
INSERT INTO Prescription (patientId,doctorId,prescriptionDate) VALUES ("AEHP00003","AEHD00002",'2022-12-02 16:10:00');
INSERT INTO Prescription (patientId,doctorId,prescriptionDate) VALUES ("AEHP00004","AEHD00002",'2022-12-02 15:00:00');
INSERT INTO Prescription (patientId,doctorId,prescriptionDate) VALUES ("AEHP00003","AEHD00002",'2022-12-04 16:45:00');

desc Prescription;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Medicine
(
 medicineId INT AUTO_INCREMENT,
 medicineName VARCHAR(30) NOT NULL,
 medicinePrice DECIMAL(10, 2) NOT NULL,
 expiryDate DATE NOT NULL,
 supplierId VARCHAR(10) NOT NULL,
 CONSTRAINT medicinePK PRIMARY KEY (medicineId)
);

INSERT INTO Medicine (medicineName, medicinePrice, expiryDate, supplierId) VALUES ("Levobunolol eye drops",
385.30, '2025-11-04', "DROPSUPP01");
INSERT INTO Medicine (medicineName, medicinePrice, expiryDate, supplierId) VALUES ("Proparacaine",
200.30, '2023-01-13', "ANESTSUP36");
INSERT INTO Medicine (medicineName, medicinePrice, expiryDate, supplierId) VALUES ("Timolol",
170.85, '2022-12-19', "REGSUPP36");
INSERT INTO Medicine (medicineName, medicinePrice, expiryDate, supplierId) VALUES ("Ciloxan Ointment",
100.00, '2022-12-13', "OintSUPP33");
INSERT INTO Medicine (medicineName, medicinePrice, expiryDate, supplierId) VALUES ("Atropine",
378.30, '2024-10-06', "ANESTSUP36");
INSERT INTO Medicine (medicineName, medicinePrice, expiryDate, supplierId) VALUES ("Patanol eye allergy drops",
65.00, '2025-12-13', "DROPSUPP03");
INSERT INTO Medicine (medicineName, medicinePrice, expiryDate, supplierId) VALUES ("Voltaren eye drops",
78.05, '2025-11-04', "DROPSUPP01");

desc Medicine;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Prescription_Has_Medicine
(
 prescriptionId INT NOT NULL,
 medicineId INT NOT NULL,
 quantity INT NOT NULL,
 CONSTRAINT prescription_medicinePK PRIMARY KEY (prescriptionId, medicineId),
 CONSTRAINT prescriptionFK FOREIGN KEY (prescriptionId) REFERENCES Prescription(prescriptionId)
 ON DELETE CASCADE,
 CONSTRAINT medicineFK FOREIGN KEY (medicineId) REFERENCES Medicine(medicineId)
 ON DELETE CASCADE
);

INSERT INTO Prescription_Has_Medicine VALUES (3, 6, 7);
INSERT INTO Prescription_Has_Medicine VALUES (3, 2, 1);
INSERT INTO Prescription_Has_Medicine VALUES (3, 7, 3);
INSERT INTO Prescription_Has_Medicine VALUES (5, 5, 1);
INSERT INTO Prescription_Has_Medicine VALUES (2, 6, 2);
INSERT INTO Prescription_Has_Medicine VALUES (6, 2, 1);

desc Prescription_Has_Medicine;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE InsuranceCompany
(
 insuranceCompanyCode VARCHAR(10),
 insuranceCompanyName VARCHAR(50) NOT NULL UNIQUE,
 insuranceCompanyAddress VARCHAR(50) NOT NULL UNIQUE,
 CONSTRAINT insuranceCompPK PRIMARY KEY (insuranceCompanyCode)
);

INSERT INTO InsuranceCompany VALUES ("INSP00001","Pine Insurance","2013 Kuhic Pine East Cary, NE 74060-8946");
INSERT INTO InsuranceCompany VALUES ("INSP00002","Walshport Insurance Providers","70026 Arnoldo Centers, OR 63709");
INSERT INTO InsuranceCompany VALUES ("INSP00003","Boehm Health Insurance","69685 Lake Gertrudehaven, MO 80583");
INSERT INTO InsuranceCompany VALUES ("INSP00004","Throughway ReAssurance","5220 Vincentchester, NV 55486");
INSERT INTO InsuranceCompany VALUES ("INSP00005","Trace Suite Health Ltd.","24021 Wuckert 008 Chanelleton, KY 02686-2775");

desc InsuranceCompany;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE InsuranceCover
(
 insuranceCompanyCode VARCHAR(10) NOT NULL,
 policyNo VARCHAR(20) NOT NULL,
 patientId VARCHAR(10) NOT NULL UNIQUE,
 coPay DECIMAL(10,2) NOT NULL,
 coInsurance DECIMAL(10,2) NOT NULL,
 policyExpiryDate DATE NOT NULL,
 insuranceGroupNumber INT,
 CONSTRAINT insuranceCoverPK PRIMARY KEY (insuranceCompanyCode, policyNo),
 CONSTRAINT insuranceCompFK FOREIGN KEY (insuranceCompanyCode) REFERENCES InsuranceCompany(insuranceCompanyCode)
 ON DELETE CASCADE,
 CONSTRAINT patientInsuranceFK FOREIGN KEY (patientId) REFERENCES Patient(patientId)
 ON DELETE CASCADE
);

INSERT INTO InsuranceCover VALUES ("INSP00001", "B5C2973A", "AEHP00002", 350, 100, '2022-12-21', 25097309);
INSERT INTO InsuranceCover VALUES ("INSP00002", "C6D66E98", "AEHP00004", 200, 50, '2023-06-25', 37314883);
INSERT INTO InsuranceCover VALUES ("INSP00001", "829CD8EC", "AEHP00003", 350, 100, '2022-12-21', 25097309);
INSERT INTO InsuranceCover VALUES ("INSP00005", "B4A71987", "AEHP00005", 150, 35, '2024-12-05', 45564617);
INSERT INTO InsuranceCover VALUES ("INSP00005", "CF6D4A45", "AEHP00001", 350, 100, '2025-01-07', 60111494);

desc InsuranceCover;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Room
(
 roomId INT AUTO_INCREMENT,
 treatmentId INT,
 roomName VARCHAR(30) NOT NULL UNIQUE,
 roomLocation VARCHAR(30) NOT NULL UNIQUE,
 CONSTRAINT roomPK PRIMARY KEY (roomId),
 CONSTRAINT treatmentRoomFK FOREIGN KEY (treatmentId) REFERENCES Treatment(treatmentId)
 ON DELETE CASCADE
);

INSERT INTO Room (treatmentId, roomName, roomLocation) VALUES (1, "General Check1", "27366 Bailee Way,WI 09040-1616");
INSERT INTO Room (treatmentId, roomName, roomLocation) VALUES (2, "Laser Cataract01", "27166 Bailee Way,WI 09025-1610");
INSERT INTO Room (treatmentId, roomName, roomLocation) VALUES (3, "Laser Lens Replacement101", "21255 Bailee Way,WI 04201-1218");
INSERT INTO Room (treatmentId, roomName, roomLocation) VALUES (4, "Grafting RoomG01", "23135 Bailee Way,WI 01040-2116");
INSERT INTO Room (treatmentId, roomName, roomLocation) VALUES (5, "CapsulotomyF03", "27363 Bailee Way,WI 09040-1616");

desc Room;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Equipment
(
 equipmentId INT AUTO_INCREMENT,
 equipmentName VARCHAR(20) NOT NULL UNIQUE,
 supplierId VARCHAR(10) NOT NULL,
 CONSTRAINT equipmentPK PRIMARY KEY (equipmentId)
);

INSERT INTO Equipment (equipmentName, supplierId) VALUES ("S1 Ophthalmic Chair","CHAIRSUP20");
INSERT INTO Equipment (equipmentName, supplierId) VALUES ("Bio-Cornea Topograph","MACHSUP510");
INSERT INTO Equipment (equipmentName, supplierId) VALUES ("I500 InstrumentStand","GENSUPP120");
INSERT INTO Equipment (equipmentName, supplierId) VALUES ("C800 CorneaAnalyzer","MACHSUP510");
INSERT INTO Equipment (equipmentName, supplierId) VALUES ("SL-D2 Slit Lamp","GENSUPP120");

desc Equipment;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Room_Has_Equipment
(
 roomId INT NOT NULL,
 equipmentId INT NOT NULL,
 equipmentNo INT,
 CONSTRAINT room_equipmentPK PRIMARY KEY (roomId, equipmentId),
 CONSTRAINT roomFK FOREIGN KEY (roomId) REFERENCES Room(roomId)
 ON DELETE CASCADE,
 CONSTRAINT equipmentFK FOREIGN KEY (equipmentId) REFERENCES Equipment(equipmentId)
 ON DELETE CASCADE
);

INSERT INTO Room_Has_Equipment VALUES (1, 1, 1);
INSERT INTO Room_Has_Equipment VALUES (1, 5, 2);
INSERT INTO Room_Has_Equipment VALUES (1, 3, 2);
INSERT INTO Room_Has_Equipment VALUES (4, 2, 1);
INSERT INTO Room_Has_Equipment VALUES (4, 1, 1);
INSERT INTO Room_Has_Equipment VALUES (4, 5, 3);

desc Room_Has_Equipment;
-- -----------------------------------------------------------------------------------------------------------------------------------------------