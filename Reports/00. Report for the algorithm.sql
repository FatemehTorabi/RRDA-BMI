-- The following code is used to create the counts for the consort diagram.
-- and upset plots
-- and BMI_years worth of data


-- EXTRACTING ENTRIES FROM DATA SOURCES
-- Layer 1.1. We count the number of distinct (valid) alf and total entries from each database 
-- Layer 1.2. We then exclude those alfs and entries that were
	-- a. outside the study period (dt < study start date OR dt > study end date) -- before or after the study start date
	-- b. do not have a good quality link (sts_cd NOT IN ('1', '4', '39').
-- Layer 1.3. We then count how many distinct alfs and total entries are eligible in our study
	-- dt between study_start AND study_end dates
	-- sts_cd in ('1', '4', '39')
-- Layer 1.4. We then count distinct alfs and total entries that are not related to BMI
	-- WLGP - those with Read codes outside the BMI Lookup table
	-- PEDW - those with diagnoses outside Obesity
	-- MIDS - those with no height AND weight entries
	-- NCCH - those with no height AND weight entries
-- Layer 1.5. We count the distinct alfs and total entries that are BMI related
	-- WLGP - those with Read codes from BMI Lookup table
	-- PEDW - those with diagnoses of Obesity
	-- MIDS - those with at least one height OR one weight entries
	-- NCCH - those with at least one height OR weight entries

-- PUTTING TOGETHER ENTRIES FROM DATA SOURCES IN ONE TABLE
-- Layer 2.1 Counting distinct entries from all the data sources put together (we then link this table to WDSD)
-- Layer 2.2 Removing distinct alfs and entries with no valid demographic information:
	-- invalid WOB,
	--invalid gndr_cd,
	-- died before the study start date
	-- died < 31 days after the study start date.
-- Layer 2.3 Counting the final general COMBO table.

-- BRANCHING TO ADULT COHORT
-- Layer 3.1.1 Branching to adult cohort
	-- Removing height entries that were not the most recent
	-- Removing entries that were done when ALF was not an adult (0-18)
	-- Removing entries that were from NCCH data source
-- Layer 3.1.2 Counting the distinct alf and total entries for Adult cohort
-- Layer 4.1.1 Counting entries that are flagged as inconsistent
-- Layer 4.1.2 Flagged as 1
-- Layer 4.1.3 Flagged as 3
-- Layer 4.1.4 Flagged as 2/4
-- Layer 4.1.5 Entries not flagged
-- Layer 5.1 Counting distinct alf and total entries for ADULT final output.

-- BRANCHING TO CYP COHORT
-- Layer 3.2.1 Removing entries when ALF were 0-1 and 19-100yo
-- Layer 3.2.2 Removing height and weight pairs that were > 180 days gap
-- Layer 3.2.3 Removing BMI value entries with no percentile or z-score
-- Layer 3.2.4 Counting the distinct alf and total entries for CYP cohort
-- Layer 4.2.1 Counting entries that are flagged as inconsistent
-- Layer 4.2.2 Flagged as 1
-- Layer 4.2.3 Flagged as 2
-- Layer 4.2.4 Entries not flagged
-- Layer 5.2 Counting distinct alf and total entries for CYP final output.


CREATE OR REPLACE VARIABLE SAILW1151V.HDR25_BMI_DATE_FROM  DATE;
SET SAILW1151V.HDR25_BMI_DATE_FROM = '2000-01-01' ; -- 'YYYY-MM-DD'

CREATE OR REPLACE VARIABLE SAILW1151V.HDR25_BMI_DATE_TO  DATE;
SET SAILW1151V.HDR25_BMI_DATE_TO = '2022-12-31' ;

CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_Consort');

CREATE TABLE SAILW1151V.HDR25_BMI_Consort
(
	row_no				VARCHAR(100),
	datasource			VARCHAR(100),
	description			VARCHAR(100),
	alf					BIGINT,
	counts				BIGINT
);

ALTER TABLE SAILW1151V.HDR25_BMI_Consort activate not logged INITIALLY;

INSERT INTO SAILW1151V.HDR25_BMI_Consort
SELECT 
	'Layer 1.1 - PEDW' AS row_no,
	'PEDW' AS datasource,
	'PEDW database' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts
FROM 
	SAILW1151V.HDR25_BMI_ALG_PEDW_SPELL a 
INNER JOIN 
	SAILW1151V.HDR25_BMI_ALG_PEDW_DIAG b 
USING 
	(spell_num_e)
WHERE alf_e IS NOT NULL
UNION
SELECT 
	'Layer 1.2 - PEDW' AS row_no,
	'PEDW' AS datasource,
	'EXCLUSIONS date, sts_cd - PEDW database' AS description,
	count(DISTINCT alf_e) AS alf,
	count_big(*) AS counts
FROM 
	SAILW1151V.HDR25_BMI_ALG_PEDW_SPELL a 
INNER JOIN 
	SAILW1151V.HDR25_BMI_ALG_PEDW_DIAG b 
USING 
	(spell_num_e)
WHERE 
	alf_e IS NOT NULL
	AND (ADMIS_DT <  SAILW1151V.HDR25_BMI_date_from -- before study start date
	OR ADMIS_DT > SAILW1151V.HDR25_BMI_DATE_TO) -- after study end date
	OR alf_sts_cd NOT IN  ('1', '4', '39')
UNION
SELECT 
	'Layer 1.3 - PEDW' AS row_no,
	'PEDW' AS datasource,
	'PEDW database - after date and sts_cd restrictions' AS description,
	count(DISTINCT alf_e) AS alf,
	count_big(*) AS counts
FROM 
	SAILW1151V.HDR25_BMI_ALG_PEDW_SPELL a 
INNER JOIN 
	SAILW1151V.HDR25_BMI_ALG_PEDW_DIAG b 
USING 
	(spell_num_e)
WHERE 
	alf_e IS NOT NULL -- has valid alf
	AND (ADMIS_DT BETWEEN SAILW1151V.HDR25_BMI_DATE_FROM AND SAILW1151V.HDR25_BMI_DATE_TO) -- within the study date
	AND alf_sts_cd IN ('1', '4', '39') -- and acceptable sts_cd
UNION
SELECT 
	'Layer 1.4 - PEDW' AS row_no,
	'PEDW' AS datasource,
	'EXCLUSIONS - PEDW database - nonObesity related diagnoses' AS description,
	count(DISTINCT alf_e) AS alf,
	count_big(*) AS counts
FROM 
	SAILW1151V.HDR25_BMI_ALG_PEDW_SPELL a 
INNER JOIN 
	SAILW1151V.HDR25_BMI_ALG_PEDW_DIAG b 
USING 
	(spell_num_e)
WHERE
	alf_e IS NOT NULL
	AND (ADMIS_DT BETWEEN SAILW1151V.HDR25_BMI_DATE_FROM AND SAILW1151V.HDR25_BMI_DATE_TO)
	AND alf_sts_cd IN ('1', '4', '39')
	AND DIAG_CD NOT LIKE 'E66%'
UNION
SELECT
	'Layer 1.5 - PEDW' AS row_no,
	'PEDW' AS datasource,
	'PEDW database - Obesity related ICD-10 codes' AS description,
	count(DISTINCT alf_e) AS alf,
	count_big(*) AS counts
FROM 
	(
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
		alf_e IS NOT NULL
		AND (ADMIS_DT  BETWEEN SAILW1151V.HDR25_BMI_DATE_FROM AND SAILW1151V.HDR25_BMI_DATE_TO)
		AND DIAG_CD LIKE 'E66%' -- ICD-10 codes that match this have obesity diagnoses.
		AND alf_sts_cd IN ('1', '4', '39')
	);

COMMIT;

-- WLGP database
INSERT INTO SAILW1151V.HDR25_BMI_Consort
SELECT
	'Layer 1.1 - WLGP' AS row_no,
	'WLGP' AS datasource,
	'WLGP database' AS description,
	count(DISTINCT alf_e) AS alf,
	count_big(*) AS counts
from SAILW1151V.HDR25_BMI_ALG_GP
WHERE alf_e IS NOT NULL
UNION
SELECT
	'Layer 1.2 - WLGP' AS row_no,
	'WLGP' AS datasource,
	'EXCLUSIONS date, sts_cd - WLGP database' AS description,
	count(DISTINCT alf_e) AS alf,
	count_big(*) AS counts
FROM 
	SAILW1151V.HDR25_BMI_ALG_GP a 
WHERE
	alf_e IS NOT NULL
	AND a.event_dt < SAILW1151V.HDR25_BMI_date_from -- before study start date
	OR a.event_dt > SAILW1151V.HDR25_BMI_date_to -- after study end date
	AND	alf_sts_cd NOT IN  ('1', '4', '39')
UNION
SELECT
	'Layer 1.3 - WLGP' AS row_no,
	'WLGP' AS datasource,
	'WLGP database - after date sts_cd restrictions' AS description,
	count(DISTINCT alf_e) AS alf,
	count_big(*) AS counts
FROM 
	SAILW1151V.HDR25_BMI_ALG_GP a 
WHERE
	alf_e IS NOT NULL
	AND a.event_dt BETWEEN SAILW1151V.HDR25_BMI_date_from AND SAILW1151V.HDR25_BMI_date_to
	AND	alf_sts_cd IN ('1', '4', '39')
UNION
SELECT
	'Layer 1.4 - WLGP' AS row_no,
	'WLGP' AS datasource,
	'EXCLUSIONS -- WLGP database - nonBMI related Read codes' AS description,
	count(DISTINCT alf_e) AS alf,
	count_big(*) AS counts
FROM 
	SAILW1151V.HDR25_BMI_ALG_GP
WHERE 
	alf_e IS NOT NULL
	AND event_cd NOT IN ('2293.','229..','229Z.','2292.','2294.','2295.','2291.','22A..', -- those events that do not match these codes (Add other codes that you used here if needed)
	'22A1.','22A2.','22A3.','22A4.','22A5.','22A6.','22AA.','22AZ.','1266.','1444.','22K3.',
	'22K..','22K1.','22K2.','22K4.','22K5.','22K6.','22K7.','22K8.','22K9.','22KC.','22KC.',
	'22KD.','22KD.','22KE.','22KE.','66C4.','66C6.','66CE.','8CV7.','8T11.','C38..','C380.',
	'C3800','C3801','C3802','C3803','C3804','C3805','C3806','C3807','C38z.','C38z0','Cyu7.',
	'22K4.','22A1.','22A2.','22A3.','22A4.','22A5.','22A6.','22AA.','R0348','66C1.','66C2.',
	'66C5.','66CX.','66CZ.','9hN..','9OK..','9OK1.','9OK3.','9OK2.','9OK4.','9OK5.','9OK6.',
	'9OK7.','9OK8.','9OKA.','9OKZ.','C38y0')
	AND event_dt BETWEEN SAILW1151V.HDR25_BMI_date_from AND SAILW1151V.HDR25_BMI_date_to -- in the inclusion date
	AND	alf_sts_cd IN ('1', '4', '39') -- with the right linkage codes.
UNION
SELECT
	'Layer 1.5 - WLGP' AS row_no,
	'WLGP' AS datasource,
	'WLGP database - BMI related Read codes' AS description,
	count(DISTINCT alf_e) AS alf,
	count_big(*) AS counts
FROM 
	SAILW1151V.HDR25_BMI_ALG_GP
WHERE 
	alf_e IS NOT NULL
	AND event_cd IN ('2293.','229..','229Z.','2292.','2294.','2295.','2291.','22A..', -- those events that do match these codes  (Add other codes that you used here if needed)
	'22A1.','22A2.','22A3.','22A4.','22A5.','22A6.','22AA.','22AZ.','1266.','1444.','22K3.',
	'22K..','22K1.','22K2.','22K4.','22K5.','22K6.','22K7.','22K8.','22K9.','22KC.','22KC.',
	'22KD.','22KD.','22KE.','22KE.','66C4.','66C6.','66CE.','8CV7.','8T11.','C38..','C380.',
	'C3800','C3801','C3802','C3803','C3804','C3805','C3806','C3807','C38z.','C38z0','Cyu7.',
	'22K4.','22A1.','22A2.','22A3.','22A4.','22A5.','22A6.','22AA.','R0348','66C1.','66C2.',
	'66C5.','66CX.','66CZ.','9hN..','9OK..','9OK1.','9OK3.','9OK2.','9OK4.','9OK5.','9OK6.',
	'9OK7.','9OK8.','9OKA.','9OKZ.','C38y0')
	AND event_dt BETWEEN SAILW1151V.HDR25_BMI_date_from AND SAILW1151V.HDR25_BMI_date_to -- in the inclusion date
	AND	alf_sts_cd IN ('1', '4', '39') -- with the right linkage codes.;
	AND (event_val BETWEEN 12 AND 100 OR event_val IS NULL) -- removing BMI values outside our range.
UNION
SELECT
	'Layer 1.5 - WLGP BMI CAT' AS row_no,
	'WLGP' AS datasource,
	'WLGP database - BMI CATEGORY' AS description,
	count(DISTINCT alf_e) AS alf,
	count_big(*) AS counts
FROM 
	SAILW1151V.HDR25_BMI_CAT
UNION
SELECT
	'Layer 1.5 - WLGP BMI VALUE' AS row_no,
	'WLGP' AS datasource,
	'WLGP database - BMI VALUE' AS description,
	count(DISTINCT alf_e) AS alf,
	count_big(*) AS counts
FROM 
	SAILW1151V.HDR25_BMI_VAL
UNION
SELECT
	'Layer 1.5 - WLGP HEIGHT' AS row_no,
	'WLGP' AS datasource,
	'WLGP database - HEIGHT' AS description,
	count(DISTINCT alf_e) AS alf,
	count_big(*) AS counts
FROM 
	SAILW1151V.HDR25_BMI_HEIGHT_WLGP
UNION
SELECT 
	'Layer 1.5 - WLGP WEIGHT' AS row_no,
	'WLGP' AS datasource,
	'WLGP database - WEIGHT' AS description,
	count(DISTINCT alf_e),
	count(*)
FROM
	SAILW1151V.HDR25_BMI_WEIGHT_WLGP;

COMMIT;

	
-- MIDS database
INSERT INTO SAILW1151V.HDR25_BMI_Consort
SELECT -- all entries from 
	'Layer 1.1 - MIDS' AS row_no,
	'MIDS' as datasource,
	'MIDS database' AS description,
	count(DISTINCT mother_alf_e) AS alf,
	count(*) AS counts
FROM SAILW1151V.HDR25_BMI_ALG_MIDS
WHERE 
	mother_alf_e IS NOT NULL
UNION
SELECT 
	'Layer 1.2 - MIDS' AS row_no,
	'MIDS' as datasource,
	'EXCLUSIONS date, sts_cd - MIDS database' AS description,
	count(DISTINCT mother_alf_e) AS alf,
	count(*) AS counts
FROM 
	SAILW1151V.HDR25_BMI_ALG_MIDS
WHERE
	mother_alf_e IS NOT NULL
	AND (INITIAL_ASS_DT <  SAILW1151V.HDR25_BMI_date_from -- before the study date
	OR initial_ass_dt > SAILW1151V.HDR25_BMI_date_to) -- after the study date
	AND mother_alf_sts_cd NOT IN ('1', '4', '39')
UNION
SELECT 
	'Layer 1.3 - MIDS' AS row_no,
	'MIDS' as datasource,
	'MIDS database - after date and sts_cd restrictions' AS description,
	count(DISTINCT mother_alf_e) AS alf,
	count(*) AS counts
FROM 
	SAILW1151V.HDR25_BMI_ALG_MIDS
WHERE 
	mother_alf_e IS NOT NULL
	AND (INITIAL_ASS_DT BETWEEN SAILW1151V.HDR25_BMI_date_from AND SAILW1151V.HDR25_BMI_date_to)
	AND mother_alf_sts_cd IN ('1', '4', '39')
UNION
SELECT -- exclusions from the eligible values
	'Layer 1.4 - MIDS' AS row_no,
	'MIDS' as datasource,
	'EXCLUSIONS - MIDS database - height AND weight IS null' AS description,
	count(DISTINCT mother_alf_e) AS alf,
	count(*) AS counts
FROM 
	SAILW1151V.HDR25_BMI_ALG_MIDS	
WHERE 
	mother_alf_e IS NOT NULL
	AND (initial_ass_dt BETWEEN SAILW1151V.HDR25_BMI_date_from AND SAILW1151V.HDR25_BMI_date_to)
	AND mother_alf_sts_cd IN ('1', '4', '39')
	AND service_user_height IS NULL
	AND  service_user_weight_kg IS NULL
UNION
SELECT -- events with eligible events
	'Layer 1.5.1 - MIDS height OR weight is NOT null' AS row_no,
	'MIDS' as datasource,
	'MIDS database - height OR weight IS NOT null' AS description,
	count(DISTINCT mother_alf_e) AS alf,
	count(*) AS counts
FROM 
	SAILW1151V.HDR25_BMI_ALG_MIDS	
WHERE 
	mother_alf_e IS NOT NULL
	AND (service_user_weight_kg IS NOT NULL OR service_user_height IS NOT NULL)
	AND (initial_ass_dt BETWEEN SAILW1151V.HDR25_BMI_date_from AND SAILW1151V.HDR25_BMI_date_to)
	AND mother_alf_sts_cd IN ('1', '4', '39')
UNION
SELECT -- events with height is not null 
	'Layer 1.5.2 - MIDS height' AS row_no,
	'MIDS' as datasource,
	'MIDS database - height IS NOT null' AS description,
	count(DISTINCT mother_alf_e) AS alf,
	count(*) AS counts
FROM 
	SAILW1151V.HDR25_BMI_ALG_MIDS	
WHERE 
	mother_alf_e IS NOT NULL
	AND service_user_height IS NOT NULL
	AND (initial_ass_dt BETWEEN SAILW1151V.HDR25_BMI_date_from AND SAILW1151V.HDR25_BMI_date_to)
	AND mother_alf_sts_cd IN ('1', '4', '39')
UNION
SELECT -- events with weight is not null
	'Layer 1.5.3 - MIDS weight' AS row_no,
	'MIDS' as datasource,
	'MIDS database - weight IS NOT null' AS description,
	count(DISTINCT mother_alf_e) AS alf,
	count(*) AS counts
FROM 
	SAILW1151V.HDR25_BMI_ALG_MIDS	
WHERE 
	mother_alf_e IS NOT NULL
	AND service_user_weight_kg IS NOT NULL
	AND (initial_ass_dt BETWEEN SAILW1151V.HDR25_BMI_date_from AND SAILW1151V.HDR25_BMI_date_to)
	AND mother_alf_sts_cd  IN ('1', '4', '39');

COMMIT;

-- NCCH database
INSERT INTO SAILW1151V.HDR25_BMI_Consort
SELECT
	'Layer 1.1 - NCCH' AS row_no,
	'NCCH' AS datasource,
	'NCCH database' AS description,
	count(DISTINCT child_id_e) AS alf,
	count(*) AS counts
FROM
	(
	SELECT
		child_id_e, -- this is the linkage field between NCCH tables.
		exam_dt,
		height
	FROM
		SAILW1151V.HDR25_BMI_ALG_NCCH_CHILD_MEASURE
	UNION
	SELECT
		child_id_e,
		exam_dt,
		height_cm AS height
	FROM
		SAILW1151V.HDR25_BMI_ALG_NCCH_EXAM 
	)
LEFT JOIN
	SAILW1151V.HDR25_BMI_ALG_NCCH_CHILD_BIRTH a -- no height here, we're using this to get the ALF_E link.
USING (child_id_e)
WHERE alf_e IS NOT NULL
UNION
SELECT
	'Layer 1.2 - NCCH' AS row_no,
	'NCCH' AS datasource,
	'EXCLUSIONS date, sts_cd - NCCH database' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts
FROM
	(
	SELECT
		child_id_e, -- this is the linkage field between NCCH tables.
		exam_dt
	FROM
		SAILW1151V.HDR25_BMI_ALG_NCCH_CHILD_MEASURE
	UNION
	SELECT
		child_id_e,
		exam_dt
	FROM
		SAILW1151V.HDR25_BMI_ALG_NCCH_EXAM
	)
LEFT JOIN
	SAILW1151V.HDR25_BMI_ALG_NCCH_CHILD_BIRTH a -- no height here, we're using this to get the ALF_E link.
USING (child_id_e)
WHERE 
	alf_e IS NOT NULL
	AND (exam_dt < SAILW1151V.HDR25_BMI_date_from -- before study start date
	OR exam_dt > SAILW1151V.HDR25_BMI_date_to) -- after study end date
	OR alf_sts_cd NOT IN ('1', '4', '39')
UNION
SELECT
	'Layer 1.3 - NCCH' AS row_no,
	'NCCH' AS datasource,
	'NCCH database - after date and sts_cd restrictions ' AS description,
	count(DISTINCT child_id_e) AS alf,
	count(*) AS counts
FROM
	(
	SELECT
		child_id_e, -- this is the linkage field between NCCH tables.
		exam_dt
	FROM
		SAILW1151V.HDR25_BMI_ALG_NCCH_CHILD_MEASURE
	UNION
	SELECT
		child_id_e,
		exam_dt
	FROM
		SAILW1151V.HDR25_BMI_ALG_NCCH_EXAM
	)
LEFT JOIN
	SAILW1151V.HDR25_BMI_ALG_NCCH_CHILD_BIRTH a -- no height here, we're using this to get the ALF_E link.
USING (child_id_e)
WHERE 
	alf_e IS NOT NULL
	AND (exam_dt BETWEEN SAILW1151V.HDR25_BMI_date_from AND SAILW1151V.HDR25_BMI_date_to) -- our study period
	AND alf_sts_cd IN ('1', '4', '39') -- eligible linkage quality
UNION
SELECT
	'Layer 1.4 - NCCH' AS row_no,
	'NCCH' AS datasource,
	'EXCLUDED - NCCH data source - height AND weight null' AS description,
	count(DISTINCT child_id_e) AS alf,
	count(*) AS counts
FROM
	(
	SELECT
		child_id_e,
		exam_dt,
		height,
		weight
	FROM
		SAILW1151V.HDR25_BMI_ALG_NCCH_CHILD_MEASURE
	UNION
	SELECT
		child_id_e,
		exam_dt,
		height_cm AS height,
		weight_kg AS weight
	FROM
		SAILW1151V.HDR25_BMI_ALG_NCCH_EXAM
	)
LEFT JOIN
	SAILW1151V.HDR25_BMI_ALG_NCCH_CHILD_BIRTH a -- no height here, we're using this to get the ALF_E link.
USING (child_id_e)
WHERE 
	alf_e IS NOT NULL
	AND (exam_dt BETWEEN SAILW1151V.HDR25_BMI_date_from AND SAILW1151V.HDR25_BMI_date_to) -- our study period
	AND alf_sts_cd IN ('1', '4', '39') -- eligible linkage quality
	AND (height IS NULL AND weight IS NULL)
UNION
SELECT
	'Layer 1.5 - NCCH' AS row_no,
	'NCCH' AS datasource,
	'NCCH data source - height or weight IS NOT null' AS description,
	count(DISTINCT child_id_e) AS alf,
	count(*) AS counts
FROM
	(
	SELECT
		child_id_e,
		exam_dt,
		height,
		weight
	FROM
		SAILW1151V.HDR25_BMI_ALG_NCCH_CHILD_MEASURE
	UNION
	SELECT
		child_id_e,
		exam_dt,
		height_cm AS height,
		weight_kg AS weight
	FROM
		SAILW1151V.HDR25_BMI_ALG_NCCH_EXAM
	)
LEFT JOIN
	SAILW1151V.HDR25_BMI_ALG_NCCH_CHILD_BIRTH a -- no height here, we're using this to get the ALF_E link.
USING (child_id_e)
WHERE 
	alf_e IS NOT NULL
	AND (exam_dt BETWEEN SAILW1151V.HDR25_BMI_date_from AND SAILW1151V.HDR25_BMI_date_to) -- our study period
	AND alf_sts_cd IN ('1', '4', '39') -- eligible linkage quality
	AND (height IS NOT NULL OR weight IS NOT NULL)
UNION
SELECT
	'Layer 1.5 - NCCH - HEIGHT' AS row_no,
	'NCCH' AS datasource,
	'NCCH data source - height NOT null' AS description,
	count(DISTINCT child_id_e) AS alf,
	count(*) AS counts
FROM
	(
	SELECT
		child_id_e,
		exam_dt,
		height,
		weight
	FROM
		SAILW1151V.HDR25_BMI_ALG_NCCH_CHILD_MEASURE
	UNION
	SELECT
		child_id_e,
		exam_dt,
		height_cm AS height,
		weight_kg AS weight
	FROM
		SAILW1151V.HDR25_BMI_ALG_NCCH_EXAM
	)
LEFT JOIN
	SAILW1151V.HDR25_BMI_ALG_NCCH_CHILD_BIRTH a -- no height here, we're using this to get the ALF_E link.
USING (child_id_e)
WHERE 
	alf_e IS NOT NULL
	AND (exam_dt BETWEEN SAILW1151V.HDR25_BMI_date_from AND SAILW1151V.HDR25_BMI_date_to) -- our study period
	AND alf_sts_cd IN ('1', '4', '39') -- eligible linkage quality
	AND height IS NOT NULL
UNION
SELECT
	'Layer 1.5 - NCCH - WEIGHT' AS row_no,
	'NCCH' AS datasource,
	'NCCH data source - weight IS NOT null' AS description,
	count(DISTINCT child_id_e) AS alf,
	count(*) AS counts
FROM
	(
	SELECT
		child_id_e,
		exam_dt,
		height,
		weight
	FROM
		SAILW1151V.HDR25_BMI_ALG_NCCH_CHILD_MEASURE
	UNION
	SELECT
		child_id_e,
		exam_dt,
		height_cm AS height,
		weight_kg AS weight
	FROM
		SAILW1151V.HDR25_BMI_ALG_NCCH_EXAM
	)
LEFT JOIN
	SAILW1151V.HDR25_BMI_ALG_NCCH_CHILD_BIRTH a -- no height here, we're using this to get the ALF_E link.
USING (child_id_e)
WHERE 
	alf_e IS NOT NULL
	AND (exam_dt BETWEEN SAILW1151V.HDR25_BMI_date_from AND SAILW1151V.HDR25_BMI_date_to) -- our study period
	AND alf_sts_cd IN ('1', '4', '39') -- eligible linkage quality
	AND alf_e IS NOT NULL -- has valid alf
	AND weight IS NOT NULL;

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_Consort
SELECT 
	'Layer 1.5.1 - ALL HEIGHT' AS row_no,
	'ALL HEIGHT' AS datasource,
	'ALL VALID HEIGHT' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts 
FROM SAILW1151V.HDR25_BMI_HEIGHT
UNION
SELECT 
	'Layer 1.5.2 - ALL WEIGHT' AS row_no,
	'ALL WEIGHT' AS datasource,
	'ALL VALID WEIGHT' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts 
FROM SAILW1151V.HDR25_BMI_WEIGHT ;
COMMIT;

-- creating the general COMBO table
INSERT INTO SAILW1151V.HDR25_BMI_Consort
SELECT 
	'Layer 2.1 - COMBO' AS row_no,
	'COMBO' AS datasource,
	'All eligible source types combined' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts
FROM SAILW1151V.HDR25_BMI_COMBO_STAGE_1
-- EXCLUSIONS -- those with invalid WOB, invalid sex, died before study start date, died 31 days after study start date
UNION
SELECT 
	'Layer 2.2 - COMBO' AS row_no,
	'COMBO' AS datasource,
	'EXCLUSIONS - WOB, SEX, FOLLOW-UP' AS description,
	count(DISTINCT a.alf_e) AS alf,
	count(*) AS counts
FROM 
	SAILW1151V.HDR25_BMI_COMBO_STAGE_1 a
LEFT JOIN
	(
	SELECT DISTINCT
	*, 
	CASE
		WHEN active_to IS NULL THEN '9999-01-01'
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
			SAILW1151V.HDR25_BMI_ALG_WDSD
		)
	) b  -- this is the new single view version
ON a.ALF_E = b.ALF_E AND a.bmi_dt BETWEEN b.active_from AND b.active_to_2
WHERE 
	b.wob IS NULL -- counting ALFs with NULL WOB
	OR (b.sex NOT IN ('1', '2') OR b.sex IS NULL) --counting ALFs with invalid gndr_cd
	OR (b.dod < SAILW1151V.HDR25_BMI_DATE_FROM) -- counting ALFs who died before the study date
	OR abs(days_between(b.dod, SAILW1151V.HDR25_BMI_DATE_FROM) < 31) -- counting ALFs who died less than 31 days after the study start date
UNION
SELECT 
	'Layer 2.3 - COMBO' AS row_no,
	'COMBO' AS datasource,
	'Final population COMBO table' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts
FROM SAILW1151V.HDR25_BMI_COMBO;

COMMIT;

-- ADULT BRANCH
INSERT INTO SAILW1151V.HDR25_BMI_Consort
SELECT 
	'Layer 3.1.1 - ADULT' AS row_no,
	'ADULT BRANCH' AS datasource,
	'ADULT BRANCH EXCLUSIONS - Height/age/NCCH' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts
FROM 
	(
	SELECT
		alf_e,
		bmi_dt
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
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS event_order,
			DAYS_BETWEEN (bmi_dt, wob)/365.25 AS age_height
		FROM 
			SAILW1151V.HDR25_BMI_COMBO
		WHERE
			source_type = 'height'
		)
	WHERE 
		age_height < 19 -- when height was recorded before they are adults
	OR event_order != 1 -- not the most recent
	UNION -- join the other source types
	SELECT
		alf_e, bmi_dt
	FROM
		SAILW1151V.HDR25_BMI_COMBO
	WHERE source_type != 'height'
	AND abs(DAYS_BETWEEN(BMI_DT, WOB)/30.44 < 228) -- counting other entries that are not eligible for the adult cohort, e.g. those below 19 years old.
	OR source_db = 'NCCH' -- or coming from NCCH
	)
UNION
SELECT 
	'Layer 3.1.2 - ADULT' AS row_no,
	'ADULT BRANCH' AS datasource,
	'Final adult cohort' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts
FROM
 SAILW1151V.HDR25_BMI_COMBO_ADULTS;


INSERT INTO SAILW1151V.HDR25_BMI_Consort
SELECT -- counting entries that were flagged
	'Layer 4.1.1 - ADULT' AS row_no,
	'ADULT BRANCH' AS datasource,
	'UNCLEAN_ADULTS - flagged as 1, 2, 3, 4' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts
FROM
	(SELECT * FROM 
	SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS_STAGE_1
	WHERE bmi_flg = 1 OR bmi_flg = 3
	UNION
	SELECT * FROM 
	SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS
	WHERE bmi_flg = 2 OR bmi_flg = 4
	)
UNION
SELECT 
	'Layer 4.1.2 - ADULT' AS row_no,
	'ADULT BRANCH' AS datasource,
	'UNCLEAN_ADULTS - flagged as 1' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts
FROM
SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS_STAGE_1
WHERE bmi_flg = 1
UNION
SELECT 
	'Layer 4.1.3 - ADULT' AS row_no,
	'ADULT BRANCH' AS datasource,
	'UNCLEAN_ADULTS -flagged as 3' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts
FROM
SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS_STAGE_1
WHERE bmi_flg = 3
UNION
SELECT 
	'Layer 4.1.4  - ADULT' AS row_no,
	'ADULT BRANCH' AS datasource,
	'UNCLEAN_ADULTS - flagged as 5' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts
FROM
SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS_STAGE_1
WHERE bmi_flg = 5 
UNION
SELECT 
	'Layer 4.1.5  - ADULT' AS row_no,
	'ADULT BRANCH' AS datasource,
	'UNCLEAN_ADULTS - flagged as 6' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts
FROM
SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS_STAGE_1
WHERE bmi_flg = 6
UNION
SELECT 
	'Layer 4.1.6 - ADULT' AS row_no,
	'ADULT BRANCH' AS datasource,
	'UNCLEAN_ADULTS - NOT flagged' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts
FROM
SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS_STAGE_1
WHERE bmi_flg IS NULL
UNION
SELECT 
	'Layer 4.1.7  - ADULT' AS row_no,
	'ADULT BRANCH' AS datasource,
	'UNCLEAN_ADULTS - flagged as 2' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts
FROM
SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS
WHERE bmi_flg = 2 
UNION
SELECT 
	'Layer 4.1.8  - ADULT' AS row_no,
	'ADULT BRANCH' AS datasource,
	'UNCLEAN_ADULTS - flagged as 4' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts
FROM
SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS
WHERE bmi_flg = 4
UNION
SELECT 
	'Layer 4.1.9 - ADULT' AS row_no,
	'ADULT BRANCH' AS datasource,
	'UNCLEAN_ADULTS - NOT flagged' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts
FROM
SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS
WHERE bmi_flg IS NULL;
COMMIT;


INSERT INTO SAILW1151V.HDR25_BMI_Consort
-- Layer 6 - final adult output
SELECT 
	'Layer 5.1 - ADULT' AS row_no,
	'ADULT BRANCH' AS datasource,
	'Adults output' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts
FROM
 SAILW1151V.HDR25_BMI_CLEAN_ADULTS;
COMMIT;

-- CYP branch
INSERT INTO SAILW1151V.HDR25_BMI_Consort
SELECT 
	'Layer 3.2.1 - CYP' AS row_no,
	'CYP' AS datasource,
	'CYP BRANCH EXCLUSION - Less than 2yo and over 18yo at BMI reading' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts
FROM SAILW1151V.HDR25_BMI_COMBO
WHERE DAYS_BETWEEN(BMI_DT, WOB)/30.44 > 228 -- more than 18 years old, i.e., turned 19.
OR DAYS_between(bmi_dt, wob)/30.44 < 24 -- less than 2 YEARS OLD
UNION
SELECT 
	'Layer 3.2.2 - CYP' AS row_no,
	'CYP' AS datasource,
	'CYP BRANCH EXCLUSION - More than 180 days date gap' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts 
FROM SAILW1151V.HDR25_BMI_COMBO_CYP_STAGE_1
WHERE date_gap > 180
UNION
SELECT 
	'Layer 3.2.3 - CYP' AS row_no,
	'CYP' AS datasource,
	'CYP BRANCH EXCLUSION - Null bmi_percentile or bmi_zscore from BMI values/height weight source types' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts FROM SAILW1151V.HDR25_BMI_COMBO_CYP_STAGE_3
WHERE bmi_percentile IS NULL OR bmi_z_score IS NULL -- only BMI values in this stage
UNION
SELECT 
	'Layer 3.2.4 - CYP' AS row_no,
	'CYP' AS datasource,
	'Final CYP cohort' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts 
FROM SAILW1151V.HDR25_BMI_COMBO_CYP
UNION
SELECT 
	'Layer 4.2.1 - CYP' AS row_no,
	'CYP' AS datasource,
	'UNCLEAN_CYP - flagged as 1' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts 
FROM SAILW1151V.HDR25_BMI_UNCLEAN_CYP_STAGE_1
WHERE bmi_flg = 1
UNION
SELECT 
	'Layer 4.2.2 - CYP' AS row_no,
	'CYP' AS datasource,
	'UNCLEAN_CYP - flagged as 3' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts 
FROM SAILW1151V.HDR25_BMI_UNCLEAN_CYP_STAGE_1
WHERE bmi_flg = 3
UNION
SELECT 
	'Layer 4.2.3 - CYP' AS row_no,
	'CYP' AS datasource,
	'UNCLEAN_CYP - flagged as 5' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts 
FROM SAILW1151V.HDR25_BMI_UNCLEAN_CYP_STAGE_1
WHERE bmi_flg = 5
UNION
SELECT 
	'Layer 4.2.4 - CYP' AS row_no,
	'CYP' AS datasource,
	'UNCLEAN_CYP - flagged as 6' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts 
FROM SAILW1151V.HDR25_BMI_UNCLEAN_CYP_STAGE_1
WHERE bmi_flg = 6
UNION
SELECT 
	'Layer 4.2.5 - CYP' AS row_no,
	'CYP' AS datasource,
	'UNCLEAN_CYP - NOT flagged' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts 
FROM SAILW1151V.HDR25_BMI_UNCLEAN_CYP_STAGE_1
WHERE bmi_flg IS NULL
UNION
SELECT 
	'Layer 4.2.8 - CYP' AS row_no,
	'CYP' AS datasource,
	'UNCLEAN_CYP - NOT flagged' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts 
FROM SAILW1151V.HDR25_BMI_UNCLEAN_CYP
WHERE bmi_flg IS NULL
COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_Consort
-- Layer 8 -- final children's output
SELECT 
	'Layer 5.2 - CYP' AS row_no,
	'CYP' AS datasource,
	'CYP output' AS description,
	count(DISTINCT alf_e) AS alf,
	count(*) AS counts 
FROM SAILW1151V.HDR25_BMI_CLEAN_CYP;
COMMIT;



SELECT * FROM sailw1151v.HDR25_BMI_CONSORT
ORDER BY row_no;


-------------------
-- getting the frequency counts FOR yearly BMI records using TableOne.
-------------------

-- Step 1. Get the proportion of individuals with at least one BMI record between 2000 - 2022.

-- counting how many distinct alfs there are in our cohort.
CREATE OR REPLACE VARIABLE SAILW1151V.HDR25_BMI_TOTAL  INTEGER;
SET SAILW1151V.HDR25_BMI_TOTAL = (SELECT count(DISTINCT alf_e) FROM SAILW1151V.HDR25_BMI_POP_DENOM hbpd );

-- getting the percentage of people with BMI records in our two outputs:
SELECT
	(counts * 1.0 / SAILW1151V.HDR25_BMI_TOTAL * 100) AS percentage 
FROM
(
SELECT count(DISTINCT alf_e) AS counts FROM
	(
	SELECT alf_e FROM SAILW1151V.HDR25_BMI_CLEAN_CYP
	UNION
	SELECT alf_e FROM SAILW1151V.HDR25_BMI_CLEAN_ADULTS
	)
)

-- ADULT COHORT
-- Step 1. Define your variables.
CREATE OR REPLACE VARIABLE SAILW1151V.HDR25_BMI_DATE_FROM  DATE;
SET SAILW1151V.HDR25_BMI_DATE_FROM = '2000-01-01' ; -- 'YYYY-MM-DD'

CREATE OR REPLACE VARIABLE SAILW1151V.HDR25_BMI_DATE_TO  DATE;
SET SAILW1151V.HDR25_BMI_DATE_TO = '2022-12-31' ;

-- get the total counts of adults in your cohort.
CREATE OR REPLACE VARIABLE SAILW1151V.HDR25_BMI_TOTAL_ADULTS  INTEGER;
SET SAILW1151V.HDR25_BMI_TOTAL_ADULTS = (SELECT count(DISTINCT alf_e) FROM SAILW1151V.HDR25_BMI_POP_DENOM hbpd WHERE cohort = 1);

-- create the table for easier retrieval in R or Python.
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_YEARLY_COUNTS_ADULTS');

CREATE TABLE SAILW1151V.HDR25_BMI_YEARLY_COUNTS_ADULTS
(
	contribution			VARCHAR(20),
	total_bmi_years			INTEGER,
	counts					INTEGER,	
	percentage				DECIMAL(6,2)
);

-- This table gives the proportion of individuals with yearly counts relative to their contribution to the study.
INSERT INTO SAILW1151V.HDR25_BMI_YEARLY_COUNTS_ADULTS
SELECT
	*,
	ROUND((counts * 1.0 / SAILW1151V.HDR25_BMI_TOTAL_ADULTS * 100), 2) AS percentage
FROM
(
SELECT
	contribution,
	total_bmi_years,
	count(DISTINCT alf_e) AS counts
FROM
	(
	SELECT
		alf_e,
		contribution,
		total_bmi_years
	FROM 
		(
		-- 2. If they have a reading for that year, they have 1 count.
		SELECT 	
			alf_e,
			SUM(year_counts) AS total_BMI_years, -- counting how many yearly records we have for that ALF.
			CASE 
				WHEN follow_up  <= 365					THEN 'up to 01 year'
				WHEN follow_up  between 366  and 730	THEN 'up to 02 years'
				WHEN follow_up  between 731  and 1095	THEN 'up to 03 years'
				WHEN follow_up  between 1096 and 1460	THEN 'up to 04 years'
				WHEN follow_up  between 1461 and 1825	THEN 'up to 05 years'
				WHEN follow_up  between 1826 and 2190	THEN 'up to 06 years'
				WHEN follow_up  between 2191 and 2555	THEN 'up to 07 years'
				WHEN follow_up  between 2556 and 2920	THEN 'up to 08 years'
				WHEN follow_up  between 2921 and 3285	THEN 'up to 09 years'
				WHEN follow_up  between 3286 and 3650	THEN 'up to 10 years'
				WHEN follow_up  between 3651 and 4015	THEN 'up to 11 years'
				WHEN follow_up  between 4016 and 4380	THEN 'up to 12 years'
				WHEN follow_up  between 4381 and 4745	THEN 'up to 13 years'
				WHEN follow_up  between 4746 and 5110	THEN 'up to 14 years'
				WHEN follow_up  between 5111 and 5475	THEN 'up to 15 years'
				WHEN follow_up  between 5476 and 5840	THEN 'up to 16 years'
				WHEN follow_up  between 5841 and 6205	THEN 'up to 17 years'
				WHEN follow_up  between 6206 and 6570	THEN 'up to 18 years'
				WHEN follow_up  between 6571 and 6935	THEN 'up to 19 years'
				WHEN follow_up  between 6936 and 7300	THEN 'up to 20 years'
				WHEN follow_up  between 7301 and 7665	THEN 'up to 21 years'
				WHEN follow_up  between 7661 and 8030	THEN 'up to 22 years'
				WHEN follow_up  between 8031 and 8395	THEN 'up to 23 years'
				WHEN follow_up  > 8395					THEN 'up to 23 years'
				ELSE NULL
			END AS contribution
		FROM
			(
			SELECT
				alf_e,
				bmi_year,
				min(dt_order) AS year_counts, -- they have a bmi readin that year, they count as 1.
				follow_up
			FROM
				(
	 			-- 1. we get the follow_up days to see how many days they contributed to the data.
				SELECT 
					a.alf_e,
					bmi_year,
					abs(DAYS_BETWEEN(max_date, SAILW1151V.HDR25_BMI_DATE_FROM)) AS follow_up, -- how many days they have contributed from the study start date.
					ROW_NUMBER() OVER (PARTITION BY a.alf_e, bmi_year ORDER BY bmi_year desc) AS dt_order -- getting a count of BMI readings per year.	
				FROM SAILW1151V.HDR25_BMI_CLEAN_ADULTS a
				LEFT JOIN
				-- we take the maximum time they are still living in Wales.
					(
					SELECT 
						DISTINCT alf_e, 
							CASE 	
								-- when they moved out of Wales before they died, choose the date they moved out.
								WHEN max(active_to) < dod									THEN max(active_to)
								-- when their residence date started before the study start date, then choose the study start date.
								WHEN min(active_from) < SAILW1151V.HDR25_BMI_DATE_FROM 		THEN SAILW1151V.HDR25_BMI_DATE_FROM
							ELSE dod
							END AS max_date
					FROM SAILW1151V.HDR25_BMI_CLEAN_ADULTS
					GROUP BY alf_e, dod
					ORDER BY alf_e
					) b
				ON a.alf_e = b.alf_e
				)
			GROUP BY alf_e, follow_up, bmi_year
			ORDER BY alf_e
			)
		GROUP BY alf_e, follow_up
		)
	GROUP BY alf_e, contribution, total_bmi_years
)
GROUP BY contribution, total_bmi_years
)
WHERE counts > 10;

SELECT * FROM SAILW1151V.HDR25_BMI_YEARLY_COUNTS_ADULTS
ORDER BY total_bmi_years, contribution;

SELECT sum(percentage) FROM SAILW1151V.HDR25_BMI_YEARLY_COUNTS_ADULTS;


---

CREATE OR REPLACE VARIABLE SAILW1151V.HDR25_BMI_DATE_FROM  DATE;
SET SAILW1151V.HDR25_BMI_DATE_FROM = '2000-01-01' ; -- 'YYYY-MM-DD'



CREATE OR REPLACE VARIABLE SAILW1151V.HDR25_BMI_TOTAL_CYP  INTEGER;
SET SAILW1151V.HDR25_BMI_TOTAL_CYP = (SELECT count(DISTINCT alf_e) FROM SAILW1151V.HDR25_BMI_POP_DENOM WHERE cohort = 2);

CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_YEARLY_COUNTS_CYP');

CREATE TABLE SAILW1151V.HDR25_BMI_YEARLY_COUNTS_CYP
(
	contribution			VARCHAR(20),
	total_bmi_years			INTEGER,
	counts					INTEGER,	
	percentage				DECIMAL(6,2)
);

INSERT INTO SAILW1151V.HDR25_BMI_YEARLY_COUNTS_CYP;
SELECT
	*,
	ROUND((counts * 1.0 / SAILW1151V.HDR25_BMI_TOTAL_CYP * 100), 2) AS percentage
FROM
(
SELECT
	contribution,
	total_bmi_years,
	count(DISTINCT alf_e) AS counts
FROM
	(
	SELECT
		alf_e,
		contribution,
		total_bmi_years
	FROM 
		(
		-- 2. If they have a reading for that year, they have 1 count.
		SELECT 	
			alf_e,
			SUM(year_counts) AS total_BMI_years, -- counting how many yearly records we have for that ALF.
			CASE 
				WHEN follow_up  <= 365					THEN 'up to 01 year'
				WHEN follow_up  between 366  and 730	THEN 'up to 02 years'
				WHEN follow_up  between 731  and 1095	THEN 'up to 03 years'
				WHEN follow_up  between 1096 and 1460	THEN 'up to 04 years'
				WHEN follow_up  between 1461 and 1825	THEN 'up to 05 years'
				WHEN follow_up  between 1826 and 2190	THEN 'up to 06 years'
				WHEN follow_up  between 2191 and 2555	THEN 'up to 07 years'
				WHEN follow_up  between 2556 and 2920	THEN 'up to 08 years'
				WHEN follow_up  between 2921 and 3285	THEN 'up to 09 years'
				WHEN follow_up  between 3286 and 3650	THEN 'up to 10 years'
				WHEN follow_up  between 3651 and 4015	THEN 'up to 11 years'
				WHEN follow_up  between 4016 and 4380	THEN 'up to 12 years'
				WHEN follow_up  between 4381 and 4745	THEN 'up to 13 years'
				WHEN follow_up  between 4746 and 5110	THEN 'up to 14 years'
				WHEN follow_up  between 5111 and 5475	THEN 'up to 15 years'
				WHEN follow_up  between 5476 and 5840	THEN 'up to 16 years'
				WHEN follow_up  between 5841 and 6205	THEN 'up to 17 years'
				WHEN follow_up  between 6206 and 6570	THEN 'up to 18 years'
				WHEN follow_up  > 6570	THEN 'up to 19 years'
				ELSE NULL
			END AS contribution
		FROM
			(
			SELECT
				alf_e,
				bmi_year,
				min(dt_order) AS year_counts, -- they have a bmi readin that year, they count as 1.
				follow_up
			FROM
				(
	 			-- 1. we get the follow_up days to see how many days they contributed to the data.
				SELECT 
					a.alf_e,
					bmi_year,
					abs(DAYS_BETWEEN(max_date, SAILW1151V.HDR25_BMI_DATE_FROM)) AS follow_up, -- how many days they have contributed from the study start date.
					ROW_NUMBER() OVER (PARTITION BY a.alf_e, bmi_year ORDER BY bmi_year desc) AS dt_order -- getting a count of BMI readings per year.	
				FROM SAILW1151V.HDR25_BMI_CLEAN_CYP a
				LEFT JOIN
				-- we take the maximum time they are still living in Wales.
					(
					SELECT DISTINCT alf_e, 
					wob,
					--wob + 18 YEARS AS bday_18th,
					CASE 
						WHEN max(active_to) < dod 						THEN max(active_to)
						WHEN max(active_to) < wob + 19 YEARS - 1 day	THEN max(active_to)
						WHEN max(active_to) > wob + 19 YEARS - 1 day	THEN wob + 18 YEARS - 1 day
						ELSE dod
						END AS max_date
					FROM SAILW1151V.HDR25_BMI_CLEAN_CYP
					GROUP BY alf_e, dod, wob
					ORDER BY alf_e
					) b
				ON a.alf_e = b.alf_e
				)
			GROUP BY alf_e, follow_up, bmi_year
			ORDER BY alf_e
			)
		GROUP BY alf_e, follow_up
		)
	GROUP BY alf_e, contribution, total_bmi_years
)
GROUP BY contribution, total_bmi_years
)
WHERE counts > 10;

SELECT * FROM SAILW1151V.HDR25_BMI_YEARLY_COUNTS_CYP
ORDER BY total_bmi_years, contribution




-- comparing male and female and age_bands

CREATE OR REPLACE VARIABLE SAILW1151V.HDR25_BMI_TOTAL_ADULT_CLEAN  INTEGER;
SET SAILW1151V.HDR25_BMI_TOTAL_ADULT_CLEAN = (SELECT count(*) FROM SAILW1151V.HDR25_BMI_CLEAN_ADULTS);
SELECT
	*,
	ROUND((counts * 1.0 / SAILW1151V.HDR25_BMI_TOTAL_ADULT_CLEAN * 100), 2) AS percentage
FROM
	(
	SELECT 
		sex, age_band,
		count(*) AS counts
	FROM SAILW1151V.HDR25_BMI_CLEAN_ADULTS
	GROUP BY sex, age_band
	ORDER BY sex, age_band
	)
	
CREATE OR REPLACE VARIABLE SAILW1151V.HDR25_BMI_TOTAL_CYP_CLEAN  INTEGER;
SET SAILW1151V.HDR25_BMI_TOTAL_CYP_CLEAN = (SELECT count(*) FROM SAILW1151V.HDR25_BMI_CLEAN_CYP);

SELECT
	*,
	ROUND((counts * 1.0 / SAILW1151V.HDR25_BMI_TOTAL_CYP_CLEAN * 100), 2) AS percentage
FROM
	(
	SELECT 
		sex, age_band,
		count(*) AS counts
	FROM SAILW1151V.HDR25_BMI_CLEAN_CYP
	GROUP BY sex, age_band
	ORDER BY sex, AGE_BAND
	)




	

-----------------------------------------
-- Upset plot for general BMI_COMBO table
-----------------------------------------
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_UPSETPLOT_ALL');

CREATE TABLE SAILW1151V.HDR25_BMI_UPSETPLOT_ALL
(
	alf_e	BIGINT,	
	WLGP	INTEGER,
	MIDS	INTEGER,
	PEDW	INTEGER,
	NCCH	INTEGER
	
);

INSERT INTO SAILW1151V.HDR25_BMI_UPSETPLOT_ALL
SELECT
	DISTINCT a.alf_e,
	CASE 
		WHEN WLGP = 1 THEN 1
		ELSE 0
		END AS WLGP,
	CASE 
		WHEN MIDS = 1 THEN 1
		ELSE 0
		END AS MIDS,
	CASE 
		WHEN PEDW = 1 THEN 1
		ELSE 0
		END AS PEDW,
	CASE 
		WHEN NCCH = 1 THEN 1
		ELSE 0
		END AS NCCH
FROM
	SAILW1151V.HDR25_BMI_COMBO a
LEFT JOIN
	(
	SELECT	
		DISTINCT alf_e,
		1 AS WLGP
	FROM 
		SAILW1151V.HDR25_BMI_COMBO
	WHERE source_db = 'WLGP'
	)b	
ON a.alf_e = b.alf_e
LEFT JOIN
	(
	SELECT	
		DISTINCT alf_e,
		1 AS MIDS
	FROM 
		SAILW1151V.HDR25_BMI_COMBO
	WHERE source_db = 'MIDS'
	)c	
ON a.alf_e = c.alf_e
LEFT JOIN
	(
	SELECT	
		DISTINCT alf_e,
		1 AS PEDW
	FROM 
		SAILW1151V.HDR25_BMI_COMBO
	WHERE source_db = 'PEDW'
	)d	
ON a.alf_e = d.alf_e
LEFT JOIN
	(
	SELECT	
		DISTINCT alf_e,
		1 AS NCCH
	FROM 
		SAILW1151V.HDR25_BMI_COMBO
	WHERE source_db = 'NCCH'
	)e	
ON a.alf_e = e.alf_e;

SELECT * FROM SAILW1151V.HDR25_BMI_UPSETPLOT_ALL;
----------------------------
-- Upset plot for adults
----------------------------
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_UPSETPLOT_ADULTS');

CREATE TABLE SAILW1151V.HDR25_BMI_UPSETPLOT_ADULTS
(
	alf_e	BIGINT,	
	WLGP	INTEGER,
	MIDS	INTEGER,
	PEDW	INTEGER
	
);

INSERT INTO SAILW1151V.HDR25_BMI_UPSETPLOT_ADULTS
SELECT
	DISTINCT a.alf_e,
	CASE 
		WHEN WLGP = 1 THEN 1
		ELSE 0
		END AS WLGP,
	CASE 
		WHEN MIDS = 1 THEN 1
		ELSE 0
		END AS MIDS,
	CASE 
		WHEN PEDW = 1 THEN 1
		ELSE 0
		END AS PEDW
FROM
	SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS a
LEFT JOIN
	(
	SELECT	
		DISTINCT alf_e,
		1 AS WLGP
	FROM 
		SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS
	WHERE source_db = 'WLGP'
	)b	
ON a.alf_e = b.alf_e
LEFT JOIN
	(
	SELECT	
		DISTINCT alf_e,
		1 AS MIDS
	FROM 
		SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS
	WHERE source_db = 'MIDS'
	)c	
ON a.alf_e = c.alf_e
LEFT JOIN
	(
	SELECT	
		DISTINCT alf_e,
		1 AS PEDW
	FROM 
		SAILW1151V.HDR25_BMI_UNCLEAN_ADULTS
	WHERE source_db = 'PEDW'
	)d	
ON a.alf_e = d.alf_e;

SELECT * FROM SAILW1151V.HDR25_BMI_UPSETPLOT_ADULTS;

----------------------
-- Upset plot for CYP
----------------------
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_UPSETPLOT_CYP');

CREATE TABLE SAILW1151V.HDR25_BMI_UPSETPLOT_CYP
(
	alf_e	BIGINT,	
	WLGP	INTEGER,
	MIDS	INTEGER,
	PEDW	INTEGER,
	NCCH	INTEGER
	
);

INSERT INTO SAILW1151V.HDR25_BMI_UPSETPLOT_CYP
SELECT
	DISTINCT a.alf_e,
	CASE 
		WHEN WLGP = 1 THEN 1
		ELSE 0
		END AS WLGP,
	CASE 
		WHEN MIDS = 1 THEN 1
		ELSE 0
		END AS MIDS,
	CASE 
		WHEN PEDW = 1 THEN 1
		ELSE 0
		END AS PEDW,
	CASE 
		WHEN NCCH = 1 THEN 1
		ELSE 0
		END AS NCCH
FROM
	SAILW1151V.HDR25_BMI_UNCLEAN_CYP a
LEFT JOIN
	(
	SELECT	
		DISTINCT alf_e,
		1 AS WLGP
	FROM 
		SAILW1151V.HDR25_BMI_UNCLEAN_CYP
	WHERE source_db = 'WLGP'
	)b	
ON a.alf_e = b.alf_e
LEFT JOIN
	(
	SELECT	
		DISTINCT alf_e,
		1 AS MIDS
	FROM 
		SAILW1151V.HDR25_BMI_UNCLEAN_CYP
	WHERE source_db = 'MIDS'
	)c	
ON a.alf_e = c.alf_e
LEFT JOIN
	(
	SELECT	
		DISTINCT alf_e,
		1 AS PEDW
	FROM 
		SAILW1151V.HDR25_BMI_UNCLEAN_CYP
	WHERE source_db = 'PEDW'
	)d	
ON a.alf_e = d.alf_e
LEFT JOIN
	(
	SELECT	
		DISTINCT alf_e,
		1 AS NCCH
	FROM 
		SAILW1151V.HDR25_BMI_UNCLEAN_CYP
	WHERE source_db = 'NCCH'
	)e	
ON a.alf_e = e.alf_e;

SELECT * FROM SAILW1151V.HDR25_BMI_UPSETPLOT_CYP;
