-- this code works to allocate LSOA2011, wimd2019 and rural_urban details for CYP the population, even those with no BMI reading.

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
FOR SAILW1151V.HDR25_BMI_CLEAN_CYP; -- our final BMI output.

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


------------------------------------------------
-- Section 2. Attaching demographic information to all ALFs in population yearly.
------------------------------------------------

CALL FNC.DROP_IF_EXISTS('SAILW1151V.HDR25_BMI_TABLEONE_GROUPED5_CYP'); 

CREATE TABLE SAILW1151V.HDR25_BMI_TABLEONE_GROUPED5_CYP
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
		percentile_bmi_cat		VARCHAR(20),
		source_db				VARCHAR(10),
-- from demographics
		wimd2019_quintile		VARCHAR(20),
		rural_urban				VARCHAR(200),
		lhb						VARCHAR(200)
);

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_GROUPED5_CYP
-- 2000-2004
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2000-2004. We select their most recent address in 2004, and attaches their most recent BMI record in 2004 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2004-12-31', wob)/365.25) AS age_years,
		CASE 
				WHEN age_band IS NOT NULL THEN age_band -- if they have the age_band from the bmi output, take that.
				-- allocating age band for individuals who do not have a BMI reading, using end of year and WOB.
				WHEN floor(DAYS_BETWEEN ('2004-12-31', wob)/30.44) BETWEEN 24 AND 60		THEN '02-05' -- between 2 and they turn 5 years old
				WHEN floor(DAYS_BETWEEN ('2004-12-31', wob)/30.44) BETWEEN 61 AND 228		THEN '05-19' -- between 5 and before they turn 19
				WHEN floor(DAYS_BETWEEN ('2004-12-31', wob)/30.44)	> 228					THEN 'over 19' -- there will be ALFs that turned 19 this year.
				ELSE NULL
				END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not CYP in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN percentile_bmi_cat IS NOT NULL THEN percentile_bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS percentile_bmi_cat,
		source_db
	FROM
	-- this is all the CYP population in 2004.
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
			WHERE denom_year IN ('2000', '2001', '2002', '2003', '2004') -- those that are living in Wales in this year
			AND cohort = 2 -- who are CYP at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this time period to remove duplicates. 
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
				percentile_bmi_cat,
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
	'2000-2004' AS denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	percentile_bmi_cat,
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

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_GROUPED5_CYP
-- 2005-2009
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2005-2009. We select their most recent address in 2009, and attaches their most recent BMI record in 2009 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2009-12-31', wob)/365.25) AS age_years,
		CASE 
				WHEN age_band IS NOT NULL THEN age_band -- if they have the age_band from the bmi output, take that.
				-- allocating age band for individuals who do not have a BMI reading, using end of year and WOB.
				WHEN floor(DAYS_BETWEEN ('2009-12-31', wob)/30.44) BETWEEN 24 AND 60		THEN '02-05' -- between 2 and they turn 5 years old
				WHEN floor(DAYS_BETWEEN ('2009-12-31', wob)/30.44) BETWEEN 61 AND 228		THEN '05-19' -- between 5 and before they turn 19
				WHEN floor(DAYS_BETWEEN ('2009-12-31', wob)/30.44)	> 228					THEN 'over 19' -- there will be ALFs that turned 19 this year.
				ELSE NULL
				END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not CYP in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN percentile_bmi_cat IS NOT NULL THEN percentile_bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS percentile_bmi_cat,
		source_db
	FROM
	-- this is all the CYP population in 2009.
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
			WHERE denom_year IN ('2005', '2006', '2007', '2008', '2009') -- those that are living in Wales in this year
			AND cohort = 2 -- who are CYP at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this time period to remove duplicates. 
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
				percentile_bmi_cat,
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
	'2005-2009' AS denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	percentile_bmi_cat,
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

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_GROUPED5_CYP
-- 2010-2014
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2010-2014. We select their most recent address in 2014, and attaches their most recent BMI record in 2014 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2014-12-31', wob)/365.25) AS age_years,
		CASE 
				WHEN age_band IS NOT NULL THEN age_band -- if they have the age_band from the bmi output, take that.
				-- allocating age band for individuals who do not have a BMI reading, using end of year and WOB.
				WHEN floor(DAYS_BETWEEN ('2014-12-31', wob)/30.44) BETWEEN 24 AND 60		THEN '02-05' -- between 2 and they turn 5 years old
				WHEN floor(DAYS_BETWEEN ('2014-12-31', wob)/30.44) BETWEEN 61 AND 228		THEN '05-19' -- between 5 and before they turn 19
				WHEN floor(DAYS_BETWEEN ('2014-12-31', wob)/30.44)	> 228					THEN 'over 19' -- there will be ALFs that turned 19 this year.
				ELSE NULL
				END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not CYP in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN percentile_bmi_cat IS NOT NULL THEN percentile_bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS percentile_bmi_cat,
		source_db
	FROM
	-- this is all the CYP population in 2014.
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
			WHERE denom_year IN ('2010', '2011', '2012', '2013', '2014') -- those that are living in Wales in this year
			AND cohort = 2 -- who are CYP at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this time period to remove duplicates. 
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
				percentile_bmi_cat,
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
	'2010-2014' AS denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	percentile_bmi_cat,
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

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_GROUPED5_CYP
-- 2015-2019
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2015-2019. We select their most recent address in 2019, and attaches their most recent BMI record in 2019 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2019-12-31', wob)/365.25) AS age_years,
		CASE 
				WHEN age_band IS NOT NULL THEN age_band -- if they have the age_band from the bmi output, take that.
				-- allocating age band for individuals who do not have a BMI reading, using end of year and WOB.
				WHEN floor(DAYS_BETWEEN ('2019-12-31', wob)/30.44) BETWEEN 24 AND 60		THEN '02-05' -- between 2 and they turn 5 years old
				WHEN floor(DAYS_BETWEEN ('2019-12-31', wob)/30.44) BETWEEN 61 AND 228		THEN '05-19' -- between 5 and before they turn 19
				WHEN floor(DAYS_BETWEEN ('2019-12-31', wob)/30.44)	> 228					THEN 'over 19' -- there will be ALFs that turned 19 this year.
				ELSE NULL
				END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not CYP in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN percentile_bmi_cat IS NOT NULL THEN percentile_bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS percentile_bmi_cat,
		source_db
	FROM
	-- this is all the CYP population in 2019.
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
			WHERE denom_year IN ('2015', '2016', '2017', '2018', '2019') -- those that are living in Wales in this year
			AND cohort = 2 -- who are CYP at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this time period to remove duplicates. 
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
				percentile_bmi_cat,
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
	'2015-2019' AS denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	percentile_bmi_cat,
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

INSERT INTO SAILW1151V.HDR25_BMI_TABLEONE_GROUPED5_CYP
-- 2020-2022
WITH t1 AS
-- this chunk extracts the distinct ALFs living in Wales in 2020-2022. We select their most recent address in 2022, and attaches their most recent BMI record in 2022 if they have one.
	(
	SELECT DISTINCT
	-- from the population cohort table
		a.alf_e,
		a.sex,
		a.wob,
		floor(DAYS_BETWEEN ('2022-12-31', wob)/365.25) AS age_years,
		CASE 
				WHEN age_band IS NOT NULL THEN age_band -- if they have the age_band from the bmi output, take that.
				-- allocating age band for individuals who do not have a BMI reading, using end of year and WOB.
				WHEN floor(DAYS_BETWEEN ('2022-12-31', wob)/30.44) BETWEEN 24 AND 60		THEN '02-05' -- between 2 and they turn 5 years old
				WHEN floor(DAYS_BETWEEN ('2022-12-31', wob)/30.44) BETWEEN 61 AND 228		THEN '05-19' -- between 5 and before they turn 19
				WHEN floor(DAYS_BETWEEN ('2022-12-31', wob)/30.44)	> 228					THEN 'over 19' -- there will be ALFs that turned 19 this year.
				ELSE NULL
				END AS age_band,
		a.dod,
		a.lsoa2011_cd						AS lsoa2011, -- the table for each yearly cohort; the NULLs will be for those ALFs who are not CYP in this cohort.
		a.start_date,
		a.end_date,
		a.denom_year,
	-- ethnicity table
		ethn_ec_ons_date_latest_desc 	AS ethnicity,
	-- from BMI output table
		bmi_dt,
 		CASE 
				WHEN percentile_bmi_cat IS NOT NULL THEN percentile_bmi_cat -- no BMI reading, allocate Unknown
				ELSE 'Unknown'
				END AS percentile_bmi_cat,
		source_db
	FROM
	-- this is all the CYP population in 2022.
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
			WHERE denom_year IN ('2020', '2021', '2022') -- those that are living in Wales in this year
			AND cohort = 2 -- who are CYP at some point this year. There will be some that would have turned 19.
			) 
		WHERE dt_order = 1 -- we select the most recent address for this time period to remove duplicates. 
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
				percentile_bmi_cat,
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
	'2020-2022' AS denom_year,
-- from BMI output table
	age_band,
	bmi_dt,
	percentile_bmi_cat,
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

SELECT denom_year, count(*)  FROM SAILW1151V.HDR25_BMI_TABLEONE_GROUPED5_CYP
GROUP BY de;