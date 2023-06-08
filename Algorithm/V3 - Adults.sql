-- BMI source types general extraction and adding cohort in BMI_UNCLEAN
-- code modified from BMI_V2 (s.j.aldridge@swansea.ac.uk)
-- by: m.j.childs@swansea.ac.uk

-- AIMS (and some changes to BMI_V2):
	-- extracting all BMI related entries between 2000-2021.
	-- date restriction applied on BMI_CAT, BMI_VAL, BMI_HEIGHTWEIGHT, and BMI_PEDW
	-- source_db column applied to each table (WLGP / MIDS / PEDW)
-- Note to User: Please read README file that accompanies this code.

-----------------------------------------------------------------------------------------------------------------
------- BMI script FOR adults aged 19 and over ----------------------
-----------------------------------------------------------------------------------------------------------------

-------- USER INPUT NEEDED HERE ---------------------------------------------------------------------------------
--1. Create a cohort table in your schema containing a list of alf's and their WOBs. 

--2. Type the name of your table into the script below under "YOUR_USER_TABLE_GOES_HERE" 
--CREATE OR REPLACE ALIAS SAILW1151V.HDR25_BMI_COHORT
--FOR "SAILW1151V.YOUR_USER_TABLE_GOES_HERE" ;

-----------------------------------------------------------------------------------------------------------------
--3. Find and replace all 1151 with your project schema number using ctrl + f

-----------------------------------------------------------------------------------------------------------------
--4. Find and replace all ALF_E with yout alf format using ctrl + f.
---	 Find and replace all SPELL_NUM_PE with yout spell_num format using ctrl + f.
/*
-----------------------------------------------------------------------------------------------------------------
--5. Create an alias for the most recent versions of the WLGP, PEDW and MIDS event tables as below:
CREATE OR REPLACE ALIAS SAILW1151V.HDR25_BMI_ALG_GP
FOR SAILWMC_V.C19_COHORT_WLGP_GP_EVENT_CLEANSED_20230323 ;
-- FOR 'YOUR_WLGP_TABLE_GOES_HERE'

CREATE OR REPLACE ALIAS SAILW1151V.HDR25_BMI_ALG_PEDW_SPELL
FOR SAILWMC_V.C19_COHORT_PEDW_SPELL_20230323 ;
-- FOR 'YOUR_PEDW_SPELL_TABLE_GOES_HERE'

CREATE OR REPLACE ALIAS SAILW1151V.HDR25_BMI_ALG_PEDW_DIAG
FOR SAILWMC_V.C19_COHORT_PEDW_DIAG_20230323 ;
-- FOR 'YOUR_PEDW_DIAG_TABLE_GOES_HERE'

CREATE OR REPLACE ALIAS SAILW1151V.HDR25_BMI_ALG_MIDS
FOR SAILWMC_V.C19_COHORT_MIDS_INITIAL_ASSESSMENT_20230323 ;
-- FOR 'YOUR_MIDS_TABLE_GOES_HERE'

CREATE OR REPLACE ALIAS SAILW1151V.HDR25_BMI_ALG_MIDS_BIRTH
FOR SAILWMC_V.C19_COHORT_MIDS_BIRTH_20230323 ;
-- FOR 'YOUR_MIDS_BIRTH_TABLE_GOES_HERE'

CREATE OR REPLACE ALIAS SAILW1151V.HDR25_BMI_ALG_NCCH_EXAM
FOR SAILWMC_V.C19_COHORT_NCCH_EXAM_20230323 ;
-- FOR 'YOUR_NCCH_EXAM_TABLE_GOES_HERE'

CREATE OR REPLACE ALIAS SAILW1151V.HDR25_BMI_ALG_NCCH_CHILD_MEASURE
FOR SAILWMC_V.C19_COHORT_NCCH_CHILD_MEASUREMENT_PROGRAM_20230323 ;
-- FOR 'YOUR_NCCH_CHILD_MEASURE_TABLE_GOES_HERE'

CREATE OR REPLACE ALIAS SAILW1151V.HDR25_BMI_ALG_NCCH_CHILD_BIRTH
FOR SAILWMC_V.C19_COHORT_NCCH_CHILD_BIRTHS_20230323 ;
-- FOR 'YOUR_NCCH_CHILD_BIRTH_TABLE_GOES_HERE'

CREATE OR REPLACE ALIAS SAILW1151V.HDR25_BMI_ALG_WDSD
FOR sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 ; -- single view WDSD table
-- FOR 'YOUR_WDSD_TABLE_GOES_HERE'

-----------------------------------------------------------------------------------------------------------------
--6. Create variables for the earliest and latest dates you want the BMI values for (replace dates as necessary)
CREATE OR REPLACE VARIABLE SAILW1151V.HDR25_BMI_DATE_FROM  DATE;
SET SAILW1151V.HDR25_BMI_DATE_FROM = '2000-01-01' ; -- 'YYYY-MM-DD'

CREATE OR REPLACE VARIABLE SAILW1151V.HDR25_BMI_DATE_TO  DATE;
SET SAILW1151V.HDR25_BMI_DATE_TO = '2022-12-31' ; -- 'YYYY-MM-DD'

--7. Optional -- Assign your acceptable ranges for bmi at:
-- same day variation - default = 0.05
CREATE OR REPLACE VARIABLE SAILW1151V.HDR25_BMI_SAME_DAY DOUBLE DEFAULT 0.05;

-- rate of change - default = 0.003
CREATE OR REPLACE VARIABLE SAILW1151V.HDR25_BMI_RATE DOUBLE DEFAULT 0.003; 

-----------------------------------------------------------------------------------------------------------------
--8. Create lookup table -- feel free to review the codes listed below and make any changes
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_LOOKUP');

CREATE TABLE SAILW1151V.HDR25_BMI_LOOKUP
(
        bmi_code        CHAR(5),
        description		VARCHAR(300),
        complexity		VARCHAR(51),
        category		VARCHAR(20)
);

--granting access to team mates
GRANT ALL ON TABLE SAILW1151V.HDR25_BMI_LOOKUP TO ROLE NRDASAIL_SAIL_1151_ANALYST;

--worth doing for large chunks of data
alter table SAILW1151V.HDR25_BMI_LOOKUP activate not logged INITIALLY;

-- This lookup table contains the GP look up codes relevent to height, weight and BMI, they are categorised as such.
insert into SAILW1151V.HDR25_BMI_LOOKUP
VALUES
('2293.', 'O/E -height within 10% average', 'where event_val between x and y (depending on unit)', 'height'),
('229..', 'O/E - height', 'where event_val between x and y (depending on unit)', 'height'),
('229Z.', 'O/E - height NOS', 'where event_val between x and y (depending on unit)', 'height'),
('2292.', 'O/E - height 10-20% < average', 'height', 'height'),
('2294.', 'O/E - height 10-20% over average', 'height', 'height'),
('2295.', 'O/E - height > 20% over average', 'height', 'height'),
('2291.', 'O/E - height > 20% below average', 'height', 'height'),
('22A..', 'O/E - weight', 'where event_val between 32 and 250', 'weight'),
('22A1.', 'O/E - weight > 20% below ideal', 'where event_val between 32 and 250', 'weight'),
('22A2.', 'O/E - weight 10-20% below ideal', 'where event_val between 32 and 250', 'weight'),
('22A3.', 'O/E - weight within 10% ideal', 'where event_val between 32 and 250', 'weight'),
('22A4.', 'O/E - weight 10-20% over ideal', 'where event_val between 32 and 250', 'weight'),
('22A5.', 'O/E - weight > 20% over ideal', 'where event_val between 32 and 250', 'weight'),
('22A6.', 'O/E - Underweight', 'where event_val between 32 and 250', 'weight'),
('22AA.', 'Overweight', 'where event_val between 32 and 250', 'weight'),
('22AZ.', 'O/E - weight NOS', 'where event_val between 32 and 250', 'weight'),
('1266.', 'FH: Obesity', 'Obese', 'obese'),
('1444.', 'H/O: obesity', 'Obese', 'obese'),
('22K3.', 'Body Mass Index low K/M2', 'Underweight', 'underweight'),
('22K..', 'Body Mass Index', 'bmi', 'bmi'),
('22K1.', 'Body Mass Index normal K/M2', 'Normal weight', 'normal weight'),
('22K2.', 'Body Mass Index high K/M2', 'Overweight/Obese', 'obese'),
('22K4.', 'Body mass index index 25-29 - overweight', 'Overweight', 'overweight'),
('22K5.', 'Body mass index 30+ - obesity', 'Obese', 'obese'),
('22K6.', 'Body mass index less than 20', 'Underweight', 'underweight'),
('22K7.', 'Body mass index 40+ - severely obese', 'Obese', 'obese'),
('22K8.', 'Body mass index 20-24 - normal', 'Normal weight', 'normal weight'),
('22K9.', 'Body mass index centile', 'bmi', 'bmi'),
('22KC.', 'Obese class I (body mass index 30.0 - 34.9)', 'Obese', 'obese'),
('22KC.', 'Obese class I (BMI 30.0-34.9)', 'Obese', 'obese'),
('22KD.', 'Obese class II (body mass index 35.0 - 39.9)', 'Obese', 'obese'),
('22KD.', 'Obese class II (BMI 35.0-39.9)', 'Obese', 'obese'),
('22KE.', 'Obese class III (BMI equal to or greater than 40.0)', 'Obese', 'obese'),
('22KE.', 'Obese cls III (BMI eq/gr 40.0)', 'Obese', 'obese'),
('66C4.', 'Has seen dietician - obesity', 'Obese', 'obese'),
('66C6.', 'Treatment of obesity started', 'Obese', 'obese'),
('66CE.', 'Reason for obesity therapy - occupational', 'Obese', 'obese'),
('8CV7.', 'Anti-obesity drug therapy commenced', 'Obese', 'obese'),
('8T11.', 'Rfrrl multidisip obesity clin', 'Obese', 'obese'),
('C38..', 'Obesity/oth hyperalimentation', 'Obese', 'obese'),
('C380.', 'Obesity', 'Obese', 'obese'),
('C3800', 'Obesity due to excess calories', 'Obese', 'obese'),
('C3801', 'Drug-induced obesity', 'Obese', 'obese'),
('C3802', 'Extrem obesity+alveol hypovent', 'Obese', 'obese'),
('C3803', 'Morbid obesity', 'Obese', 'obese'),
('C3804', 'Central obesity', 'Obese', 'obese'),
('C3805', 'Generalised obesity', 'Obese', 'obese'),
('C3806', 'Adult-onset obesity', 'Obese', 'obese'),
('C3807', 'Lifelong obesity', 'Obese', 'obese'),
('C38z.', 'Obesity/oth hyperalimentat NOS', 'Obese', 'obese'),
('C38z0', 'Simple obesity NOS', 'Obese', 'obese'),
('Cyu7.', '[X]Obesity+oth hyperalimentatn', 'Obese', 'obese'),
('22K4.', 'BMI 25-29 - overweight', 'Overweight', 'overweight'),
('22A1.', 'O/E - weight > 20% below ideal', 'Underweight', 'underweight'),
('22A2.', 'O/E -weight 10-20% below ideal', 'Underweight', 'underweight'),
('22A3.', 'O/E - weight within 10% ideal', 'Normal weight', 'normal weight'),
('22A4.', 'O/E - weight 10-20% over ideal', 'Overweight', 'overweight'),
('22A5.', 'O/E - weight > 20% over ideal', 'Overweight', 'overweight'),
('22A6.', 'O/E - Underweight', 'Underweight', 'underweight'),
('22AA.', 'Overweight', 'Overweight', 'overweight'),
('R0348', '[D] Underweight', 'Underweight', 'underweight'),
('66C1.','Itinital obesity assessment','Obese','obese'),
('66C2.','Follow-up obesity assessment','Obese','obese'),
('66C5.','Treatment of obesity changed','Obese','obese'),
('66CX.','Obesity multidisciplinary case review','Obese','obese'),
('66CZ.','Obesity monitoring NOS','Obese','obese'),
('9hN..','Exception reporting: obesity quality indicators','Obese','obese'),
('9OK..','Obesity monitoring admin.','Obese','obese'),
('9OK1.','Attends obesity monitoring','Obese','obese'),
('9OK3.','Obesity monitoring default','Obese','obese'),
('9OK2.','Refuses obesity monitoring','Obese','obese'),
('9OK4.','Obesity monitoring 1st letter','Obese','obese'),
('9OK5.','Obesity monitoring 2nd letter','Obese','obese'),
('9OK6.','Obesity monitoring 3rd letter','Obese','obese'),
('9OK7.','Obesity monitoring verbal inv.','Obese','obese'),
('9OK8.','Obesity monitor phone invite','Obese','obese'),
('9OKA.','Obesity monitoring check done','Obese','obese'),
('9OKZ.','Obesity monitoring admin.NOS','Obese','obese'),
('C38y0','Pickwickian syndrome','Obese','obese')
;

-- end of read codes
-----------------------------------------------------------------------------------------------------------------
-- 9. Drop final BMI table if it exists using the code below
-----------------------------------------------------------------------------------------------------------------
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS');
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_CLEAN_ADULTS');

------------------------------------------------------------------------------------------------------------------
------------------------------- ALGORITHM RUNS FROM HERE ---------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
--1. creating subtables of BMI category
-- there will be a table for underweight, normal weight, overweight, and obese.
-- these will then be put together using UNION ALL to make the BMI_CAT table.
------------------------------------------------------------------------------------------------------------------
--1a. table for normal underweight
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_UNDERWEIGHT');

CREATE TABLE SAILW1151V.HDR25_UNDERWEIGHT
(
		ALF_E        	BIGINT,
		bmi_dt     		DATE,
		bmi_cat			VARCHAR(13),
		bmi_c			CHAR(1),
		bmi_val			DECIMAL(5),
		source_db		VARCHAR(12)
)
DISTRIBUTE BY HASH(ALF_E);
COMMIT;

INSERT INTO SAILW1151V.HDR25_UNDERWEIGHT
SELECT -- extracting those categorised as underweight
	DISTINCT (ALF_E), 
	event_dt AS bmi_dt, 
	'Underweight' AS bmi_cat, 
	'1' AS bmi_c,
	CASE 
		WHEN event_val >= 12 	AND event_val < 18.50 	THEN event_val 
		WHEN event_val IS NULL 							THEN NULL
		ELSE 9999
		END AS bmi_val,
	'WLGP' AS source_db
FROM 
	SAILW1151V.HDR25_BMI_ALG_GP a
INNER JOIN 
	SAILW1151V.HDR25_BMI_lookup b
ON a.event_cd = b.bmi_code AND b.category = 'underweight'
WHERE 
	a.event_dt BETWEEN SAILW1151V.HDR25_BMI_DATE_FROM AND SAILW1151V.HDR25_BMI_DATE_TO
AND	alf_sts_cd IN ('1', '4', '39')
;

COMMIT;


--1b. table for normal weight
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_NORMALWEIGHT');

CREATE TABLE SAILW1151V.HDR25_NORMALWEIGHT
(
		ALF_E        	BIGINT,
		bmi_dt     		DATE,
		bmi_cat			VARCHAR(13),
		bmi_c			CHAR(1),
		bmi_val			DECIMAL(5),
		source_db		VARCHAR(12)
)
DISTRIBUTE BY HASH(ALF_E);
COMMIT;

INSERT INTO SAILW1151V.HDR25_NORMALWEIGHT
SELECT
	DISTINCT (ALF_E), 
	event_dt AS bmi_dt, 
	'Normal weight' AS bmi_cat, 
	'2' AS bmi_c,
	CASE 
		WHEN event_val >= 18.5 AND event_val < 25 		THEN event_val 
		WHEN event_val IS NULL 							THEN NULL
		ELSE 9999
		END AS bmi_val,
	'WLGP' AS source_db
FROM 
	SAILW1151V.HDR25_BMI_ALG_GP a
RIGHT JOIN 
	SAILW1151V.HDR25_BMI_lookup b
ON a.event_cd = b.bmi_code AND b.category = 'normal weight'
WHERE 
	a.event_dt BETWEEN SAILW1151V.HDR25_BMI_DATE_FROM AND SAILW1151V.HDR25_BMI_DATE_TO
	AND	alf_sts_cd IN ('1', '4', '39')
;


--1c. creating table for overweight
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_OVERWEIGHT');

CREATE TABLE SAILW1151V.HDR25_OVERWEIGHT
(
		ALF_E        	BIGINT,
		bmi_dt     		DATE,
		bmi_cat			VARCHAR(13),
		bmi_c			CHAR(1),
		bmi_val			DECIMAL(5),
		source_db		VARCHAR(12)
)
DISTRIBUTE BY HASH(ALF_E);
COMMIT;

INSERT INTO SAILW1151V.HDR25_OVERWEIGHT
SELECT 
	DISTINCT (ALF_E), 
	event_dt AS bmi_dt, 
	'Overweight' AS bmi_cat, 
	'3' AS bmi_c,
	CASE 
		WHEN event_val >= 25 AND event_val < 30 		THEN event_val 
		WHEN event_val IS NULL 							THEN NULL
		ELSE 9999
		END AS bmi_val,
	'WLGP' AS source_db
FROM 
	SAILW1151V.HDR25_BMI_ALG_GP a
RIGHT JOIN 
	SAILW1151V.HDR25_BMI_lookup b
ON a.event_cd = b.bmi_code AND b.category = 'overweight'
WHERE 
	a.event_dt BETWEEN SAILW1151V.HDR25_BMI_DATE_FROM AND SAILW1151V.HDR25_BMI_DATE_TO
AND	alf_sts_cd IN ('1', '4', '39')
;

COMMIT;

--1d. creating table for obese
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_OBESE');

CREATE TABLE SAILW1151V.HDR25_OBESE
(
		ALF_E        	BIGINT,
		bmi_dt     		DATE,
		bmi_cat			VARCHAR(13),
		bmi_c			CHAR(1),
		bmi_val			DECIMAL(5),
		source_db		VARCHAR(12)
)
DISTRIBUTE BY HASH(ALF_E);
COMMIT;

ALTER TABLE SAILW1151V.HDR25_OBESE activate not logged INITIALLY;

INSERT INTO SAILW1151V.HDR25_OBESE
SELECT 
	DISTINCT (ALF_E), 
	event_dt AS bmi_dt, 
	'Obese' AS bmi_cat, 
	'4' AS bmi_c,
	CASE 
		WHEN event_val > 30 AND event_val < 100 		THEN event_val 
		WHEN event_val IS NULL 							THEN NULL
		ELSE 9999
		END AS bmi_val,
	'WLGP' AS source_db
FROM SAILW1151V.HDR25_BMI_ALG_GP a
RIGHT JOIN 
	SAILW1151V.HDR25_BMI_lookup b
ON a.event_cd = b.bmi_code AND b.category = 'obese'
WHERE 
	a.event_dt BETWEEN SAILW1151V.HDR25_BMI_DATE_FROM AND SAILW1151V.HDR25_BMI_DATE_TO
AND	alf_sts_cd IN ('1', '4', '39')
;



--1e. Pulling ALL entries from WLGP that have BMI category allocated between the time-frame specified.
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_CAT');

CREATE TABLE SAILW1151V.HDR25_BMI_CAT
(
		ALF_E        	BIGINT,
		bmi_dt     		DATE,
		bmi_cat			VARCHAR(13),
		bmi_c			CHAR(1),
		bmi_val			DECIMAL(5),
		source_db		VARCHAR(12)
)
DISTRIBUTE BY HASH(ALF_E);
COMMIT;

CALL SYSPROC.ADMIN_CMD('runstats on table SAILW1151V.HDR25_BMI_CAT with distribution and detailed indexes all');  
COMMIT;	

ALTER TABLE SAILW1151V.HDR25_BMI_CAT activate not logged INITIALLY;

INSERT INTO SAILW1151V.HDR25_BMI_CAT
SELECT DISTINCT -- now we join all these tables together, removing duplicates.
	*
FROM 
	SAILW1151V.HDR25_UNDERWEIGHT
UNION ALL
SELECT DISTINCT
	*
FROM 
	SAILW1151V.HDR25_NORMALWEIGHT
UNION ALL
SELECT DISTINCT
	*
FROM SAILW1151V.HDR25_OVERWEIGHT
UNION ALL
SELECT DISTINCT
	*
FROM SAILW1151V.HDR25_OBESE

COMMIT;

-----------------------------------------------------------------------------------------------------------------
---2. Extracting BMI VALUES
-----------------------------------------------------------------------------------------------------------------
-- Here we extract ALL entries with BMI values from the time-frame specified.
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_VAL');

CREATE TABLE SAILW1151V.HDR25_BMI_VAL
(
		ALF_E        	BIGINT,
		bmi_dt     		DATE,
		bmi_val			DECIMAL(5),
		bmi_cat			CHAR(20),
		bmi_c			CHAR(1),
		source_db		VARCHAR(12)
)
DISTRIBUTE BY HASH(ALF_E);
COMMIT;

CALL SYSPROC.ADMIN_CMD('runstats on table SAILW1151V.HDR25_BMI_VAL with distribution and detailed indexes all');  
COMMIT;	


INSERT INTO SAILW1151V.HDR25_BMI_VAL
SELECT DISTINCT 
    ALF_E, 
	bmi_dt,
	bmi_val,
	CASE  
		WHEN bmi_val < 18.5 					THEN 'Underweight'
		WHEN bmi_val >=18.5   AND bmi_val < 25 	THEN 'Normal weight'
		WHEN bmi_val >= 25.0  AND bmi_val < 30 	THEN 'Overweight'
		WHEN bmi_val >= 30.0 					THEN 'Obese'
		ELSE NULL 
		END AS bmi_cat, -- all the appropriate values will be assigned these categories. 
	CASE  
		WHEN bmi_val < 18.5 					THEN '1'
		WHEN bmi_val >=18.5   AND bmi_val < 25 	THEN '2'
		WHEN bmi_val >= 25.0  AND bmi_val < 30 	THEN '3'
		WHEN bmi_val >= 30.0 					THEN '4'
		ELSE NULL 
		END AS bmi_c, -- all the appropriate values will be assigned these numerical categories. 
		'WLGP' AS source_db
FROM 
	(
	SELECT DISTINCT 
        ALF_E, 
		event_dt    AS bmi_dt, 
		event_val   AS bmi_val
	FROM 
		SAILW1151V.HDR25_BMI_ALG_GP a -- all of the WLGP data which has event_cd
	RIGHT JOIN 
		SAILW1151V.HDR25_BMI_LOOKUP b -- that matches up the bmi_code in this table
	ON a.event_cd = b.bmi_code
	WHERE 
		category = 'bmi' -- all entries relating to 'bmi' which have:
	AND alf_sts_cd 	IN ('1', '4', '39') -- all the acceptable sts_cd
	AND event_val 	BETWEEN 12 AND 100 -- all the acceptable bmi values
	AND event_dt	BETWEEN SAILW1151V.HDR25_BMI_DATE_FROM AND SAILW1151V.HDR25_BMI_DATE_TO -- we want to capture the study date.
	)
; 

COMMIT; 

-----------------------------------------------------------------------------------------------------------------
--3. extracting height and weight values from WLGP, MIDS, and NCCH databases.
-----------------------------------------------------------------------------------------------------------------
-- For each table, we want ALF_E, height_dt/weight_dt, height/weight, and source_db.
	-- We only want valid readings, so not include NULL values.
	-- We want to limit the extraction to our start and end dates.

--3.1.a. Extracting height from WLGP
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_HEIGHT_WLGP');

CREATE TABLE SAILW1151V.HDR25_BMI_HEIGHT_WLGP
(
		ALF_E        	BIGINT,
		height_dt      	DATE,
		height     		DECIMAL(31,8),
		source_db		CHAR(4)
)
DISTRIBUTE BY HASH(ALF_E);

CALL SYSPROC.ADMIN_CMD('runstats on table SAILW1151V.HDR25_BMI_HEIGHT_WLGP with distribution and detailed indexes all');
COMMIT; 

ALTER TABLE SAILW1151V.HDR25_BMI_HEIGHT_WLGP activate not logged INITIALLY;

INSERT INTO SAILW1151V.HDR25_BMI_HEIGHT_WLGP
SELECT DISTINCT 
	ALF_E,  
	event_dt AS height_dt, 
	event_val AS height,
	'WLGP' AS source_db
FROM 
	SAILW1151V.HDR25_BMI_ALG_GP a
RIGHT JOIN
	SAILW1151V.HDR25_BMI_LOOKUP b
ON a.event_cd = b.bmi_code AND b.category = 'height'
WHERE 
	(event_dt BETWEEN SAILW1151V.HDR25_BMI_DATE_FROM AND SAILW1151V.HDR25_BMI_DATE_TO)
	AND alf_sts_cd IN ('1', '4', '39')
	AND event_val IS NOT NULL -- we want valid height 
;

--3.1.b. Extracting weight from WLGP.	
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_WEIGHT_WLGP');

CREATE TABLE SAILW1151V.HDR25_BMI_WEIGHT_WLGP
(
		ALF_E        	BIGINT,
		weight_dt      	DATE,
		weight     		INTEGER,
		source_db		CHAR(4)
)
DISTRIBUTE BY HASH(ALF_E);

CALL SYSPROC.ADMIN_CMD('runstats on table SAILW1151V.HDR25_BMI_WEIGHT_WLGP with distribution and detailed indexes all');
COMMIT; 

ALTER TABLE SAILW1151V.HDR25_BMI_WEIGHT_WLGP activate not logged INITIALLY;

INSERT INTO SAILW1151V.HDR25_BMI_WEIGHT_WLGP
SELECT DISTINCT 
	ALF_E,   
	event_dt	AS weight_dt,
	event_val 	AS weight,
	'WLGP' 		AS source_db
FROM 
	SAILW1151V.HDR25_BMI_ALG_GP a
RIGHT JOIN
	SAILW1151V.HDR25_BMI_LOOKUP b
ON a.event_cd = b.bmi_code AND b.category = 'weight'
WHERE 
	(event_dt BETWEEN SAILW1151V.HDR25_BMI_DATE_FROM AND SAILW1151V.HDR25_BMI_DATE_TO)
	AND alf_sts_cd IN ('1', '4', '39')
	AND event_val IS NOT NULL -- we want valid weight.
;

COMMIT; 

	
--3.2.a. getting height and weight from MIDS
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_HEIGHT_MIDS');

CREATE TABLE SAILW1151V.HDR25_BMI_HEIGHT_MIDS
(
		ALF_E        	BIGINT,
		height_dt      	DATE,
		height     		DECIMAL(5,2),
		source_db		CHAR(4)
)
DISTRIBUTE BY HASH(ALF_E);

CALL SYSPROC.ADMIN_CMD('runstats on table SAILW1151V.HDR25_BMI_HEIGHT_MIDS with distribution and detailed indexes all');
COMMIT; 

ALTER TABLE SAILW1151V.HDR25_BMI_HEIGHT_MIDS activate not logged INITIALLY;

INSERT INTO SAILW1151V.HDR25_BMI_HEIGHT_MIDS
SELECT DISTINCT 
	mother_ALF_E		AS ALF_E,
	initial_ass_dt 		AS height_dt, 
	service_user_height AS height,
	'MIDS'				AS source_db
FROM
	SAILW1151V.HDR25_BMI_ALG_MIDS
WHERE 
	(INITIAL_ASS_DT BETWEEN SAILW1151V.HDR25_BMI_DATE_FROM AND SAILW1151V.HDR25_BMI_DATE_TO)
	AND mother_alf_sts_cd IN ('1', '4', '39')
	AND service_user_height IS NOT NULL;
 

--3.2.b. weight from MIDS
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_WEIGHT_MIDS');

CREATE TABLE SAILW1151V.HDR25_BMI_WEIGHT_MIDS
(
		ALF_E        	BIGINT,
		weight_dt      	DATE,
		weight     		INTEGER,
		source_db		CHAR(4)
)
DISTRIBUTE BY HASH(ALF_E);

CALL SYSPROC.ADMIN_CMD('runstats on table SAILW1151V.HDR25_BMI_WEIGHT_MIDS with distribution and detailed indexes all');
COMMIT; 

ALTER TABLE SAILW1151V.HDR25_BMI_WEIGHT_MIDS activate not logged INITIALLY;

INSERT INTO SAILW1151V.HDR25_BMI_WEIGHT_MIDS
SELECT DISTINCT 
	mother_ALF_E			AS ALF_E,
	initial_ass_dt 			AS weight_dt, 
	service_user_weight_kg 	AS weight,
	'MIDS'					AS source_db
FROM
	SAILW1151V.HDR25_BMI_ALG_MIDS 
WHERE 
	(INITIAL_ASS_DT BETWEEN SAILW1151V.HDR25_BMI_DATE_FROM AND SAILW1151V.HDR25_BMI_DATE_TO)
	AND mother_alf_sts_cd IN ('1', '4', '39')
	AND service_user_weight_kg IS NOT NULL;

COMMIT;


--3.3.a. Extracting height from NCCH tables
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_HEIGHT_NCCH');

CREATE TABLE SAILW1151V.HDR25_BMI_HEIGHT_NCCH
(
		ALF_E        	BIGINT,
		height_dt      	DATE,
		height     		DECIMAL(5,2),
		source_db		CHAR(4)
)
DISTRIBUTE BY HASH(ALF_E);

CALL SYSPROC.ADMIN_CMD('runstats on table SAILW1151V.HDR25_BMI_HEIGHT_NCCH with distribution and detailed indexes all');
COMMIT; 

ALTER TABLE SAILW1151V.HDR25_BMI_HEIGHT_NCCH activate not logged INITIALLY;

INSERT INTO SAILW1151V.HDR25_BMI_HEIGHT_NCCH
SELECT DISTINCT 
	a.ALF_E,
	exam_dt 	AS height_dt,
	height,  -- height is measured in cm, the calculations applied in other height tables do not work for these heights
	'NCCH'	AS source_db
FROM
	(
	SELECT
		child_id_e, -- this is the linkage field between NCCH tables.
		exam_dt,
		height
	FROM
		SAILW1151V.HDR25_BMI_ALG_NCCH_CHILD_MEASURE
	WHERE 
		(exam_dt BETWEEN SAILW1151V.HDR25_BMI_DATE_FROM AND SAILW1151V.HDR25_BMI_DATE_TO)
	AND height IS NOT NULL
	UNION
	SELECT
		child_id_e,
		exam_dt,
		height_cm AS height
	FROM
		SAILW1151V.HDR25_BMI_ALG_NCCH_EXAM  
	WHERE 
		(exam_dt BETWEEN SAILW1151V.HDR25_BMI_DATE_FROM AND SAILW1151V.HDR25_BMI_DATE_TO)
	AND height_cm IS NOT NULL
	)
LEFT JOIN
	SAILW1151V.HDR25_BMI_ALG_NCCH_CHILD_BIRTH a -- no height here, we're using this to get the ALF_E link.
USING (child_id_e)
WHERE 
	alf_sts_cd IN ('1', '4', '39')
AND height IS NOT NULL
;
 

--3.3.b. Extracting weight from NCCH tables
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_WEIGHT_NCCH');

CREATE TABLE SAILW1151V.HDR25_BMI_WEIGHT_NCCH
(
		ALF_E        	BIGINT,
		weight_dt      	DATE,
		weight     		DECIMAL(5,2),
		source_db		CHAR(4)
)
DISTRIBUTE BY HASH(ALF_E);

CALL SYSPROC.ADMIN_CMD('runstats on table SAILW1151V.HDR25_BMI_WEIGHT_NCCH with distribution and detailed indexes all');
COMMIT; 

ALTER TABLE SAILW1151V.HDR25_BMI_WEIGHT_NCCH activate not logged INITIALLY;

INSERT INTO SAILW1151V.HDR25_BMI_WEIGHT_NCCH
SELECT DISTINCT 
	a.ALF_E,
	exam_dt 	AS weight_dt,
	weight, 
	'NCCH'		AS source_db
FROM
	(
	SELECT
		child_id_e, -- this is the linkage field between NCCH tables.
		exam_dt,
		weight
	FROM
		SAILW1151V.HDR25_BMI_ALG_NCCH_CHILD_MEASURE 
	WHERE 
		(exam_dt BETWEEN SAILW1151V.HDR25_BMI_DATE_FROM AND SAILW1151V.HDR25_BMI_DATE_TO)
	AND weight IS NOT NULL
	UNION
	SELECT
		child_id_e,
		exam_dt,
		weight_kg AS weight
	FROM
		SAILW1151V.HDR25_BMI_ALG_NCCH_EXAM 
	WHERE 
		(exam_dt BETWEEN SAILW1151V.HDR25_BMI_DATE_FROM AND SAILW1151V.HDR25_BMI_DATE_TO)
	AND weight_kg IS NOT NULL
	) b
LEFT JOIN
	SAILW1151V.HDR25_BMI_ALG_NCCH_CHILD_BIRTH a  -- no weight here, we're using this to get the ALF_E link.
USING (child_id_e)
WHERE 
	alf_sts_cd IN ('1', '4', '39')
AND weight IS NOT NULL;


--3.4.a. Union all  height tables
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_HEIGHT');

CREATE TABLE SAILW1151V.HDR25_BMI_HEIGHT
(
		ALF_E        	BIGINT,
		height_dt      	DATE,
		height     		DECIMAL(31,8),
		source_db		CHAR(4)
)
DISTRIBUTE BY HASH(ALF_E);

CALL SYSPROC.ADMIN_CMD('runstats on table SAILW1151V.HDR25_BMI_HEIGHT with distribution and detailed indexes all');
COMMIT; 

INSERT INTO SAILW1151V.HDR25_BMI_HEIGHT -- creating a long table with all the height values from WLGP, MIDS and NCCH.
SELECT DISTINCT
	*
FROM 
	SAILW1151V.HDR25_BMI_HEIGHT_WLGP;

INSERT INTO SAILW1151V.HDR25_BMI_HEIGHT
SELECT DISTINCT
	*
FROM
	SAILW1151V.HDR25_BMI_HEIGHT_MIDS;
	
INSERT INTO SAILW1151V.HDR25_BMI_HEIGHT
SELECT DISTINCT
	*
FROM
	SAILW1151V.HDR25_BMI_HEIGHT_NCCH;

COMMIT;

--3.4.b. Union all weight tables
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_WEIGHT');

CREATE TABLE SAILW1151V.HDR25_BMI_WEIGHT
(
		ALF_E        	BIGINT,
		weight_dt      	DATE,
		weight     		INTEGER,
		source_db		CHAR(4)
)
DISTRIBUTE BY HASH(ALF_E);

CALL SYSPROC.ADMIN_CMD('runstats on table SAILW1151V.HDR25_BMI_WEIGHT with distribution and detailed indexes all');
COMMIT; 

ALTER TABLE SAILW1151V.HDR25_BMI_WEIGHT activate not logged INITIALLY;

INSERT INTO SAILW1151V.HDR25_BMI_WEIGHT --creating a long table with all the weight values from WLGP, MIDS and NCCH.
SELECT DISTINCT
	*
FROM 
	SAILW1151V.HDR25_BMI_WEIGHT_WLGP;

INSERT INTO SAILW1151V.HDR25_BMI_WEIGHT
SELECT DISTINCT
	*
FROM
	SAILW1151V.HDR25_BMI_WEIGHT_MIDS;

INSERT INTO SAILW1151V.HDR25_BMI_WEIGHT
SELECT DISTINCT
	*
FROM
	SAILW1151V.HDR25_BMI_WEIGHT_NCCH;

COMMIT;

-----------------------------------------------------------------------------------------------------------------
---4. extracting ALF_Es WITH code FROM PEDW
-----------------------------------------------------------------------------------------------------------------
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_PEDW');

CREATE TABLE SAILW1151V.HDR25_BMI_PEDW
(
		ALF_E        	BIGINT,
		bmi_dt     		DATE,
		bmi_cat			VARCHAR(13),
		bmi_c			CHAR(1),
		source_db		CHAR(4)
)
DISTRIBUTE BY HASH(ALF_E);

CALL SYSPROC.ADMIN_CMD('runstats on table SAILW1151V.HDR25_BMI_PEDW with distribution and detailed indexes all');
COMMIT; 

INSERT INTO SAILW1151V.HDR25_BMI_PEDW 
SELECT distinct ALF_E, 
	ADMIS_DT 	AS bmi_dt, 
	'Obese' 	AS bmi_cat,
	'4' 		AS bmi_c,
	'PEDW' 		AS source_db
FROM 
	SAILW1151V.HDR25_BMI_ALG_PEDW_SPELL a 
INNER JOIN 
	SAILW1151V.HDR25_BMI_ALG_PEDW_DIAG b 
USING 
	(SPELL_NUM_E)
WHERE 
	(ADMIS_DT  BETWEEN SAILW1151V.HDR25_BMI_DATE_FROM AND SAILW1151V.HDR25_BMI_DATE_TO)
	AND DIAG_CD LIKE 'E66%' -- ICD-10 codes that match this have obesity diagnoses.
	AND alf_sts_cd IN ('1', '4', '39') ;

COMMIT;

--------------------------------------------------------------
------------ Putting all BMI data in one table.
--------------------------------------------------------------
-- Here we put all the BMI data in one table. We allocate a hierarchical rank based on source type.
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_COMBO_STAGE_1');

CREATE TABLE SAILW1151V.HDR25_BMI_COMBO_STAGE_1
(
		ALF_E        	BIGINT,
		bmi_dt     		DATE,
		bmi_cat			VARCHAR(13),
		bmi_c			CHAR(1),
		bmi_val			DECIMAL(5),
		height			DECIMAL(31,8),
		weight			INTEGER,
		source_type		VARCHAR(50),
		source_rank		SMALLINT,
		source_db		CHAR(4)
)
DISTRIBUTE BY HASH(ALF_E);

CALL SYSPROC.ADMIN_CMD('runstats on table SAILW1151V.HDR25_BMI_COMBO_STAGE_1 with distribution and detailed indexes all');
COMMIT; 

ALTER TABLE SAILW1151V.HDR25_BMI_COMBO_STAGE_1 activate not logged INITIALLY;

INSERT INTO SAILW1151V.HDR25_BMI_COMBO_STAGE_1 
-- this puts together all of the BMI components into one long table.
SELECT  DISTINCT
	*
FROM 
	(
	SELECT 
		ALF_E, 
		bmi_dt, 
		bmi_cat, 
		bmi_c,
		bmi_val, 
		NULL 			AS height, 
		NULL 			AS weight, 
		'bmi category' 	AS source_type, 
		'5' 			AS source_rank,
		source_db
	FROM 
		SAILW1151V.HDR25_BMI_CAT 
	UNION ALL
	SELECT 
		ALF_E, 
		bmi_dt, 
		bmi_cat, 
		bmi_c,
		bmi_val, 
		NULL 			AS height, 
		NULL 			AS weight, 
		'bmi value' 	AS source_type, 
		'1' 			AS source_rank,
		source_db 
	FROM 
		SAILW1151V.HDR25_BMI_VAL
	UNION ALL
	SELECT 
		ALF_E, 
		height_dt 	AS bmi_dt, 
		NULL		AS bmi_cat,
		NULL		AS bmi_c,
		NULL		AS bmi_val, 
		height, 
		NULL 		AS weight, 
		'height' 	AS source_type, 
		'2' 		AS source_rank,
		source_db
	FROM SAILW1151V.HDR25_BMI_HEIGHT
	WHERE 
		source_db = 'WLGP'
	UNION ALL
	SELECT 
		ALF_E, 
		height_dt 	AS bmi_dt, 
		NULL		AS bmi_cat,
		NULL		AS bmi_c,
		NULL		AS bmi_val, 
		height, 
		NULL 		AS weight, 
		'height' 	AS source_type, 
		'3' 		AS source_rank,
		source_db
	FROM SAILW1151V.HDR25_BMI_HEIGHT
	WHERE 
		source_db = 'MIDS'
	UNION ALL
	SELECT 
		ALF_E, 
		height_dt 	AS bmi_dt, 
		NULL		AS bmi_cat,
		NULL		AS bmi_c,
		NULL		AS bmi_val, 
		height, 
		NULL 		AS weight, 
		'height' 	AS source_type, 
		'4' 		AS source_rank,
		source_db
	FROM SAILW1151V.HDR25_BMI_HEIGHT
	WHERE 
		source_db = 'NCCH'
	UNION ALL
		SELECT 
		ALF_E, 
		weight_dt 	AS bmi_dt, 
		NULL		AS bmi_cat,
		NULL		AS bmi_c,
		NULL		AS bmi_val, 
		NULL 		AS height, 
		weight, 
		'weight' 	AS source_type, 
		'2' 		AS source_rank,
		source_db
	FROM SAILW1151V.HDR25_BMI_WEIGHT
	WHERE 
		source_db = 'WLGP'
	UNION ALL
	SELECT 
		ALF_E, 
		weight_dt 	AS bmi_dt, 
		NULL		AS bmi_cat,
		NULL		AS bmi_c,
		NULL		AS bmi_val, 
		NULL 		AS height, 
		weight, 
		'weight' 	AS source_type, 
		'3' 		AS source_rank,
		source_db
	FROM SAILW1151V.HDR25_BMI_WEIGHT
	WHERE 
		source_db = 'MIDS'
	UNION ALL
	SELECT 
		ALF_E, 
		weight_dt 	AS bmi_dt, 
		NULL		AS bmi_cat,
		NULL		AS bmi_c,
		NULL		AS bmi_val, 
		NULL 		AS height, 
		weight, 
		'weight' 	AS source_type, 
		'4' 		AS source_rank,
		source_db
	FROM SAILW1151V.HDR25_BMI_WEIGHT
	WHERE 
		source_db = 'NCCH'
	UNION ALL 
	SELECT 
		ALF_E, 
		bmi_dt,
		bmi_cat,
		bmi_c,
		NULL				AS bmi_val, 
		NULL 				AS height, 
		NULL 				AS weight, 
		'ICD-10' 			AS source_type, 
		'6' 				AS source_rank,
		source_db			
	FROM 
		SAILW1151V.HDR25_BMI_PEDW
)
;

*/
---- Linking WDSD tables
-- we only want to select ALFs with valid WOB, valid gndr_cd, and those who were alive after the start date.
-- we also calculate how many days each ALF has contributed to the data so we created a follow_up_dod (when they died) and follow_up_res (when they moved out of Wales)
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_COMBO_STAGE_2');

CREATE TABLE SAILW1151V.HDR25_BMI_COMBO_STAGE_2
(
		ALF_E        	BIGINT,
		sex				CHAR(1),
		wob				DATE,
		bmi_dt     		DATE,
		bmi_cat			VARCHAR(13),
		bmi_c			CHAR(1),
		bmi_val			DECIMAL(5),
		height			DECIMAL(31,8),
		weight			INTEGER,
		source_type		VARCHAR(50),
		source_rank		SMALLINT,
		source_db		CHAR(4),
		active_from		DATE,
		active_to		DATE,
		dod				DATE,
		follow_up_dod	INTEGER,
		follow_up_res	INTEGER
)
DISTRIBUTE BY HASH(ALF_E);

CALL SYSPROC.ADMIN_CMD('runstats on table SAILW1151V.HDR25_BMI_COMBO_STAGE_2 with distribution and detailed indexes all');
COMMIT; 

ALTER TABLE SAILW1151V.HDR25_BMI_COMBO_STAGE_2 activate not logged INITIALLY;

INSERT INTO SAILW1151V.HDR25_BMI_COMBO_STAGE_2 -- attaching dod, from_dt, to_dt to BMI_COMBO and creating the follow_up field.
SELECT
	*,
	-- counting how many days they contributed to the data before death
	-- this creates a flag which counts the difference between study start date and DOD.
	-- we will remove those with > 31 days follow up in the next stage.
	abs(DAYS_BETWEEN(dod, SAILW1151V.HDR25_BMI_DATE_FROM)) AS follow_up_dod,
	-- counting how many days they contributed to the data before moving out
	abs(DAYS_BETWEEN(active_from, SAILW1151V.HDR25_BMI_DATE_TO)) AS follow_up_res
FROM
	(
	SELECT DISTINCT 
		a.ALF_E,
		b.sex,
		b.wob,
		bmi_dt, 
		bmi_cat, 
		bmi_c,
		bmi_val, 
		height, 
		weight, 
		source_type, 
		source_rank,
		source_db,
		b.active_from_2 AS active_from,
		b.active_to_2 AS active_to,
		CASE
			WHEN b.dod IS NOT NULL THEN b.DOD
			ELSE '9999-01-01'
			END AS dod
	FROM 
		SAILW1151V.HDR25_BMI_COMBO_STAGE_1 a
	LEFT JOIN
		(
		SELECT DISTINCT
		*, 
		CASE -- if they lived in Wales before the study start date, this is changed to the study start date for the calculation of follow_up_res
			WHEN active_from < SAILW1151V.HDR25_BMI_DATE_FROM THEN SAILW1151V.HDR25_BMI_DATE_FROM
			ELSE active_from
			END AS active_from_2,
		CASE -- if they are still living in Wales at present, change to end of study date.
			WHEN active_to IS NULL THEN SAILW1151V.HDR25_BMI_DATE_TO
			ELSE active_to
			END AS active_to_2
		FROM
			(
			SELECT
				alf_e,
				gndr_cd AS sex,
				wob,
				death_dt AS dod,
				CAST(activefrom AS date) AS active_from,
				CAST(activeto AS date) AS active_to
			FROM
				SAILW1151V.HDR25_BMI_ALG_WDSD -- the single view wdsd table.
			)
		) b
	ON a.ALF_E = b.ALF_E AND a.bmi_dt BETWEEN b.active_from AND b.active_to_2
	WHERE 
		b.wob IS NOT NULL -- we only want to keep ALFs that have WOB
		AND (b.sex IN ('1', '2') AND b.sex IS NOT NULL) -- we want ALFs with valid gndr_cd
		OR 	b.dod > SAILW1151V.HDR25_BMI_DATE_FROM -- we want ALFs who were alive after the start date.
		-- we want ALFs who were alive after the start date. NOTE if I use 'AND', this returns 0 entries. 'OR' function works.
	);


------- selecting only those with 31 days follow up
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_COMBO');
-- this creates the general combo table.

CREATE TABLE SAILW1151V.HDR25_BMI_COMBO
(
		ALF_E        	BIGINT,
		sex				CHAR(1),
		wob				DATE,
		bmi_dt     		DATE,
		bmi_cat			VARCHAR(13),
		bmi_c			CHAR(1),
		bmi_val			DECIMAL(5),
		height			DECIMAL(31,8),
		weight			INTEGER,
		source_type		VARCHAR(50),
		source_rank		SMALLINT,
		source_db		CHAR(4),
		active_from		DATE,
		active_to		DATE,
		dod				DATE,
		follow_up_dod	INTEGER,
		follow_up_res	INTEGER
)
DISTRIBUTE BY HASH(ALF_E);

CALL SYSPROC.ADMIN_CMD('runstats on table SAILW1151V.HDR25_BMI_COMBO with distribution and detailed indexes all');
COMMIT; 

ALTER TABLE SAILW1151V.HDR25_BMI_COMBO activate not logged INITIALLY;

INSERT INTO SAILW1151V.HDR25_BMI_COMBO
SELECT
	ALF_E,
	sex,
	wob,
	bmi_dt, 
	bmi_cat, 
	bmi_c,
	bmi_val, 
	height, 
	weight, 
	source_type, 
	source_rank,
	source_db,
	CASE 
		WHEN active_from IS NULL		THEN SAILW1151V.HDR25_BMI_DATE_FROM
		WHEN active_from IS NOT NULL	THEN active_from
		END AS active_from,
	CASE
		WHEN active_to IS NOT NULL 		THEN active_to
		WHEN active_to IS NULL 			THEN SAILW1151V.HDR25_BMI_DATE_TO
		END AS active_to,
	dod,
	follow_up_dod,
	follow_up_res
FROM 
	SAILW1151V.HDR25_BMI_COMBO_STAGE_2
WHERE 
	follow_up_dod > 31; -- we only want ALFs who were alive/in the study after 31 days of the study start date.

COMMIT;

-------------------------------------------------------------------------------
---- Stage 3. Calculating age and pairing height and weight for ADULT COHORT
-------------------------------------------------------------------------------
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_COMBO_ADULTS_STAGE_1');

CREATE TABLE SAILW1151V.HDR25_BMI_COMBO_ADULTS_STAGE_1
(
		alf_e        	BIGINT,
		sex				CHAR(1),
		wob				DATE,
		bmi_dt     		DATE,
		bmi_cat			VARCHAR(13),
		bmi_c			CHAR(1),
		bmi_val			DECIMAL(5),
		height			DECIMAL(31,8),
		weight			INTEGER,
		source_type		VARCHAR(50),
		source_rank		SMALLINT,
		source_db		CHAR(4),
		active_from		DATE,
		active_to		DATE,
		dod				DATE,
		follow_up_dod	INTEGER,
		follow_up_res	INTEGER
)
DISTRIBUTE BY HASH(alf_e);

CALL SYSPROC.ADMIN_CMD('runstats on table SAILW1151V.HDR25_BMI_COMBO_ADULTS_STAGE_1 with distribution and detailed indexes all');
COMMIT; 

ALTER TABLE SAILW1151V.HDR25_BMI_COMBO_ADULTS_STAGE_1 activate not logged INITIALLY;

INSERT INTO SAILW1151V.HDR25_BMI_COMBO_ADULTS_STAGE_1
WITH height_table AS
-- creating the height table
-- 1.standardising measurements
-- 2. taking only height that is recorded in adulthood
-- 3. taking only the most recent height for adults.
	(
	SELECT
		alf_e,
		sex,
		wob,
		bmi_dt, 
		bmi_cat, 
		bmi_c,
		bmi_val, 
		height_standard AS height, 
		source_type, 
		source_rank,
		source_db,
		active_from,
		active_to,
		dod,
		follow_up_dod,
		follow_up_res
	FROM
		(
		SELECT
			*,
			CASE 
				WHEN height BETWEEN 1.2 	AND 2.13 	THEN height 
				WHEN height BETWEEN 120 	AND 213 	THEN height/100 -- converts centimeters to meters
				WHEN height BETWEEN 48 		AND 84 		THEN (height*2.54)/100  -- converts inches to meters
				ELSE NULL 
				END AS height_standard,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS event_order, -- to get the most recent height reading
			DAYS_BETWEEN (bmi_dt, wob)/365.25 AS age_height
		FROM 
			SAILW1151V.HDR25_BMI_COMBO
		WHERE
			source_type = 'height' -- selecting entries that are only height values
			AND height != 0 -- it will not calculate if 0 is used as denominator.
		)
	WHERE 
		event_order = 1 -- select only the latest reading for adults
		AND age_height BETWEEN 19 AND 100 -- only height readings done when they were adults are kept to be used to calculate BMI.
		AND source_db != 'NCCH' -- we do not include data from NCCH for the adult cohort.
	),
weight_table AS-- weight TABLE
-- extracting weight measurements from BMI_COMBO table.
	(
	SELECT
		alf_e,
		sex,
		wob,
		bmi_dt, 
		bmi_cat, 
		bmi_c,
		bmi_val,  
		weight, 
		source_type, 
		source_rank,
		source_db,
		active_from,
		active_to,
		dod,
		follow_up_dod,
		follow_up_res
	FROM 
		SAILW1151V.HDR25_BMI_COMBO
	WHERE 
        source_type = 'weight'
		AND source_db != 'NCCH' -- we do not include data from NCCH for the adult cohort.
		AND DAYS_BETWEEN (bmi_dt, wob)/365.25 BETWEEN 19 AND 100 -- want to include ALFs who were aged 19 and 100 at the time of BMI reading.
	),
height_weight AS
-- calculating BMI value from the latest height reading for each ALF and the weight entries.
	(
	SELECT
		alf_e,
		sex,
		wob,
		bmi_dt,
		CASE  
			WHEN bmi_val < 18.5 					THEN 'Underweight'
			WHEN bmi_val >=18.5   AND bmi_val < 25 	THEN 'Normal weight'
			WHEN bmi_val >= 25.0  AND bmi_val < 30 	THEN 'Overweight'
			WHEN bmi_val >= 30.0 					THEN 'Obese'
			ELSE NULL 
			END AS bmi_cat, -- all the appropriate values will be assigned these categories. 
		CASE  
			WHEN bmi_val < 18.5 					THEN '1'
			WHEN bmi_val >=18.5   AND bmi_val < 25 	THEN '2'
			WHEN bmi_val >= 25.0  AND bmi_val < 30 	THEN '3'
			WHEN bmi_val >= 30.0 					THEN '4'
			ELSE NULL 
			END AS bmi_c,
		bmi_val,
		height,
		weight,
		source_type,
		source_rank,
		source_db,
		active_from,
		active_to,
		dod,
		follow_up_dod,
		follow_up_res
	FROM 
		(
		SELECT 
			a.alf_e,
			a.sex,
			a.wob,
			b.bmi_dt,
			DEC(DEC(weight, 10, 2)/(height*height),10) AS bmi_val, -- calculates BMI_VAL from height and weight values
			height,
			weight,
			b.source_type,
			b.source_rank,
			b.source_db,
			b.active_from,
			b.active_to,
			b.dod,
			b.follow_up_dod,
			b.follow_up_res
		FROM
			HEIGHT_TABLE a -- the latest height reading for each ALF. 
		INNER JOIN
			weight_table b -- all the weight readings for each ALF.
		USING (alf_e)
		WHERE 
			DEC(DEC(weight, 10, 2)/(height*height),10) BETWEEN 12 AND 100 -- only keeping values that are within our range.
		)
	)
-- getting the table where BMI value has been calculated from height and weight data.
SELECT 
    * 
FROM 
    height_weight;
    
 
--- now adding the other SOURCE types
-- we also allocate the age band in this section.
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_COMBO_ADULTS');

CREATE TABLE SAILW1151V.HDR25_BMI_COMBO_ADULTS
(
		alf_e        	BIGINT,
		sex				CHAR(1),
		wob				DATE,
		age_months		INTEGER,
		age_years		INTEGER,
		age_band		VARCHAR(100),
		bmi_dt     		DATE,
		bmi_cat			VARCHAR(13),
		bmi_c			CHAR(1),
		bmi_val			DECIMAL(5),
		height			DECIMAL(31,8),
		weight			INTEGER,
		source_type		VARCHAR(50),
		source_rank		SMALLINT,
		source_db		CHAR(4),
		active_from		DATE,
		active_to		DATE,
		dod				DATE,
		follow_up_dod	INTEGER,
		follow_up_res	INTEGER
)
DISTRIBUTE BY HASH(alf_e);

CALL SYSPROC.ADMIN_CMD('runstats on table SAILW1151V.HDR25_BMI_COMBO_ADULTS with distribution and detailed indexes all');
COMMIT; 

ALTER TABLE SAILW1151V.HDR25_BMI_COMBO_ADULTS activate not logged INITIALLY;

INSERT INTO SAILW1151V.HDR25_BMI_COMBO_ADULTS
	SELECT
		alf_e,
		sex,
		wob,
		ROUND(DAYS_BETWEEN(BMI_DT, WOB)/30.44)			AS age_months,
		ROUND(DAYS_BETWEEN(BMI_DT, WOB)/365.25)			AS age_years,
		CASE 
			WHEN ROUND(DAYS_BETWEEN(BMI_DT, WOB)/365.25) BETWEEN 19 AND 29		THEN '19-29'
			WHEN ROUND(DAYS_BETWEEN(BMI_DT, WOB)/365.25) = 19 					THEN '19-29'
			WHEN ROUND(DAYS_BETWEEN(BMI_DT, WOB)/365.25) = 29					THEN '19-29'
			WHEN ROUND(DAYS_BETWEEN(BMI_DT, WOB)/365.25) BETWEEN 30 AND 39		THEN '30-39'
			WHEN ROUND(DAYS_BETWEEN(BMI_DT, WOB)/365.25) = 30 					THEN '30-39'
			WHEN ROUND(DAYS_BETWEEN(BMI_DT, WOB)/365.25) = 39					THEN '30-39'
			WHEN ROUND(DAYS_BETWEEN(BMI_DT, WOB)/365.25) BETWEEN 40 AND 49		THEN '40-49'
			WHEN ROUND(DAYS_BETWEEN(BMI_DT, WOB)/365.25) = 40 					THEN '40-49'
			WHEN ROUND(DAYS_BETWEEN(BMI_DT, WOB)/365.25) = 49					THEN '40-49'
			WHEN ROUND(DAYS_BETWEEN(BMI_DT, WOB)/365.25) BETWEEN 50 AND 59		THEN '50-59'
			WHEN ROUND(DAYS_BETWEEN(BMI_DT, WOB)/365.25) = 50 					THEN '50-59'
			WHEN ROUND(DAYS_BETWEEN(BMI_DT, WOB)/365.25) = 59					THEN '50-59'
			WHEN ROUND(DAYS_BETWEEN(BMI_DT, WOB)/365.25) BETWEEN 60 AND 69		THEN '60-69'
			WHEN ROUND(DAYS_BETWEEN(BMI_DT, WOB)/365.25) = 60 					THEN '60-69'
			WHEN ROUND(DAYS_BETWEEN(BMI_DT, WOB)/365.25) = 69					THEN '60-69'
			WHEN ROUND(DAYS_BETWEEN(BMI_DT, WOB)/365.25) BETWEEN 70 AND 79		THEN '70-79'
			WHEN ROUND(DAYS_BETWEEN(BMI_DT, WOB)/365.25) = 70 					THEN '70-79'
			WHEN ROUND(DAYS_BETWEEN(BMI_DT, WOB)/365.25) = 79					THEN '70-79'
			WHEN ROUND(DAYS_BETWEEN(BMI_DT, WOB)/365.25) BETWEEN 80 AND 89		THEN '80-89'
			WHEN ROUND(DAYS_BETWEEN(BMI_DT, WOB)/365.25) = 80 					THEN '80-89'
			WHEN ROUND(DAYS_BETWEEN(BMI_DT, WOB)/365.25) = 89					THEN '80-89'
			WHEN ROUND(DAYS_BETWEEN(BMI_DT, WOB)/365.25) >= 90					THEN '90 -100'
			ELSE NULL 
		END AS age_band,
		bmi_dt,
		bmi_cat, -- all the appropriate values will be assigned these categories. 
		bmi_c,
		bmi_val,
		height,
		weight,
		source_type,
		source_rank,
		source_db,
		active_from,
		active_to,
		dod,
		follow_up_dod,
		follow_up_res
	FROM 
		(
		SELECT
			*
		FROM 
			SAILW1151V.HDR25_BMI_COMBO_ADULTS_STAGE_1-- table which calculated the BMI value and assigned BMI categories from the height and weight values.
		UNION
		SELECT 
			alf_e,
			sex,
			wob,
			bmi_dt, 
			bmi_cat, 
			bmi_c,
			bmi_val,
			height,
			weight, 
			source_type, 
			source_rank,
			source_db,
			active_from,
			active_to,
			dod,
			follow_up_dod,
			follow_up_res
		FROM 
			SAILW1151V.HDR25_BMI_COMBO
		WHERE source_type IN ('bmi category', 'bmi value', 'ICD-10') 
		-- adding all the other entries from BMI_COMBO that were from other sources.
		)
	WHERE 
	 	DAYS_BETWEEN (bmi_dt, wob)/365.25 BETWEEN 19 AND 100 -- getting readings when ALF are 19-100yo.
		AND source_db != 'NCCH' -- we exclude all entries for NCCH in the adult cohort.
;

--------------------------------------------
--- Stage 4. Identifying inconsistencies
--------------------------------------------
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS_STAGE_1');

CREATE TABLE SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS_STAGE_1
(
		alf_e        	BIGINT,
		sex				CHAR(1),
		wob				DATE,
		age_months		INTEGER,
		age_years		INTEGER,
		age_band		VARCHAR(100),
		bmi_dt     		DATE,
		bmi_cat			VARCHAR(13),
		bmi_c			CHAR(1),
		bmi_val			DECIMAL(5),
		height			DECIMAL(31,8),
		weight			INTEGER,
		source_type		VARCHAR(50),
		source_rank		SMALLINT,
		source_db		CHAR(4),
		active_from		DATE,
		active_to		DATE,
		dod				DATE,
		follow_up_dod	INTEGER,
		follow_up_res	INTEGER,
		bmi_flg			CHAR(1)
)
DISTRIBUTE BY HASH(alf_e);

CALL SYSPROC.ADMIN_CMD('runstats on table SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS_STAGE_1 with distribution and detailed indexes all');
COMMIT; 

ALTER TABLE SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS_STAGE_1 activate not logged INITIALLY;

-- first step of cleaning - flags same-day inconsistencies
INSERT INTO SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS_STAGE_1
	SELECT 
		a.alf_e,
		sex,
		wob,
		age_months,
		age_years,
		age_band,
		bmi_dt,
		bmi_cat,
		bmi_c,
		bmi_val,
		height,
		weight,
		source_type,
		source_rank,
		source_db,
		active_from,
		active_to,
		dod,
		follow_up_dod,
		follow_up_res,
	CASE 	
		WHEN BMI_VAL IS NULL THEN -- only BMI categories recorded
			CASE 
				WHEN (dt_diff_before = 0 	AND cat_diff_before > 1) OR  (dt_diff_after = 0 AND cat_diff_after > 1) 						THEN 1 -- same day readings,  different bmi categories
				ELSE NULL END 
		WHEN BMI_VAL IS NOT NULL THEN -- BMI values were recorded.
			CASE 	
				-- same day readings with more than 5% difference in bmi_value BUT has same BMI_recorded, keep the first reading.
				WHEN (dt_diff_after = 0 	AND (val_diff_after/bmi_val) > SAILW1151V.HDR25_BMI_SAME_DAY AND cat_diff_after = 0) 		THEN 5 -- same day readings, more than 5% BMI value, but same category recording -- we want to keep this record.
				-- same day readings with more than 5% difference in bmi_value AND has different categories recorded
				WHEN (dt_diff_before = 0 	AND (val_diff_before/bmi_val) > SAILW1151V.HDR25_BMI_SAME_DAY)
					OR (dt_diff_after = 0 	AND (val_diff_after/bmi_val) > SAILW1151V.HDR25_BMI_SAME_DAY)	
					AND cat_diff_after != 0																								THEN 3 -- more than 5% weight difference on same day reading, and different category
				-- same day reading, less than 5% BMI difference in BMI value, BUT has change of 1 BMI category. We want to keep, but flag them in case:
				WHEN ((dt_diff_before = 0 	AND (val_diff_before/bmi_val) < SAILW1151V.HDR25_BMI_SAME_DAY)
					and (dt_diff_after = 0 	AND (val_diff_after/bmi_val) < SAILW1151V.HDR25_BMI_SAME_DAY))
					AND (cat_diff_before = 1 OR cat_diff_after = 1)																		THEN 6	
				ELSE NULL END
		END AS bmi_flg				
	FROM 
		(
		SELECT DISTINCT 
			alf_e -- all the ALFs on our adult cohort.
		FROM
			SAILW1151V.HDR25_BMI_COMBO_ADULTS
		) a
	LEFT JOIN
		( -- identifying the changes in BMI categories/BMI values for same-day / over time period.
		  -- we sequence entries on BMI_DT, BMI_VAL and BMI_C in order to compare the values in a more standardised manner
		  -- same day readings will be sequenced in ascending order and changes between entries will be calculated.
		SELECT 
			*,
			abs(bmi_val - (lag(bmi_val) 			OVER (PARTITION BY alf_e ORDER BY bmi_dt, bmi_val, bmi_c)))		AS val_diff_before, 	-- identifies changes in bmi value from previous reading
			abs(dec(bmi_val - (lead(bmi_val) 		OVER (PARTITION BY alf_e ORDER BY bmi_dt, bmi_val, bmi_c)))) 	AS val_diff_after, 		-- identifies changes in bmi_value with next reading
			abs(bmi_c - (lag(bmi_c) 				OVER (PARTITION BY alf_e ORDER BY bmi_dt, bmi_val, bmi_c))) 	AS cat_diff_before, 	-- identifies changes in bmi category from previous reading
			abs(bmi_c - (lead(bmi_c) 				OVER (PARTITION BY alf_e ORDER BY bmi_dt, bmi_val, bmi_c))) 	AS cat_diff_after, 		-- identifies changes in bmi category with next reading
			abs(DAYS_BETWEEN(bmi_dt,(lag(bmi_dt)	OVER (PARTITION BY alf_e ORDER BY bmi_dt, bmi_val, bmi_c)))) 	AS dt_diff_before, 		-- identifies number of days passed from previous reading
			abs(DAYS_BETWEEN(bmi_dt,(lead(bmi_dt) 	OVER (PARTITION BY alf_e ORDER BY bmi_dt, bmi_val, bmi_c)))) 	AS dt_diff_after 		-- identifies number of days passed with next reading
		FROM 
			SAILW1151V.HDR25_BMI_COMBO_ADULTS
		) b
	USING (alf_e)
;

COMMIT;


-- Now we do the second stage of flagging, where we remove entries flagged as 1 or 3 in UNCLEAN_STAGE_1
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS');

CREATE TABLE SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS
(
		alf_e        	BIGINT,
		sex				CHAR(1),
		wob				DATE,
		age_months		INTEGER,
		age_years		INTEGER,
		age_band		VARCHAR(100),
		bmi_dt     		DATE,
		bmi_cat			VARCHAR(13),
		bmi_c			CHAR(1),
		bmi_val			DECIMAL(5),
		height			DECIMAL(31,8),
		weight			INTEGER,
		source_type		VARCHAR(50),
		source_rank		SMALLINT,
		source_db		CHAR(4),
		active_from		DATE,
		active_to		DATE,
		dod				DATE,
		follow_up_dod	INTEGER,
		follow_up_res	INTEGER,
		bmi_flg			CHAR(1)
)
DISTRIBUTE BY HASH(alf_e);

CALL SYSPROC.ADMIN_CMD('runstats on table SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS with distribution and detailed indexes all');
COMMIT; 

ALTER TABLE SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS activate not logged INITIALLY;

-- second step of cleaning - flags different day inconsistencies
INSERT INTO SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS
	SELECT 
		a.alf_e,
		sex,
		wob,
		age_months,
		age_years,
		age_band,
		bmi_dt,
		bmi_cat,
		bmi_c,
		bmi_val,
		height,
		weight,
		source_type,
		source_rank,
		source_db,
		active_from,
		active_to,
		dod,
		follow_up_dod,
		follow_up_res,
	CASE 
		WHEN bmi_flg IS NOT NULL	THEN bmi_flg
		WHEN BMI_VAL IS NULL THEN -- only BMI categories recorded
			CASE
				WHEN (dt_diff_before != 0 		AND cat_diff_before/dt_diff_before > SAILW1151V.HDR25_BMI_RATE 	AND cat_diff_before > 1) 
						OR 	 (dt_diff_after != 0 	AND cat_diff_after/dt_diff_after > SAILW1151V.HDR25_BMI_RATE  	AND cat_diff_after > 1) 	THEN 2 -- more than 0.3% rate of CHANGE
			ELSE NULL END 
		WHEN BMI_VAL IS NOT NULL THEN -- BMI values were recorded.
			CASE
			-- different day readings with more than .3% change of BMI value per day AND more than 1 category change.
					WHEN (dt_diff_before != 0 	AND ((val_diff_before/bmi_val)/dt_diff_before) > SAILW1151V.HDR25_BMI_RATE AND cat_diff_before > 1) 
						OR (dt_diff_after != 0 	AND ((val_diff_after/bmi_val)/dt_diff_after) > SAILW1151V.HDR25_BMI_RATE  AND cat_diff_after > 1) 	THEN 4  -- more than 0.03% rate of change over time.
			ELSE NULL END
		END AS bmi_flg				
	FROM 
		(
		SELECT DISTINCT 
			alf_e -- all the ALFs on our adult cohort.
		FROM
			SAILW1151V.HDR25_BMI_COMBO_ADULTS
		) a
	LEFT JOIN
		( -- identifying the changes in BMI categories/BMI values for same-day / over time period.
		  -- we sequence entries on BMI_DT, BMI_VAL and BMI_C in order to compare the values in a more standardised manner
		  -- same day readings will be sequenced in ascending order and changes between entries will be calculated.
		SELECT 
			*,
			abs(bmi_val - (lag(bmi_val) 			OVER (PARTITION BY alf_e ORDER BY bmi_dt, bmi_val, bmi_c)))		AS val_diff_before, 	-- identifies changes in bmi value from previous reading
			abs(dec(bmi_val - (lead(bmi_val) 		OVER (PARTITION BY alf_e ORDER BY bmi_dt, bmi_val, bmi_c)))) 	AS val_diff_after, 		-- identifies changes in bmi_value with next reading
			abs(bmi_c - (lag(bmi_c) 				OVER (PARTITION BY alf_e ORDER BY bmi_dt, bmi_val, bmi_c))) 	AS cat_diff_before, 	-- identifies changes in bmi category from previous reading
			abs(bmi_c - (lead(bmi_c) 				OVER (PARTITION BY alf_e ORDER BY bmi_dt, bmi_val, bmi_c))) 	AS cat_diff_after, 		-- identifies changes in bmi category with next reading
			abs(DAYS_BETWEEN(bmi_dt,(lag(bmi_dt)	OVER (PARTITION BY alf_e ORDER BY bmi_dt, bmi_val, bmi_c)))) 	AS dt_diff_before, 		-- identifies number of days passed from previous reading
			abs(DAYS_BETWEEN(bmi_dt,(lead(bmi_dt) 	OVER (PARTITION BY alf_e ORDER BY bmi_dt, bmi_val, bmi_c)))) 	AS dt_diff_after 		-- identifies number of days passed with next reading
		FROM 
			SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS_STAGE_1
		-- these are the entries we want to keep:
		WHERE 
			bmi_flg = 5 OR bmi_flg = 6 OR bmi_flg IS NULL
		) b
	USING (alf_e)
;

COMMIT;


SELECT '1' AS row_no, count(DISTINCT alf_e) AS ALFs, count(*) AS counts FROM SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS_STAGE_1
WHERE bmi_flg = 1
UNION 
SELECT '2' AS row_no, count(DISTINCT alf_e) AS ALFs, count(*) AS counts FROM SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS_STAGE_1
WHERE bmi_flg = 3
UNION 
SELECT '5' AS row_no, count(DISTINCT alf_e) AS ALFs, count(*) AS counts FROM SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS_STAGE_1
WHERE bmi_flg = 5
UNION 
SELECT '6' AS row_no, count(DISTINCT alf_e) AS ALFs, count(*) AS counts FROM SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS_STAGE_1
WHERE bmi_flg = 6;


SELECT '3' AS row_no, count(DISTINCT alf_e) AS ALFs, count(*) AS counts FROM SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS
WHERE bmi_flg = 2
UNION 
SELECT '4' AS row_no, count(DISTINCT alf_e) AS ALFs, count(*) AS counts FROM SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS
WHERE bmi_flg = 4
UNION
SELECT '5' AS row_no, count(DISTINCT alf_e) AS ALFs, count(*) AS counts FROM SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS
WHERE bmi_flg = 5
UNION 
SELECT '6' AS row_no, count(DISTINCT alf_e) AS ALFs, count(*) AS counts FROM SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS
WHERE bmi_flg = 6;


----------------------------------------
-- Stage 5. Output table
----------------------------------------
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_CLEAN_ADULTS_STAGE_1');

CREATE TABLE SAILW1151V.HDR25_BMI_CLEAN_ADULTS_STAGE_1  -- this table selects entries that are NOT flagged in the previous step.
(
		alf_e        	BIGINT,
		sex				CHAR(1),
		wob				DATE,
		age_months		INTEGER,
		age_years		INTEGER,
		age_band		VARCHAR(100),
		bmi_dt     		DATE,
		bmi_cat			VARCHAR(20),
		bmi_val			DECIMAL(5),
		height			DECIMAL(31,8),
		weight			INTEGER,
		source_type		VARCHAR(50),
		source_rank		SMALLINT,
		source_db		CHAR(4),
		active_from		DATE,
		active_to		DATE,
		dod				DATE,
		follow_up_dod	INTEGER,
		follow_up_res	INTEGER,
		bmi_flg			CHAR(1)
)
DISTRIBUTE BY HASH(alf_e);

CALL SYSPROC.ADMIN_CMD('runstats on table SAILW1151V.HDR25_BMI_CLEAN_ADULTS_STAGE_1  with distribution and detailed indexes all');
COMMIT; 

INSERT INTO SAILW1151V.HDR25_BMI_CLEAN_ADULTS_STAGE_1
SELECT
	alf_e,
	sex,
	wob,
	age_months,
	age_years,
	age_band,
	bmi_dt,
	CASE
		WHEN bmi_val IS NOT NULL THEN -- reiterating the BMI categories for BMI values.
		CASE
			WHEN bmi_val < 18.5 									THEN 'Underweight'
			WHEN bmi_val >=18.5   AND bmi_val < 25 					THEN 'Normal weight'
			WHEN bmi_val >= 25.0  AND bmi_val < 30 					THEN 'Overweight'
			WHEN bmi_val >= 30.0 									THEN 'Obese'
			ELSE NULL END
		WHEN bmi_val IS NULL THEN -- reiterating the BMI categories from source types.
		CASE
			WHEN source_type = 'bmi category'						THEN BMI_CAT
			WHEN source_type = 'ICD-10'								THEN 'Obese'
			ELSE NULL END
	END AS bmi_cat,
	bmi_val,
	height,
	weight,
	source_type,
	source_rank,
	source_db,
	active_from,
	active_to,
	dod,
	follow_up_dod,
	follow_up_res,
	bmi_flg
FROM
	(
	SELECT DISTINCT
		*,
		ROW_NUMBER() OVER (PARTITION BY alf_e, bmi_dt ORDER BY source_rank) AS counts -- to identify the duplicates
	FROM
		(
		SELECT DISTINCT 
			a.alf_e,
			sex,
			wob,
			age_months,
			age_years,
			age_band,
			a.bmi_dt,
			bmi_cat,
			bmi_val,
			height,
			weight,
			source_type,
			a.source_rank,
			source_db,
			active_from,
			active_to,
			dod,
			follow_up_dod,
			follow_up_res,
			bmi_flg	
		FROM
			(
	--		SELECT count(*)
	--		FROM
	--		(
			SELECT DISTINCT-- our ADULTS cohort
				alf_e,
				bmi_dt,
				min(source_rank) AS source_rank -- choose the entry with highest hierarchical rank
			FROM
				SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS
			GROUP BY
				alf_e,
				bmi_dt,
				bmi_flg
			ORDER BY
				alf_e,
				bmi_dt 
			) a
		LEFT JOIN 
			SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS c
		ON a.alf_e = c.alf_e AND a.bmi_dt=c.bmi_dt AND a.source_rank = c.source_rank
		WHERE 
			bmi_flg IS NULL OR bmi_flg = 5 OR bmi_flg = 6 -- we want to only include entries that are not flagged OR have bmi_flg 5 OR 6.
		) 
	)
WHERE 
	counts = 1 -- remove duplicates brought by the LEFT JOIN.
ORDER BY 
	alf_e, 
	bmi_dt;

---------------------------------------------------------------
-- Adding pregnancy flags.
---------------------------------------------------------------
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_CLEAN_ADULTS');

CREATE TABLE SAILW1151V.HDR25_BMI_CLEAN_ADULTS  -- here we only select entries that are NOT flagged in the previous step.
(
		alf_e        	BIGINT,
		sex				CHAR(1),
		wob				DATE,
		age_months		INTEGER,
		age_years		INTEGER,
		age_band		VARCHAR(100),
		bmi_dt     		DATE,
		bmi_cat			VARCHAR(100),
		bmi_val			DECIMAL(5),
		height			DECIMAL(31,8),
		weight			INTEGER,
		source_type		VARCHAR(50),
		source_rank		CHAR(1),
		source_db		CHAR(4),
		active_from		DATE,
		active_to		DATE,
		dod				DATE,
		follow_up_dod	INTEGER,
		follow_up_res	INTEGER,
		bmi_flg			CHAR(1),
		bmi_year		VARCHAR(4),
		pregnancy_flg	VARCHAR(100)
)
DISTRIBUTE BY HASH(alf_e);

CALL SYSPROC.ADMIN_CMD('runstats on table SAILW1151V.HDR25_BMI_CLEAN_ADULTS  with distribution and detailed indexes all');
COMMIT; 

INSERT INTO SAILW1151V.HDR25_BMI_CLEAN_ADULTS
	SELECT
		alf_e,
		sex,
		wob,
		age_months,
		age_years,
		age_band,
		bmi_dt,
		bmi_cat,
		bmi_val,
		height,
		weight,
		source_type,
		source_rank,
		source_db,
		active_from,
		active_to,
		dod,
		follow_up_dod,
		follow_up_res,
		bmi_flg,
		YEAR(bmi_dt) AS bmi_year, -- will be used for yearly counts
		pregnancy_flg
	FROM
		(
		SELECT DISTINCT
			a.*, -- everything from STAGE_1 table.
			CASE 
				WHEN (DAYS_BETWEEN (bmi_dt, BABY_BIRTH_DT))  <= -1 		AND (DAYS_BETWEEN (bmi_dt, e.BABY_BIRTH_DT)) > -294 		THEN 'pre-natal' -- 42 weeks before birth
				WHEN (DAYS_BETWEEN (bmi_dt, BABY_BIRTH_DT)) BETWEEN 1 	AND 294 													THEN 'post-natal' -- 42 weeks after birth
				ELSE NULL 
				END AS pregnancy_flg, -- this is to  indicate whether the weight recorded is pregnancy related.
			ROW_NUMBER() OVER (PARTITION BY a.alf_e, a.bmi_dt ORDER BY a.source_rank) AS counts
		FROM 
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS_STAGE_1 a
		LEFT JOIN 
			SAILW1151V.HDR25_BMI_ALG_MIDS_BIRTH e
		ON a.alf_e = e.MOTHER_alf_e
		WHERE source_db != 'MIDS' -- entries from databases that are not MIDS could be pre/post/null.
		UNION
		SELECT
			a.*,
			'pre-natal' AS PREGNANCY_FLG,
			ROW_NUMBER() OVER (PARTITION BY alf_e, bmi_dt ORDER BY source_rank) AS counts
		FROM 
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS_STAGE_1 a
		WHERE source_db = 'MIDS' -- all entries from MIDS are pre-natal.
		) 
	WHERE counts = 1 -- removes duplicates created from pregnancy_flgs.
;

COMMIT;

SELECT * FROM SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS_STAGE_1;
SELECT * FROM SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS;
SELECT * FROM SAILW1151V.HDR25_BMI_CLEAN_ADULTS;

