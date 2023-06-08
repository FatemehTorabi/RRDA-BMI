-- Created by m.j.childs@swansea.ac.uk
-- Functions used:
	-- SELECT, CREATE, INSERT, DROP, LEFT JOIN

-- This code creates a long table that can be used to generate a TableOne in R or Python.
-- This will have the baseline characteristics of the population from 2000-2022, grouped by 5 years, e.g. 2000-2004, 2005-2009, etc.

------------------------------------------------
-- Section 1. Defining your variables
------------------------------------------------

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


CALL FNC.DROP_IF_EXISTS('SAILW1151V.HDR25_BMI_TABLEONE_GROUPED5_ADULT'); 

CREATE TABLE SAILW1151V.HDR25_BMI_TABLEONE_GROUPED5_ADULT
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
		denom_year				VARCHAR(10),
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


INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_GROUPED5_ADULT
-- 2000-2004
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2000-2004. We select their most recent address in 2000-2004, and attaches their most recent BMI record in 2000-2004 if they have one.
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
			WHERE denom_year IN ('2000', '2001', '2002', '2003', '2004')-- those that are living in Wales in this year
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
			WHERE bmi_year IN ('2000', '2001', '2002', '2003', '2004')
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
	'2000-2004' AS denom_year,
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

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_GROUPED5_ADULT
-- 2005-2009
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2005-2009. We select their most recent address in 2005-2009, and attaches their most recent BMI record in 2005-2009 if they have one.
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
	-- this is all the Adult population in 2005 - 2009.
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
			WHERE denom_year IN ('2005', '2006', '2007', '2008', '2009')-- those that are living in Wales in this year
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
			WHERE bmi_year IN ('2005', '2006', '2007', '2008', '2009')
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
-- Now we attach the residency information to our cohort in 2005 - 2009.
SELECT
	alf_e,
	ethnicity,
	sex,
	wob,
	dod,
	t1.lsoa2011,
	t1.start_date,
	t1.end_date,
	'2005-2009' AS denom_year,
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

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_GROUPED5_ADULT
-- 2010-2014
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2010-2014. We select their most recent address in 2010-2014, and attaches their most recent BMI record in 2010-2014 if they have one.
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
	-- this is all the Adult population in 2005 - 2009.
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
			WHERE denom_year IN ('2010', '2011', '2012', '2013', '2014')-- those that are living in Wales in this year
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
			WHERE bmi_year IN ('2010', '2011', '2012', '2013', '2014')
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
-- Now we attach the residency information to our cohort in 2005 - 2009.
SELECT
	alf_e,
	ethnicity,
	sex,
	wob,
	dod,
	t1.lsoa2011,
	t1.start_date,
	t1.end_date,
	'2010-2014' AS denom_year,
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

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_GROUPED5_ADULT
-- 2015-2019
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2015-2019. We select their most recent address in 2015-2019, and attaches their most recent BMI record in 2015-2019 if they have one.
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
	-- this is all the Adult population in 2015-2019.
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
			WHERE denom_year IN ('2015', '2016', '2017', '2018', '2019')-- those that are living in Wales in this year
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
			WHERE bmi_year IN ('2015', '2016', '2017', '2018', '2019')
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
-- Now we attach the residency information to our cohort in 2015-2019.
SELECT
	alf_e,
	ethnicity,
	sex,
	wob,
	dod,
	t1.lsoa2011,
	t1.start_date,
	t1.end_date,
	'2015-2019' AS denom_year,
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

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_GROUPED5_ADULT
-- 2020-2022
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2020-2022. We select their most recent address in 2020-2022, and attaches their most recent BMI record in 2020-2022 if they have one.
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
	-- this is all the Adult population in 2020-2022.
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
			WHERE denom_year IN ('2020', '2021', '2022')-- those that are living in Wales in this year
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
			WHERE bmi_year IN ('2020', '2021', '2022')
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
-- Now we attach the residency information to our cohort in 2020-2022.
SELECT
	alf_e,
	ethnicity,
	sex,
	wob,
	dod,
	t1.lsoa2011,
	t1.start_date,
	t1.end_date,
	'2020-2022' AS denom_year,
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







SELECT DISTINCT denom_year, count(*) FROM SAILW1151V.HDR25_BMI_TABLEONE_GROUPED5_ADULT GROUP BY denom_year
