--Group 41

--Part 2
CREATE TABLE Departments 
(dID CHAR(5) NOT NULL PRIMARY KEY, 
dName VARCHAR(20) NOT NULL, 
number_of_employees INT NOT NULL, 
wing INT, chief_doctor CHAR(10), 
head_nurse CHAR(10));

CREATE TABLE Staff 
(eID CHAR(10) NOT NULL PRIMARY KEY, 
sName VARCHAR(20) NOT NULL, 
sLast VARCHAR(20), 
medicare_number CHAR(10) NOT NULL UNIQUE, 
date_of_birth DATE, 
gender CHAR(1), 
civicNumber VARCHAR(10), 
city VARCHAR(30), 
postalCode VARCHAR(10), 
country VARCHAR(30), 
phone_number CHAR(10), 
date_of_employement DATE, 
biweekly_hours INT);

CREATE TABLE Nurses 
(eID CHAR(10) NOT NULL PRIMARY KEY, 
prescription_authorisation CHAR(1) NOT NULL, 
hourly_salary DECIMAL(16,2), 
in_department CHAR(5) NOT NULL, 
since DATE);
CREATE TABLE Doctors 
(eID CHAR(10) NOT NULL PRIMARY KEY, 
level VARCHAR(20) NOT NULL,
number_of_patient_visits INT, 
mortality_rate DECIMAL(5, 4), 
annual_salary DECIMAL(16,2), 
area_of_research VARCHAR(80), 
in_department CHAR(5) NOT NULL, 
since DATE);

CREATE TABLE Orderlies 
(eID CHAR(10) NOT NULL PRIMARY KEY, 
task VARCHAR(50) NOT NULL, 
hourly_salary DECIMAL(16,2), 
in_department CHAR(5) NOT NULL);

CREATE TABLE Administrative 
(eID CHAR(10) NOT NULL PRIMARY KEY, 
responsibility VARCHAR(20) NOT NULL, 
position VARCHAR(20), 
annual_salary DECIMAL(16,2), 
in_department CHAR(5) NOT NULL);

CREATE TABLE Custodial 
(eID CHAR(10) NOT NULL PRIMARY KEY, 
floor_assignment INT NOT NULL, 
hourly_salary DECIMAL(16,2), 
in_department CHAR(5) NOT NULL);

CREATE TABLE Stays 
(sID CHAR(10) NOT NULL PRIMARY KEY,
in_date DATE NOT NULL, 
out_date DATE, 
symptoms VARCHAR(50), 
diagnosis VARCHAR(50), 
pID CHAR(10) NOT NULL);

CREATE TABLE Patient 
(pID CHAR(10) NOT NULL PRIMARY KEY, 
medicare_number CHAR(10) NOT NULL UNIQUE, 
pName VARCHAR(20) NOT NULL, 
pLast VARCHAR(20), 
civicNumber VARCHAR(10), 
city VARCHAR(30), 
postalCode VARCHAR(10), 
country VARCHAR(30), 
age INT, 
gender CHAR(1), 
phone_number CHAR(10), 
emergency_contact CHAR(10), 
blood_type VARCHAR(3));

CREATE TABLE Beds 
(bedID CHAR(10) NOT NULL PRIMARY KEY, 
room_number INT NOT NULL, 
last_cleaned DATE, 
sID CHAR(10), 
eID CHAR(10) NOT NULL) ;

CREATE TABLE Medication 
(scientific_name VARCHAR(30) NOT NULL PRIMARY KEY, 
company VARCHAR(20), 
cost_per_gram DECIMAL(16,2));

CREATE TABLE Vitals 
(date_measured DATE NOT NULL, 
time_measured TIME NOT NULL, 
type VARCHAR(20) NOT NULL, 
value REAL, 
sID CHAR(10) NOT NULL, 
eID CHAR(10) NOT NULL, 
PRIMARY KEY (sID, eID, date_measured, time_measured, type));

CREATE TABLE Administered 
(sID CHAR(10) NOT NULL, 
medication VARCHAR(20) NOT NULL,
dose_g REAL NOT NULL, 
duration_days INT NOT NULL, 
frequency_perday INT NOT NULL, 
PRIMARY KEY (sID,medication));

CREATE TABLE Watched_over 
(eID CHAR(10) NOT NULL, 
sID CHAR(10) NOT NULL, 
shift_date DATE NOT NULL, 
PRIMARY KEY (sID,eid));

CREATE TABLE Cared_for 
(eID CHAR(10) NOT NULL,
sID CHAR(10) NOT NULL , 
type VARCHAR(20), 
PRIMARY KEY (sID,eID));


ALTER TABLE Departments ADD CONSTRAINT DEP_DOC_FKEY FOREIGN KEY (chief_doctor) REFERENCES Doctors(eID);
ALTER TABLE Departments ADD CONSTRAINT DEP_NUR_FKEY FOREIGN KEY (head_nurse) REFERENCES Nurses(eID);
ALTER TABLE Nurses ADD CONSTRAINT NUR_DEP_FKEY FOREIGN KEY (in_department) REFERENCES Departments(dID);
ALTER TABLE Nurses ADD CONSTRAINT NUR_STAFF_FKEY FOREIGN KEY (eid) REFERENCES Staff(eID) ON DELETE CASCADE;
ALTER TABLE Doctors ADD CONSTRAINT DOC_DEP_FKEY FOREIGN KEY (in_department) REFERENCES Departments(dID);
ALTER TABLE Doctors ADD CONSTRAINT DOC_STAFF_FKEY FOREIGN KEY (eid) REFERENCES Staff(eID) ON DELETE CASCADE;
ALTER TABLE Orderlies ADD CONSTRAINT ORD_DEP_FKEY FOREIGN KEY (in_department) REFERENCES Departments(dID);
ALTER TABLE Orderlies ADD CONSTRAINT ORD_STAFF_FKEY FOREIGN KEY (eid) REFERENCES Staff(eID) ON DELETE CASCADE;
ALTER TABLE Administrative ADD CONSTRAINT ADMIN_DEP_FKEY FOREIGN KEY (in_department) REFERENCES Departments(dID);
ALTER TABLE Administrative ADD CONSTRAINT ADMIN_STAFF_FKEY FOREIGN KEY (eid) REFERENCES Staff(eID) ON DELETE CASCADE;
ALTER TABLE Custodial ADD CONSTRAINT CUST_DEP_FKEY FOREIGN KEY (in_department) REFERENCES Departments(dID);
ALTER TABLE Custodial ADD CONSTRAINT CUST_STAFF_FKEY FOREIGN KEY (eid) REFERENCES Staff(eID) ON DELETE CASCADE;
ALTER TABLE Stays ADD CONSTRAINT STAY_PT_FKEY FOREIGN KEY (pID) REFERENCES Patient(pID);
ALTER TABLE Stays ADD CONSTRAINT IN_OUT CHECK (in_date < out_date);
ALTER TABLE Patient ADD CONSTRAINT B_TYPE CHECK (blood_type = 'A+' OR blood_type = 'A-' OR blood_type = 'B+' OR blood_type = 'B-' OR blood_type = 'AB+' OR blood_type = 'AB-' OR blood_type = 'O+' OR blood_type = 'O-');
ALTER TABLE Beds ADD CONSTRAINT BED_ORD_FKEY FOREIGN KEY (eID) REFERENCES Orderlies(eID);
ALTER TABLE Beds ADD CONSTRAINT ROOM_NUM CHECK (room_number > 0 AND room_number < 900);
-- assume 9 floors
ALTER TABLE Beds ADD CONSTRAINT BED_STAY_FKEY FOREIGN KEY (sID) REFERENCES Stays(sID) ON DELETE CASCADE;
ALTER TABLE Vitals ADD CONSTRAINT VIT_STAY_FKEY FOREIGN KEY (sID) REFERENCES Stays(sID) ON DELETE CASCADE;
ALTER TABLE Vitals ADD CONSTRAINT VIT_EMP_FKEY FOREIGN KEY (eID) REFERENCES Nurses(eID) ON DELETE CASCADE;
ALTER TABLE Administered ADD CONSTRAINT PRES_STAY_FKEY FOREIGN KEY (sID) REFERENCES Stays(sID) ON DELETE CASCADE;
ALTER TABLE Administered ADD CONSTRAINT PRES_MED_FKEY FOREIGN KEY (medication) REFERENCES Medication(scientific_name);
ALTER TABLE Watched_over ADD CONSTRAINT WO_STAY_FKEY FOREIGN KEY (sID) REFERENCES Stays(sID) ON DELETE CASCADE;
ALTER TABLE Watched_over ADD CONSTRAINT WO_NUR_FKEY FOREIGN KEY (eID) REFERENCES Nurses(eID) ON DELETE CASCADE;
ALTER TABLE Cared_for ADD CONSTRAINT CF_STAY_FKEY FOREIGN KEY (sID) REFERENCES Stays(sID) ON DELETE CASCADE;
ALTER TABLE Cared_for ADD CONSTRAINT CF_DOC_FKEY FOREIGN KEY (eID) REFERENCES Doctors(eID) ON DELETE CASCADE;
ALTER TABLE Cared_for ADD CONSTRAINT typ_p_np CHECK ( type = 'primary' OR type = 'secondary');


--Part 3 & 4

INSERT INTO Departments VALUES
	('DEP01', 'Urology', 10, 2, NULL, NULL),
	('DEP02', 'Cardiology', 10, 1, NULL, NULL),
	('DEP03', 'Orthopaedic Surgery', 10, 2, NULL, NULL),
	('DEP04', 'Neurosurgery', 10, 2, NULL, NULL),
	('DEP05', 'Psychiatry', 10, 4, NULL, NULL),
	('DEP06', 'Central ICU', 10, 1, NULL, NULL),
	('DEP07', 'Gastroenterology', 10, 1, NULL, NULL),
	('DEP08', 'Oncology', 10, 3, NULL, NULL),
	('DEP09', 'Nephrology', 10, 3, NULL, NULL),
	('DEP10', 'Radiotherapy', 10, 3, NULL, NULL);

INSERT INTO Staff VALUES 
	('DOC2000001','Imad','Halabi','2222287075','1979-02-11','M','1610','Montreal','E7O9X3','Canada','5142474688','2012-02-01',84),
	('DOC2000002','Jabir','Assaf','2222297145','1978-02-19','M','1594','Laval','T3M2E6','Canada','5142494932','2014-01-01',75),
	('DOC2000003','Ibrahim','Atalla','2222203491','1962-06-25','M','1967','Montreal','S0F1F9','Canada','5142465313','2010-11-01',76),
	('DOC2000004','Rima','Bahar','2222258500','1960-03-06','F','1993','Brossard','E0U3U7','Canada','5142477081','1990-10-01',79),
	('DOC2000005','Nawal','Tannous','2222284414','1977-05-05','F','770','Montreal','J1U8B0','Canada','5142463763','2013-03-01',30),

	('NUR2000001','Gebran','Zoghby','2222284733','1957-04-25','M','195','Brossard','E6L6F1','Canada','5142464753','2010-02-01',82),
	('NUR2000002','Karim','Kannaan','2222234726','1957-07-26','M','419','Montreal','X1U3F4','Canada','5142424868','2014-06-01',95),
	('NUR2000003','Nada','Bishara','2222214255','1961-02-07','F','1171','Montreal','Y9Q7E4','Canada','5142428656','1998-02-01',45),
	('NUR2000004','Hanan','Toma','2222277081','1963-04-06','F','1574','Montreal','V7P6W3','Canada','5142414780','2005-05-01',76),
	('NUR2000005','Shophia','Asad','2222262044','1974-05-24','F','135','Laval','X7C6L5','Canada','5142493385','2000-03-01',38),
	('ORD2000001','Rafiq','Deeb','2222273969','1960-05-31','M','189','Laval','R8L1P6','Canada','5142446755','2000-01-01',22),
	('ORD2000002','Shakir','Khoury','2222261645','1979-06-26','M','960','Laval','N2R2S3','Canada','5142424688','2013-01-01',45),
	('ORD2000003','Fouad','kassis','2222297573','1957-12-03','M','119','Brossard','V8U9N1','Canada','5142481418','2008-01-01',95),
	('ORD2000004','Anas','Naser','2222211456','1966-10-10','M','620','Montreal','H4J4K5','Canada','5142428592','2012-01-01',34),
	('ORD2000005','Bernadette','Sayeh','2222230676','1972-06-23','F','443','Laval','Y0D9F3','Canada','5142484679','2003-01-01',10),

	('DOC1000001','Marcos','King','1111174265','1965-01-20','M','2801','Montreal','H1B2C3','Canada','5145756130','1995-02-25',83),
	('DOC1000002','Tyrone','Lawson','1111116206','1966-03-20','M','779','Laval','H7C4D5','Canada','5141913842','1995-12-12',76),
	('DOC1000003','Caleb','Shaw','1111136119','1967-08-18','M','2220','Montreal','H1E6F7','Canada','5143026337','2005-10-07',75),
	('DOC1000004','Joanna','Pratt','1111178381','1979-11-13','F','2595','Brossard','H5A8G9','Canada','5147253891','2009-06-14',80),
	('DOC1000005','Carol','Rose','1111174584','1984-05-16','F','2156','Montreal','H1H1I2','Canada','5148828942','2012-08-24',31),

	('DOC1000006','Geneva','Munoz','1111123456','1985-12-13','F','111','Brossard','H3A2C3','Canada','5147253891','2008-07-14',79),
	('DOC1000007','Elaine','Murray','1111134567','1986-05-10','F','22','Montreal','H1H4I5','Canada','5148828942','2007-08-24',33),
	('DOC1000008','Candace','Flowers','1111145678','1985-1-15','F','4','Brossard','H3A8T7','Canada','5147253891','2009-07-14',85),
	('DOC1000009','Carrie','Simon','1111156789','1986-06-16','F','15','Montreal','H1R1W5','Canada','5148828942','2013-08-24',32),

	('NUR1000001','Roman','Francis','1111154483','1903-08-16','M','1951','Brossard','H5J6K7','Canada','5148506237','2000-01-01',81),
	('NUR1000002','Rolando','Love','1111137463','1974-03-17','M','2595','Montreal','H1L9M1','Canada','5141902977','2001-10-14',96),
	('NUR1000003','Candice','Mendoza','1111113435','1976-04-29', 'F','2990','Montreal','H1N2O3','Canada','5147564920','2005-12-17',44),
	('NUR1000004','Pauline','Cruz','1111185127','1939-08-08','F','264','Montreal','H1P4S5','Canada','5144319935','2006-09-15',77),
	('NUR1000005','Katie','Munoz','1111126389','1982-10-08','F','2748','Laval','H7T8U9','Canada','5144955438','2006-10-29',37),
	('ADM3000001','Katie','Munoz','3333326319','1982-10-08','F','2748','Laval','H7T8U9','Canada','5144955438','2006-10-29',37),
	('CUS3000001','Katie','Munoz','3333326329','1982-10-08','F','2748','Laval','H7T8U9','Canada','5144955438','2006-10-29',37);


INSERT INTO Doctors VALUES 
	('DOC2000001','R3', 233, 0.1458, 65000.00, 'Urology','DEP01', '2012-02-08'),
	('DOC2000002','Medical student',2, 0.0000, NULL, 'cariovasular diseases', 'DEP02','2014-01-05'),
	('DOC2000003','R5',824, 0.4200, 145645.58,'artificial hips', 'DEP03','2010-11-25'),
	('DOC2000004','Permanent', 2702, 0.2300,475000.30, 'neurological implants', 'DEP04','1990-10-02'),
	('DOC2000005','R1',120, 0.0300,32000.45,'Therapy success in psychologique diseases', 'DEP05', '2013-03-20'),
	('DOC1000001','Permanent', 2200, 0.2458, 475000.30, 'Critical Care', 'DEP06', '1995-02-25'),
	('DOC1000002','Permanent', 2410, 0.2600, 485000.30, 'Gastroenterology', 'DEP07','1995-12-12'),
	('DOC1000003','Permanent', 2300, 0.3200, 465000.30, 'Oncology', 'DEP08','2005-10-07'),
	('DOC1000004','Permanent', 2350, 0.2300, 455000.30, 'Nephrology', 'DEP09','2009-06-14'),
	('DOC1000005','Permanent', 2100, 0.2700, 460000.30, 'Radiotherapy', 'DEP10', '2012-08-24'),

	('DOC1000006','Permanent', 2410, 0.2500, 485000.30, 'Gastroenterology', 'DEP07','2008-07-14'),
	('DOC1000007','Permanent', 2300, 0.2800, 465000.30, 'Oncology', 'DEP08','2007-08-24'),
	('DOC1000008','Permanent', 2350, 0.2500, 455000.30, 'Nephrology', 'DEP09','2009-07-14'),
	('DOC1000009','Permanent', 2100, 0.2400, 460000.30, 'Radiotherapy', 'DEP10', '2013-08-24');



INSERT INTO Nurses VALUES 
	('NUR2000001', 'y', 13.50, 'DEP01', '2010-02-08'),
	('NUR2000002', 'n', 10.50, 'DEP02', '2014-06-02'),
	('NUR2000003', 'y', 15.50, 'DEP03', '1998-02-23'),
	('NUR2000004', 'y', 13.00, 'DEP04', '2005-05-01'),
	('NUR2000005', 'y', 13.50, 'DEP05', '2000-03-17'),
	('NUR1000001', 'y', 13.50, 'DEP06', '2000-01-01'),
	('NUR1000002', 'n', 10.50, 'DEP07', '2001-10-14'),
	('NUR1000003', 'y', 15.50, 'DEP08', '2005-12-17'),
	('NUR1000004', 'y', 13.00, 'DEP09', '2006-09-15'),
	('NUR1000005', 'y', 13.50, 'DEP10', '2006-10-29');

UPDATE Departments SET chief_doctor ='DOC2000001', head_nurse ='NUR2000001' WHERE dID='DEP01'; 
UPDATE Departments SET chief_doctor ='DOC2000002', head_nurse ='NUR2000002' WHERE dID='DEP02'; 
UPDATE Departments SET chief_doctor ='DOC2000003', head_nurse ='NUR2000003' WHERE dID='DEP03'; 
UPDATE Departments SET chief_doctor ='DOC2000004', head_nurse ='NUR2000004' WHERE dID='DEP04'; 
UPDATE Departments SET chief_doctor ='DOC2000005', head_nurse ='NUR2000005' WHERE dID='DEP05'; 
UPDATE Departments SET chief_doctor ='DOC1000001', head_nurse ='NUR1000001' WHERE dID='DEP06'; 
UPDATE Departments SET chief_doctor ='DOC1000002', head_nurse ='NUR1000002' WHERE dID='DEP07'; 
UPDATE Departments SET chief_doctor ='DOC1000003', head_nurse ='NUR1000003' WHERE dID='DEP08'; 
UPDATE Departments SET chief_doctor ='DOC1000004', head_nurse ='NUR1000004' WHERE dID='DEP09'; 
UPDATE Departments SET chief_doctor ='DOC1000005', head_nurse ='NUR1000005' WHERE dID='DEP10'; 


INSERT INTO Orderlies VALUES 
	('ORD2000001','Post-surgery transport',12.00,'DEP01'),
	('ORD2000002','morgue transport',11.00,'DEP02'),
	('ORD2000003','bed cleaning',13.50,'DEP03'),
	('ORD2000004','bed cleaning',10.00,'DEP04'),
	('ORD2000005','emergency transport',11.50,'DEP05');


INSERT INTO Patient VALUES 
	('PT20000001','2222208092','Mohammed','Abou-Saba','2119', 'sherbrooke', 'H1A1A1', 'canada', 32, 'M','5142399127','5142117880','AB+'),
	('PT20000002','2222212345','Mahmoud','El-Hareb','22', 'beyrout', '11112222', 'lebanon', 25, 'M','5142152432','5142323467','B+'),
	('PT20000003','2222204637','Fatima','Baroud','1123', 'montreal', 'H2B2B2', 'canada',18,'F','5142874014','5142731202','A-'),
	('PT20000004','2222205647','Tanious','Bin-Mahmood','4453', 'laval', 'H7A1A1', 'canada',78,'M','5142212927','5142598509','O+'),
	('PT20000005','2222245632','Khadija', 'Lafleur','665', 'montreal', 'H1C1C1', 'canada',39,'F','5142303302','5142697140','O-'),
	('PT30000001','3333301010','Alex','Simons','3132', 'montreal', 'H1A1A9', 'canada', 44, 'M','5143321543','5143121123','AB-'), 
	('PT30000002','3333300202','Janice','Franco','3245', 'brossard', 'H1A1A6', 'canada', 36, 'F','5143332242','5143024123','A+'),

	('PT10000001','1111105647','Roberto','Klein','123', 'laval', 'H7A1A1', 'canada',78,'M','5142214567','5142597535','O+'),
	('PT10000002','1111145632','Marta', 'Nelson','456', 'laval', 'H7A1A2', 'canada',39,'F','5142308767','5142691237','O-'),
	('PT10000003','1111134567','Al','Collier','789', 'laval', 'H7A1A3', 'canada',78,'M','5142215435','5142595302','O+'),
	('PT10000004','1111112345','Marsha', 'Strickland','102', 'laval', 'H1C1F4', 'canada',39,'F','5142305432','5142697825','O-'),
	('PT10000005','1111123456','Brittany','Adkins','101', 'laval', 'H7A1D3', 'canada',78,'M','5142217835','5142596354','O+');

INSERT INTO Stays VALUES 
	('STAY200001','2015-02-23', NULL, 'trouble breathing, left arm pain','cardio stenosis','PT20000001'),
	('STAY200002','2010-05-12', '2010-07-11', 'low immune system, fatigue', 'HIV, Insomnia', 'PT20000004'),
	('STAY200003','2013-02-14', '2013-02-18', 'lower abdominal pain , inflammation', 'appendicitis', 'PT20000003'),
	('STAY200004','2012-05-21', '2012-10-22', 'fatigue, fever, rash', 'HIV, flu', 'PT20000004'),
	('STAY200005','2015-01-12', '2015-03-01', 'extreme pain left lower leg', 'broken tibia', 'PT20000002'),
	('STAY200006','2010-01-01', '2010-03-08', 'weak immune system, fatigue', 'HIV', 'PT20000002'),
	('STAY300001','2013-06-21', '2013-07-04', 'heart palpitations , anxiety , headache','ptsd','PT30000002'),
	('STAY300002','2014-09-02', '2014-09-20', 'paranoia, hair loss, anger','malnutrition','PT30000002'),
	('STAY300003','2015-03-01', NULL, 'fatigue , nausea , headache','pregnancy complications','PT30000002'),
	('STAY300004','2014-02-01', NULL, 'psychotic episodes, emotional distress','bipolar disorder','PT30000001'),
	('STAY300005','2010-02-23','2010-02-25', 'trouble breathing, left arm pain','cardio stenosis','PT10000001'),
	('STAY300006','2011-02-23', '2011-02-25', 'trouble breathing, left arm pain','cardio stenosis','PT10000002'),
	('STAY300007','2012-02-23', '2012-02-25', 'trouble breathing, left arm pain','cardio stenosis','PT10000003'),
	('STAY300008','2013-02-23', '2013-02-25', 'trouble breathing, left arm pain','cardio stenosis','PT10000004'),
	('STAY300009','2014-02-23', '2014-02-25', 'trouble breathing, left arm pain','cardio stenosis','PT10000005'),
	('STAY300010','2010-02-23','2010-02-25', 'trouble breathing, left arm pain','cardio stenosis','PT20000001'),
	('STAY300011','2011-02-23', '2011-02-25', 'trouble breathing, left arm pain','cardio stenosis','PT20000001'),
	('STAY300012','2012-02-23', '2012-02-25', 'trouble breathing, left arm pain','cardio stenosis','PT20000001'),
	('STAY300013','2013-02-23', '2013-02-25', 'trouble breathing, left arm pain','cardio stenosis','PT20000001'),
	('STAY300014','2014-02-23', '2014-02-25', 'trouble breathing, left arm pain','cardio stenosis','PT20000001');



INSERT INTO Beds VALUES 
	('BED2000001',840,'2015-03-01','STAY200001','ORD2000003'),
	('BED2000002',712,'2015-03-01',NULL,'ORD2000003'),
	('BED2000003',012,'2015-03-01',NULL,'ORD2000004'),
	('BED2000004',122,'2015-03-01',NULL,'ORD2000003'),
	('BED2000005',500,'2015-03-01',NULL,'ORD2000004'),
	('BED2000006',713,'2015-03-01',NULL,'ORD2000003'), 
	('BED2000007',013,'2015-03-01',NULL,'ORD2000004'), 
	('BED2000008',123,'2015-03-01','STAY300003','ORD2000003'), 
	('BED2000009',501,'2015-03-01','STAY300004','ORD2000004');

INSERT INTO Medication VALUES 
	('infliximab', 'Janssen Biotech', 1250.00),
	('celecoxib', 'Pfizer', 38.04),
	('sildenafil','Pfizer',349.88),
	('benztropine','Pliva',102.55),
	('prasugrel','Daiichi Sankyo', 21.33);

INSERT INTO Administered VALUES 
	('STAY200005','infliximab',0.001,35,1),
	('STAY200001','benztropine',0.5,5,2),
	('STAY200004','sildenafil',0.250,5,3),
	('STAY200004','infliximab',0.002,105,1),
	('STAY200003','celecoxib',0.550,10,5),
	('STAY300007','sildenafil',0.250,5,3),
	('STAY300008','infliximab',0.002,105,1),
	('STAY300009','celecoxib',0.550,10,5);


INSERT INTO Cared_for VALUES 
	('DOC2000004','STAY200003','primary'),
	('DOC2000002','STAY200003','secondary'),
	('DOC2000002','STAY200004','secondary'),
	('DOC2000001','STAY200001','secondary'),
	('DOC2000003','STAY200005','primary'),
	('DOC1000001','STAY200002','primary'),
	('DOC1000002','STAY300001','primary'),
	('DOC1000003','STAY200003','secondary'),
	('DOC1000004','STAY300003','primary'),
	('DOC1000004','STAY300004','primary');


INSERT INTO Watched_over VALUES 
	('NUR2000003','STAY200001','2015-03-01'),
	('NUR2000003','STAY200003','2013-02-15'),
	('NUR2000002','STAY200005','2015-02-04'),
	('NUR2000004','STAY200004','2012-07-05'),
	('NUR2000003','STAY200004','2012-05-30'),
	('NUR1000001','STAY300001','2015-01-01'),
	('NUR1000002','STAY300002','2015-01-01'),
	('NUR1000003','STAY300003','2015-01-01'),
	('NUR1000004','STAY300004','2015-01-01'),
	('NUR1000004','STAY200003','2013-02-16'),
	('NUR2000001','STAY200003','2013-02-17'),
	('NUR1000001','STAY200003','2013-02-18');


INSERT INTO Vitals VALUES
	('2015-02-23', '09:00:00', 'Heart rate', 90, 'STAY200001', 'NUR2000003'),
	('2013-02-14', '11:00:00', 'Body temperature', 38.4, 'STAY200003', 'NUR2000003');

INSERT INTO Administrative (eid, responsibility, in_department) VALUES ('ADM3000001','Management','DEP01');

INSERT INTO Custodial (eid, floor_assignment, in_department) VALUES ('CUS3000001',1,'DEP01');




--Part 5

--1 : compute total medication cost per patient since 2015-01-01, assume charges are computed at exit from hospital for discharged patients.

SELECT pName, pLast, patient.pID, SUM(dose_g * duration_days * frequency_perday) AS Total_due FROM table (SELECT Stays.sID, pID, dose_g, duration_days, frequency_perday FROM Stays, Administered WHERE stays.sID = Administered.sID AND (out_date > '2011-01-01' OR out_date IS NULL)) as PT_2015 , patient WHERE PT_2015.pID = patient.pID GROUP BY pName, pLast, patient.pID;

-- 2: For research purposes (origin effects on HIV symptoms), give the average stay duration of all stays where the patient is diagnosed for with HIV and the Patient lives in Canada; do the same for patients from Lebanon

SELECT country , avg(days (out_date) - days (in_date)) AS average_duration FROM patient,Stays WHERE Stays.diagnosis LIKE '%HIV%' AND Stays.pID = patient.pID AND (UCASE(patient.country) = 'LEBANON' OR UCASE(patient.country) = 'CANADA') GROUP BY country;

-- 3: Due to a big accident, and lack of time, the hospital needs the phone number of all FORMER patients (not currently hospitalized) with blood type O- or O+ Thal live in laval

SELECT pName, pLast, phone_number FROM patient WHERE patient.pID NOT IN (SELECT pID FROM Stays WHERE out_date IS NULL) AND UCASE(patient.city) = 'LAVAL' AND patient.blood_type LIKE 'O_';

--4: the hospital has realized that a certain patient in the hospital has a dangerous transmissible disease, The disease is particularly dangerous for people over 50 years old !! List all staff members who have been in contact with the patient and are over 50 and there phone number. we are given the Stay associtaed with the infectious patient as target_sid (suppose it is 'STAY200003')
 

SELECT eID, sName, sLast, phone_number, date_of_birth 
FROM staff 
WHERE staff.eid IN (SELECT eID FROM Cared_for WHERE Cared_for.sid = 'STAY200003' 
UNION 
SELECT eID 
FROM Watched_over 
WHERE Watched_over.sid = 'STAY200003' 
UNION 
SELECT eID 
FROM Beds 
WHERE Beds.sid = 'STAY200003') AND date_of_birth < (current date - 50 YEARS);


--5: Calculate and list doctor's first name, last name, age and area_of_research for all female doctors who are less than 40 years old.

SELECT S.sName, S.sLast, (YEAR (current date) - YEAR (date_of_birth)) AS age, D.area_of_research FROM Staff S, Doctors D WHERE S.eid = D.eid AND S.gender = 'F' AND (YEAR (current date) - YEAR (date_of_birth)) < 40;




--Part 6 Data modifications

-- 1 : There has been an outbreak, and all employees under 40 years of age must be quarantined. But first, we must create patient files for each of these employees, in order to later be able to admit them. 

INSERT INTO Patient (pID, medicare_number, pName, pLast, gender, age, phone_number) SELECT eID, medicare_number, sName, sLast, gender, (YEAR(current date) - YEAR(date_of_birth)), phone_number FROM Staff WHERE (YEAR(current date) - YEAR(date_of_birth)) < 40 AND medicare_number NOT IN (SELECT p.medicare_number FROM patient p);

-- 2 : We realize that the outbreak was a false alarm, and want to remove the temporary patient files created for the staff members in a hurry (having used their eid as a pid as a temporary measure, instead of creating proper pID's for each employee). 

DELETE FROM patient WHERE pID NOT LIKE 'PT%';

-- 3 : Due to a flooding in the hospital, all patients living in Montreal must be moved to a  hospital in Montreal in order to reduce the workload and the traffic in the hospital. Therefore, we must discharge all stays that correspond to our criteria. 

UPDATE stays SET out_date = current date WHERE stays.pID IN (SELECT patient.pID FROM patient WHERE UCASE(city) = 'MONTREAL') AND out_date IS NULL;

-- 4 : The hospital is under pressure from the government to improve the quality of its care. Therefore, all of the doctors with a mortality rate higher than 0.2 will be fired from the hospital.



UPDATE Doctors SET Doctors.annual_salary = Doctors.annual_salary- 100.00 WHERE Doctors.mortality_rate >  0.3000;










--Part 7 
-- 1 : A view that lists all departments that have a chief doctor and some information about the doctor who is the chief of the department.


CREATE VIEW chief_doctors AS SELECT Departments.did, doctor_info.eid, doctor_info.sName, doctor_info.sLast FROM Departments, table (SELECT Doctors.eid, staff.sName, staff.sLast FROM Doctors, Staff WHERE Doctors.eid = Staff.eid) AS doctor_info WHERE doctor_info.eid = Departments.chief_doctor;

-- 2 : A view that lists all patients's names and pID if they are currently staying at the hospital.

CREATE VIEW current_patient AS SELECT patient.pID, patient.pName, patient.pLast FROM patient, stays WHERE stays.out_date IS NULL AND stays.pID = patient.pID;

-- 1 : Query on view chief_doctors, returns a list of chief doctors in the hospital and the number of patients they have watched over/are watching over. 

SELECT chief_doctors.eid, chief_doctors.sName, chief_doctors.sLast, count(*) FROM chief_doctors, cared_for WHERE chief_doctors.eid = cared_for.eid GROUP BY chief_doctors.eid, chief_doctors.sName, chief_doctors.sLast;

-- 2 : Query on view current_patient, returns only the past stays of every patient currently staying at the hospital. 

SELECT current_patient.pid, current_patient.pName, current_patient.pLast, stays.sid, stays.in_date, stays.out_date FROM stays, current_patient WHERE stays.pid = current_patient.pid AND stays.out_date IS NOT NULL;





