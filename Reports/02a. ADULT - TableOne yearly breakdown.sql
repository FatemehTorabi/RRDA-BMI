-- this code works to allocate LSOA2011, wimd2019 and rural_urban details for Adults the population, even those with no BMI reading.

------------------------------------------------
-- Section 1. Defining your variables
------------------------------------------------
/*
--Step 1. set the study start date. This will be used to filter out ALFs who have died before your specified study period.
CREATE OR REPLACE VARIABLE SAILW1151V.HDR25_DATE_FROM  DATE;
SET SAILW1151V.HDR25_DATE_FROM = '2000-01-01';

CREATE OR REPLACE VARIABLE SAILW1151V.HDR25_DATE_TO  DATE;
SET SAILW1151V.HDR25_DATE_TO = '2022-12-31';

--Step 2. Define your tables here. These tables will be used to extract demographical information for your cohort.
CREATE OR REPLACE ALIAS SAILW1151V.HDR25_BMI_ALG_COHORT
FOR SAILW1151V.HDR25_BMI_POP_DENOM ; -- has all the ALFs living in Wales from 2010-2022

CREATE OR REPLACE ALIAS SAILW1151V.HDR25_BMI_ALG_OUTPUT
FOR SAILW1151V.HDR25_BMI_CLEAN_ADULTS; -- our final BMI output.

CREATE OR REPLACE ALIAS SAILW1151V.HDR25_BMI_ETHN
FOR SAILW1151V.RRDA_ETHN ; -- has ethnicity field.

CREATE OR REPLACE ALIAS SAILW1151V.HDR25_BMI_ALG_WDSD
FOR SAILWMC_V.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 ; -- sinkle view WDSD for demographics
--SAILXXXXV.WDSD_AR_PERS_20220905

CREATE OR REPLACE ALIAS SAILW1151V.HDR25_BMI_WIMD2019
FOR sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_LSOA2011; -- has wimd2019
-- SAILWMC_V.C19_COHORT_WDSD_CLEAN_ADD_GEOG_CHAR_LSOA2011_20230126 

CREATE OR REPLACE ALIAS SAILW1151V.HDR25_BMI_ALG_LSOA_LHB_LOOKUP -- has rural/urban and LHB
FOR sailw1151v.HDR25_BMI_GEOGRAPHY_LOOKUP ;

;
------------------------------------------------
-- Section 2. Attaching demographic information to all ALFs in population yearly.
------------------------------------------------

CALL FNC.DROP_IF_EXISTS('SAILW1151V.HDR25_BMI_TABLEONE_ADULT'); 

CREATE TABLE SAILW1151V.HDR25_BMI_TABLEONE_ADULT
(
-- from denominator table
		alf_e        			BIGINT, 
-- from ETHN table.
		ethnicity				CHAR(100), 
-- from denominator table		
		sex						CHAR(1), 
		wob						DATE, 
		dod						DATE,
		lsoa2011				VARCHAR(10),
		start_date				DATE,
		end_date				DATE,
		denom_year				VARCHAR(4),
-- from BMI_CLEAN
		age_band				VARCHAR(100),
		bmi_dt					DATE,
		bmi_cat		VARCHAR(20),
		source_db				VARCHAR(10),
-- from demographics
		wimd2019_quintile		VARCHAR(20),
		rural_urban				VARCHAR(200),
		lhb						VARCHAR(200)
);


INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_ADULT
-- 2000
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2000. We select their most recent address in 2000, and attaches their most recent BMI record in 2000 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2000-12-31', wob)/365.25) AS age_years,
		CASE 
				-- those with age_bands already from the BMI output
				WHEN age_band IS NOT NULL THEN age_band 
				-- individuals living in Wales in this year, but no BMI output. We allocate an age band for them here. using the end of the year and their WOB
				WHEN ROUND(DAYS_BETWEEN('2000-12-31', WOB)/365.25) BETWEEN 19 AND 29		THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2000-12-31', WOB)/365.25) = 19 					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2000-12-31', WOB)/365.25) = 29					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2000-12-31', WOB)/365.25) BETWEEN 30 AND 39		THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2000-12-31', WOB)/365.25) = 30 					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2000-12-31', WOB)/365.25) = 39					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2000-12-31', WOB)/365.25) BETWEEN 40 AND 49		THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2000-12-31', WOB)/365.25) = 40 					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2000-12-31', WOB)/365.25) = 49					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2000-12-31', WOB)/365.25) BETWEEN 50 AND 59		THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2000-12-31', WOB)/365.25) = 50 					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2000-12-31', WOB)/365.25) = 59					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2000-12-31', WOB)/365.25) BETWEEN 60 AND 69		THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2000-12-31', WOB)/365.25) = 60 					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2000-12-31', WOB)/365.25) = 69					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2000-12-31', WOB)/365.25) BETWEEN 70 AND 79		THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2000-12-31', WOB)/365.25) = 70 					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2000-12-31', WOB)/365.25) = 79					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2000-12-31', WOB)/365.25) BETWEEN 80 AND 89		THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2000-12-31', WOB)/365.25) = 80 					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2000-12-31', WOB)/365.25) = 89					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2000-12-31', WOB)/365.25) >= 90					THEN '90 -100'
				ELSE NULL 
		END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not Adults in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN bmi_cat IS NOT NULL THEN bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS bmi_cat,
		source_db
	FROM
	-- this is all the Adult population in 2000.
		(
		SELECT * FROM
			(
			SELECT DISTINCT 
				alf_e, 
				sex, 
				wob, 
				lsoa2011_cd, 
				start_date, 
				end_date, 
				dod, 
				denom_year, 
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY start_date, end_date desc) AS dt_order -- to identify those with multiple addresses in this year.
			FROM SAILW1151V.HDR25_BMI_ALG_COHORT a -- the population denominator table
			WHERE denom_year = 2000 -- those that are living in Wales in this year
			AND cohort = 1 -- who are Adults at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this year to remove duplicates.
		)a
	LEFT JOIN
	-- we extract their ethnicity
		SAILW1151V.HDR25_BMI_ETHN AS b 
	ON a.alf_e = b.alf_e
	LEFT JOIN
	-- we extract the BMI data from our output
		(
		SELECT
			*
		FROM
			(
			SELECT
				alf_e,
				age_band,
				bmi_dt,
				bmi_cat,
				source_db,
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
			FROM
				SAILW1151V.HDR25_BMI_ALG_OUTPUT
			WHERE bmi_year = 2000
			) 
		WHERE dt_order = 1
		) c
	ON a.alf_e = c.ALF_E
	ORDER BY alf_e
	),
t2 AS 
-- This chunk puts together the demographical information related to LSOA2011 codes. We will then attach this to t1 in the next step,.
	(
	SELECT
		*
	FROM
		(
		SELECT DISTINCT
				e.LSOA2011_CD 				AS lsoa2011
			,	e.WIMD_2019_QUINTILE_DESC 	AS wimd2019_quintile
			,	g.RU_Name 					AS rural_urban
			,	g.LHB_Name					AS lhb
			, 	ROW_NUMBER() OVER (PARTITION BY e.lsoa2011_cd ORDER BY wimd_2019_quintile_desc) AS row_seq
		FROM
			SAILW1151V.HDR25_BMI_WIMD2019 AS e -- getting wimd2019
		LEFT JOIN 
			SAILW1151V.HDR25_BMI_ALG_LSOA_LHB_LOOKUP AS g -- getting rural/urban and LHB details
		ON e.LSOA2011_CD=g.LSOA2011_Code 
		WHERE e.lsoa2011_cd IS NOT NULL
		)
	WHERE row_seq = 1
	)
-- Now we attach the residency information to our cohort in 2000.
SELECT
	alf_e,
	ethnicity,
	sex,
	wob,
	dod,
	t1.lsoa2011,
	t1.start_date,
	t1.end_date,
	t1.denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	bmi_cat,
	CASE 
		WHEN  source_db IS NULL THEN 'Unknown'
		ELSE  source_db
		END AS source_db,
-- from wimd2019 table
	CASE 
		WHEN  wimd2019_quintile IS NULL THEN 'Unknown'
		ELSE  wimd2019_quintile
		END AS wimd2019_quintile,
-- from rural/urban table
	CASE 
		WHEN  rural_urban IS NULL THEN 'Unknown'
		ELSE  rural_urban
		END AS rural_urban,
	CASE 
		WHEN  lhb IS NULL THEN 'Unknown'
		ELSE  lhb
		END AS lhb
FROM 
	t1
LEFT JOIN
	t2
ON t1.lsoa2011 = t2.lsoa2011 -- this matches the residency information of ALFs
;

COMMIT;
*/
INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_ADULT
-- 2001
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2001. We select their most recent address in 2001, and attaches their most recent BMI record in 2001 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2001-12-31', wob)/365.25) AS age_years,
		CASE 
				-- those with age_bands already from the BMI output
				WHEN age_band IS NOT NULL THEN age_band 
				-- individuals living in Wales in this year, but no BMI output. We allocate an age band for them here. using the end of the year and their WOB
				WHEN ROUND(DAYS_BETWEEN('2001-12-31', WOB)/365.25) BETWEEN 19 AND 29		THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2001-12-31', WOB)/365.25) = 19 					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2001-12-31', WOB)/365.25) = 29					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2001-12-31', WOB)/365.25) BETWEEN 30 AND 39		THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2001-12-31', WOB)/365.25) = 30 					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2001-12-31', WOB)/365.25) = 39					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2001-12-31', WOB)/365.25) BETWEEN 40 AND 49		THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2001-12-31', WOB)/365.25) = 40 					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2001-12-31', WOB)/365.25) = 49					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2001-12-31', WOB)/365.25) BETWEEN 50 AND 59		THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2001-12-31', WOB)/365.25) = 50 					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2001-12-31', WOB)/365.25) = 59					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2001-12-31', WOB)/365.25) BETWEEN 60 AND 69		THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2001-12-31', WOB)/365.25) = 60 					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2001-12-31', WOB)/365.25) = 69					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2001-12-31', WOB)/365.25) BETWEEN 70 AND 79		THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2001-12-31', WOB)/365.25) = 70 					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2001-12-31', WOB)/365.25) = 79					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2001-12-31', WOB)/365.25) BETWEEN 80 AND 89		THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2001-12-31', WOB)/365.25) = 80 					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2001-12-31', WOB)/365.25) = 89					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2001-12-31', WOB)/365.25) >= 90					THEN '90 -100'
				ELSE NULL 
		END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not Adults in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN bmi_cat IS NOT NULL THEN bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS bmi_cat,
		source_db
	FROM
	-- this is all the Adult population in 2001.
		(
		SELECT * FROM
			(
			SELECT DISTINCT 
				alf_e, 
				sex, 
				wob, 
				lsoa2011_cd, 
				start_date, 
				end_date, 
				dod, 
				denom_year, 
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY start_date, end_date desc) AS dt_order -- to identify those with multiple addresses in this year.
			FROM SAILW1151V.HDR25_BMI_ALG_COHORT a -- the population denominator table
			WHERE denom_year = 2001 -- those that are living in Wales in this year
			AND cohort = 1 -- who are Adults at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this year to remove duplicates.
		)a
	LEFT JOIN
	-- we extract their ethnicity
		SAILW1151V.HDR25_BMI_ETHN AS b 
	ON a.alf_e = b.alf_e
	LEFT JOIN
	-- we extract the BMI data from our output
		(
		SELECT
			*
		FROM
			(
			SELECT
				alf_e,
				age_band,
				bmi_dt,
				bmi_cat,
				source_db,
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
			FROM
				SAILW1151V.HDR25_BMI_ALG_OUTPUT
			WHERE bmi_year = 2001
			) 
		WHERE dt_order = 1
		) c
	ON a.alf_e = c.ALF_E
	ORDER BY alf_e
	),
t2 AS 
-- This chunk puts together the demographical information related to LSOA2011 codes. We will then attach this to t1 in the next step,.
	(
	SELECT
		*
	FROM
		(
		SELECT DISTINCT
				e.LSOA2011_CD 				AS lsoa2011
			,	e.WIMD_2019_QUINTILE_DESC 	AS wimd2019_quintile
			,	g.RU_Name 					AS rural_urban
			,	g.LHB_Name					AS lhb
			, 	ROW_NUMBER() OVER (PARTITION BY e.lsoa2011_cd ORDER BY wimd_2019_quintile_desc) AS row_seq
		FROM
			SAILW1151V.HDR25_BMI_WIMD2019 AS e -- getting wimd2019
		LEFT JOIN 
			SAILW1151V.HDR25_BMI_ALG_LSOA_LHB_LOOKUP AS g -- getting rural/urban and LHB details
		ON e.LSOA2011_CD=g.LSOA2011_Code 
		WHERE e.lsoa2011_cd IS NOT NULL
		)
	WHERE row_seq = 1
	)
-- Now we attach the residency information to our cohort in 2001.
SELECT
	alf_e,
	ethnicity,
	sex,
	wob,
	dod,
	t1.lsoa2011,
	t1.start_date,
	t1.end_date,
	t1.denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	bmi_cat,
	CASE 
		WHEN  source_db IS NULL THEN 'Unknown'
		ELSE  source_db
		END AS source_db,
-- from wimd2019 table
	CASE 
		WHEN  wimd2019_quintile IS NULL THEN 'Unknown'
		ELSE  wimd2019_quintile
		END AS wimd2019_quintile,
-- from rural/urban table
	CASE 
		WHEN  rural_urban IS NULL THEN 'Unknown'
		ELSE  rural_urban
		END AS rural_urban,
	CASE 
		WHEN  lhb IS NULL THEN 'Unknown'
		ELSE  lhb
		END AS lhb
FROM 
	t1
LEFT JOIN
	t2
ON t1.lsoa2011 = t2.lsoa2011 -- this matches the residency information of ALFs
;

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_ADULT
-- 2002
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2002. We select their most recent address in 2002, and attaches their most recent BMI record in 2002 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2002-12-31', wob)/365.25) AS age_years,
		CASE 
				-- those with age_bands already from the BMI output
				WHEN age_band IS NOT NULL THEN age_band 
				-- individuals living in Wales in this year, but no BMI output. We allocate an age band for them here. using the end of the year and their WOB
				WHEN ROUND(DAYS_BETWEEN('2002-12-31', WOB)/365.25) BETWEEN 19 AND 29		THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2002-12-31', WOB)/365.25) = 19 					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2002-12-31', WOB)/365.25) = 29					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2002-12-31', WOB)/365.25) BETWEEN 30 AND 39		THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2002-12-31', WOB)/365.25) = 30 					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2002-12-31', WOB)/365.25) = 39					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2002-12-31', WOB)/365.25) BETWEEN 40 AND 49		THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2002-12-31', WOB)/365.25) = 40 					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2002-12-31', WOB)/365.25) = 49					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2002-12-31', WOB)/365.25) BETWEEN 50 AND 59		THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2002-12-31', WOB)/365.25) = 50 					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2002-12-31', WOB)/365.25) = 59					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2002-12-31', WOB)/365.25) BETWEEN 60 AND 69		THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2002-12-31', WOB)/365.25) = 60 					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2002-12-31', WOB)/365.25) = 69					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2002-12-31', WOB)/365.25) BETWEEN 70 AND 79		THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2002-12-31', WOB)/365.25) = 70 					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2002-12-31', WOB)/365.25) = 79					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2002-12-31', WOB)/365.25) BETWEEN 80 AND 89		THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2002-12-31', WOB)/365.25) = 80 					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2002-12-31', WOB)/365.25) = 89					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2002-12-31', WOB)/365.25) >= 90					THEN '90 -100'
				ELSE NULL 
		END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not Adults in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN bmi_cat IS NOT NULL THEN bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS bmi_cat,
		source_db
	FROM
	-- this is all the Adult population in 2002.
		(
		SELECT * FROM
			(
			SELECT DISTINCT 
				alf_e, 
				sex, 
				wob, 
				lsoa2011_cd, 
				start_date, 
				end_date, 
				dod, 
				denom_year, 
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY start_date, end_date desc) AS dt_order -- to identify those with multiple addresses in this year.
			FROM SAILW1151V.HDR25_BMI_ALG_COHORT a -- the population denominator table
			WHERE denom_year = 2002 -- those that are living in Wales in this year
			AND cohort = 1 -- who are Adults at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this year to remove duplicates.
		)a
	LEFT JOIN
	-- we extract their ethnicity
		SAILW1151V.HDR25_BMI_ETHN AS b 
	ON a.alf_e = b.alf_e
	LEFT JOIN
	-- we extract the BMI data from our output
		(
		SELECT
			*
		FROM
			(
			SELECT
				alf_e,
				age_band,
				bmi_dt,
				bmi_cat,
				source_db,
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
			FROM
				SAILW1151V.HDR25_BMI_ALG_OUTPUT
			WHERE bmi_year = 2002
			) 
		WHERE dt_order = 1
		) c
	ON a.alf_e = c.ALF_E
	ORDER BY alf_e
	),
t2 AS 
-- This chunk puts together the demographical information related to LSOA2011 codes. We will then attach this to t1 in the next step,.
	(
	SELECT
		*
	FROM
		(
		SELECT DISTINCT
				e.LSOA2011_CD 				AS lsoa2011
			,	e.WIMD_2019_QUINTILE_DESC 	AS wimd2019_quintile
			,	g.RU_Name 					AS rural_urban
			,	g.LHB_Name					AS lhb
			, 	ROW_NUMBER() OVER (PARTITION BY e.lsoa2011_cd ORDER BY wimd_2019_quintile_desc) AS row_seq
		FROM
			SAILW1151V.HDR25_BMI_WIMD2019 AS e -- getting wimd2019
		LEFT JOIN 
			SAILW1151V.HDR25_BMI_ALG_LSOA_LHB_LOOKUP AS g -- getting rural/urban and LHB details
		ON e.LSOA2011_CD=g.LSOA2011_Code 
		WHERE e.lsoa2011_cd IS NOT NULL
		)
	WHERE row_seq = 1
	)
-- Now we attach the residency information to our cohort in 2002.
SELECT
	alf_e,
	ethnicity,
	sex,
	wob,
	dod,
	t1.lsoa2011,
	t1.start_date,
	t1.end_date,
	t1.denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	bmi_cat,
	CASE 
		WHEN  source_db IS NULL THEN 'Unknown'
		ELSE  source_db
		END AS source_db,
-- from wimd2019 table
	CASE 
		WHEN  wimd2019_quintile IS NULL THEN 'Unknown'
		ELSE  wimd2019_quintile
		END AS wimd2019_quintile,
-- from rural/urban table
	CASE 
		WHEN  rural_urban IS NULL THEN 'Unknown'
		ELSE  rural_urban
		END AS rural_urban,
	CASE 
		WHEN  lhb IS NULL THEN 'Unknown'
		ELSE  lhb
		END AS lhb
FROM 
	t1
LEFT JOIN
	t2
ON t1.lsoa2011 = t2.lsoa2011 -- this matches the residency information of ALFs
;

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_ADULT
-- 2003
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2003. We select their most recent address in 2003, and attaches their most recent BMI record in 2003 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2003-12-31', wob)/365.25) AS age_years,
		CASE 
				-- those with age_bands already from the BMI output
				WHEN age_band IS NOT NULL THEN age_band 
				-- individuals living in Wales in this year, but no BMI output. We allocate an age band for them here. using the end of the year and their WOB
				WHEN ROUND(DAYS_BETWEEN('2003-12-31', WOB)/365.25) BETWEEN 19 AND 29		THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2003-12-31', WOB)/365.25) = 19 					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2003-12-31', WOB)/365.25) = 29					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2003-12-31', WOB)/365.25) BETWEEN 30 AND 39		THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2003-12-31', WOB)/365.25) = 30 					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2003-12-31', WOB)/365.25) = 39					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2003-12-31', WOB)/365.25) BETWEEN 40 AND 49		THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2003-12-31', WOB)/365.25) = 40 					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2003-12-31', WOB)/365.25) = 49					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2003-12-31', WOB)/365.25) BETWEEN 50 AND 59		THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2003-12-31', WOB)/365.25) = 50 					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2003-12-31', WOB)/365.25) = 59					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2003-12-31', WOB)/365.25) BETWEEN 60 AND 69		THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2003-12-31', WOB)/365.25) = 60 					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2003-12-31', WOB)/365.25) = 69					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2003-12-31', WOB)/365.25) BETWEEN 70 AND 79		THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2003-12-31', WOB)/365.25) = 70 					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2003-12-31', WOB)/365.25) = 79					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2003-12-31', WOB)/365.25) BETWEEN 80 AND 89		THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2003-12-31', WOB)/365.25) = 80 					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2003-12-31', WOB)/365.25) = 89					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2003-12-31', WOB)/365.25) >= 90					THEN '90 -100'
				ELSE NULL 
		END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not Adults in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN bmi_cat IS NOT NULL THEN bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS bmi_cat,
		source_db
	FROM
	-- this is all the Adult population in 2003.
		(
		SELECT * FROM
			(
			SELECT DISTINCT 
				alf_e, 
				sex, 
				wob, 
				lsoa2011_cd, 
				start_date, 
				end_date, 
				dod, 
				denom_year, 
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY start_date, end_date desc) AS dt_order -- to identify those with multiple addresses in this year.
			FROM SAILW1151V.HDR25_BMI_ALG_COHORT a -- the population denominator table
			WHERE denom_year = 2003 -- those that are living in Wales in this year
			AND cohort = 1 -- who are Adults at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this year to remove duplicates.
		)a
	LEFT JOIN
	-- we extract their ethnicity
		SAILW1151V.HDR25_BMI_ETHN AS b 
	ON a.alf_e = b.alf_e
	LEFT JOIN
	-- we extract the BMI data from our output
		(
		SELECT
			*
		FROM
			(
			SELECT
				alf_e,
				age_band,
				bmi_dt,
				bmi_cat,
				source_db,
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
			FROM
				SAILW1151V.HDR25_BMI_ALG_OUTPUT
			WHERE bmi_year = 2003
			) 
		WHERE dt_order = 1
		) c
	ON a.alf_e = c.ALF_E
	ORDER BY alf_e
	),
t2 AS 
-- This chunk puts together the demographical information related to LSOA2011 codes. We will then attach this to t1 in the next step,.
	(
	SELECT
		*
	FROM
		(
		SELECT DISTINCT
				e.LSOA2011_CD 				AS lsoa2011
			,	e.WIMD_2019_QUINTILE_DESC 	AS wimd2019_quintile
			,	g.RU_Name 					AS rural_urban
			,	g.LHB_Name					AS lhb
			, 	ROW_NUMBER() OVER (PARTITION BY e.lsoa2011_cd ORDER BY wimd_2019_quintile_desc) AS row_seq
		FROM
			SAILW1151V.HDR25_BMI_WIMD2019 AS e -- getting wimd2019
		LEFT JOIN 
			SAILW1151V.HDR25_BMI_ALG_LSOA_LHB_LOOKUP AS g -- getting rural/urban and LHB details
		ON e.LSOA2011_CD=g.LSOA2011_Code 
		WHERE e.lsoa2011_cd IS NOT NULL
		)
	WHERE row_seq = 1
	)
-- Now we attach the residency information to our cohort in 2003.
SELECT
	alf_e,
	ethnicity,
	sex,
	wob,
	dod,
	t1.lsoa2011,
	t1.start_date,
	t1.end_date,
	t1.denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	bmi_cat,
	CASE 
		WHEN  source_db IS NULL THEN 'Unknown'
		ELSE  source_db
		END AS source_db,
-- from wimd2019 table
	CASE 
		WHEN  wimd2019_quintile IS NULL THEN 'Unknown'
		ELSE  wimd2019_quintile
		END AS wimd2019_quintile,
-- from rural/urban table
	CASE 
		WHEN  rural_urban IS NULL THEN 'Unknown'
		ELSE  rural_urban
		END AS rural_urban,
	CASE 
		WHEN  lhb IS NULL THEN 'Unknown'
		ELSE  lhb
		END AS lhb
FROM 
	t1
LEFT JOIN
	t2
ON t1.lsoa2011 = t2.lsoa2011 -- this matches the residency information of ALFs
;

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_ADULT
-- 2004
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2004. We select their most recent address in 2004, and attaches their most recent BMI record in 2004 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2004-12-31', wob)/365.25) AS age_years,
		CASE 
				-- those with age_bands already from the BMI output
				WHEN age_band IS NOT NULL THEN age_band 
				-- individuals living in Wales in this year, but no BMI output. We allocate an age band for them here. using the end of the year and their WOB
				WHEN ROUND(DAYS_BETWEEN('2004-12-31', WOB)/365.25) BETWEEN 19 AND 29		THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2004-12-31', WOB)/365.25) = 19 					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2004-12-31', WOB)/365.25) = 29					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2004-12-31', WOB)/365.25) BETWEEN 30 AND 39		THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2004-12-31', WOB)/365.25) = 30 					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2004-12-31', WOB)/365.25) = 39					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2004-12-31', WOB)/365.25) BETWEEN 40 AND 49		THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2004-12-31', WOB)/365.25) = 40 					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2004-12-31', WOB)/365.25) = 49					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2004-12-31', WOB)/365.25) BETWEEN 50 AND 59		THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2004-12-31', WOB)/365.25) = 50 					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2004-12-31', WOB)/365.25) = 59					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2004-12-31', WOB)/365.25) BETWEEN 60 AND 69		THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2004-12-31', WOB)/365.25) = 60 					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2004-12-31', WOB)/365.25) = 69					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2004-12-31', WOB)/365.25) BETWEEN 70 AND 79		THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2004-12-31', WOB)/365.25) = 70 					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2004-12-31', WOB)/365.25) = 79					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2004-12-31', WOB)/365.25) BETWEEN 80 AND 89		THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2004-12-31', WOB)/365.25) = 80 					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2004-12-31', WOB)/365.25) = 89					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2004-12-31', WOB)/365.25) >= 90					THEN '90 -100'
				ELSE NULL 
		END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not Adults in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN bmi_cat IS NOT NULL THEN bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS bmi_cat,
		source_db
	FROM
	-- this is all the Adult population in 2004.
		(
		SELECT * FROM
			(
			SELECT DISTINCT 
				alf_e, 
				sex, 
				wob, 
				lsoa2011_cd, 
				start_date, 
				end_date, 
				dod, 
				denom_year, 
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY start_date, end_date desc) AS dt_order -- to identify those with multiple addresses in this year.
			FROM SAILW1151V.HDR25_BMI_ALG_COHORT a -- the population denominator table
			WHERE denom_year = 2004 -- those that are living in Wales in this year
			AND cohort = 1 -- who are Adults at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this year to remove duplicates.
		)a
	LEFT JOIN
	-- we extract their ethnicity
		SAILW1151V.HDR25_BMI_ETHN AS b 
	ON a.alf_e = b.alf_e
	LEFT JOIN
	-- we extract the BMI data from our output
		(
		SELECT
			*
		FROM
			(
			SELECT
				alf_e,
				age_band,
				bmi_dt,
				bmi_cat,
				source_db,
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
			FROM
				SAILW1151V.HDR25_BMI_ALG_OUTPUT
			WHERE bmi_year = 2004
			) 
		WHERE dt_order = 1
		) c
	ON a.alf_e = c.ALF_E
	ORDER BY alf_e
	),
t2 AS 
-- This chunk puts together the demographical information related to LSOA2011 codes. We will then attach this to t1 in the next step,.
	(
	SELECT
		*
	FROM
		(
		SELECT DISTINCT
				e.LSOA2011_CD 				AS lsoa2011
			,	e.WIMD_2019_QUINTILE_DESC 	AS wimd2019_quintile
			,	g.RU_Name 					AS rural_urban
			,	g.LHB_Name					AS lhb
			, 	ROW_NUMBER() OVER (PARTITION BY e.lsoa2011_cd ORDER BY wimd_2019_quintile_desc) AS row_seq
		FROM
			SAILW1151V.HDR25_BMI_WIMD2019 AS e -- getting wimd2019
		LEFT JOIN 
			SAILW1151V.HDR25_BMI_ALG_LSOA_LHB_LOOKUP AS g -- getting rural/urban and LHB details
		ON e.LSOA2011_CD=g.LSOA2011_Code 
		WHERE e.lsoa2011_cd IS NOT NULL
		)
	WHERE row_seq = 1
	)
-- Now we attach the residency information to our cohort in 2004.
SELECT
	alf_e,
	ethnicity,
	sex,
	wob,
	dod,
	t1.lsoa2011,
	t1.start_date,
	t1.end_date,
	t1.denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	bmi_cat,
	CASE 
		WHEN  source_db IS NULL THEN 'Unknown'
		ELSE  source_db
		END AS source_db,
-- from wimd2019 table
	CASE 
		WHEN  wimd2019_quintile IS NULL THEN 'Unknown'
		ELSE  wimd2019_quintile
		END AS wimd2019_quintile,
-- from rural/urban table
	CASE 
		WHEN  rural_urban IS NULL THEN 'Unknown'
		ELSE  rural_urban
		END AS rural_urban,
	CASE 
		WHEN  lhb IS NULL THEN 'Unknown'
		ELSE  lhb
		END AS lhb
FROM 
	t1
LEFT JOIN
	t2
ON t1.lsoa2011 = t2.lsoa2011 -- this matches the residency information of ALFs
;

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_ADULT
-- 2005
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2005. We select their most recent address in 2005, and attaches their most recent BMI record in 2005 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2005-12-31', wob)/365.25) AS age_years,
		CASE 
				-- those with age_bands already from the BMI output
				WHEN age_band IS NOT NULL THEN age_band 
				-- individuals living in Wales in this year, but no BMI output. We allocate an age band for them here. using the end of the year and their WOB
				WHEN ROUND(DAYS_BETWEEN('2005-12-31', WOB)/365.25) BETWEEN 19 AND 29		THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2005-12-31', WOB)/365.25) = 19 					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2005-12-31', WOB)/365.25) = 29					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2005-12-31', WOB)/365.25) BETWEEN 30 AND 39		THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2005-12-31', WOB)/365.25) = 30 					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2005-12-31', WOB)/365.25) = 39					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2005-12-31', WOB)/365.25) BETWEEN 40 AND 49		THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2005-12-31', WOB)/365.25) = 40 					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2005-12-31', WOB)/365.25) = 49					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2005-12-31', WOB)/365.25) BETWEEN 50 AND 59		THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2005-12-31', WOB)/365.25) = 50 					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2005-12-31', WOB)/365.25) = 59					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2005-12-31', WOB)/365.25) BETWEEN 60 AND 69		THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2005-12-31', WOB)/365.25) = 60 					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2005-12-31', WOB)/365.25) = 69					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2005-12-31', WOB)/365.25) BETWEEN 70 AND 79		THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2005-12-31', WOB)/365.25) = 70 					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2005-12-31', WOB)/365.25) = 79					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2005-12-31', WOB)/365.25) BETWEEN 80 AND 89		THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2005-12-31', WOB)/365.25) = 80 					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2005-12-31', WOB)/365.25) = 89					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2005-12-31', WOB)/365.25) >= 90					THEN '90 -100'
				ELSE NULL 
		END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not Adults in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN bmi_cat IS NOT NULL THEN bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS bmi_cat,
		source_db
	FROM
	-- this is all the Adult population in 2005.
		(
		SELECT * FROM
			(
			SELECT DISTINCT 
				alf_e, 
				sex, 
				wob, 
				lsoa2011_cd, 
				start_date, 
				end_date, 
				dod, 
				denom_year, 
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY start_date, end_date desc) AS dt_order -- to identify those with multiple addresses in this year.
			FROM SAILW1151V.HDR25_BMI_ALG_COHORT a -- the population denominator table
			WHERE denom_year = 2005 -- those that are living in Wales in this year
			AND cohort = 1 -- who are Adults at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this year to remove duplicates.
		)a
	LEFT JOIN
	-- we extract their ethnicity
		SAILW1151V.HDR25_BMI_ETHN AS b 
	ON a.alf_e = b.alf_e
	LEFT JOIN
	-- we extract the BMI data from our output
		(
		SELECT
			*
		FROM
			(
			SELECT
				alf_e,
				age_band,
				bmi_dt,
				bmi_cat,
				source_db,
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
			FROM
				SAILW1151V.HDR25_BMI_ALG_OUTPUT
			WHERE bmi_year = 2005
			) 
		WHERE dt_order = 1
		) c
	ON a.alf_e = c.ALF_E
	ORDER BY alf_e
	),
t2 AS 
-- This chunk puts together the demographical information related to LSOA2011 codes. We will then attach this to t1 in the next step,.
	(
	SELECT
		*
	FROM
		(
		SELECT DISTINCT
				e.LSOA2011_CD 				AS lsoa2011
			,	e.WIMD_2019_QUINTILE_DESC 	AS wimd2019_quintile
			,	g.RU_Name 					AS rural_urban
			,	g.LHB_Name					AS lhb
			, 	ROW_NUMBER() OVER (PARTITION BY e.lsoa2011_cd ORDER BY wimd_2019_quintile_desc) AS row_seq
		FROM
			SAILW1151V.HDR25_BMI_WIMD2019 AS e -- getting wimd2019
		LEFT JOIN 
			SAILW1151V.HDR25_BMI_ALG_LSOA_LHB_LOOKUP AS g -- getting rural/urban and LHB details
		ON e.LSOA2011_CD=g.LSOA2011_Code 
		WHERE e.lsoa2011_cd IS NOT NULL
		)
	WHERE row_seq = 1
	)
-- Now we attach the residency information to our cohort in 2005.
SELECT
	alf_e,
	ethnicity,
	sex,
	wob,
	dod,
	t1.lsoa2011,
	t1.start_date,
	t1.end_date,
	t1.denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	bmi_cat,
	CASE 
		WHEN  source_db IS NULL THEN 'Unknown'
		ELSE  source_db
		END AS source_db,
-- from wimd2019 table
	CASE 
		WHEN  wimd2019_quintile IS NULL THEN 'Unknown'
		ELSE  wimd2019_quintile
		END AS wimd2019_quintile,
-- from rural/urban table
	CASE 
		WHEN  rural_urban IS NULL THEN 'Unknown'
		ELSE  rural_urban
		END AS rural_urban,
	CASE 
		WHEN  lhb IS NULL THEN 'Unknown'
		ELSE  lhb
		END AS lhb
FROM 
	t1
LEFT JOIN
	t2
ON t1.lsoa2011 = t2.lsoa2011 -- this matches the residency information of ALFs
;

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_ADULT
-- 2006
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2006. We select their most recent address in 2006, and attaches their most recent BMI record in 2006 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2006-12-31', wob)/365.25) AS age_years,
		CASE 
				-- those with age_bands already from the BMI output
				WHEN age_band IS NOT NULL THEN age_band 
				-- individuals living in Wales in this year, but no BMI output. We allocate an age band for them here. using the end of the year and their WOB
				WHEN ROUND(DAYS_BETWEEN('2006-12-31', WOB)/365.25) BETWEEN 19 AND 29		THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2006-12-31', WOB)/365.25) = 19 					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2006-12-31', WOB)/365.25) = 29					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2006-12-31', WOB)/365.25) BETWEEN 30 AND 39		THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2006-12-31', WOB)/365.25) = 30 					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2006-12-31', WOB)/365.25) = 39					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2006-12-31', WOB)/365.25) BETWEEN 40 AND 49		THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2006-12-31', WOB)/365.25) = 40 					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2006-12-31', WOB)/365.25) = 49					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2006-12-31', WOB)/365.25) BETWEEN 50 AND 59		THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2006-12-31', WOB)/365.25) = 50 					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2006-12-31', WOB)/365.25) = 59					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2006-12-31', WOB)/365.25) BETWEEN 60 AND 69		THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2006-12-31', WOB)/365.25) = 60 					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2006-12-31', WOB)/365.25) = 69					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2006-12-31', WOB)/365.25) BETWEEN 70 AND 79		THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2006-12-31', WOB)/365.25) = 70 					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2006-12-31', WOB)/365.25) = 79					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2006-12-31', WOB)/365.25) BETWEEN 80 AND 89		THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2006-12-31', WOB)/365.25) = 80 					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2006-12-31', WOB)/365.25) = 89					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2006-12-31', WOB)/365.25) >= 90					THEN '90 -100'
				ELSE NULL 
		END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not Adults in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN bmi_cat IS NOT NULL THEN bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS bmi_cat,
		source_db
	FROM
	-- this is all the Adult population in 2006.
		(
		SELECT * FROM
			(
			SELECT DISTINCT 
				alf_e, 
				sex, 
				wob, 
				lsoa2011_cd, 
				start_date, 
				end_date, 
				dod, 
				denom_year, 
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY start_date, end_date desc) AS dt_order -- to identify those with multiple addresses in this year.
			FROM SAILW1151V.HDR25_BMI_ALG_COHORT a -- the population denominator table
			WHERE denom_year = 2006 -- those that are living in Wales in this year
			AND cohort = 1 -- who are Adults at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this year to remove duplicates.
		)a
	LEFT JOIN
	-- we extract their ethnicity
		SAILW1151V.HDR25_BMI_ETHN AS b 
	ON a.alf_e = b.alf_e
	LEFT JOIN
	-- we extract the BMI data from our output
		(
		SELECT
			*
		FROM
			(
			SELECT
				alf_e,
				age_band,
				bmi_dt,
				bmi_cat,
				source_db,
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
			FROM
				SAILW1151V.HDR25_BMI_ALG_OUTPUT
			WHERE bmi_year = 2006
			) 
		WHERE dt_order = 1
		) c
	ON a.alf_e = c.ALF_E
	ORDER BY alf_e
	),
t2 AS 
-- This chunk puts together the demographical information related to LSOA2011 codes. We will then attach this to t1 in the next step,.
	(
	SELECT
		*
	FROM
		(
		SELECT DISTINCT
				e.LSOA2011_CD 				AS lsoa2011
			,	e.WIMD_2019_QUINTILE_DESC 	AS wimd2019_quintile
			,	g.RU_Name 					AS rural_urban
			,	g.LHB_Name					AS lhb
			, 	ROW_NUMBER() OVER (PARTITION BY e.lsoa2011_cd ORDER BY wimd_2019_quintile_desc) AS row_seq
		FROM
			SAILW1151V.HDR25_BMI_WIMD2019 AS e -- getting wimd2019
		LEFT JOIN 
			SAILW1151V.HDR25_BMI_ALG_LSOA_LHB_LOOKUP AS g -- getting rural/urban and LHB details
		ON e.LSOA2011_CD=g.LSOA2011_Code 
		WHERE e.lsoa2011_cd IS NOT NULL
		)
	WHERE row_seq = 1
	)
-- Now we attach the residency information to our cohort in 2006.
SELECT
	alf_e,
	ethnicity,
	sex,
	wob,
	dod,
	t1.lsoa2011,
	t1.start_date,
	t1.end_date,
	t1.denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	bmi_cat,
	CASE 
		WHEN  source_db IS NULL THEN 'Unknown'
		ELSE  source_db
		END AS source_db,
-- from wimd2019 table
	CASE 
		WHEN  wimd2019_quintile IS NULL THEN 'Unknown'
		ELSE  wimd2019_quintile
		END AS wimd2019_quintile,
-- from rural/urban table
	CASE 
		WHEN  rural_urban IS NULL THEN 'Unknown'
		ELSE  rural_urban
		END AS rural_urban,
	CASE 
		WHEN  lhb IS NULL THEN 'Unknown'
		ELSE  lhb
		END AS lhb
FROM 
	t1
LEFT JOIN
	t2
ON t1.lsoa2011 = t2.lsoa2011 -- this matches the residency information of ALFs
;

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_ADULT
-- 2007
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2007. We select their most recent address in 2007, and attaches their most recent BMI record in 2007 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2007-12-31', wob)/365.25) AS age_years,
		CASE 
				-- those with age_bands already from the BMI output
				WHEN age_band IS NOT NULL THEN age_band 
				-- individuals living in Wales in this year, but no BMI output. We allocate an age band for them here. using the end of the year and their WOB
				WHEN ROUND(DAYS_BETWEEN('2007-12-31', WOB)/365.25) BETWEEN 19 AND 29		THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2007-12-31', WOB)/365.25) = 19 					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2007-12-31', WOB)/365.25) = 29					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2007-12-31', WOB)/365.25) BETWEEN 30 AND 39		THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2007-12-31', WOB)/365.25) = 30 					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2007-12-31', WOB)/365.25) = 39					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2007-12-31', WOB)/365.25) BETWEEN 40 AND 49		THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2007-12-31', WOB)/365.25) = 40 					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2007-12-31', WOB)/365.25) = 49					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2007-12-31', WOB)/365.25) BETWEEN 50 AND 59		THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2007-12-31', WOB)/365.25) = 50 					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2007-12-31', WOB)/365.25) = 59					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2007-12-31', WOB)/365.25) BETWEEN 60 AND 69		THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2007-12-31', WOB)/365.25) = 60 					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2007-12-31', WOB)/365.25) = 69					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2007-12-31', WOB)/365.25) BETWEEN 70 AND 79		THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2007-12-31', WOB)/365.25) = 70 					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2007-12-31', WOB)/365.25) = 79					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2007-12-31', WOB)/365.25) BETWEEN 80 AND 89		THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2007-12-31', WOB)/365.25) = 80 					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2007-12-31', WOB)/365.25) = 89					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2007-12-31', WOB)/365.25) >= 90					THEN '90 -100'
				ELSE NULL 
		END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not Adults in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN bmi_cat IS NOT NULL THEN bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS bmi_cat,
		source_db
	FROM
	-- this is all the Adult population in 2007.
		(
		SELECT * FROM
			(
			SELECT DISTINCT 
				alf_e, 
				sex, 
				wob, 
				lsoa2011_cd, 
				start_date, 
				end_date, 
				dod, 
				denom_year, 
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY start_date, end_date desc) AS dt_order -- to identify those with multiple addresses in this year.
			FROM SAILW1151V.HDR25_BMI_ALG_COHORT a -- the population denominator table
			WHERE denom_year = 2007 -- those that are living in Wales in this year
			AND cohort = 1 -- who are Adults at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this year to remove duplicates.
		)a
	LEFT JOIN
	-- we extract their ethnicity
		SAILW1151V.HDR25_BMI_ETHN AS b 
	ON a.alf_e = b.alf_e
	LEFT JOIN
	-- we extract the BMI data from our output
		(
		SELECT
			*
		FROM
			(
			SELECT
				alf_e,
				age_band,
				bmi_dt,
				bmi_cat,
				source_db,
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
			FROM
				SAILW1151V.HDR25_BMI_ALG_OUTPUT
			WHERE bmi_year = 2007
			) 
		WHERE dt_order = 1
		) c
	ON a.alf_e = c.ALF_E
	ORDER BY alf_e
	),
t2 AS 
-- This chunk puts together the demographical information related to LSOA2011 codes. We will then attach this to t1 in the next step,.
	(
	SELECT
		*
	FROM
		(
		SELECT DISTINCT
				e.LSOA2011_CD 				AS lsoa2011
			,	e.WIMD_2019_QUINTILE_DESC 	AS wimd2019_quintile
			,	g.RU_Name 					AS rural_urban
			,	g.LHB_Name					AS lhb
			, 	ROW_NUMBER() OVER (PARTITION BY e.lsoa2011_cd ORDER BY wimd_2019_quintile_desc) AS row_seq
		FROM
			SAILW1151V.HDR25_BMI_WIMD2019 AS e -- getting wimd2019
		LEFT JOIN 
			SAILW1151V.HDR25_BMI_ALG_LSOA_LHB_LOOKUP AS g -- getting rural/urban and LHB details
		ON e.LSOA2011_CD=g.LSOA2011_Code 
		WHERE e.lsoa2011_cd IS NOT NULL
		)
	WHERE row_seq = 1
	)
-- Now we attach the residency information to our cohort in 2007.
SELECT
	alf_e,
	ethnicity,
	sex,
	wob,
	dod,
	t1.lsoa2011,
	t1.start_date,
	t1.end_date,
	t1.denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	bmi_cat,
	CASE 
		WHEN  source_db IS NULL THEN 'Unknown'
		ELSE  source_db
		END AS source_db,
-- from wimd2019 table
	CASE 
		WHEN  wimd2019_quintile IS NULL THEN 'Unknown'
		ELSE  wimd2019_quintile
		END AS wimd2019_quintile,
-- from rural/urban table
	CASE 
		WHEN  rural_urban IS NULL THEN 'Unknown'
		ELSE  rural_urban
		END AS rural_urban,
	CASE 
		WHEN  lhb IS NULL THEN 'Unknown'
		ELSE  lhb
		END AS lhb
FROM 
	t1
LEFT JOIN
	t2
ON t1.lsoa2011 = t2.lsoa2011 -- this matches the residency information of ALFs
;

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_ADULT
-- 2008
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2008. We select their most recent address in 2008, and attaches their most recent BMI record in 2008 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2008-12-31', wob)/365.25) AS age_years,
		CASE 
				-- those with age_bands already from the BMI output
				WHEN age_band IS NOT NULL THEN age_band 
				-- individuals living in Wales in this year, but no BMI output. We allocate an age band for them here. using the end of the year and their WOB
				WHEN ROUND(DAYS_BETWEEN('2008-12-31', WOB)/365.25) BETWEEN 19 AND 29		THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2008-12-31', WOB)/365.25) = 19 					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2008-12-31', WOB)/365.25) = 29					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2008-12-31', WOB)/365.25) BETWEEN 30 AND 39		THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2008-12-31', WOB)/365.25) = 30 					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2008-12-31', WOB)/365.25) = 39					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2008-12-31', WOB)/365.25) BETWEEN 40 AND 49		THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2008-12-31', WOB)/365.25) = 40 					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2008-12-31', WOB)/365.25) = 49					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2008-12-31', WOB)/365.25) BETWEEN 50 AND 59		THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2008-12-31', WOB)/365.25) = 50 					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2008-12-31', WOB)/365.25) = 59					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2008-12-31', WOB)/365.25) BETWEEN 60 AND 69		THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2008-12-31', WOB)/365.25) = 60 					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2008-12-31', WOB)/365.25) = 69					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2008-12-31', WOB)/365.25) BETWEEN 70 AND 79		THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2008-12-31', WOB)/365.25) = 70 					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2008-12-31', WOB)/365.25) = 79					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2008-12-31', WOB)/365.25) BETWEEN 80 AND 89		THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2008-12-31', WOB)/365.25) = 80 					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2008-12-31', WOB)/365.25) = 89					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2008-12-31', WOB)/365.25) >= 90					THEN '90 -100'
				ELSE NULL 
		END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not Adults in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN bmi_cat IS NOT NULL THEN bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS bmi_cat,
		source_db
	FROM
	-- this is all the Adult population in 2008.
		(
		SELECT * FROM
			(
			SELECT DISTINCT 
				alf_e, 
				sex, 
				wob, 
				lsoa2011_cd, 
				start_date, 
				end_date, 
				dod, 
				denom_year, 
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY start_date, end_date desc) AS dt_order -- to identify those with multiple addresses in this year.
			FROM SAILW1151V.HDR25_BMI_ALG_COHORT a -- the population denominator table
			WHERE denom_year = 2008 -- those that are living in Wales in this year
			AND cohort = 1 -- who are Adults at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this year to remove duplicates.
		)a
	LEFT JOIN
	-- we extract their ethnicity
		SAILW1151V.HDR25_BMI_ETHN AS b 
	ON a.alf_e = b.alf_e
	LEFT JOIN
	-- we extract the BMI data from our output
		(
		SELECT
			*
		FROM
			(
			SELECT
				alf_e,
				age_band,
				bmi_dt,
				bmi_cat,
				source_db,
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
			FROM
				SAILW1151V.HDR25_BMI_ALG_OUTPUT
			WHERE bmi_year = 2008
			) 
		WHERE dt_order = 1
		) c
	ON a.alf_e = c.ALF_E
	ORDER BY alf_e
	),
t2 AS 
-- This chunk puts together the demographical information related to LSOA2011 codes. We will then attach this to t1 in the next step,.
	(
	SELECT
		*
	FROM
		(
		SELECT DISTINCT
				e.LSOA2011_CD 				AS lsoa2011
			,	e.WIMD_2019_QUINTILE_DESC 	AS wimd2019_quintile
			,	g.RU_Name 					AS rural_urban
			,	g.LHB_Name					AS lhb
			, 	ROW_NUMBER() OVER (PARTITION BY e.lsoa2011_cd ORDER BY wimd_2019_quintile_desc) AS row_seq
		FROM
			SAILW1151V.HDR25_BMI_WIMD2019 AS e -- getting wimd2019
		LEFT JOIN 
			SAILW1151V.HDR25_BMI_ALG_LSOA_LHB_LOOKUP AS g -- getting rural/urban and LHB details
		ON e.LSOA2011_CD=g.LSOA2011_Code 
		WHERE e.lsoa2011_cd IS NOT NULL
		)
	WHERE row_seq = 1
	)
-- Now we attach the residency information to our cohort in 2008.
SELECT
	alf_e,
	ethnicity,
	sex,
	wob,
	dod,
	t1.lsoa2011,
	t1.start_date,
	t1.end_date,
	t1.denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	bmi_cat,
	CASE 
		WHEN  source_db IS NULL THEN 'Unknown'
		ELSE  source_db
		END AS source_db,
-- from wimd2019 table
	CASE 
		WHEN  wimd2019_quintile IS NULL THEN 'Unknown'
		ELSE  wimd2019_quintile
		END AS wimd2019_quintile,
-- from rural/urban table
	CASE 
		WHEN  rural_urban IS NULL THEN 'Unknown'
		ELSE  rural_urban
		END AS rural_urban,
	CASE 
		WHEN  lhb IS NULL THEN 'Unknown'
		ELSE  lhb
		END AS lhb
FROM 
	t1
LEFT JOIN
	t2
ON t1.lsoa2011 = t2.lsoa2011 -- this matches the residency information of ALFs
;

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_ADULT
-- 2009
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2009. We select their most recent address in 2009, and attaches their most recent BMI record in 2009 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2009-12-31', wob)/365.25) AS age_years,
		CASE 
				-- those with age_bands already from the BMI output
				WHEN age_band IS NOT NULL THEN age_band 
				-- individuals living in Wales in this year, but no BMI output. We allocate an age band for them here. using the end of the year and their WOB
				WHEN ROUND(DAYS_BETWEEN('2009-12-31', WOB)/365.25) BETWEEN 19 AND 29		THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2009-12-31', WOB)/365.25) = 19 					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2009-12-31', WOB)/365.25) = 29					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2009-12-31', WOB)/365.25) BETWEEN 30 AND 39		THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2009-12-31', WOB)/365.25) = 30 					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2009-12-31', WOB)/365.25) = 39					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2009-12-31', WOB)/365.25) BETWEEN 40 AND 49		THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2009-12-31', WOB)/365.25) = 40 					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2009-12-31', WOB)/365.25) = 49					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2009-12-31', WOB)/365.25) BETWEEN 50 AND 59		THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2009-12-31', WOB)/365.25) = 50 					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2009-12-31', WOB)/365.25) = 59					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2009-12-31', WOB)/365.25) BETWEEN 60 AND 69		THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2009-12-31', WOB)/365.25) = 60 					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2009-12-31', WOB)/365.25) = 69					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2009-12-31', WOB)/365.25) BETWEEN 70 AND 79		THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2009-12-31', WOB)/365.25) = 70 					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2009-12-31', WOB)/365.25) = 79					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2009-12-31', WOB)/365.25) BETWEEN 80 AND 89		THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2009-12-31', WOB)/365.25) = 80 					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2009-12-31', WOB)/365.25) = 89					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2009-12-31', WOB)/365.25) >= 90					THEN '90 -100'
				ELSE NULL 
		END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not Adults in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN bmi_cat IS NOT NULL THEN bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS bmi_cat,
		source_db
	FROM
	-- this is all the Adult population in 2009.
		(
		SELECT * FROM
			(
			SELECT DISTINCT 
				alf_e, 
				sex, 
				wob, 
				lsoa2011_cd, 
				start_date, 
				end_date, 
				dod, 
				denom_year, 
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY start_date, end_date desc) AS dt_order -- to identify those with multiple addresses in this year.
			FROM SAILW1151V.HDR25_BMI_ALG_COHORT a -- the population denominator table
			WHERE denom_year = 2009 -- those that are living in Wales in this year
			AND cohort = 1 -- who are Adults at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this year to remove duplicates.
		)a
	LEFT JOIN
	-- we extract their ethnicity
		SAILW1151V.HDR25_BMI_ETHN AS b 
	ON a.alf_e = b.alf_e
	LEFT JOIN
	-- we extract the BMI data from our output
		(
		SELECT
			*
		FROM
			(
			SELECT
				alf_e,
				age_band,
				bmi_dt,
				bmi_cat,
				source_db,
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
			FROM
				SAILW1151V.HDR25_BMI_ALG_OUTPUT
			WHERE bmi_year = 2009
			) 
		WHERE dt_order = 1
		) c
	ON a.alf_e = c.ALF_E
	ORDER BY alf_e
	),
t2 AS 
-- This chunk puts together the demographical information related to LSOA2011 codes. We will then attach this to t1 in the next step,.
	(
	SELECT
		*
	FROM
		(
		SELECT DISTINCT
				e.LSOA2011_CD 				AS lsoa2011
			,	e.WIMD_2019_QUINTILE_DESC 	AS wimd2019_quintile
			,	g.RU_Name 					AS rural_urban
			,	g.LHB_Name					AS lhb
			, 	ROW_NUMBER() OVER (PARTITION BY e.lsoa2011_cd ORDER BY wimd_2019_quintile_desc) AS row_seq
		FROM
			SAILW1151V.HDR25_BMI_WIMD2019 AS e -- getting wimd2019
		LEFT JOIN 
			SAILW1151V.HDR25_BMI_ALG_LSOA_LHB_LOOKUP AS g -- getting rural/urban and LHB details
		ON e.LSOA2011_CD=g.LSOA2011_Code 
		WHERE e.lsoa2011_cd IS NOT NULL
		)
	WHERE row_seq = 1
	)
-- Now we attach the residency information to our cohort in 2009.
SELECT
	alf_e,
	ethnicity,
	sex,
	wob,
	dod,
	t1.lsoa2011,
	t1.start_date,
	t1.end_date,
	t1.denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	bmi_cat,
	CASE 
		WHEN  source_db IS NULL THEN 'Unknown'
		ELSE  source_db
		END AS source_db,
-- from wimd2019 table
	CASE 
		WHEN  wimd2019_quintile IS NULL THEN 'Unknown'
		ELSE  wimd2019_quintile
		END AS wimd2019_quintile,
-- from rural/urban table
	CASE 
		WHEN  rural_urban IS NULL THEN 'Unknown'
		ELSE  rural_urban
		END AS rural_urban,
	CASE 
		WHEN  lhb IS NULL THEN 'Unknown'
		ELSE  lhb
		END AS lhb
FROM 
	t1
LEFT JOIN
	t2
ON t1.lsoa2011 = t2.lsoa2011 -- this matches the residency information of ALFs
;

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_ADULT
-- 2010
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2010. We select their most recent address in 2010, and attaches their most recent BMI record in 2010 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2010-12-31', wob)/365.25) AS age_years,
		CASE 
				-- those with age_bands already from the BMI output
				WHEN age_band IS NOT NULL THEN age_band 
				-- individuals living in Wales in this year, but no BMI output. We allocate an age band for them here. using the end of the year and their WOB
				WHEN ROUND(DAYS_BETWEEN('2010-12-31', WOB)/365.25) BETWEEN 19 AND 29		THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2010-12-31', WOB)/365.25) = 19 					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2010-12-31', WOB)/365.25) = 29					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2010-12-31', WOB)/365.25) BETWEEN 30 AND 39		THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2010-12-31', WOB)/365.25) = 30 					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2010-12-31', WOB)/365.25) = 39					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2010-12-31', WOB)/365.25) BETWEEN 40 AND 49		THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2010-12-31', WOB)/365.25) = 40 					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2010-12-31', WOB)/365.25) = 49					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2010-12-31', WOB)/365.25) BETWEEN 50 AND 59		THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2010-12-31', WOB)/365.25) = 50 					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2010-12-31', WOB)/365.25) = 59					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2010-12-31', WOB)/365.25) BETWEEN 60 AND 69		THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2010-12-31', WOB)/365.25) = 60 					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2010-12-31', WOB)/365.25) = 69					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2010-12-31', WOB)/365.25) BETWEEN 70 AND 79		THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2010-12-31', WOB)/365.25) = 70 					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2010-12-31', WOB)/365.25) = 79					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2010-12-31', WOB)/365.25) BETWEEN 80 AND 89		THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2010-12-31', WOB)/365.25) = 80 					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2010-12-31', WOB)/365.25) = 89					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2010-12-31', WOB)/365.25) >= 90					THEN '90 -100'
				ELSE NULL 
		END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not Adults in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN bmi_cat IS NOT NULL THEN bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS bmi_cat,
		source_db
	FROM
	-- this is all the Adult population in 2010.
		(
		SELECT * FROM
			(
			SELECT DISTINCT 
				alf_e, 
				sex, 
				wob, 
				lsoa2011_cd, 
				start_date, 
				end_date, 
				dod, 
				denom_year, 
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY start_date, end_date desc) AS dt_order -- to identify those with multiple addresses in this year.
			FROM SAILW1151V.HDR25_BMI_ALG_COHORT a -- the population denominator table
			WHERE denom_year = 2010 -- those that are living in Wales in this year
			AND cohort = 1 -- who are Adults at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this year to remove duplicates.
		)a
	LEFT JOIN
	-- we extract their ethnicity
		SAILW1151V.HDR25_BMI_ETHN AS b 
	ON a.alf_e = b.alf_e
	LEFT JOIN
	-- we extract the BMI data from our output
		(
		SELECT
			*
		FROM
			(
			SELECT
				alf_e,
				age_band,
				bmi_dt,
				bmi_cat,
				source_db,
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
			FROM
				SAILW1151V.HDR25_BMI_ALG_OUTPUT
			WHERE bmi_year = 2010
			) 
		WHERE dt_order = 1
		) c
	ON a.alf_e = c.ALF_E
	ORDER BY alf_e
	),
t2 AS 
-- This chunk puts together the demographical information related to LSOA2011 codes. We will then attach this to t1 in the next step,.
	(
	SELECT
		*
	FROM
		(
		SELECT DISTINCT
				e.LSOA2011_CD 				AS lsoa2011
			,	e.WIMD_2019_QUINTILE_DESC 	AS wimd2019_quintile
			,	g.RU_Name 					AS rural_urban
			,	g.LHB_Name					AS lhb
			, 	ROW_NUMBER() OVER (PARTITION BY e.lsoa2011_cd ORDER BY wimd_2019_quintile_desc) AS row_seq
		FROM
			SAILW1151V.HDR25_BMI_WIMD2019 AS e -- getting wimd2019
		LEFT JOIN 
			SAILW1151V.HDR25_BMI_ALG_LSOA_LHB_LOOKUP AS g -- getting rural/urban and LHB details
		ON e.LSOA2011_CD=g.LSOA2011_Code 
		WHERE e.lsoa2011_cd IS NOT NULL
		)
	WHERE row_seq = 1
	)
-- Now we attach the residency information to our cohort in 2010.
SELECT
	alf_e,
	ethnicity,
	sex,
	wob,
	dod,
	t1.lsoa2011,
	t1.start_date,
	t1.end_date,
	t1.denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	bmi_cat,
	CASE 
		WHEN  source_db IS NULL THEN 'Unknown'
		ELSE  source_db
		END AS source_db,
-- from wimd2019 table
	CASE 
		WHEN  wimd2019_quintile IS NULL THEN 'Unknown'
		ELSE  wimd2019_quintile
		END AS wimd2019_quintile,
-- from rural/urban table
	CASE 
		WHEN  rural_urban IS NULL THEN 'Unknown'
		ELSE  rural_urban
		END AS rural_urban,
	CASE 
		WHEN  lhb IS NULL THEN 'Unknown'
		ELSE  lhb
		END AS lhb
FROM 
	t1
LEFT JOIN
	t2
ON t1.lsoa2011 = t2.lsoa2011 -- this matches the residency information of ALFs
;

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_ADULT
-- 2011
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2011. We select their most recent address in 2011, and attaches their most recent BMI record in 2011 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2011-12-31', wob)/365.25) AS age_years,
		CASE 
				-- those with age_bands already from the BMI output
				WHEN age_band IS NOT NULL THEN age_band 
				-- individuals living in Wales in this year, but no BMI output. We allocate an age band for them here. using the end of the year and their WOB
				WHEN ROUND(DAYS_BETWEEN('2011-12-31', WOB)/365.25) BETWEEN 19 AND 29		THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2011-12-31', WOB)/365.25) = 19 					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2011-12-31', WOB)/365.25) = 29					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2011-12-31', WOB)/365.25) BETWEEN 30 AND 39		THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2011-12-31', WOB)/365.25) = 30 					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2011-12-31', WOB)/365.25) = 39					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2011-12-31', WOB)/365.25) BETWEEN 40 AND 49		THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2011-12-31', WOB)/365.25) = 40 					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2011-12-31', WOB)/365.25) = 49					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2011-12-31', WOB)/365.25) BETWEEN 50 AND 59		THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2011-12-31', WOB)/365.25) = 50 					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2011-12-31', WOB)/365.25) = 59					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2011-12-31', WOB)/365.25) BETWEEN 60 AND 69		THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2011-12-31', WOB)/365.25) = 60 					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2011-12-31', WOB)/365.25) = 69					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2011-12-31', WOB)/365.25) BETWEEN 70 AND 79		THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2011-12-31', WOB)/365.25) = 70 					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2011-12-31', WOB)/365.25) = 79					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2011-12-31', WOB)/365.25) BETWEEN 80 AND 89		THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2011-12-31', WOB)/365.25) = 80 					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2011-12-31', WOB)/365.25) = 89					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2011-12-31', WOB)/365.25) >= 90					THEN '90 -100'
				ELSE NULL 
		END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not Adults in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN bmi_cat IS NOT NULL THEN bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS bmi_cat,
		source_db
	FROM
	-- this is all the Adult population in 2011.
		(
		SELECT * FROM
			(
			SELECT DISTINCT 
				alf_e, 
				sex, 
				wob, 
				lsoa2011_cd, 
				start_date, 
				end_date, 
				dod, 
				denom_year, 
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY start_date, end_date desc) AS dt_order -- to identify those with multiple addresses in this year.
			FROM SAILW1151V.HDR25_BMI_ALG_COHORT a -- the population denominator table
			WHERE denom_year = 2011 -- those that are living in Wales in this year
			AND cohort = 1 -- who are Adults at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this year to remove duplicates.
		)a
	LEFT JOIN
	-- we extract their ethnicity
		SAILW1151V.HDR25_BMI_ETHN AS b 
	ON a.alf_e = b.alf_e
	LEFT JOIN
	-- we extract the BMI data from our output
		(
		SELECT
			*
		FROM
			(
			SELECT
				alf_e,
				age_band,
				bmi_dt,
				bmi_cat,
				source_db,
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
			FROM
				SAILW1151V.HDR25_BMI_ALG_OUTPUT
			WHERE bmi_year = 2011
			) 
		WHERE dt_order = 1
		) c
	ON a.alf_e = c.ALF_E
	ORDER BY alf_e
	),
t2 AS 
-- This chunk puts together the demographical information related to LSOA2011 codes. We will then attach this to t1 in the next step,.
	(
	SELECT
		*
	FROM
		(
		SELECT DISTINCT
				e.LSOA2011_CD 				AS lsoa2011
			,	e.WIMD_2019_QUINTILE_DESC 	AS wimd2019_quintile
			,	g.RU_Name 					AS rural_urban
			,	g.LHB_Name					AS lhb
			, 	ROW_NUMBER() OVER (PARTITION BY e.lsoa2011_cd ORDER BY wimd_2019_quintile_desc) AS row_seq
		FROM
			SAILW1151V.HDR25_BMI_WIMD2019 AS e -- getting wimd2019
		LEFT JOIN 
			SAILW1151V.HDR25_BMI_ALG_LSOA_LHB_LOOKUP AS g -- getting rural/urban and LHB details
		ON e.LSOA2011_CD=g.LSOA2011_Code 
		WHERE e.lsoa2011_cd IS NOT NULL
		)
	WHERE row_seq = 1
	)
-- Now we attach the residency information to our cohort in 2011.
SELECT
	alf_e,
	ethnicity,
	sex,
	wob,
	dod,
	t1.lsoa2011,
	t1.start_date,
	t1.end_date,
	t1.denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	bmi_cat,
	CASE 
		WHEN  source_db IS NULL THEN 'Unknown'
		ELSE  source_db
		END AS source_db,
-- from wimd2019 table
	CASE 
		WHEN  wimd2019_quintile IS NULL THEN 'Unknown'
		ELSE  wimd2019_quintile
		END AS wimd2019_quintile,
-- from rural/urban table
	CASE 
		WHEN  rural_urban IS NULL THEN 'Unknown'
		ELSE  rural_urban
		END AS rural_urban,
	CASE 
		WHEN  lhb IS NULL THEN 'Unknown'
		ELSE  lhb
		END AS lhb
FROM 
	t1
LEFT JOIN
	t2
ON t1.lsoa2011 = t2.lsoa2011 -- this matches the residency information of ALFs
;

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_ADULT
-- 2012
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2012. We select their most recent address in 2012, and attaches their most recent BMI record in 2012 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2012-12-31', wob)/365.25) AS age_years,
		CASE 
				-- those with age_bands already from the BMI output
				WHEN age_band IS NOT NULL THEN age_band 
				-- individuals living in Wales in this year, but no BMI output. We allocate an age band for them here. using the end of the year and their WOB
				WHEN ROUND(DAYS_BETWEEN('2012-12-31', WOB)/365.25) BETWEEN 19 AND 29		THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2012-12-31', WOB)/365.25) = 19 					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2012-12-31', WOB)/365.25) = 29					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2012-12-31', WOB)/365.25) BETWEEN 30 AND 39		THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2012-12-31', WOB)/365.25) = 30 					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2012-12-31', WOB)/365.25) = 39					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2012-12-31', WOB)/365.25) BETWEEN 40 AND 49		THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2012-12-31', WOB)/365.25) = 40 					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2012-12-31', WOB)/365.25) = 49					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2012-12-31', WOB)/365.25) BETWEEN 50 AND 59		THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2012-12-31', WOB)/365.25) = 50 					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2012-12-31', WOB)/365.25) = 59					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2012-12-31', WOB)/365.25) BETWEEN 60 AND 69		THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2012-12-31', WOB)/365.25) = 60 					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2012-12-31', WOB)/365.25) = 69					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2012-12-31', WOB)/365.25) BETWEEN 70 AND 79		THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2012-12-31', WOB)/365.25) = 70 					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2012-12-31', WOB)/365.25) = 79					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2012-12-31', WOB)/365.25) BETWEEN 80 AND 89		THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2012-12-31', WOB)/365.25) = 80 					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2012-12-31', WOB)/365.25) = 89					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2012-12-31', WOB)/365.25) >= 90					THEN '90 -100'
				ELSE NULL 
		END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not Adults in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN bmi_cat IS NOT NULL THEN bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS bmi_cat,
		source_db
	FROM
	-- this is all the Adult population in 2012.
		(
		SELECT * FROM
			(
			SELECT DISTINCT 
				alf_e, 
				sex, 
				wob, 
				lsoa2011_cd, 
				start_date, 
				end_date, 
				dod, 
				denom_year, 
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY start_date, end_date desc) AS dt_order -- to identify those with multiple addresses in this year.
			FROM SAILW1151V.HDR25_BMI_ALG_COHORT a -- the population denominator table
			WHERE denom_year = 2012 -- those that are living in Wales in this year
			AND cohort = 1 -- who are Adults at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this year to remove duplicates.
		)a
	LEFT JOIN
	-- we extract their ethnicity
		SAILW1151V.HDR25_BMI_ETHN AS b 
	ON a.alf_e = b.alf_e
	LEFT JOIN
	-- we extract the BMI data from our output
		(
		SELECT
			*
		FROM
			(
			SELECT
				alf_e,
				age_band,
				bmi_dt,
				bmi_cat,
				source_db,
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
			FROM
				SAILW1151V.HDR25_BMI_ALG_OUTPUT
			WHERE bmi_year = 2012
			) 
		WHERE dt_order = 1
		) c
	ON a.alf_e = c.ALF_E
	ORDER BY alf_e
	),
t2 AS 
-- This chunk puts together the demographical information related to LSOA2011 codes. We will then attach this to t1 in the next step,.
	(
	SELECT
		*
	FROM
		(
		SELECT DISTINCT
				e.LSOA2011_CD 				AS lsoa2011
			,	e.WIMD_2019_QUINTILE_DESC 	AS wimd2019_quintile
			,	g.RU_Name 					AS rural_urban
			,	g.LHB_Name					AS lhb
			, 	ROW_NUMBER() OVER (PARTITION BY e.lsoa2011_cd ORDER BY wimd_2019_quintile_desc) AS row_seq
		FROM
			SAILW1151V.HDR25_BMI_WIMD2019 AS e -- getting wimd2019
		LEFT JOIN 
			SAILW1151V.HDR25_BMI_ALG_LSOA_LHB_LOOKUP AS g -- getting rural/urban and LHB details
		ON e.LSOA2011_CD=g.LSOA2011_Code 
		WHERE e.lsoa2011_cd IS NOT NULL
		)
	WHERE row_seq = 1
	)
-- Now we attach the residency information to our cohort in 2012.
SELECT
	alf_e,
	ethnicity,
	sex,
	wob,
	dod,
	t1.lsoa2011,
	t1.start_date,
	t1.end_date,
	t1.denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	bmi_cat,
	CASE 
		WHEN  source_db IS NULL THEN 'Unknown'
		ELSE  source_db
		END AS source_db,
-- from wimd2019 table
	CASE 
		WHEN  wimd2019_quintile IS NULL THEN 'Unknown'
		ELSE  wimd2019_quintile
		END AS wimd2019_quintile,
-- from rural/urban table
	CASE 
		WHEN  rural_urban IS NULL THEN 'Unknown'
		ELSE  rural_urban
		END AS rural_urban,
	CASE 
		WHEN  lhb IS NULL THEN 'Unknown'
		ELSE  lhb
		END AS lhb
FROM 
	t1
LEFT JOIN
	t2
ON t1.lsoa2011 = t2.lsoa2011 -- this matches the residency information of ALFs
;

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_ADULT
-- 2013
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2013. We select their most recent address in 2013, and attaches their most recent BMI record in 2013 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2013-12-31', wob)/365.25) AS age_years,
		CASE 
				-- those with age_bands already from the BMI output
				WHEN age_band IS NOT NULL THEN age_band 
				-- individuals living in Wales in this year, but no BMI output. We allocate an age band for them here. using the end of the year and their WOB
				WHEN ROUND(DAYS_BETWEEN('2013-12-31', WOB)/365.25) BETWEEN 19 AND 29		THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2013-12-31', WOB)/365.25) = 19 					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2013-12-31', WOB)/365.25) = 29					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2013-12-31', WOB)/365.25) BETWEEN 30 AND 39		THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2013-12-31', WOB)/365.25) = 30 					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2013-12-31', WOB)/365.25) = 39					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2013-12-31', WOB)/365.25) BETWEEN 40 AND 49		THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2013-12-31', WOB)/365.25) = 40 					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2013-12-31', WOB)/365.25) = 49					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2013-12-31', WOB)/365.25) BETWEEN 50 AND 59		THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2013-12-31', WOB)/365.25) = 50 					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2013-12-31', WOB)/365.25) = 59					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2013-12-31', WOB)/365.25) BETWEEN 60 AND 69		THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2013-12-31', WOB)/365.25) = 60 					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2013-12-31', WOB)/365.25) = 69					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2013-12-31', WOB)/365.25) BETWEEN 70 AND 79		THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2013-12-31', WOB)/365.25) = 70 					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2013-12-31', WOB)/365.25) = 79					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2013-12-31', WOB)/365.25) BETWEEN 80 AND 89		THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2013-12-31', WOB)/365.25) = 80 					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2013-12-31', WOB)/365.25) = 89					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2013-12-31', WOB)/365.25) >= 90					THEN '90 -100'
				ELSE NULL 
		END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not Adults in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN bmi_cat IS NOT NULL THEN bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS bmi_cat,
		source_db
	FROM
	-- this is all the Adult population in 2013.
		(
		SELECT * FROM
			(
			SELECT DISTINCT 
				alf_e, 
				sex, 
				wob, 
				lsoa2011_cd, 
				start_date, 
				end_date, 
				dod, 
				denom_year, 
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY start_date, end_date desc) AS dt_order -- to identify those with multiple addresses in this year.
			FROM SAILW1151V.HDR25_BMI_ALG_COHORT a -- the population denominator table
			WHERE denom_year = 2013 -- those that are living in Wales in this year
			AND cohort = 1 -- who are Adults at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this year to remove duplicates.
		)a
	LEFT JOIN
	-- we extract their ethnicity
		SAILW1151V.HDR25_BMI_ETHN AS b 
	ON a.alf_e = b.alf_e
	LEFT JOIN
	-- we extract the BMI data from our output
		(
		SELECT
			*
		FROM
			(
			SELECT
				alf_e,
				age_band,
				bmi_dt,
				bmi_cat,
				source_db,
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
			FROM
				SAILW1151V.HDR25_BMI_ALG_OUTPUT
			WHERE bmi_year = 2013
			) 
		WHERE dt_order = 1
		) c
	ON a.alf_e = c.ALF_E
	ORDER BY alf_e
	),
t2 AS 
-- This chunk puts together the demographical information related to LSOA2011 codes. We will then attach this to t1 in the next step,.
	(
	SELECT
		*
	FROM
		(
		SELECT DISTINCT
				e.LSOA2011_CD 				AS lsoa2011
			,	e.WIMD_2019_QUINTILE_DESC 	AS wimd2019_quintile
			,	g.RU_Name 					AS rural_urban
			,	g.LHB_Name					AS lhb
			, 	ROW_NUMBER() OVER (PARTITION BY e.lsoa2011_cd ORDER BY wimd_2019_quintile_desc) AS row_seq
		FROM
			SAILW1151V.HDR25_BMI_WIMD2019 AS e -- getting wimd2019
		LEFT JOIN 
			SAILW1151V.HDR25_BMI_ALG_LSOA_LHB_LOOKUP AS g -- getting rural/urban and LHB details
		ON e.LSOA2011_CD=g.LSOA2011_Code 
		WHERE e.lsoa2011_cd IS NOT NULL
		)
	WHERE row_seq = 1
	)
-- Now we attach the residency information to our cohort in 2013.
SELECT
	alf_e,
	ethnicity,
	sex,
	wob,
	dod,
	t1.lsoa2011,
	t1.start_date,
	t1.end_date,
	t1.denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	bmi_cat,
	CASE 
		WHEN  source_db IS NULL THEN 'Unknown'
		ELSE  source_db
		END AS source_db,
-- from wimd2019 table
	CASE 
		WHEN  wimd2019_quintile IS NULL THEN 'Unknown'
		ELSE  wimd2019_quintile
		END AS wimd2019_quintile,
-- from rural/urban table
	CASE 
		WHEN  rural_urban IS NULL THEN 'Unknown'
		ELSE  rural_urban
		END AS rural_urban,
	CASE 
		WHEN  lhb IS NULL THEN 'Unknown'
		ELSE  lhb
		END AS lhb
FROM 
	t1
LEFT JOIN
	t2
ON t1.lsoa2011 = t2.lsoa2011 -- this matches the residency information of ALFs
;

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_ADULT
-- 2014
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2014. We select their most recent address in 2014, and attaches their most recent BMI record in 2014 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2014-12-31', wob)/365.25) AS age_years,
		CASE 
				-- those with age_bands already from the BMI output
				WHEN age_band IS NOT NULL THEN age_band 
				-- individuals living in Wales in this year, but no BMI output. We allocate an age band for them here. using the end of the year and their WOB
				WHEN ROUND(DAYS_BETWEEN('2014-12-31', WOB)/365.25) BETWEEN 19 AND 29		THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2014-12-31', WOB)/365.25) = 19 					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2014-12-31', WOB)/365.25) = 29					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2014-12-31', WOB)/365.25) BETWEEN 30 AND 39		THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2014-12-31', WOB)/365.25) = 30 					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2014-12-31', WOB)/365.25) = 39					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2014-12-31', WOB)/365.25) BETWEEN 40 AND 49		THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2014-12-31', WOB)/365.25) = 40 					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2014-12-31', WOB)/365.25) = 49					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2014-12-31', WOB)/365.25) BETWEEN 50 AND 59		THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2014-12-31', WOB)/365.25) = 50 					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2014-12-31', WOB)/365.25) = 59					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2014-12-31', WOB)/365.25) BETWEEN 60 AND 69		THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2014-12-31', WOB)/365.25) = 60 					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2014-12-31', WOB)/365.25) = 69					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2014-12-31', WOB)/365.25) BETWEEN 70 AND 79		THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2014-12-31', WOB)/365.25) = 70 					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2014-12-31', WOB)/365.25) = 79					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2014-12-31', WOB)/365.25) BETWEEN 80 AND 89		THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2014-12-31', WOB)/365.25) = 80 					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2014-12-31', WOB)/365.25) = 89					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2014-12-31', WOB)/365.25) >= 90					THEN '90 -100'
				ELSE NULL 
		END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not Adults in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN bmi_cat IS NOT NULL THEN bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS bmi_cat,
		source_db
	FROM
	-- this is all the Adult population in 2014.
		(
		SELECT * FROM
			(
			SELECT DISTINCT 
				alf_e, 
				sex, 
				wob, 
				lsoa2011_cd, 
				start_date, 
				end_date, 
				dod, 
				denom_year, 
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY start_date, end_date desc) AS dt_order -- to identify those with multiple addresses in this year.
			FROM SAILW1151V.HDR25_BMI_ALG_COHORT a -- the population denominator table
			WHERE denom_year = 2014 -- those that are living in Wales in this year
			AND cohort = 1 -- who are Adults at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this year to remove duplicates.
		)a
	LEFT JOIN
	-- we extract their ethnicity
		SAILW1151V.HDR25_BMI_ETHN AS b 
	ON a.alf_e = b.alf_e
	LEFT JOIN
	-- we extract the BMI data from our output
		(
		SELECT
			*
		FROM
			(
			SELECT
				alf_e,
				age_band,
				bmi_dt,
				bmi_cat,
				source_db,
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
			FROM
				SAILW1151V.HDR25_BMI_ALG_OUTPUT
			WHERE bmi_year = 2014
			) 
		WHERE dt_order = 1
		) c
	ON a.alf_e = c.ALF_E
	ORDER BY alf_e
	),
t2 AS 
-- This chunk puts together the demographical information related to LSOA2011 codes. We will then attach this to t1 in the next step,.
	(
	SELECT
		*
	FROM
		(
		SELECT DISTINCT
				e.LSOA2011_CD 				AS lsoa2011
			,	e.WIMD_2019_QUINTILE_DESC 	AS wimd2019_quintile
			,	g.RU_Name 					AS rural_urban
			,	g.LHB_Name					AS lhb
			, 	ROW_NUMBER() OVER (PARTITION BY e.lsoa2011_cd ORDER BY wimd_2019_quintile_desc) AS row_seq
		FROM
			SAILW1151V.HDR25_BMI_WIMD2019 AS e -- getting wimd2019
		LEFT JOIN 
			SAILW1151V.HDR25_BMI_ALG_LSOA_LHB_LOOKUP AS g -- getting rural/urban and LHB details
		ON e.LSOA2011_CD=g.LSOA2011_Code 
		WHERE e.lsoa2011_cd IS NOT NULL
		)
	WHERE row_seq = 1
	)
-- Now we attach the residency information to our cohort in 2014.
SELECT
	alf_e,
	ethnicity,
	sex,
	wob,
	dod,
	t1.lsoa2011,
	t1.start_date,
	t1.end_date,
	t1.denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	bmi_cat,
	CASE 
		WHEN  source_db IS NULL THEN 'Unknown'
		ELSE  source_db
		END AS source_db,
-- from wimd2019 table
	CASE 
		WHEN  wimd2019_quintile IS NULL THEN 'Unknown'
		ELSE  wimd2019_quintile
		END AS wimd2019_quintile,
-- from rural/urban table
	CASE 
		WHEN  rural_urban IS NULL THEN 'Unknown'
		ELSE  rural_urban
		END AS rural_urban,
	CASE 
		WHEN  lhb IS NULL THEN 'Unknown'
		ELSE  lhb
		END AS lhb
FROM 
	t1
LEFT JOIN
	t2
ON t1.lsoa2011 = t2.lsoa2011 -- this matches the residency information of ALFs
;

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_ADULT
-- 2015
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2015. We select their most recent address in 2015, and attaches their most recent BMI record in 2015 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2015-12-31', wob)/365.25) AS age_years,
		CASE 
				-- those with age_bands already from the BMI output
				WHEN age_band IS NOT NULL THEN age_band 
				-- individuals living in Wales in this year, but no BMI output. We allocate an age band for them here. using the end of the year and their WOB
				WHEN ROUND(DAYS_BETWEEN('2015-12-31', WOB)/365.25) BETWEEN 19 AND 29		THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2015-12-31', WOB)/365.25) = 19 					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2015-12-31', WOB)/365.25) = 29					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2015-12-31', WOB)/365.25) BETWEEN 30 AND 39		THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2015-12-31', WOB)/365.25) = 30 					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2015-12-31', WOB)/365.25) = 39					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2015-12-31', WOB)/365.25) BETWEEN 40 AND 49		THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2015-12-31', WOB)/365.25) = 40 					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2015-12-31', WOB)/365.25) = 49					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2015-12-31', WOB)/365.25) BETWEEN 50 AND 59		THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2015-12-31', WOB)/365.25) = 50 					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2015-12-31', WOB)/365.25) = 59					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2015-12-31', WOB)/365.25) BETWEEN 60 AND 69		THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2015-12-31', WOB)/365.25) = 60 					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2015-12-31', WOB)/365.25) = 69					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2015-12-31', WOB)/365.25) BETWEEN 70 AND 79		THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2015-12-31', WOB)/365.25) = 70 					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2015-12-31', WOB)/365.25) = 79					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2015-12-31', WOB)/365.25) BETWEEN 80 AND 89		THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2015-12-31', WOB)/365.25) = 80 					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2015-12-31', WOB)/365.25) = 89					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2015-12-31', WOB)/365.25) >= 90					THEN '90 -100'
				ELSE NULL 
		END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not Adults in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN bmi_cat IS NOT NULL THEN bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS bmi_cat,
		source_db
	FROM
	-- this is all the Adult population in 2015.
		(
		SELECT * FROM
			(
			SELECT DISTINCT 
				alf_e, 
				sex, 
				wob, 
				lsoa2011_cd, 
				start_date, 
				end_date, 
				dod, 
				denom_year, 
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY start_date, end_date desc) AS dt_order -- to identify those with multiple addresses in this year.
			FROM SAILW1151V.HDR25_BMI_ALG_COHORT a -- the population denominator table
			WHERE denom_year = 2015 -- those that are living in Wales in this year
			AND cohort = 1 -- who are Adults at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this year to remove duplicates.
		)a
	LEFT JOIN
	-- we extract their ethnicity
		SAILW1151V.HDR25_BMI_ETHN AS b 
	ON a.alf_e = b.alf_e
	LEFT JOIN
	-- we extract the BMI data from our output
		(
		SELECT
			*
		FROM
			(
			SELECT
				alf_e,
				age_band,
				bmi_dt,
				bmi_cat,
				source_db,
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
			FROM
				SAILW1151V.HDR25_BMI_ALG_OUTPUT
			WHERE bmi_year = 2015
			) 
		WHERE dt_order = 1
		) c
	ON a.alf_e = c.ALF_E
	ORDER BY alf_e
	),
t2 AS 
-- This chunk puts together the demographical information related to LSOA2011 codes. We will then attach this to t1 in the next step,.
	(
	SELECT
		*
	FROM
		(
		SELECT DISTINCT
				e.LSOA2011_CD 				AS lsoa2011
			,	e.WIMD_2019_QUINTILE_DESC 	AS wimd2019_quintile
			,	g.RU_Name 					AS rural_urban
			,	g.LHB_Name					AS lhb
			, 	ROW_NUMBER() OVER (PARTITION BY e.lsoa2011_cd ORDER BY wimd_2019_quintile_desc) AS row_seq
		FROM
			SAILW1151V.HDR25_BMI_WIMD2019 AS e -- getting wimd2019
		LEFT JOIN 
			SAILW1151V.HDR25_BMI_ALG_LSOA_LHB_LOOKUP AS g -- getting rural/urban and LHB details
		ON e.LSOA2011_CD=g.LSOA2011_Code 
		WHERE e.lsoa2011_cd IS NOT NULL
		)
	WHERE row_seq = 1
	)
-- Now we attach the residency information to our cohort in 2015.
SELECT
	alf_e,
	ethnicity,
	sex,
	wob,
	dod,
	t1.lsoa2011,
	t1.start_date,
	t1.end_date,
	t1.denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	bmi_cat,
	CASE 
		WHEN  source_db IS NULL THEN 'Unknown'
		ELSE  source_db
		END AS source_db,
-- from wimd2019 table
	CASE 
		WHEN  wimd2019_quintile IS NULL THEN 'Unknown'
		ELSE  wimd2019_quintile
		END AS wimd2019_quintile,
-- from rural/urban table
	CASE 
		WHEN  rural_urban IS NULL THEN 'Unknown'
		ELSE  rural_urban
		END AS rural_urban,
	CASE 
		WHEN  lhb IS NULL THEN 'Unknown'
		ELSE  lhb
		END AS lhb
FROM 
	t1
LEFT JOIN
	t2
ON t1.lsoa2011 = t2.lsoa2011 -- this matches the residency information of ALFs
;

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_ADULT
-- 2016
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2016. We select their most recent address in 2016, and attaches their most recent BMI record in 2016 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2016-12-31', wob)/365.25) AS age_years,
		CASE 
				-- those with age_bands already from the BMI output
				WHEN age_band IS NOT NULL THEN age_band 
				-- individuals living in Wales in this year, but no BMI output. We allocate an age band for them here. using the end of the year and their WOB
				WHEN ROUND(DAYS_BETWEEN('2016-12-31', WOB)/365.25) BETWEEN 19 AND 29		THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2016-12-31', WOB)/365.25) = 19 					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2016-12-31', WOB)/365.25) = 29					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2016-12-31', WOB)/365.25) BETWEEN 30 AND 39		THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2016-12-31', WOB)/365.25) = 30 					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2016-12-31', WOB)/365.25) = 39					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2016-12-31', WOB)/365.25) BETWEEN 40 AND 49		THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2016-12-31', WOB)/365.25) = 40 					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2016-12-31', WOB)/365.25) = 49					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2016-12-31', WOB)/365.25) BETWEEN 50 AND 59		THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2016-12-31', WOB)/365.25) = 50 					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2016-12-31', WOB)/365.25) = 59					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2016-12-31', WOB)/365.25) BETWEEN 60 AND 69		THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2016-12-31', WOB)/365.25) = 60 					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2016-12-31', WOB)/365.25) = 69					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2016-12-31', WOB)/365.25) BETWEEN 70 AND 79		THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2016-12-31', WOB)/365.25) = 70 					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2016-12-31', WOB)/365.25) = 79					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2016-12-31', WOB)/365.25) BETWEEN 80 AND 89		THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2016-12-31', WOB)/365.25) = 80 					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2016-12-31', WOB)/365.25) = 89					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2016-12-31', WOB)/365.25) >= 90					THEN '90 -100'
				ELSE NULL 
		END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not Adults in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN bmi_cat IS NOT NULL THEN bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS bmi_cat,
		source_db
	FROM
	-- this is all the Adult population in 2016.
		(
		SELECT * FROM
			(
			SELECT DISTINCT 
				alf_e, 
				sex, 
				wob, 
				lsoa2011_cd, 
				start_date, 
				end_date, 
				dod, 
				denom_year, 
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY start_date, end_date desc) AS dt_order -- to identify those with multiple addresses in this year.
			FROM SAILW1151V.HDR25_BMI_ALG_COHORT a -- the population denominator table
			WHERE denom_year = 2016 -- those that are living in Wales in this year
			AND cohort = 1 -- who are Adults at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this year to remove duplicates.
		)a
	LEFT JOIN
	-- we extract their ethnicity
		SAILW1151V.HDR25_BMI_ETHN AS b 
	ON a.alf_e = b.alf_e
	LEFT JOIN
	-- we extract the BMI data from our output
		(
		SELECT
			*
		FROM
			(
			SELECT
				alf_e,
				age_band,
				bmi_dt,
				bmi_cat,
				source_db,
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
			FROM
				SAILW1151V.HDR25_BMI_ALG_OUTPUT
			WHERE bmi_year = 2016
			) 
		WHERE dt_order = 1
		) c
	ON a.alf_e = c.ALF_E
	ORDER BY alf_e
	),
t2 AS 
-- This chunk puts together the demographical information related to LSOA2011 codes. We will then attach this to t1 in the next step,.
	(
	SELECT
		*
	FROM
		(
		SELECT DISTINCT
				e.LSOA2011_CD 				AS lsoa2011
			,	e.WIMD_2019_QUINTILE_DESC 	AS wimd2019_quintile
			,	g.RU_Name 					AS rural_urban
			,	g.LHB_Name					AS lhb
			, 	ROW_NUMBER() OVER (PARTITION BY e.lsoa2011_cd ORDER BY wimd_2019_quintile_desc) AS row_seq
		FROM
			SAILW1151V.HDR25_BMI_WIMD2019 AS e -- getting wimd2019
		LEFT JOIN 
			SAILW1151V.HDR25_BMI_ALG_LSOA_LHB_LOOKUP AS g -- getting rural/urban and LHB details
		ON e.LSOA2011_CD=g.LSOA2011_Code 
		WHERE e.lsoa2011_cd IS NOT NULL
		)
	WHERE row_seq = 1
	)
-- Now we attach the residency information to our cohort in 2016.
SELECT
	alf_e,
	ethnicity,
	sex,
	wob,
	dod,
	t1.lsoa2011,
	t1.start_date,
	t1.end_date,
	t1.denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	bmi_cat,
	CASE 
		WHEN  source_db IS NULL THEN 'Unknown'
		ELSE  source_db
		END AS source_db,
-- from wimd2019 table
	CASE 
		WHEN  wimd2019_quintile IS NULL THEN 'Unknown'
		ELSE  wimd2019_quintile
		END AS wimd2019_quintile,
-- from rural/urban table
	CASE 
		WHEN  rural_urban IS NULL THEN 'Unknown'
		ELSE  rural_urban
		END AS rural_urban,
	CASE 
		WHEN  lhb IS NULL THEN 'Unknown'
		ELSE  lhb
		END AS lhb
FROM 
	t1
LEFT JOIN
	t2
ON t1.lsoa2011 = t2.lsoa2011 -- this matches the residency information of ALFs
;

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_ADULT
-- 2017
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2017. We select their most recent address in 2017, and attaches their most recent BMI record in 2017 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2017-12-31', wob)/365.25) AS age_years,
		CASE 
				-- those with age_bands already from the BMI output
				WHEN age_band IS NOT NULL THEN age_band 
				-- individuals living in Wales in this year, but no BMI output. We allocate an age band for them here. using the end of the year and their WOB
				WHEN ROUND(DAYS_BETWEEN('2017-12-31', WOB)/365.25) BETWEEN 19 AND 29		THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2017-12-31', WOB)/365.25) = 19 					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2017-12-31', WOB)/365.25) = 29					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2017-12-31', WOB)/365.25) BETWEEN 30 AND 39		THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2017-12-31', WOB)/365.25) = 30 					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2017-12-31', WOB)/365.25) = 39					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2017-12-31', WOB)/365.25) BETWEEN 40 AND 49		THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2017-12-31', WOB)/365.25) = 40 					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2017-12-31', WOB)/365.25) = 49					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2017-12-31', WOB)/365.25) BETWEEN 50 AND 59		THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2017-12-31', WOB)/365.25) = 50 					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2017-12-31', WOB)/365.25) = 59					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2017-12-31', WOB)/365.25) BETWEEN 60 AND 69		THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2017-12-31', WOB)/365.25) = 60 					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2017-12-31', WOB)/365.25) = 69					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2017-12-31', WOB)/365.25) BETWEEN 70 AND 79		THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2017-12-31', WOB)/365.25) = 70 					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2017-12-31', WOB)/365.25) = 79					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2017-12-31', WOB)/365.25) BETWEEN 80 AND 89		THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2017-12-31', WOB)/365.25) = 80 					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2017-12-31', WOB)/365.25) = 89					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2017-12-31', WOB)/365.25) >= 90					THEN '90 -100'
				ELSE NULL 
		END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not Adults in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN bmi_cat IS NOT NULL THEN bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS bmi_cat,
		source_db
	FROM
	-- this is all the Adult population in 2017.
		(
		SELECT * FROM
			(
			SELECT DISTINCT 
				alf_e, 
				sex, 
				wob, 
				lsoa2011_cd, 
				start_date, 
				end_date, 
				dod, 
				denom_year, 
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY start_date, end_date desc) AS dt_order -- to identify those with multiple addresses in this year.
			FROM SAILW1151V.HDR25_BMI_ALG_COHORT a -- the population denominator table
			WHERE denom_year = 2017 -- those that are living in Wales in this year
			AND cohort = 1 -- who are Adults at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this year to remove duplicates.
		)a
	LEFT JOIN
	-- we extract their ethnicity
		SAILW1151V.HDR25_BMI_ETHN AS b 
	ON a.alf_e = b.alf_e
	LEFT JOIN
	-- we extract the BMI data from our output
		(
		SELECT
			*
		FROM
			(
			SELECT
				alf_e,
				age_band,
				bmi_dt,
				bmi_cat,
				source_db,
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
			FROM
				SAILW1151V.HDR25_BMI_ALG_OUTPUT
			WHERE bmi_year = 2017
			) 
		WHERE dt_order = 1
		) c
	ON a.alf_e = c.ALF_E
	ORDER BY alf_e
	),
t2 AS 
-- This chunk puts together the demographical information related to LSOA2011 codes. We will then attach this to t1 in the next step,.
	(
	SELECT
		*
	FROM
		(
		SELECT DISTINCT
				e.LSOA2011_CD 				AS lsoa2011
			,	e.WIMD_2019_QUINTILE_DESC 	AS wimd2019_quintile
			,	g.RU_Name 					AS rural_urban
			,	g.LHB_Name					AS lhb
			, 	ROW_NUMBER() OVER (PARTITION BY e.lsoa2011_cd ORDER BY wimd_2019_quintile_desc) AS row_seq
		FROM
			SAILW1151V.HDR25_BMI_WIMD2019 AS e -- getting wimd2019
		LEFT JOIN 
			SAILW1151V.HDR25_BMI_ALG_LSOA_LHB_LOOKUP AS g -- getting rural/urban and LHB details
		ON e.LSOA2011_CD=g.LSOA2011_Code 
		WHERE e.lsoa2011_cd IS NOT NULL
		)
	WHERE row_seq = 1
	)
-- Now we attach the residency information to our cohort in 2017.
SELECT
	alf_e,
	ethnicity,
	sex,
	wob,
	dod,
	t1.lsoa2011,
	t1.start_date,
	t1.end_date,
	t1.denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	bmi_cat,
	CASE 
		WHEN  source_db IS NULL THEN 'Unknown'
		ELSE  source_db
		END AS source_db,
-- from wimd2019 table
	CASE 
		WHEN  wimd2019_quintile IS NULL THEN 'Unknown'
		ELSE  wimd2019_quintile
		END AS wimd2019_quintile,
-- from rural/urban table
	CASE 
		WHEN  rural_urban IS NULL THEN 'Unknown'
		ELSE  rural_urban
		END AS rural_urban,
	CASE 
		WHEN  lhb IS NULL THEN 'Unknown'
		ELSE  lhb
		END AS lhb
FROM 
	t1
LEFT JOIN
	t2
ON t1.lsoa2011 = t2.lsoa2011 -- this matches the residency information of ALFs
;

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_ADULT
-- 2018
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2018. We select their most recent address in 2018, and attaches their most recent BMI record in 2018 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2018-12-31', wob)/365.25) AS age_years,
		CASE 
				-- those with age_bands already from the BMI output
				WHEN age_band IS NOT NULL THEN age_band 
				-- individuals living in Wales in this year, but no BMI output. We allocate an age band for them here. using the end of the year and their WOB
				WHEN ROUND(DAYS_BETWEEN('2018-12-31', WOB)/365.25) BETWEEN 19 AND 29		THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2018-12-31', WOB)/365.25) = 19 					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2018-12-31', WOB)/365.25) = 29					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2018-12-31', WOB)/365.25) BETWEEN 30 AND 39		THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2018-12-31', WOB)/365.25) = 30 					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2018-12-31', WOB)/365.25) = 39					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2018-12-31', WOB)/365.25) BETWEEN 40 AND 49		THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2018-12-31', WOB)/365.25) = 40 					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2018-12-31', WOB)/365.25) = 49					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2018-12-31', WOB)/365.25) BETWEEN 50 AND 59		THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2018-12-31', WOB)/365.25) = 50 					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2018-12-31', WOB)/365.25) = 59					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2018-12-31', WOB)/365.25) BETWEEN 60 AND 69		THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2018-12-31', WOB)/365.25) = 60 					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2018-12-31', WOB)/365.25) = 69					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2018-12-31', WOB)/365.25) BETWEEN 70 AND 79		THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2018-12-31', WOB)/365.25) = 70 					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2018-12-31', WOB)/365.25) = 79					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2018-12-31', WOB)/365.25) BETWEEN 80 AND 89		THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2018-12-31', WOB)/365.25) = 80 					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2018-12-31', WOB)/365.25) = 89					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2018-12-31', WOB)/365.25) >= 90					THEN '90 -100'
				ELSE NULL 
		END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not Adults in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN bmi_cat IS NOT NULL THEN bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS bmi_cat,
		source_db
	FROM
	-- this is all the Adult population in 2018.
		(
		SELECT * FROM
			(
			SELECT DISTINCT 
				alf_e, 
				sex, 
				wob, 
				lsoa2011_cd, 
				start_date, 
				end_date, 
				dod, 
				denom_year, 
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY start_date, end_date desc) AS dt_order -- to identify those with multiple addresses in this year.
			FROM SAILW1151V.HDR25_BMI_ALG_COHORT a -- the population denominator table
			WHERE denom_year = 2018 -- those that are living in Wales in this year
			AND cohort = 1 -- who are Adults at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this year to remove duplicates.
		)a
	LEFT JOIN
	-- we extract their ethnicity
		SAILW1151V.HDR25_BMI_ETHN AS b 
	ON a.alf_e = b.alf_e
	LEFT JOIN
	-- we extract the BMI data from our output
		(
		SELECT
			*
		FROM
			(
			SELECT
				alf_e,
				age_band,
				bmi_dt,
				bmi_cat,
				source_db,
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
			FROM
				SAILW1151V.HDR25_BMI_ALG_OUTPUT
			WHERE bmi_year = 2018
			) 
		WHERE dt_order = 1
		) c
	ON a.alf_e = c.ALF_E
	ORDER BY alf_e
	),
t2 AS 
-- This chunk puts together the demographical information related to LSOA2011 codes. We will then attach this to t1 in the next step,.
	(
	SELECT
		*
	FROM
		(
		SELECT DISTINCT
				e.LSOA2011_CD 				AS lsoa2011
			,	e.WIMD_2019_QUINTILE_DESC 	AS wimd2019_quintile
			,	g.RU_Name 					AS rural_urban
			,	g.LHB_Name					AS lhb
			, 	ROW_NUMBER() OVER (PARTITION BY e.lsoa2011_cd ORDER BY wimd_2019_quintile_desc) AS row_seq
		FROM
			SAILW1151V.HDR25_BMI_WIMD2019 AS e -- getting wimd2019
		LEFT JOIN 
			SAILW1151V.HDR25_BMI_ALG_LSOA_LHB_LOOKUP AS g -- getting rural/urban and LHB details
		ON e.LSOA2011_CD=g.LSOA2011_Code 
		WHERE e.lsoa2011_cd IS NOT NULL
		)
	WHERE row_seq = 1
	)
-- Now we attach the residency information to our cohort in 2018.
SELECT
	alf_e,
	ethnicity,
	sex,
	wob,
	dod,
	t1.lsoa2011,
	t1.start_date,
	t1.end_date,
	t1.denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	bmi_cat,
	CASE 
		WHEN  source_db IS NULL THEN 'Unknown'
		ELSE  source_db
		END AS source_db,
-- from wimd2019 table
	CASE 
		WHEN  wimd2019_quintile IS NULL THEN 'Unknown'
		ELSE  wimd2019_quintile
		END AS wimd2019_quintile,
-- from rural/urban table
	CASE 
		WHEN  rural_urban IS NULL THEN 'Unknown'
		ELSE  rural_urban
		END AS rural_urban,
	CASE 
		WHEN  lhb IS NULL THEN 'Unknown'
		ELSE  lhb
		END AS lhb
FROM 
	t1
LEFT JOIN
	t2
ON t1.lsoa2011 = t2.lsoa2011 -- this matches the residency information of ALFs
;

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_ADULT
-- 2019
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2019. We select their most recent address in 2019, and attaches their most recent BMI record in 2019 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2019-12-31', wob)/365.25) AS age_years,
		CASE 
				-- those with age_bands already from the BMI output
				WHEN age_band IS NOT NULL THEN age_band 
				-- individuals living in Wales in this year, but no BMI output. We allocate an age band for them here. using the end of the year and their WOB
				WHEN ROUND(DAYS_BETWEEN('2019-12-31', WOB)/365.25) BETWEEN 19 AND 29		THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2019-12-31', WOB)/365.25) = 19 					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2019-12-31', WOB)/365.25) = 29					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2019-12-31', WOB)/365.25) BETWEEN 30 AND 39		THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2019-12-31', WOB)/365.25) = 30 					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2019-12-31', WOB)/365.25) = 39					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2019-12-31', WOB)/365.25) BETWEEN 40 AND 49		THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2019-12-31', WOB)/365.25) = 40 					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2019-12-31', WOB)/365.25) = 49					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2019-12-31', WOB)/365.25) BETWEEN 50 AND 59		THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2019-12-31', WOB)/365.25) = 50 					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2019-12-31', WOB)/365.25) = 59					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2019-12-31', WOB)/365.25) BETWEEN 60 AND 69		THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2019-12-31', WOB)/365.25) = 60 					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2019-12-31', WOB)/365.25) = 69					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2019-12-31', WOB)/365.25) BETWEEN 70 AND 79		THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2019-12-31', WOB)/365.25) = 70 					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2019-12-31', WOB)/365.25) = 79					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2019-12-31', WOB)/365.25) BETWEEN 80 AND 89		THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2019-12-31', WOB)/365.25) = 80 					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2019-12-31', WOB)/365.25) = 89					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2019-12-31', WOB)/365.25) >= 90					THEN '90 -100'
				ELSE NULL 
		END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not Adults in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN bmi_cat IS NOT NULL THEN bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS bmi_cat,
		source_db
	FROM
	-- this is all the Adult population in 2019.
		(
		SELECT * FROM
			(
			SELECT DISTINCT 
				alf_e, 
				sex, 
				wob, 
				lsoa2011_cd, 
				start_date, 
				end_date, 
				dod, 
				denom_year, 
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY start_date, end_date desc) AS dt_order -- to identify those with multiple addresses in this year.
			FROM SAILW1151V.HDR25_BMI_ALG_COHORT a -- the population denominator table
			WHERE denom_year = 2019 -- those that are living in Wales in this year
			AND cohort = 1 -- who are Adults at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this year to remove duplicates.
		)a
	LEFT JOIN
	-- we extract their ethnicity
		SAILW1151V.HDR25_BMI_ETHN AS b 
	ON a.alf_e = b.alf_e
	LEFT JOIN
	-- we extract the BMI data from our output
		(
		SELECT
			*
		FROM
			(
			SELECT
				alf_e,
				age_band,
				bmi_dt,
				bmi_cat,
				source_db,
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
			FROM
				SAILW1151V.HDR25_BMI_ALG_OUTPUT
			WHERE bmi_year = 2019
			) 
		WHERE dt_order = 1
		) c
	ON a.alf_e = c.ALF_E
	ORDER BY alf_e
	),
t2 AS 
-- This chunk puts together the demographical information related to LSOA2011 codes. We will then attach this to t1 in the next step,.
	(
	SELECT
		*
	FROM
		(
		SELECT DISTINCT
				e.LSOA2011_CD 				AS lsoa2011
			,	e.WIMD_2019_QUINTILE_DESC 	AS wimd2019_quintile
			,	g.RU_Name 					AS rural_urban
			,	g.LHB_Name					AS lhb
			, 	ROW_NUMBER() OVER (PARTITION BY e.lsoa2011_cd ORDER BY wimd_2019_quintile_desc) AS row_seq
		FROM
			SAILW1151V.HDR25_BMI_WIMD2019 AS e -- getting wimd2019
		LEFT JOIN 
			SAILW1151V.HDR25_BMI_ALG_LSOA_LHB_LOOKUP AS g -- getting rural/urban and LHB details
		ON e.LSOA2011_CD=g.LSOA2011_Code 
		WHERE e.lsoa2011_cd IS NOT NULL
		)
	WHERE row_seq = 1
	)
-- Now we attach the residency information to our cohort in 2019.
SELECT
	alf_e,
	ethnicity,
	sex,
	wob,
	dod,
	t1.lsoa2011,
	t1.start_date,
	t1.end_date,
	t1.denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	bmi_cat,
	CASE 
		WHEN  source_db IS NULL THEN 'Unknown'
		ELSE  source_db
		END AS source_db,
-- from wimd2019 table
	CASE 
		WHEN  wimd2019_quintile IS NULL THEN 'Unknown'
		ELSE  wimd2019_quintile
		END AS wimd2019_quintile,
-- from rural/urban table
	CASE 
		WHEN  rural_urban IS NULL THEN 'Unknown'
		ELSE  rural_urban
		END AS rural_urban,
	CASE 
		WHEN  lhb IS NULL THEN 'Unknown'
		ELSE  lhb
		END AS lhb
FROM 
	t1
LEFT JOIN
	t2
ON t1.lsoa2011 = t2.lsoa2011 -- this matches the residency information of ALFs
;

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_ADULT
-- 2020
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2020. We select their most recent address in 2020, and attaches their most recent BMI record in 2020 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2020-12-31', wob)/365.25) AS age_years,
		CASE 
				-- those with age_bands already from the BMI output
				WHEN age_band IS NOT NULL THEN age_band 
				-- individuals living in Wales in this year, but no BMI output. We allocate an age band for them here. using the end of the year and their WOB
				WHEN ROUND(DAYS_BETWEEN('2020-12-31', WOB)/365.25) BETWEEN 19 AND 29		THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2020-12-31', WOB)/365.25) = 19 					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2020-12-31', WOB)/365.25) = 29					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2020-12-31', WOB)/365.25) BETWEEN 30 AND 39		THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2020-12-31', WOB)/365.25) = 30 					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2020-12-31', WOB)/365.25) = 39					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2020-12-31', WOB)/365.25) BETWEEN 40 AND 49		THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2020-12-31', WOB)/365.25) = 40 					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2020-12-31', WOB)/365.25) = 49					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2020-12-31', WOB)/365.25) BETWEEN 50 AND 59		THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2020-12-31', WOB)/365.25) = 50 					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2020-12-31', WOB)/365.25) = 59					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2020-12-31', WOB)/365.25) BETWEEN 60 AND 69		THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2020-12-31', WOB)/365.25) = 60 					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2020-12-31', WOB)/365.25) = 69					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2020-12-31', WOB)/365.25) BETWEEN 70 AND 79		THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2020-12-31', WOB)/365.25) = 70 					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2020-12-31', WOB)/365.25) = 79					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2020-12-31', WOB)/365.25) BETWEEN 80 AND 89		THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2020-12-31', WOB)/365.25) = 80 					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2020-12-31', WOB)/365.25) = 89					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2020-12-31', WOB)/365.25) >= 90					THEN '90 -100'
				ELSE NULL 
		END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not Adults in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN bmi_cat IS NOT NULL THEN bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS bmi_cat,
		source_db
	FROM
	-- this is all the Adult population in 2020.
		(
		SELECT * FROM
			(
			SELECT DISTINCT 
				alf_e, 
				sex, 
				wob, 
				lsoa2011_cd, 
				start_date, 
				end_date, 
				dod, 
				denom_year, 
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY start_date, end_date desc) AS dt_order -- to identify those with multiple addresses in this year.
			FROM SAILW1151V.HDR25_BMI_ALG_COHORT a -- the population denominator table
			WHERE denom_year = 2020 -- those that are living in Wales in this year
			AND cohort = 1 -- who are Adults at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this year to remove duplicates.
		)a
	LEFT JOIN
	-- we extract their ethnicity
		SAILW1151V.HDR25_BMI_ETHN AS b 
	ON a.alf_e = b.alf_e
	LEFT JOIN
	-- we extract the BMI data from our output
		(
		SELECT
			*
		FROM
			(
			SELECT
				alf_e,
				age_band,
				bmi_dt,
				bmi_cat,
				source_db,
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
			FROM
				SAILW1151V.HDR25_BMI_ALG_OUTPUT
			WHERE bmi_year = 2020
			) 
		WHERE dt_order = 1
		) c
	ON a.alf_e = c.ALF_E
	ORDER BY alf_e
	),
t2 AS 
-- This chunk puts together the demographical information related to LSOA2011 codes. We will then attach this to t1 in the next step,.
	(
	SELECT
		*
	FROM
		(
		SELECT DISTINCT
				e.LSOA2011_CD 				AS lsoa2011
			,	e.WIMD_2019_QUINTILE_DESC 	AS wimd2019_quintile
			,	g.RU_Name 					AS rural_urban
			,	g.LHB_Name					AS lhb
			, 	ROW_NUMBER() OVER (PARTITION BY e.lsoa2011_cd ORDER BY wimd_2019_quintile_desc) AS row_seq
		FROM
			SAILW1151V.HDR25_BMI_WIMD2019 AS e -- getting wimd2019
		LEFT JOIN 
			SAILW1151V.HDR25_BMI_ALG_LSOA_LHB_LOOKUP AS g -- getting rural/urban and LHB details
		ON e.LSOA2011_CD=g.LSOA2011_Code 
		WHERE e.lsoa2011_cd IS NOT NULL
		)
	WHERE row_seq = 1
	)
-- Now we attach the residency information to our cohort in 2020.
SELECT
	alf_e,
	ethnicity,
	sex,
	wob,
	dod,
	t1.lsoa2011,
	t1.start_date,
	t1.end_date,
	t1.denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	bmi_cat,
	CASE 
		WHEN  source_db IS NULL THEN 'Unknown'
		ELSE  source_db
		END AS source_db,
-- from wimd2019 table
	CASE 
		WHEN  wimd2019_quintile IS NULL THEN 'Unknown'
		ELSE  wimd2019_quintile
		END AS wimd2019_quintile,
-- from rural/urban table
	CASE 
		WHEN  rural_urban IS NULL THEN 'Unknown'
		ELSE  rural_urban
		END AS rural_urban,
	CASE 
		WHEN  lhb IS NULL THEN 'Unknown'
		ELSE  lhb
		END AS lhb
FROM 
	t1
LEFT JOIN
	t2
ON t1.lsoa2011 = t2.lsoa2011 -- this matches the residency information of ALFs
;

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_ADULT
-- 2021
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2021. We select their most recent address in 2021, and attaches their most recent BMI record in 2021 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2021-12-31', wob)/365.25) AS age_years,
		CASE 
				-- those with age_bands already from the BMI output
				WHEN age_band IS NOT NULL THEN age_band 
				-- individuals living in Wales in this year, but no BMI output. We allocate an age band for them here. using the end of the year and their WOB
				WHEN ROUND(DAYS_BETWEEN('2021-12-31', WOB)/365.25) BETWEEN 19 AND 29		THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2021-12-31', WOB)/365.25) = 19 					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2021-12-31', WOB)/365.25) = 29					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2021-12-31', WOB)/365.25) BETWEEN 30 AND 39		THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2021-12-31', WOB)/365.25) = 30 					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2021-12-31', WOB)/365.25) = 39					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2021-12-31', WOB)/365.25) BETWEEN 40 AND 49		THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2021-12-31', WOB)/365.25) = 40 					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2021-12-31', WOB)/365.25) = 49					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2021-12-31', WOB)/365.25) BETWEEN 50 AND 59		THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2021-12-31', WOB)/365.25) = 50 					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2021-12-31', WOB)/365.25) = 59					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2021-12-31', WOB)/365.25) BETWEEN 60 AND 69		THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2021-12-31', WOB)/365.25) = 60 					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2021-12-31', WOB)/365.25) = 69					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2021-12-31', WOB)/365.25) BETWEEN 70 AND 79		THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2021-12-31', WOB)/365.25) = 70 					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2021-12-31', WOB)/365.25) = 79					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2021-12-31', WOB)/365.25) BETWEEN 80 AND 89		THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2021-12-31', WOB)/365.25) = 80 					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2021-12-31', WOB)/365.25) = 89					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2021-12-31', WOB)/365.25) >= 90					THEN '90 -100'
				ELSE NULL 
		END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not Adults in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN bmi_cat IS NOT NULL THEN bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS bmi_cat,
		source_db
	FROM
	-- this is all the Adult population in 2021.
		(
		SELECT * FROM
			(
			SELECT DISTINCT 
				alf_e, 
				sex, 
				wob, 
				lsoa2011_cd, 
				start_date, 
				end_date, 
				dod, 
				denom_year, 
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY start_date, end_date desc) AS dt_order -- to identify those with multiple addresses in this year.
			FROM SAILW1151V.HDR25_BMI_ALG_COHORT a -- the population denominator table
			WHERE denom_year = 2021 -- those that are living in Wales in this year
			AND cohort = 1 -- who are Adults at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this year to remove duplicates.
		)a
	LEFT JOIN
	-- we extract their ethnicity
		SAILW1151V.HDR25_BMI_ETHN AS b 
	ON a.alf_e = b.alf_e
	LEFT JOIN
	-- we extract the BMI data from our output
		(
		SELECT
			*
		FROM
			(
			SELECT
				alf_e,
				age_band,
				bmi_dt,
				bmi_cat,
				source_db,
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
			FROM
				SAILW1151V.HDR25_BMI_ALG_OUTPUT
			WHERE bmi_year = 2021
			) 
		WHERE dt_order = 1
		) c
	ON a.alf_e = c.ALF_E
	ORDER BY alf_e
	),
t2 AS 
-- This chunk puts together the demographical information related to LSOA2011 codes. We will then attach this to t1 in the next step,.
	(
	SELECT
		*
	FROM
		(
		SELECT DISTINCT
				e.LSOA2011_CD 				AS lsoa2011
			,	e.WIMD_2019_QUINTILE_DESC 	AS wimd2019_quintile
			,	g.RU_Name 					AS rural_urban
			,	g.LHB_Name					AS lhb
			, 	ROW_NUMBER() OVER (PARTITION BY e.lsoa2011_cd ORDER BY wimd_2019_quintile_desc) AS row_seq
		FROM
			SAILW1151V.HDR25_BMI_WIMD2019 AS e -- getting wimd2019
		LEFT JOIN 
			SAILW1151V.HDR25_BMI_ALG_LSOA_LHB_LOOKUP AS g -- getting rural/urban and LHB details
		ON e.LSOA2011_CD=g.LSOA2011_Code 
		WHERE e.lsoa2011_cd IS NOT NULL
		)
	WHERE row_seq = 1
	)
-- Now we attach the residency information to our cohort in 2021.
SELECT
	alf_e,
	ethnicity,
	sex,
	wob,
	dod,
	t1.lsoa2011,
	t1.start_date,
	t1.end_date,
	t1.denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	bmi_cat,
	CASE 
		WHEN  source_db IS NULL THEN 'Unknown'
		ELSE  source_db
		END AS source_db,
-- from wimd2019 table
	CASE 
		WHEN  wimd2019_quintile IS NULL THEN 'Unknown'
		ELSE  wimd2019_quintile
		END AS wimd2019_quintile,
-- from rural/urban table
	CASE 
		WHEN  rural_urban IS NULL THEN 'Unknown'
		ELSE  rural_urban
		END AS rural_urban,
	CASE 
		WHEN  lhb IS NULL THEN 'Unknown'
		ELSE  lhb
		END AS lhb
FROM 
	t1
LEFT JOIN
	t2
ON t1.lsoa2011 = t2.lsoa2011 -- this matches the residency information of ALFs
;

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_ADULT
-- 2022
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2022. We select their most recent address in 2022, and attaches their most recent BMI record in 2022 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2022-12-31', wob)/365.25) AS age_years,
		CASE 
				-- those with age_bands already from the BMI output
				WHEN age_band IS NOT NULL THEN age_band 
				-- individuals living in Wales in this year, but no BMI output. We allocate an age band for them here. using the end of the year and their WOB
				WHEN ROUND(DAYS_BETWEEN('2022-12-31', WOB)/365.25) BETWEEN 19 AND 29		THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2022-12-31', WOB)/365.25) = 19 					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2022-12-31', WOB)/365.25) = 29					THEN '19-29'
				WHEN ROUND(DAYS_BETWEEN('2022-12-31', WOB)/365.25) BETWEEN 30 AND 39		THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2022-12-31', WOB)/365.25) = 30 					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2022-12-31', WOB)/365.25) = 39					THEN '30-39'
				WHEN ROUND(DAYS_BETWEEN('2022-12-31', WOB)/365.25) BETWEEN 40 AND 49		THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2022-12-31', WOB)/365.25) = 40 					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2022-12-31', WOB)/365.25) = 49					THEN '40-49'
				WHEN ROUND(DAYS_BETWEEN('2022-12-31', WOB)/365.25) BETWEEN 50 AND 59		THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2022-12-31', WOB)/365.25) = 50 					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2022-12-31', WOB)/365.25) = 59					THEN '50-59'
				WHEN ROUND(DAYS_BETWEEN('2022-12-31', WOB)/365.25) BETWEEN 60 AND 69		THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2022-12-31', WOB)/365.25) = 60 					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2022-12-31', WOB)/365.25) = 69					THEN '60-69'
				WHEN ROUND(DAYS_BETWEEN('2022-12-31', WOB)/365.25) BETWEEN 70 AND 79		THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2022-12-31', WOB)/365.25) = 70 					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2022-12-31', WOB)/365.25) = 79					THEN '70-79'
				WHEN ROUND(DAYS_BETWEEN('2022-12-31', WOB)/365.25) BETWEEN 80 AND 89		THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2022-12-31', WOB)/365.25) = 80 					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2022-12-31', WOB)/365.25) = 89					THEN '80-89'
				WHEN ROUND(DAYS_BETWEEN('2022-12-31', WOB)/365.25) >= 90					THEN '90 -100'
				ELSE NULL 
		END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not Adults in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN bmi_cat IS NOT NULL THEN bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS bmi_cat,
		source_db
	FROM
	-- this is all the Adult population in 2022.
		(
		SELECT * FROM
			(
			SELECT DISTINCT 
				alf_e, 
				sex, 
				wob, 
				lsoa2011_cd, 
				start_date, 
				end_date, 
				dod, 
				denom_year, 
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY start_date, end_date desc) AS dt_order -- to identify those with multiple addresses in this year.
			FROM SAILW1151V.HDR25_BMI_ALG_COHORT a -- the population denominator table
			WHERE denom_year = 2022 -- those that are living in Wales in this year
			AND cohort = 1 -- who are Adults at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this year to remove duplicates.
		)a
	LEFT JOIN
	-- we extract their ethnicity
		SAILW1151V.HDR25_BMI_ETHN AS b 
	ON a.alf_e = b.alf_e
	LEFT JOIN
	-- we extract the BMI data from our output
		(
		SELECT
			*
		FROM
			(
			SELECT
				alf_e,
				age_band,
				bmi_dt,
				bmi_cat,
				source_db,
				ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
			FROM
				SAILW1151V.HDR25_BMI_ALG_OUTPUT
			WHERE bmi_year = 2022
			) 
		WHERE dt_order = 1
		) c
	ON a.alf_e = c.ALF_E
	ORDER BY alf_e
	),
t2 AS 
-- This chunk puts together the demographical information related to LSOA2011 codes. We will then attach this to t1 in the next step,.
	(
	SELECT
		*
	FROM
		(
		SELECT DISTINCT
				e.LSOA2011_CD 				AS lsoa2011
			,	e.WIMD_2019_QUINTILE_DESC 	AS wimd2019_quintile
			,	g.RU_Name 					AS rural_urban
			,	g.LHB_Name					AS lhb
			, 	ROW_NUMBER() OVER (PARTITION BY e.lsoa2011_cd ORDER BY wimd_2019_quintile_desc) AS row_seq
		FROM
			SAILW1151V.HDR25_BMI_WIMD2019 AS e -- getting wimd2019
		LEFT JOIN 
			SAILW1151V.HDR25_BMI_ALG_LSOA_LHB_LOOKUP AS g -- getting rural/urban and LHB details
		ON e.LSOA2011_CD=g.LSOA2011_Code 
		WHERE e.lsoa2011_cd IS NOT NULL
		)
	WHERE row_seq = 1
	)
-- Now we attach the residency information to our cohort in 2022.
SELECT
	alf_e,
	ethnicity,
	sex,
	wob,
	dod,
	t1.lsoa2011,
	t1.start_date,
	t1.end_date,
	t1.denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	bmi_cat,
	CASE 
		WHEN  source_db IS NULL THEN 'Unknown'
		ELSE  source_db
		END AS source_db,
-- from wimd2019 table
	CASE 
		WHEN  wimd2019_quintile IS NULL THEN 'Unknown'
		ELSE  wimd2019_quintile
		END AS wimd2019_quintile,
-- from rural/urban table
	CASE 
		WHEN  rural_urban IS NULL THEN 'Unknown'
		ELSE  rural_urban
		END AS rural_urban,
	CASE 
		WHEN  lhb IS NULL THEN 'Unknown'
		ELSE  lhb
		END AS lhb
FROM 
	t1
LEFT JOIN
	t2
ON t1.lsoa2011 = t2.lsoa2011 -- this matches the residency information of ALFs
;

COMMIT;

SELECT denom_year, count(DISTINCT alf_e), count(*) FROM SAILW1151V.HDR25_BMI_TABLEONE_ADULT
GROUP BY denom_year;