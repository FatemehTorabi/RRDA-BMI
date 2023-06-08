-- This code is the first step to creating TableOne. Here we get a monthly population denominator between 2000-2022.
-- 1. Find ALFs who lived in Wales for the particular month, e.g. Jan 2000.
-- 2. Allocate whether this ALF is an adult (1) or CYP (2) in that month.
-- 3. We only keep records that have a valid ALF, valid WOB, gndr_cd (1, 2), those who were alive on that month.
	-- NOTE: When an ALF dies within that month, they will not be included in that month, 
	-- e.g. if an ALF died on the 15th Feb, we will only collect information from them until 31 January.
	-- NOTE: Each month will have a different distinct alf count as there will be deaths/movement in and out of Wales.
-- this code is divided into yearly chunks (2000-2022) which creates a long table of all the individuals in Wales with their LSOA2011 information for each month-year.
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_POP_DENOM');

CREATE TABLE SAILW1151V.HDR25_BMI_POP_DENOM
(
	alf_e			BIGINT,
	sex				CHAR(1), -- gndr_cd (1 = Male, 2 = Female)
	wob				DATE, -- week of birth, used to categorise adult/cyp
	dod				DATE, -- date of death
	lsoa2011_cd		VARCHAR(20), -- this is needed to map out the wimd2019 and rural_urban details for TableOne.
	denom_year		CHAR(4), -- the year they are alive and in Wales.
	denom_month		CHAR(2), -- the month they are alive and in Wales.
	cohort			CHAR(1), -- adult (1) or CYP (2) for that month.
	start_date		DATE, -- start date of residency period
	end_date		DATE -- end date of residency period
);

INSERT INTO SAILW1151V.HDR25_BMI_POP_DENOM
-- 2000
WITH t1 AS -- table for Jan 2000
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2000' 	AS denom_year,
			'1' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2000-01-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2000-01-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2000-01-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2000-01-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2000-01-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2000-01-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t2 as -- Feb 2000
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2000' 	AS denom_year,
			'2' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2000-02-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2000-02-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2000-02-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2000-02-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2000-02-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2000-02-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t3 as -- March 2000
(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2000' 	AS denom_year,
			'3' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2000-03-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2000-03-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2000-03-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2000-03-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2000-03-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2000-03-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t4 as -- April 2000
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2000' 	AS denom_year,
			'4' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2000-04-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2000-04-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2000-04-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2000-04-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2000-04-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2000-04-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t5 as -- May 2000
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2000' 	AS denom_year,
			'5' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2000-05-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2000-05-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2000-05-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2000-05-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2000-05-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2000-05-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t6 as -- June 2000
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2000' 	AS denom_year,
			'6' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2000-06-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2000-06-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2000-06-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2000-06-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2000-06-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2000-06-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t7 as -- July 2000
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2000' 	AS denom_year,
			'7' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2000-07-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2000-07-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2000-07-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2000-07-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2000-07-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2000-07-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t8 as -- Aug 2000
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2000' 	AS denom_year,
			'8' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2000-08-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2000-08-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2000-08-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2000-08-01' -- those born before the 1st of each month
					AND wob IS NOT NULL) -- who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2000-08-01' -- and alive before 1st of each month
					OR a.death_dt IS NULL) -- or still alive until present
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' --  who live in Wales
				AND '2000-08-01' BETWEEN start_date AND end_date -- that have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t9 as -- Sept 2000
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2000' 	AS denom_year,
			'9' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2000-09-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2000-09-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2000-09-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2000-09-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2000-09-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2000-09-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t10 AS -- Oct 2000
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2000' 	AS denom_year,
			'10' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2000-10-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2000-10-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2000-10-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2000-10-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL)
				AND (c.death_dt > '2000-10-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2000-10-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t11 as -- Nov 2000
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2000' 	AS denom_year,
			'11' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2000-11-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2000-11-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2000-11-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2000-11-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2000-11-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2000-11-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t12 as -- Dec 2000
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2000' 	AS denom_year,
			'12' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2000-12-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2000-12-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2000-12-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2000-12-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2000-12-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2000-12-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
union_tables AS 
	(
	SELECT * FROM T1
	UNION ALL 
	SELECT * FROM T2
	UNION ALL
	SELECT * FROM T3
	UNION ALL
	SELECT * FROM T4
	UNION ALL
	SELECT * FROM T5
	UNION ALL
	SELECT * FROM T6
	UNION ALL
	SELECT * FROM T7
	UNION ALL
	SELECT * FROM T8
	UNION ALL
	SELECT * FROM T9
	UNION ALL
	SELECT * FROM T10
	UNION ALL
	SELECT * FROM T11
	UNION ALL
	SELECT * FROM T12
	)
SELECT alf_e, sex, wob, dod, lsoa2011_cd, denom_year, denom_month, cohort, start_date, end_date FROM union_tables;
-- this creates a long table of all ALFs

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_POP_DENOM
-- 2001
WITH t1 AS -- table for Jan 2001
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2001' 	AS denom_year,
			'1' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2001-01-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2001-01-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2001-01-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2001-01-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2001-01-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2001-01-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t2 as -- Feb 2001
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2001' 	AS denom_year,
			'2' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2001-02-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2001-02-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2001-02-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2001-02-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2001-02-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2001-02-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t3 as -- March 2001
(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2001' 	AS denom_year,
			'3' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2001-03-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2001-03-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2001-03-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2001-03-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2001-03-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2001-03-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t4 as -- April 2001
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2001' 	AS denom_year,
			'4' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2001-04-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2001-04-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2001-04-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2001-04-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2001-04-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2001-04-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t5 as -- May 2001
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2001' 	AS denom_year,
			'5' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2001-05-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2001-05-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2001-05-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2001-05-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2001-05-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2001-05-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t6 as -- June 2001
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2001' 	AS denom_year,
			'6' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2001-06-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2001-06-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2001-06-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2001-06-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2001-06-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2001-06-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t7 as -- July 2001
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2001' 	AS denom_year,
			'7' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2001-07-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2001-07-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2001-07-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2001-07-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2001-07-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2001-07-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t8 as -- Aug 2001
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2001' 	AS denom_year,
			'8' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2001-08-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2001-08-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2001-08-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2001-08-01' -- those born before the 1st of each month
					AND wob IS NOT NULL) -- who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2001-08-01' -- and alive before 1st of each month
					OR a.death_dt IS NULL) -- or still alive until present
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' --  who live in Wales
				AND '2001-08-01' BETWEEN start_date AND end_date -- that have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t9 as -- Sept 2001
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2001' 	AS denom_year,
			'9' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2001-09-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2001-09-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2001-09-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2001-09-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2001-09-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2001-09-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t10 AS -- Oct 2001
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2001' 	AS denom_year,
			'10' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2001-10-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2001-10-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2001-10-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2001-10-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL)
				AND (c.death_dt > '2001-10-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2001-10-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t11 as -- Nov 2001
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2001' 	AS denom_year,
			'11' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2001-11-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2001-11-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2001-11-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2001-11-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2001-11-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2001-11-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t12 as -- Dec 2001
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2001' 	AS denom_year,
			'12' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2001-12-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2001-12-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2001-12-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2001-12-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2001-12-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2001-12-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
union_tables AS 
	(
	SELECT * FROM T1
	UNION ALL 
	SELECT * FROM T2
	UNION ALL
	SELECT * FROM T3
	UNION ALL
	SELECT * FROM T4
	UNION ALL
	SELECT * FROM T5
	UNION ALL
	SELECT * FROM T6
	UNION ALL
	SELECT * FROM T7
	UNION ALL
	SELECT * FROM T8
	UNION ALL
	SELECT * FROM T9
	UNION ALL
	SELECT * FROM T10
	UNION ALL
	SELECT * FROM T11
	UNION ALL
	SELECT * FROM T12
	)
SELECT alf_e, sex, wob, dod, lsoa2011_cd, denom_year, denom_month, cohort, start_date, end_date FROM union_tables;
-- this creates a long table of all ALFs

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_POP_DENOM
-- 2002
WITH t1 AS -- table for Jan 2002
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2002' 	AS denom_year,
			'1' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2002-01-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2002-01-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2002-01-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2002-01-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2002-01-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2002-01-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t2 as -- Feb 2002
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2002' 	AS denom_year,
			'2' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2002-02-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2002-02-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2002-02-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2002-02-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2002-02-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2002-02-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t3 as -- March 2002
(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2002' 	AS denom_year,
			'3' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2002-03-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2002-03-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2002-03-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2002-03-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2002-03-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2002-03-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t4 as -- April 2002
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2002' 	AS denom_year,
			'4' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2002-04-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2002-04-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2002-04-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2002-04-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2002-04-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2002-04-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t5 as -- May 2002
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2002' 	AS denom_year,
			'5' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2002-05-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2002-05-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2002-05-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2002-05-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2002-05-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2002-05-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t6 as -- June 2002
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2002' 	AS denom_year,
			'6' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2002-06-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2002-06-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2002-06-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2002-06-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2002-06-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2002-06-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t7 as -- July 2002
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2002' 	AS denom_year,
			'7' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2002-07-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2002-07-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2002-07-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2002-07-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2002-07-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2002-07-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t8 as -- Aug 2002
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2002' 	AS denom_year,
			'8' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2002-08-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2002-08-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2002-08-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2002-08-01' -- those born before the 1st of each month
					AND wob IS NOT NULL) -- who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2002-08-01' -- and alive before 1st of each month
					OR a.death_dt IS NULL) -- or still alive until present
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' --  who live in Wales
				AND '2002-08-01' BETWEEN start_date AND end_date -- that have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t9 as -- Sept 2002
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2002' 	AS denom_year,
			'9' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2002-09-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2002-09-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2002-09-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2002-09-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2002-09-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2002-09-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t10 AS -- Oct 2002
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2002' 	AS denom_year,
			'10' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2002-10-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2002-10-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2002-10-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2002-10-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL)
				AND (c.death_dt > '2002-10-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2002-10-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t11 as -- Nov 2002
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2002' 	AS denom_year,
			'11' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2002-11-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2002-11-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2002-11-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2002-11-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2002-11-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2002-11-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t12 as -- Dec 2002
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2002' 	AS denom_year,
			'12' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2002-12-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2002-12-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2002-12-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2002-12-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2002-12-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2002-12-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
union_tables AS 
	(
	SELECT * FROM T1
	UNION ALL 
	SELECT * FROM T2
	UNION ALL
	SELECT * FROM T3
	UNION ALL
	SELECT * FROM T4
	UNION ALL
	SELECT * FROM T5
	UNION ALL
	SELECT * FROM T6
	UNION ALL
	SELECT * FROM T7
	UNION ALL
	SELECT * FROM T8
	UNION ALL
	SELECT * FROM T9
	UNION ALL
	SELECT * FROM T10
	UNION ALL
	SELECT * FROM T11
	UNION ALL
	SELECT * FROM T12
	)
SELECT alf_e, sex, wob, dod, lsoa2011_cd, denom_year, denom_month, cohort, start_date, end_date FROM union_tables;
-- this creates a long table of all ALFs

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_POP_DENOM
-- 2003
WITH t1 AS -- table for Jan 2003
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2003' 	AS denom_year,
			'1' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2003-01-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2003-01-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2003-01-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2003-01-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2003-01-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2003-01-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t2 as -- Feb 2003
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2003' 	AS denom_year,
			'2' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2003-02-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2003-02-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2003-02-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2003-02-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2003-02-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2003-02-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t3 as -- March 2003
(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2003' 	AS denom_year,
			'3' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2003-03-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2003-03-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2003-03-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2003-03-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2003-03-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2003-03-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t4 as -- April 2003
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2003' 	AS denom_year,
			'4' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2003-04-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2003-04-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2003-04-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2003-04-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2003-04-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2003-04-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t5 as -- May 2003
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2003' 	AS denom_year,
			'5' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2003-05-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2003-05-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2003-05-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2003-05-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2003-05-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2003-05-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t6 as -- June 2003
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2003' 	AS denom_year,
			'6' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2003-06-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2003-06-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2003-06-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2003-06-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2003-06-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2003-06-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t7 as -- July 2003
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2003' 	AS denom_year,
			'7' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2003-07-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2003-07-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2003-07-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2003-07-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2003-07-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2003-07-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t8 as -- Aug 2003
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2003' 	AS denom_year,
			'8' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2003-08-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2003-08-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2003-08-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2003-08-01' -- those born before the 1st of each month
					AND wob IS NOT NULL) -- who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2003-08-01' -- and alive before 1st of each month
					OR a.death_dt IS NULL) -- or still alive until present
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' --  who live in Wales
				AND '2003-08-01' BETWEEN start_date AND end_date -- that have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t9 as -- Sept 2003
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2003' 	AS denom_year,
			'9' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2003-09-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2003-09-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2003-09-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2003-09-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2003-09-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2003-09-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t10 AS -- Oct 2003
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2003' 	AS denom_year,
			'10' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2003-10-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2003-10-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2003-10-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2003-10-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL)
				AND (c.death_dt > '2003-10-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2003-10-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t11 as -- Nov 2003
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2003' 	AS denom_year,
			'11' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2003-11-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2003-11-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2003-11-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2003-11-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2003-11-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2003-11-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t12 as -- Dec 2003
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2003' 	AS denom_year,
			'12' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2003-12-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2003-12-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2003-12-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2003-12-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2003-12-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2003-12-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
union_tables AS 
	(
	SELECT * FROM T1
	UNION ALL 
	SELECT * FROM T2
	UNION ALL
	SELECT * FROM T3
	UNION ALL
	SELECT * FROM T4
	UNION ALL
	SELECT * FROM T5
	UNION ALL
	SELECT * FROM T6
	UNION ALL
	SELECT * FROM T7
	UNION ALL
	SELECT * FROM T8
	UNION ALL
	SELECT * FROM T9
	UNION ALL
	SELECT * FROM T10
	UNION ALL
	SELECT * FROM T11
	UNION ALL
	SELECT * FROM T12
	)
SELECT alf_e, sex, wob, dod, lsoa2011_cd, denom_year, denom_month, cohort, start_date, end_date FROM union_tables;
-- this creates a long table of all ALFs

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_POP_DENOM
-- 2004
WITH t1 AS -- table for Jan 2004
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2004' 	AS denom_year,
			'1' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2004-01-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2004-01-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2004-01-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2004-01-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2004-01-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2004-01-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t2 as -- Feb 2004
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2004' 	AS denom_year,
			'2' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2004-02-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2004-02-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2004-02-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2004-02-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2004-02-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2004-02-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t3 as -- March 2004
(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2004' 	AS denom_year,
			'3' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2004-03-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2004-03-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2004-03-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2004-03-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2004-03-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2004-03-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t4 as -- April 2004
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2004' 	AS denom_year,
			'4' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2004-04-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2004-04-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2004-04-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2004-04-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2004-04-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2004-04-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t5 as -- May 2004
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2004' 	AS denom_year,
			'5' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2004-05-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2004-05-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2004-05-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2004-05-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2004-05-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2004-05-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t6 as -- June 2004
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2004' 	AS denom_year,
			'6' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2004-06-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2004-06-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2004-06-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2004-06-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2004-06-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2004-06-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t7 as -- July 2004
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2004' 	AS denom_year,
			'7' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2004-07-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2004-07-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2004-07-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2004-07-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2004-07-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2004-07-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t8 as -- Aug 2004
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2004' 	AS denom_year,
			'8' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2004-08-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2004-08-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2004-08-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2004-08-01' -- those born before the 1st of each month
					AND wob IS NOT NULL) -- who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2004-08-01' -- and alive before 1st of each month
					OR a.death_dt IS NULL) -- or still alive until present
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' --  who live in Wales
				AND '2004-08-01' BETWEEN start_date AND end_date -- that have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t9 as -- Sept 2004
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2004' 	AS denom_year,
			'9' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2004-09-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2004-09-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2004-09-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2004-09-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2004-09-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2004-09-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t10 AS -- Oct 2004
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2004' 	AS denom_year,
			'10' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2004-10-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2004-10-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2004-10-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2004-10-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL)
				AND (c.death_dt > '2004-10-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2004-10-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t11 as -- Nov 2004
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2004' 	AS denom_year,
			'11' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2004-11-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2004-11-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2004-11-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2004-11-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2004-11-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2004-11-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t12 as -- Dec 2004
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2004' 	AS denom_year,
			'12' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2004-12-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2004-12-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2004-12-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2004-12-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2004-12-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2004-12-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
union_tables AS 
	(
	SELECT * FROM T1
	UNION ALL 
	SELECT * FROM T2
	UNION ALL
	SELECT * FROM T3
	UNION ALL
	SELECT * FROM T4
	UNION ALL
	SELECT * FROM T5
	UNION ALL
	SELECT * FROM T6
	UNION ALL
	SELECT * FROM T7
	UNION ALL
	SELECT * FROM T8
	UNION ALL
	SELECT * FROM T9
	UNION ALL
	SELECT * FROM T10
	UNION ALL
	SELECT * FROM T11
	UNION ALL
	SELECT * FROM T12
	)
SELECT alf_e, sex, wob, dod, lsoa2011_cd, denom_year, denom_month, cohort, start_date, end_date FROM union_tables;
-- this creates a long table of all ALFs

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_POP_DENOM
-- 2005
WITH t1 AS -- table for Jan 2005
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2005' 	AS denom_year,
			'1' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2005-01-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2005-01-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2005-01-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2005-01-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2005-01-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2005-01-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t2 as -- Feb 2005
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2005' 	AS denom_year,
			'2' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2005-02-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2005-02-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2005-02-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2005-02-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2005-02-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2005-02-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t3 as -- March 2005
(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2005' 	AS denom_year,
			'3' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2005-03-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2005-03-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2005-03-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2005-03-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2005-03-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2005-03-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t4 as -- April 2005
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2005' 	AS denom_year,
			'4' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2005-04-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2005-04-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2005-04-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2005-04-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2005-04-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2005-04-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t5 as -- May 2005
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2005' 	AS denom_year,
			'5' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2005-05-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2005-05-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2005-05-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2005-05-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2005-05-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2005-05-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t6 as -- June 2005
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2005' 	AS denom_year,
			'6' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2005-06-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2005-06-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2005-06-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2005-06-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2005-06-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2005-06-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t7 as -- July 2005
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2005' 	AS denom_year,
			'7' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2005-07-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2005-07-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2005-07-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2005-07-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2005-07-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2005-07-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t8 as -- Aug 2005
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2005' 	AS denom_year,
			'8' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2005-08-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2005-08-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2005-08-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2005-08-01' -- those born before the 1st of each month
					AND wob IS NOT NULL) -- who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2005-08-01' -- and alive before 1st of each month
					OR a.death_dt IS NULL) -- or still alive until present
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' --  who live in Wales
				AND '2005-08-01' BETWEEN start_date AND end_date -- that have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t9 as -- Sept 2005
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2005' 	AS denom_year,
			'9' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2005-09-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2005-09-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2005-09-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2005-09-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2005-09-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2005-09-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t10 AS -- Oct 2005
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2005' 	AS denom_year,
			'10' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2005-10-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2005-10-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2005-10-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2005-10-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL)
				AND (c.death_dt > '2005-10-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2005-10-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t11 as -- Nov 2005
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2005' 	AS denom_year,
			'11' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2005-11-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2005-11-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2005-11-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2005-11-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2005-11-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2005-11-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t12 as -- Dec 2005
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2005' 	AS denom_year,
			'12' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2005-12-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2005-12-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2005-12-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2005-12-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2005-12-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2005-12-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
union_tables AS 
	(
	SELECT * FROM T1
	UNION ALL 
	SELECT * FROM T2
	UNION ALL
	SELECT * FROM T3
	UNION ALL
	SELECT * FROM T4
	UNION ALL
	SELECT * FROM T5
	UNION ALL
	SELECT * FROM T6
	UNION ALL
	SELECT * FROM T7
	UNION ALL
	SELECT * FROM T8
	UNION ALL
	SELECT * FROM T9
	UNION ALL
	SELECT * FROM T10
	UNION ALL
	SELECT * FROM T11
	UNION ALL
	SELECT * FROM T12
	)
SELECT alf_e, sex, wob, dod, lsoa2011_cd, denom_year, denom_month, cohort, start_date, end_date FROM union_tables;
-- this creates a long table of all ALFs

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_POP_DENOM
-- 2006
WITH t1 AS -- table for Jan 2006
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2006' 	AS denom_year,
			'1' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2006-01-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2006-01-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2006-01-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2006-01-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2006-01-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2006-01-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t2 as -- Feb 2006
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2006' 	AS denom_year,
			'2' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2006-02-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2006-02-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2006-02-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2006-02-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2006-02-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2006-02-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t3 as -- March 2006
(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2006' 	AS denom_year,
			'3' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2006-03-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2006-03-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2006-03-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2006-03-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2006-03-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2006-03-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t4 as -- April 2006
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2006' 	AS denom_year,
			'4' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2006-04-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2006-04-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2006-04-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2006-04-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2006-04-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2006-04-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t5 as -- May 2006
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2006' 	AS denom_year,
			'5' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2006-05-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2006-05-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2006-05-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2006-05-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2006-05-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2006-05-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t6 as -- June 2006
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2006' 	AS denom_year,
			'6' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2006-06-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2006-06-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2006-06-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2006-06-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2006-06-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2006-06-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t7 as -- July 2006
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2006' 	AS denom_year,
			'7' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2006-07-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2006-07-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2006-07-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2006-07-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2006-07-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2006-07-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t8 as -- Aug 2006
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2006' 	AS denom_year,
			'8' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2006-08-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2006-08-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2006-08-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2006-08-01' -- those born before the 1st of each month
					AND wob IS NOT NULL) -- who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2006-08-01' -- and alive before 1st of each month
					OR a.death_dt IS NULL) -- or still alive until present
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' --  who live in Wales
				AND '2006-08-01' BETWEEN start_date AND end_date -- that have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t9 as -- Sept 2006
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2006' 	AS denom_year,
			'9' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2006-09-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2006-09-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2006-09-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2006-09-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2006-09-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2006-09-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t10 AS -- Oct 2006
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2006' 	AS denom_year,
			'10' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2006-10-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2006-10-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2006-10-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2006-10-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL)
				AND (c.death_dt > '2006-10-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2006-10-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t11 as -- Nov 2006
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2006' 	AS denom_year,
			'11' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2006-11-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2006-11-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2006-11-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2006-11-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2006-11-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2006-11-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t12 as -- Dec 2006
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2006' 	AS denom_year,
			'12' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2006-12-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2006-12-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2006-12-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2006-12-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2006-12-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2006-12-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
union_tables AS 
	(
	SELECT * FROM T1
	UNION ALL 
	SELECT * FROM T2
	UNION ALL
	SELECT * FROM T3
	UNION ALL
	SELECT * FROM T4
	UNION ALL
	SELECT * FROM T5
	UNION ALL
	SELECT * FROM T6
	UNION ALL
	SELECT * FROM T7
	UNION ALL
	SELECT * FROM T8
	UNION ALL
	SELECT * FROM T9
	UNION ALL
	SELECT * FROM T10
	UNION ALL
	SELECT * FROM T11
	UNION ALL
	SELECT * FROM T12
	)
SELECT alf_e, sex, wob, dod, lsoa2011_cd, denom_year, denom_month, cohort, start_date, end_date FROM union_tables;
-- this creates a long table of all ALFs

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_POP_DENOM
-- 2007
WITH t1 AS -- table for Jan 2007
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2007' 	AS denom_year,
			'1' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2007-01-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2007-01-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2007-01-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2007-01-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2007-01-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2007-01-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t2 as -- Feb 2007
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2007' 	AS denom_year,
			'2' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2007-02-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2007-02-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2007-02-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2007-02-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2007-02-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2007-02-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t3 as -- March 2007
(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2007' 	AS denom_year,
			'3' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2007-03-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2007-03-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2007-03-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2007-03-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2007-03-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2007-03-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t4 as -- April 2007
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2007' 	AS denom_year,
			'4' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2007-04-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2007-04-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2007-04-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2007-04-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2007-04-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2007-04-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t5 as -- May 2007
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2007' 	AS denom_year,
			'5' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2007-05-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2007-05-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2007-05-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2007-05-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2007-05-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2007-05-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t6 as -- June 2007
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2007' 	AS denom_year,
			'6' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2007-06-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2007-06-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2007-06-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2007-06-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2007-06-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2007-06-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t7 as -- July 2007
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2007' 	AS denom_year,
			'7' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2007-07-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2007-07-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2007-07-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2007-07-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2007-07-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2007-07-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t8 as -- Aug 2007
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2007' 	AS denom_year,
			'8' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2007-08-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2007-08-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2007-08-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2007-08-01' -- those born before the 1st of each month
					AND wob IS NOT NULL) -- who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2007-08-01' -- and alive before 1st of each month
					OR a.death_dt IS NULL) -- or still alive until present
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' --  who live in Wales
				AND '2007-08-01' BETWEEN start_date AND end_date -- that have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t9 as -- Sept 2007
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2007' 	AS denom_year,
			'9' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2007-09-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2007-09-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2007-09-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2007-09-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2007-09-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2007-09-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t10 AS -- Oct 2007
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2007' 	AS denom_year,
			'10' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2007-10-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2007-10-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2007-10-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2007-10-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL)
				AND (c.death_dt > '2007-10-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2007-10-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t11 as -- Nov 2007
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2007' 	AS denom_year,
			'11' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2007-11-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2007-11-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2007-11-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2007-11-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2007-11-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2007-11-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t12 as -- Dec 2007
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2007' 	AS denom_year,
			'12' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2007-12-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2007-12-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2007-12-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2007-12-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2007-12-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2007-12-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
union_tables AS 
	(
	SELECT * FROM T1
	UNION ALL 
	SELECT * FROM T2
	UNION ALL
	SELECT * FROM T3
	UNION ALL
	SELECT * FROM T4
	UNION ALL
	SELECT * FROM T5
	UNION ALL
	SELECT * FROM T6
	UNION ALL
	SELECT * FROM T7
	UNION ALL
	SELECT * FROM T8
	UNION ALL
	SELECT * FROM T9
	UNION ALL
	SELECT * FROM T10
	UNION ALL
	SELECT * FROM T11
	UNION ALL
	SELECT * FROM T12
	)
SELECT alf_e, sex, wob, dod, lsoa2011_cd, denom_year, denom_month, cohort, start_date, end_date FROM union_tables;
-- this creates a long table of all ALFs

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_POP_DENOM
-- 2008
WITH t1 AS -- table for Jan 2008
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2008' 	AS denom_year,
			'1' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2008-01-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2008-01-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2008-01-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2008-01-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2008-01-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2008-01-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t2 as -- Feb 2008
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2008' 	AS denom_year,
			'2' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2008-02-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2008-02-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2008-02-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2008-02-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2008-02-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2008-02-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t3 as -- March 2008
(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2008' 	AS denom_year,
			'3' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2008-03-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2008-03-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2008-03-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2008-03-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2008-03-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2008-03-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t4 as -- April 2008
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2008' 	AS denom_year,
			'4' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2008-04-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2008-04-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2008-04-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2008-04-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2008-04-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2008-04-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t5 as -- May 2008
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2008' 	AS denom_year,
			'5' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2008-05-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2008-05-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2008-05-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2008-05-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2008-05-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2008-05-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t6 as -- June 2008
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2008' 	AS denom_year,
			'6' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2008-06-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2008-06-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2008-06-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2008-06-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2008-06-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2008-06-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t7 as -- July 2008
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2008' 	AS denom_year,
			'7' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2008-07-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2008-07-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2008-07-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2008-07-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2008-07-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2008-07-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t8 as -- Aug 2008
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2008' 	AS denom_year,
			'8' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2008-08-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2008-08-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2008-08-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2008-08-01' -- those born before the 1st of each month
					AND wob IS NOT NULL) -- who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2008-08-01' -- and alive before 1st of each month
					OR a.death_dt IS NULL) -- or still alive until present
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' --  who live in Wales
				AND '2008-08-01' BETWEEN start_date AND end_date -- that have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t9 as -- Sept 2008
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2008' 	AS denom_year,
			'9' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2008-09-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2008-09-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2008-09-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2008-09-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2008-09-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2008-09-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t10 AS -- Oct 2008
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2008' 	AS denom_year,
			'10' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2008-10-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2008-10-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2008-10-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2008-10-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL)
				AND (c.death_dt > '2008-10-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2008-10-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t11 as -- Nov 2008
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2008' 	AS denom_year,
			'11' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2008-11-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2008-11-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2008-11-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2008-11-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2008-11-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2008-11-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t12 as -- Dec 2008
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2008' 	AS denom_year,
			'12' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2008-12-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2008-12-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2008-12-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2008-12-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2008-12-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2008-12-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
union_tables AS 
	(
	SELECT * FROM T1
	UNION ALL 
	SELECT * FROM T2
	UNION ALL
	SELECT * FROM T3
	UNION ALL
	SELECT * FROM T4
	UNION ALL
	SELECT * FROM T5
	UNION ALL
	SELECT * FROM T6
	UNION ALL
	SELECT * FROM T7
	UNION ALL
	SELECT * FROM T8
	UNION ALL
	SELECT * FROM T9
	UNION ALL
	SELECT * FROM T10
	UNION ALL
	SELECT * FROM T11
	UNION ALL
	SELECT * FROM T12
	)
SELECT alf_e, sex, wob, dod, lsoa2011_cd, denom_year, denom_month, cohort, start_date, end_date FROM union_tables;
-- this creates a long table of all ALFs

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_POP_DENOM
-- 2009
WITH t1 AS -- table for Jan 2009
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2009' 	AS denom_year,
			'1' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2009-01-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2009-01-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2009-01-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2009-01-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2009-01-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2009-01-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t2 as -- Feb 2009
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2009' 	AS denom_year,
			'2' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2009-02-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2009-02-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2009-02-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2009-02-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2009-02-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2009-02-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t3 as -- March 2009
(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2009' 	AS denom_year,
			'3' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2009-03-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2009-03-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2009-03-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2009-03-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2009-03-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2009-03-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t4 as -- April 2009
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2009' 	AS denom_year,
			'4' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2009-04-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2009-04-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2009-04-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2009-04-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2009-04-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2009-04-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t5 as -- May 2009
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2009' 	AS denom_year,
			'5' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2009-05-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2009-05-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2009-05-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2009-05-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2009-05-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2009-05-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t6 as -- June 2009
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2009' 	AS denom_year,
			'6' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2009-06-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2009-06-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2009-06-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2009-06-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2009-06-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2009-06-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t7 as -- July 2009
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2009' 	AS denom_year,
			'7' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2009-07-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2009-07-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2009-07-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2009-07-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2009-07-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2009-07-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t8 as -- Aug 2009
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2009' 	AS denom_year,
			'8' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2009-08-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2009-08-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2009-08-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2009-08-01' -- those born before the 1st of each month
					AND wob IS NOT NULL) -- who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2009-08-01' -- and alive before 1st of each month
					OR a.death_dt IS NULL) -- or still alive until present
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' --  who live in Wales
				AND '2009-08-01' BETWEEN start_date AND end_date -- that have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t9 as -- Sept 2009
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2009' 	AS denom_year,
			'9' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2009-09-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2009-09-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2009-09-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2009-09-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2009-09-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2009-09-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t10 AS -- Oct 2009
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2009' 	AS denom_year,
			'10' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2009-10-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2009-10-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2009-10-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2009-10-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL)
				AND (c.death_dt > '2009-10-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2009-10-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t11 as -- Nov 2009
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2009' 	AS denom_year,
			'11' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2009-11-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2009-11-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2009-11-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2009-11-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2009-11-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2009-11-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t12 as -- Dec 2009
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2009' 	AS denom_year,
			'12' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2009-12-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2009-12-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2009-12-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2009-12-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2009-12-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2009-12-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
union_tables AS 
	(
	SELECT * FROM T1
	UNION ALL 
	SELECT * FROM T2
	UNION ALL
	SELECT * FROM T3
	UNION ALL
	SELECT * FROM T4
	UNION ALL
	SELECT * FROM T5
	UNION ALL
	SELECT * FROM T6
	UNION ALL
	SELECT * FROM T7
	UNION ALL
	SELECT * FROM T8
	UNION ALL
	SELECT * FROM T9
	UNION ALL
	SELECT * FROM T10
	UNION ALL
	SELECT * FROM T11
	UNION ALL
	SELECT * FROM T12
	)
SELECT alf_e, sex, wob, dod, lsoa2011_cd, denom_year, denom_month, cohort, start_date, end_date FROM union_tables;
-- this creates a long table of all ALFs

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_POP_DENOM
-- 2010
WITH t1 AS -- table for Jan 2010
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2010' 	AS denom_year,
			'1' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2010-01-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2010-01-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2010-01-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2010-01-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2010-01-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2010-01-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t2 as -- Feb 2010
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2010' 	AS denom_year,
			'2' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2010-02-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2010-02-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2010-02-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2010-02-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2010-02-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2010-02-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t3 as -- March 2010
(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2010' 	AS denom_year,
			'3' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2010-03-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2010-03-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2010-03-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2010-03-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2010-03-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2010-03-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t4 as -- April 2010
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2010' 	AS denom_year,
			'4' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2010-04-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2010-04-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2010-04-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2010-04-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2010-04-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2010-04-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t5 as -- May 2010
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2010' 	AS denom_year,
			'5' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2010-05-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2010-05-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2010-05-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2010-05-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2010-05-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2010-05-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t6 as -- June 2010
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2010' 	AS denom_year,
			'6' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2010-06-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2010-06-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2010-06-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2010-06-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2010-06-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2010-06-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t7 as -- July 2010
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2010' 	AS denom_year,
			'7' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2010-07-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2010-07-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2010-07-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2010-07-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2010-07-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2010-07-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t8 as -- Aug 2010
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2010' 	AS denom_year,
			'8' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2010-08-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2010-08-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2010-08-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2010-08-01' -- those born before the 1st of each month
					AND wob IS NOT NULL) -- who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2010-08-01' -- and alive before 1st of each month
					OR a.death_dt IS NULL) -- or still alive until present
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' --  who live in Wales
				AND '2010-08-01' BETWEEN start_date AND end_date -- that have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t9 as -- Sept 2010
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2010' 	AS denom_year,
			'9' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2010-09-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2010-09-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2010-09-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2010-09-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2010-09-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2010-09-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t10 AS -- Oct 2010
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2010' 	AS denom_year,
			'10' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2010-10-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2010-10-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2010-10-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2010-10-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL)
				AND (c.death_dt > '2010-10-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2010-10-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t11 as -- Nov 2010
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2010' 	AS denom_year,
			'11' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2010-11-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2010-11-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2010-11-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2010-11-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2010-11-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2010-11-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t12 as -- Dec 2010
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2010' 	AS denom_year,
			'12' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2010-12-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2010-12-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2010-12-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2010-12-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2010-12-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2010-12-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
union_tables AS 
	(
	SELECT * FROM T1
	UNION ALL 
	SELECT * FROM T2
	UNION ALL
	SELECT * FROM T3
	UNION ALL
	SELECT * FROM T4
	UNION ALL
	SELECT * FROM T5
	UNION ALL
	SELECT * FROM T6
	UNION ALL
	SELECT * FROM T7
	UNION ALL
	SELECT * FROM T8
	UNION ALL
	SELECT * FROM T9
	UNION ALL
	SELECT * FROM T10
	UNION ALL
	SELECT * FROM T11
	UNION ALL
	SELECT * FROM T12
	)
SELECT alf_e, sex, wob, dod, lsoa2011_cd, denom_year, denom_month, cohort, start_date, end_date FROM union_tables;
-- this creates a long table of all ALFs

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_POP_DENOM
-- 2011
WITH t1 AS -- table for Jan 2011
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2011' 	AS denom_year,
			'1' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2011-01-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2011-01-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2011-01-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2011-01-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2011-01-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2011-01-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t2 as -- Feb 2011
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2011' 	AS denom_year,
			'2' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2011-02-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2011-02-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2011-02-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2011-02-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2011-02-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2011-02-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t3 as -- March 2011
(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2011' 	AS denom_year,
			'3' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2011-03-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2011-03-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2011-03-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2011-03-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2011-03-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2011-03-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t4 as -- April 2011
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2011' 	AS denom_year,
			'4' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2011-04-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2011-04-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2011-04-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2011-04-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2011-04-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2011-04-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t5 as -- May 2011
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2011' 	AS denom_year,
			'5' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2011-05-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2011-05-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2011-05-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2011-05-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2011-05-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2011-05-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t6 as -- June 2011
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2011' 	AS denom_year,
			'6' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2011-06-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2011-06-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2011-06-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2011-06-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2011-06-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2011-06-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t7 as -- July 2011
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2011' 	AS denom_year,
			'7' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2011-07-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2011-07-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2011-07-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2011-07-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2011-07-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2011-07-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t8 as -- Aug 2011
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2011' 	AS denom_year,
			'8' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2011-08-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2011-08-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2011-08-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2011-08-01' -- those born before the 1st of each month
					AND wob IS NOT NULL) -- who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2011-08-01' -- and alive before 1st of each month
					OR a.death_dt IS NULL) -- or still alive until present
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' --  who live in Wales
				AND '2011-08-01' BETWEEN start_date AND end_date -- that have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t9 as -- Sept 2011
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2011' 	AS denom_year,
			'9' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2011-09-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2011-09-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2011-09-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2011-09-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2011-09-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2011-09-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t10 AS -- Oct 2011
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2011' 	AS denom_year,
			'10' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2011-10-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2011-10-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2011-10-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2011-10-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL)
				AND (c.death_dt > '2011-10-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2011-10-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t11 as -- Nov 2011
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2011' 	AS denom_year,
			'11' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2011-11-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2011-11-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2011-11-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2011-11-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2011-11-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2011-11-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t12 as -- Dec 2011
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2011' 	AS denom_year,
			'12' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2011-12-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2011-12-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2011-12-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2011-12-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2011-12-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2011-12-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
union_tables AS 
	(
	SELECT * FROM T1
	UNION ALL 
	SELECT * FROM T2
	UNION ALL
	SELECT * FROM T3
	UNION ALL
	SELECT * FROM T4
	UNION ALL
	SELECT * FROM T5
	UNION ALL
	SELECT * FROM T6
	UNION ALL
	SELECT * FROM T7
	UNION ALL
	SELECT * FROM T8
	UNION ALL
	SELECT * FROM T9
	UNION ALL
	SELECT * FROM T10
	UNION ALL
	SELECT * FROM T11
	UNION ALL
	SELECT * FROM T12
	)
SELECT alf_e, sex, wob, dod, lsoa2011_cd, denom_year, denom_month, cohort, start_date, end_date FROM union_tables;
-- this creates a long table of all ALFs

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_POP_DENOM
-- 2012
WITH t1 AS -- table for Jan 2012
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2012' 	AS denom_year,
			'1' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2012-01-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2012-01-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2012-01-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2012-01-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2012-01-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2012-01-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t2 as -- Feb 2012
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2012' 	AS denom_year,
			'2' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2012-02-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2012-02-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2012-02-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2012-02-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2012-02-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2012-02-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t3 as -- March 2012
(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2012' 	AS denom_year,
			'3' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2012-03-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2012-03-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2012-03-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2012-03-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2012-03-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2012-03-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t4 as -- April 2012
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2012' 	AS denom_year,
			'4' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2012-04-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2012-04-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2012-04-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2012-04-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2012-04-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2012-04-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t5 as -- May 2012
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2012' 	AS denom_year,
			'5' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2012-05-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2012-05-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2012-05-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2012-05-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2012-05-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2012-05-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t6 as -- June 2012
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2012' 	AS denom_year,
			'6' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2012-06-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2012-06-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2012-06-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2012-06-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2012-06-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2012-06-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t7 as -- July 2012
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2012' 	AS denom_year,
			'7' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2012-07-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2012-07-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2012-07-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2012-07-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2012-07-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2012-07-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t8 as -- Aug 2012
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2012' 	AS denom_year,
			'8' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2012-08-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2012-08-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2012-08-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2012-08-01' -- those born before the 1st of each month
					AND wob IS NOT NULL) -- who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2012-08-01' -- and alive before 1st of each month
					OR a.death_dt IS NULL) -- or still alive until present
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' --  who live in Wales
				AND '2012-08-01' BETWEEN start_date AND end_date -- that have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t9 as -- Sept 2012
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2012' 	AS denom_year,
			'9' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2012-09-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2012-09-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2012-09-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2012-09-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2012-09-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2012-09-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t10 AS -- Oct 2012
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2012' 	AS denom_year,
			'10' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2012-10-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2012-10-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2012-10-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2012-10-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL)
				AND (c.death_dt > '2012-10-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2012-10-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t11 as -- Nov 2012
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2012' 	AS denom_year,
			'11' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2012-11-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2012-11-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2012-11-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2012-11-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2012-11-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2012-11-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t12 as -- Dec 2012
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2012' 	AS denom_year,
			'12' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2012-12-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2012-12-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2012-12-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2012-12-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2012-12-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2012-12-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
union_tables AS 
	(
	SELECT * FROM T1
	UNION ALL 
	SELECT * FROM T2
	UNION ALL
	SELECT * FROM T3
	UNION ALL
	SELECT * FROM T4
	UNION ALL
	SELECT * FROM T5
	UNION ALL
	SELECT * FROM T6
	UNION ALL
	SELECT * FROM T7
	UNION ALL
	SELECT * FROM T8
	UNION ALL
	SELECT * FROM T9
	UNION ALL
	SELECT * FROM T10
	UNION ALL
	SELECT * FROM T11
	UNION ALL
	SELECT * FROM T12
	)
SELECT alf_e, sex, wob, dod, lsoa2011_cd, denom_year, denom_month, cohort, start_date, end_date FROM union_tables;
-- this creates a long table of all ALFs

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_POP_DENOM
-- 2013
WITH t1 AS -- table for Jan 2013
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2013' 	AS denom_year,
			'1' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2013-01-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2013-01-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2013-01-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2013-01-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2013-01-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2013-01-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t2 as -- Feb 2013
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2013' 	AS denom_year,
			'2' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2013-02-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2013-02-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2013-02-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2013-02-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2013-02-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2013-02-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t3 as -- March 2013
(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2013' 	AS denom_year,
			'3' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2013-03-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2013-03-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2013-03-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2013-03-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2013-03-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2013-03-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t4 as -- April 2013
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2013' 	AS denom_year,
			'4' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2013-04-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2013-04-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2013-04-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2013-04-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2013-04-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2013-04-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t5 as -- May 2013
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2013' 	AS denom_year,
			'5' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2013-05-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2013-05-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2013-05-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2013-05-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2013-05-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2013-05-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t6 as -- June 2013
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2013' 	AS denom_year,
			'6' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2013-06-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2013-06-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2013-06-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2013-06-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2013-06-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2013-06-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t7 as -- July 2013
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2013' 	AS denom_year,
			'7' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2013-07-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2013-07-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2013-07-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2013-07-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2013-07-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2013-07-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t8 as -- Aug 2013
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2013' 	AS denom_year,
			'8' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2013-08-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2013-08-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2013-08-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2013-08-01' -- those born before the 1st of each month
					AND wob IS NOT NULL) -- who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2013-08-01' -- and alive before 1st of each month
					OR a.death_dt IS NULL) -- or still alive until present
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' --  who live in Wales
				AND '2013-08-01' BETWEEN start_date AND end_date -- that have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t9 as -- Sept 2013
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2013' 	AS denom_year,
			'9' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2013-09-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2013-09-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2013-09-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2013-09-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2013-09-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2013-09-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t10 AS -- Oct 2013
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2013' 	AS denom_year,
			'10' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2013-10-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2013-10-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2013-10-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2013-10-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL)
				AND (c.death_dt > '2013-10-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2013-10-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t11 as -- Nov 2013
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2013' 	AS denom_year,
			'11' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2013-11-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2013-11-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2013-11-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2013-11-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2013-11-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2013-11-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t12 as -- Dec 2013
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2013' 	AS denom_year,
			'12' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2013-12-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2013-12-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2013-12-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2013-12-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2013-12-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2013-12-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
union_tables AS 
	(
	SELECT * FROM T1
	UNION ALL 
	SELECT * FROM T2
	UNION ALL
	SELECT * FROM T3
	UNION ALL
	SELECT * FROM T4
	UNION ALL
	SELECT * FROM T5
	UNION ALL
	SELECT * FROM T6
	UNION ALL
	SELECT * FROM T7
	UNION ALL
	SELECT * FROM T8
	UNION ALL
	SELECT * FROM T9
	UNION ALL
	SELECT * FROM T10
	UNION ALL
	SELECT * FROM T11
	UNION ALL
	SELECT * FROM T12
	)
SELECT alf_e, sex, wob, dod, lsoa2011_cd, denom_year, denom_month, cohort, start_date, end_date FROM union_tables;
-- this creates a long table of all ALFs

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_POP_DENOM
-- 2014
WITH t1 AS -- table for Jan 2014
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2014' 	AS denom_year,
			'1' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2014-01-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2014-01-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2014-01-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2014-01-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2014-01-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2014-01-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t2 as -- Feb 2014
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2014' 	AS denom_year,
			'2' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2014-02-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2014-02-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2014-02-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2014-02-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2014-02-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2014-02-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t3 as -- March 2014
(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2014' 	AS denom_year,
			'3' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2014-03-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2014-03-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2014-03-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2014-03-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2014-03-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2014-03-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t4 as -- April 2014
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2014' 	AS denom_year,
			'4' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2014-04-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2014-04-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2014-04-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2014-04-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2014-04-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2014-04-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t5 as -- May 2014
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2014' 	AS denom_year,
			'5' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2014-05-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2014-05-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2014-05-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2014-05-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2014-05-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2014-05-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t6 as -- June 2014
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2014' 	AS denom_year,
			'6' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2014-06-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2014-06-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2014-06-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2014-06-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2014-06-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2014-06-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t7 as -- July 2014
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2014' 	AS denom_year,
			'7' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2014-07-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2014-07-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2014-07-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2014-07-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2014-07-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2014-07-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t8 as -- Aug 2014
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2014' 	AS denom_year,
			'8' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2014-08-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2014-08-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2014-08-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2014-08-01' -- those born before the 1st of each month
					AND wob IS NOT NULL) -- who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2014-08-01' -- and alive before 1st of each month
					OR a.death_dt IS NULL) -- or still alive until present
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' --  who live in Wales
				AND '2014-08-01' BETWEEN start_date AND end_date -- that have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t9 as -- Sept 2014
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2014' 	AS denom_year,
			'9' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2014-09-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2014-09-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2014-09-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2014-09-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2014-09-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2014-09-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t10 AS -- Oct 2014
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2014' 	AS denom_year,
			'10' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2014-10-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2014-10-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2014-10-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2014-10-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL)
				AND (c.death_dt > '2014-10-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2014-10-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t11 as -- Nov 2014
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2014' 	AS denom_year,
			'11' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2014-11-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2014-11-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2014-11-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2014-11-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2014-11-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2014-11-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t12 as -- Dec 2014
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2014' 	AS denom_year,
			'12' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2014-12-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2014-12-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2014-12-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2014-12-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2014-12-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2014-12-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
union_tables AS 
	(
	SELECT * FROM T1
	UNION ALL 
	SELECT * FROM T2
	UNION ALL
	SELECT * FROM T3
	UNION ALL
	SELECT * FROM T4
	UNION ALL
	SELECT * FROM T5
	UNION ALL
	SELECT * FROM T6
	UNION ALL
	SELECT * FROM T7
	UNION ALL
	SELECT * FROM T8
	UNION ALL
	SELECT * FROM T9
	UNION ALL
	SELECT * FROM T10
	UNION ALL
	SELECT * FROM T11
	UNION ALL
	SELECT * FROM T12
	)
SELECT alf_e, sex, wob, dod, lsoa2011_cd, denom_year, denom_month, cohort, start_date, end_date FROM union_tables;
-- this creates a long table of all ALFs

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_POP_DENOM
-- 2015
WITH t1 AS -- table for Jan 2015
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2015' 	AS denom_year,
			'1' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2015-01-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2015-01-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2015-01-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2015-01-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2015-01-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2015-01-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t2 as -- Feb 2015
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2015' 	AS denom_year,
			'2' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2015-02-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2015-02-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2015-02-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2015-02-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2015-02-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2015-02-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t3 as -- March 2015
(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2015' 	AS denom_year,
			'3' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2015-03-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2015-03-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2015-03-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2015-03-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2015-03-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2015-03-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t4 as -- April 2015
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2015' 	AS denom_year,
			'4' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2015-04-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2015-04-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2015-04-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2015-04-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2015-04-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2015-04-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t5 as -- May 2015
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2015' 	AS denom_year,
			'5' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2015-05-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2015-05-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2015-05-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2015-05-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2015-05-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2015-05-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t6 as -- June 2015
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2015' 	AS denom_year,
			'6' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2015-06-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2015-06-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2015-06-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2015-06-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2015-06-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2015-06-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t7 as -- July 2015
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2015' 	AS denom_year,
			'7' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2015-07-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2015-07-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2015-07-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2015-07-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2015-07-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2015-07-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t8 as -- Aug 2015
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2015' 	AS denom_year,
			'8' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2015-08-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2015-08-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2015-08-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2015-08-01' -- those born before the 1st of each month
					AND wob IS NOT NULL) -- who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2015-08-01' -- and alive before 1st of each month
					OR a.death_dt IS NULL) -- or still alive until present
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' --  who live in Wales
				AND '2015-08-01' BETWEEN start_date AND end_date -- that have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t9 as -- Sept 2015
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2015' 	AS denom_year,
			'9' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2015-09-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2015-09-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2015-09-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2015-09-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2015-09-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2015-09-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t10 AS -- Oct 2015
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2015' 	AS denom_year,
			'10' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2015-10-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2015-10-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2015-10-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2015-10-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL)
				AND (c.death_dt > '2015-10-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2015-10-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t11 as -- Nov 2015
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2015' 	AS denom_year,
			'11' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2015-11-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2015-11-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2015-11-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2015-11-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2015-11-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2015-11-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t12 as -- Dec 2015
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2015' 	AS denom_year,
			'12' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2015-12-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2015-12-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2015-12-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2015-12-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2015-12-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2015-12-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
union_tables AS 
	(
	SELECT * FROM T1
	UNION ALL 
	SELECT * FROM T2
	UNION ALL
	SELECT * FROM T3
	UNION ALL
	SELECT * FROM T4
	UNION ALL
	SELECT * FROM T5
	UNION ALL
	SELECT * FROM T6
	UNION ALL
	SELECT * FROM T7
	UNION ALL
	SELECT * FROM T8
	UNION ALL
	SELECT * FROM T9
	UNION ALL
	SELECT * FROM T10
	UNION ALL
	SELECT * FROM T11
	UNION ALL
	SELECT * FROM T12
	)
SELECT alf_e, sex, wob, dod, lsoa2011_cd, denom_year, denom_month, cohort, start_date, end_date FROM union_tables;
-- this creates a long table of all ALFs

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_POP_DENOM
-- 2016
WITH t1 AS -- table for Jan 2016
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2016' 	AS denom_year,
			'1' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2016-01-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2016-01-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2016-01-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2016-01-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2016-01-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2016-01-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t2 as -- Feb 2016
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2016' 	AS denom_year,
			'2' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2016-02-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2016-02-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2016-02-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2016-02-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2016-02-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2016-02-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t3 as -- March 2016
(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2016' 	AS denom_year,
			'3' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2016-03-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2016-03-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2016-03-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2016-03-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2016-03-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2016-03-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t4 as -- April 2016
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2016' 	AS denom_year,
			'4' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2016-04-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2016-04-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2016-04-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2016-04-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2016-04-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2016-04-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t5 as -- May 2016
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2016' 	AS denom_year,
			'5' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2016-05-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2016-05-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2016-05-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2016-05-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2016-05-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2016-05-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t6 as -- June 2016
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2016' 	AS denom_year,
			'6' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2016-06-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2016-06-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2016-06-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2016-06-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2016-06-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2016-06-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t7 as -- July 2016
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2016' 	AS denom_year,
			'7' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2016-07-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2016-07-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2016-07-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2016-07-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2016-07-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2016-07-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t8 as -- Aug 2016
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2016' 	AS denom_year,
			'8' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2016-08-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2016-08-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2016-08-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2016-08-01' -- those born before the 1st of each month
					AND wob IS NOT NULL) -- who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2016-08-01' -- and alive before 1st of each month
					OR a.death_dt IS NULL) -- or still alive until present
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' --  who live in Wales
				AND '2016-08-01' BETWEEN start_date AND end_date -- that have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t9 as -- Sept 2016
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2016' 	AS denom_year,
			'9' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2016-09-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2016-09-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2016-09-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2016-09-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2016-09-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2016-09-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t10 AS -- Oct 2016
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2016' 	AS denom_year,
			'10' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2016-10-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2016-10-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2016-10-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2016-10-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL)
				AND (c.death_dt > '2016-10-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2016-10-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t11 as -- Nov 2016
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2016' 	AS denom_year,
			'11' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2016-11-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2016-11-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2016-11-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2016-11-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2016-11-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2016-11-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t12 as -- Dec 2016
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2016' 	AS denom_year,
			'12' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2016-12-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2016-12-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2016-12-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2016-12-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2016-12-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2016-12-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
union_tables AS 
	(
	SELECT * FROM T1
	UNION ALL 
	SELECT * FROM T2
	UNION ALL
	SELECT * FROM T3
	UNION ALL
	SELECT * FROM T4
	UNION ALL
	SELECT * FROM T5
	UNION ALL
	SELECT * FROM T6
	UNION ALL
	SELECT * FROM T7
	UNION ALL
	SELECT * FROM T8
	UNION ALL
	SELECT * FROM T9
	UNION ALL
	SELECT * FROM T10
	UNION ALL
	SELECT * FROM T11
	UNION ALL
	SELECT * FROM T12
	)
SELECT alf_e, sex, wob, dod, lsoa2011_cd, denom_year, denom_month, cohort, start_date, end_date FROM union_tables;
-- this creates a long table of all ALFs

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_POP_DENOM
-- 2017
WITH t1 AS -- table for Jan 2017
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2017' 	AS denom_year,
			'1' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2017-01-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2017-01-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2017-01-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2017-01-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2017-01-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2017-01-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t2 as -- Feb 2017
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2017' 	AS denom_year,
			'2' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2017-02-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2017-02-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2017-02-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2017-02-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2017-02-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2017-02-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t3 as -- March 2017
(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2017' 	AS denom_year,
			'3' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2017-03-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2017-03-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2017-03-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2017-03-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2017-03-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2017-03-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t4 as -- April 2017
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2017' 	AS denom_year,
			'4' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2017-04-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2017-04-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2017-04-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2017-04-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2017-04-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2017-04-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t5 as -- May 2017
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2017' 	AS denom_year,
			'5' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2017-05-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2017-05-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2017-05-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2017-05-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2017-05-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2017-05-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t6 as -- June 2017
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2017' 	AS denom_year,
			'6' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2017-06-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2017-06-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2017-06-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2017-06-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2017-06-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2017-06-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t7 as -- July 2017
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2017' 	AS denom_year,
			'7' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2017-07-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2017-07-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2017-07-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2017-07-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2017-07-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2017-07-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t8 as -- Aug 2017
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2017' 	AS denom_year,
			'8' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2017-08-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2017-08-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2017-08-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2017-08-01' -- those born before the 1st of each month
					AND wob IS NOT NULL) -- who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2017-08-01' -- and alive before 1st of each month
					OR a.death_dt IS NULL) -- or still alive until present
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' --  who live in Wales
				AND '2017-08-01' BETWEEN start_date AND end_date -- that have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t9 as -- Sept 2017
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2017' 	AS denom_year,
			'9' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2017-09-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2017-09-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2017-09-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2017-09-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2017-09-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2017-09-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t10 AS -- Oct 2017
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2017' 	AS denom_year,
			'10' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2017-10-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2017-10-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2017-10-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2017-10-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL)
				AND (c.death_dt > '2017-10-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2017-10-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t11 as -- Nov 2017
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2017' 	AS denom_year,
			'11' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2017-11-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2017-11-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2017-11-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2017-11-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2017-11-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2017-11-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t12 as -- Dec 2017
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2017' 	AS denom_year,
			'12' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2017-12-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2017-12-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2017-12-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2017-12-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2017-12-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2017-12-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
union_tables AS 
	(
	SELECT * FROM T1
	UNION ALL 
	SELECT * FROM T2
	UNION ALL
	SELECT * FROM T3
	UNION ALL
	SELECT * FROM T4
	UNION ALL
	SELECT * FROM T5
	UNION ALL
	SELECT * FROM T6
	UNION ALL
	SELECT * FROM T7
	UNION ALL
	SELECT * FROM T8
	UNION ALL
	SELECT * FROM T9
	UNION ALL
	SELECT * FROM T10
	UNION ALL
	SELECT * FROM T11
	UNION ALL
	SELECT * FROM T12
	)
SELECT alf_e, sex, wob, dod, lsoa2011_cd, denom_year, denom_month, cohort, start_date, end_date FROM union_tables;
-- this creates a long table of all ALFs

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_POP_DENOM
-- 2018
WITH t1 AS -- table for Jan 2018
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2018' 	AS denom_year,
			'1' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2018-01-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2018-01-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2018-01-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2018-01-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2018-01-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2018-01-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t2 as -- Feb 2018
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2018' 	AS denom_year,
			'2' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2018-02-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2018-02-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2018-02-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2018-02-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2018-02-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2018-02-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t3 as -- March 2018
(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2018' 	AS denom_year,
			'3' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2018-03-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2018-03-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2018-03-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2018-03-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2018-03-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2018-03-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t4 as -- April 2018
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2018' 	AS denom_year,
			'4' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2018-04-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2018-04-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2018-04-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2018-04-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2018-04-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2018-04-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t5 as -- May 2018
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2018' 	AS denom_year,
			'5' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2018-05-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2018-05-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2018-05-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2018-05-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2018-05-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2018-05-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t6 as -- June 2018
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2018' 	AS denom_year,
			'6' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2018-06-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2018-06-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2018-06-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2018-06-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2018-06-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2018-06-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t7 as -- July 2018
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2018' 	AS denom_year,
			'7' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2018-07-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2018-07-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2018-07-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2018-07-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2018-07-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2018-07-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t8 as -- Aug 2018
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2018' 	AS denom_year,
			'8' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2018-08-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2018-08-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2018-08-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2018-08-01' -- those born before the 1st of each month
					AND wob IS NOT NULL) -- who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2018-08-01' -- and alive before 1st of each month
					OR a.death_dt IS NULL) -- or still alive until present
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' --  who live in Wales
				AND '2018-08-01' BETWEEN start_date AND end_date -- that have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t9 as -- Sept 2018
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2018' 	AS denom_year,
			'9' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2018-09-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2018-09-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2018-09-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2018-09-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2018-09-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2018-09-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t10 AS -- Oct 2018
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2018' 	AS denom_year,
			'10' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2018-10-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2018-10-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2018-10-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2018-10-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL)
				AND (c.death_dt > '2018-10-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2018-10-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t11 as -- Nov 2018
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2018' 	AS denom_year,
			'11' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2018-11-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2018-11-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2018-11-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2018-11-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2018-11-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2018-11-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t12 as -- Dec 2018
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2018' 	AS denom_year,
			'12' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2018-12-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2018-12-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2018-12-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2018-12-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2018-12-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2018-12-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
union_tables AS 
	(
	SELECT * FROM T1
	UNION ALL 
	SELECT * FROM T2
	UNION ALL
	SELECT * FROM T3
	UNION ALL
	SELECT * FROM T4
	UNION ALL
	SELECT * FROM T5
	UNION ALL
	SELECT * FROM T6
	UNION ALL
	SELECT * FROM T7
	UNION ALL
	SELECT * FROM T8
	UNION ALL
	SELECT * FROM T9
	UNION ALL
	SELECT * FROM T10
	UNION ALL
	SELECT * FROM T11
	UNION ALL
	SELECT * FROM T12
	)
SELECT alf_e, sex, wob, dod, lsoa2011_cd, denom_year, denom_month, cohort, start_date, end_date FROM union_tables;
-- this creates a long table of all ALFs

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_POP_DENOM
-- 2019
WITH t1 AS -- table for Jan 2019
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2019' 	AS denom_year,
			'1' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2019-01-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2019-01-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2019-01-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2019-01-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2019-01-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2019-01-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t2 as -- Feb 2019
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2019' 	AS denom_year,
			'2' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2019-02-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2019-02-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2019-02-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2019-02-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2019-02-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2019-02-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t3 as -- March 2019
(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2019' 	AS denom_year,
			'3' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2019-03-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2019-03-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2019-03-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2019-03-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2019-03-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2019-03-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t4 as -- April 2019
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2019' 	AS denom_year,
			'4' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2019-04-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2019-04-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2019-04-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2019-04-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2019-04-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2019-04-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t5 as -- May 2019
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2019' 	AS denom_year,
			'5' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2019-05-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2019-05-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2019-05-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2019-05-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2019-05-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2019-05-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t6 as -- June 2019
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2019' 	AS denom_year,
			'6' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2019-06-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2019-06-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2019-06-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2019-06-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2019-06-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2019-06-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t7 as -- July 2019
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2019' 	AS denom_year,
			'7' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2019-07-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2019-07-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2019-07-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2019-07-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2019-07-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2019-07-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t8 as -- Aug 2019
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2019' 	AS denom_year,
			'8' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2019-08-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2019-08-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2019-08-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2019-08-01' -- those born before the 1st of each month
					AND wob IS NOT NULL) -- who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2019-08-01' -- and alive before 1st of each month
					OR a.death_dt IS NULL) -- or still alive until present
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' --  who live in Wales
				AND '2019-08-01' BETWEEN start_date AND end_date -- that have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t9 as -- Sept 2019
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2019' 	AS denom_year,
			'9' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2019-09-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2019-09-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2019-09-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2019-09-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2019-09-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2019-09-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t10 AS -- Oct 2019
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2019' 	AS denom_year,
			'10' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2019-10-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2019-10-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2019-10-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2019-10-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL)
				AND (c.death_dt > '2019-10-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2019-10-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t11 as -- Nov 2019
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2019' 	AS denom_year,
			'11' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2019-11-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2019-11-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2019-11-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2019-11-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2019-11-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2019-11-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t12 as -- Dec 2019
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2019' 	AS denom_year,
			'12' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2019-12-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2019-12-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2019-12-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2019-12-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2019-12-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2019-12-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
union_tables AS 
	(
	SELECT * FROM T1
	UNION ALL 
	SELECT * FROM T2
	UNION ALL
	SELECT * FROM T3
	UNION ALL
	SELECT * FROM T4
	UNION ALL
	SELECT * FROM T5
	UNION ALL
	SELECT * FROM T6
	UNION ALL
	SELECT * FROM T7
	UNION ALL
	SELECT * FROM T8
	UNION ALL
	SELECT * FROM T9
	UNION ALL
	SELECT * FROM T10
	UNION ALL
	SELECT * FROM T11
	UNION ALL
	SELECT * FROM T12
	)
SELECT alf_e, sex, wob, dod, lsoa2011_cd, denom_year, denom_month, cohort, start_date, end_date FROM union_tables;
-- this creates a long table of all ALFs

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_POP_DENOM
-- 2020
WITH t1 AS -- table for Jan 2020
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2020' 	AS denom_year,
			'1' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2020-01-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2020-01-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2020-01-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2020-01-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2020-01-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2020-01-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t2 as -- Feb 2020
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2020' 	AS denom_year,
			'2' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2020-02-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2020-02-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2020-02-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2020-02-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2020-02-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2020-02-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t3 as -- March 2020
(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2020' 	AS denom_year,
			'3' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2020-03-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2020-03-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2020-03-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2020-03-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2020-03-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2020-03-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t4 as -- April 2020
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2020' 	AS denom_year,
			'4' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2020-04-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2020-04-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2020-04-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2020-04-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2020-04-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2020-04-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t5 as -- May 2020
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2020' 	AS denom_year,
			'5' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2020-05-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2020-05-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2020-05-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2020-05-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2020-05-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2020-05-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t6 as -- June 2020
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2020' 	AS denom_year,
			'6' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2020-06-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2020-06-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2020-06-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2020-06-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2020-06-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2020-06-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t7 as -- July 2020
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2020' 	AS denom_year,
			'7' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2020-07-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2020-07-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2020-07-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2020-07-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2020-07-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2020-07-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t8 as -- Aug 2020
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2020' 	AS denom_year,
			'8' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2020-08-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2020-08-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2020-08-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2020-08-01' -- those born before the 1st of each month
					AND wob IS NOT NULL) -- who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2020-08-01' -- and alive before 1st of each month
					OR a.death_dt IS NULL) -- or still alive until present
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' --  who live in Wales
				AND '2020-08-01' BETWEEN start_date AND end_date -- that have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t9 as -- Sept 2020
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2020' 	AS denom_year,
			'9' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2020-09-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2020-09-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2020-09-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2020-09-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2020-09-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2020-09-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t10 AS -- Oct 2020
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2020' 	AS denom_year,
			'10' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2020-10-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2020-10-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2020-10-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2020-10-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL)
				AND (c.death_dt > '2020-10-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2020-10-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t11 as -- Nov 2020
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2020' 	AS denom_year,
			'11' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2020-11-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2020-11-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2020-11-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2020-11-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2020-11-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2020-11-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t12 as -- Dec 2020
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2020' 	AS denom_year,
			'12' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2020-12-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2020-12-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2020-12-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2020-12-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2020-12-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2020-12-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
union_tables AS 
	(
	SELECT * FROM T1
	UNION ALL 
	SELECT * FROM T2
	UNION ALL
	SELECT * FROM T3
	UNION ALL
	SELECT * FROM T4
	UNION ALL
	SELECT * FROM T5
	UNION ALL
	SELECT * FROM T6
	UNION ALL
	SELECT * FROM T7
	UNION ALL
	SELECT * FROM T8
	UNION ALL
	SELECT * FROM T9
	UNION ALL
	SELECT * FROM T10
	UNION ALL
	SELECT * FROM T11
	UNION ALL
	SELECT * FROM T12
	)
SELECT alf_e, sex, wob, dod, lsoa2011_cd, denom_year, denom_month, cohort, start_date, end_date FROM union_tables;
-- this creates a long table of all ALFs

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_POP_DENOM
-- 2021
WITH t1 AS -- table for Jan 2021
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2021' 	AS denom_year,
			'1' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2021-01-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2021-01-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2021-01-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2021-01-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2021-01-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2021-01-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t2 as -- Feb 2021
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2021' 	AS denom_year,
			'2' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2021-02-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2021-02-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2021-02-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2021-02-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2021-02-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2021-02-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t3 as -- March 2021
(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2021' 	AS denom_year,
			'3' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2021-03-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2021-03-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2021-03-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2021-03-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2021-03-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2021-03-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t4 as -- April 2021
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2021' 	AS denom_year,
			'4' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2021-04-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2021-04-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2021-04-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2021-04-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2021-04-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2021-04-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t5 as -- May 2021
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2021' 	AS denom_year,
			'5' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2021-05-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2021-05-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2021-05-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2021-05-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2021-05-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2021-05-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t6 as -- June 2021
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2021' 	AS denom_year,
			'6' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2021-06-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2021-06-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2021-06-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2021-06-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2021-06-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2021-06-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t7 as -- July 2021
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2021' 	AS denom_year,
			'7' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2021-07-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2021-07-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2021-07-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2021-07-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2021-07-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2021-07-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t8 as -- Aug 2021
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2021' 	AS denom_year,
			'8' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2021-08-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2021-08-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2021-08-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2021-08-01' -- those born before the 1st of each month
					AND wob IS NOT NULL) -- who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2021-08-01' -- and alive before 1st of each month
					OR a.death_dt IS NULL) -- or still alive until present
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' --  who live in Wales
				AND '2021-08-01' BETWEEN start_date AND end_date -- that have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t9 as -- Sept 2021
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2021' 	AS denom_year,
			'9' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2021-09-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2021-09-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2021-09-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2021-09-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2021-09-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2021-09-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t10 AS -- Oct 2021
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2021' 	AS denom_year,
			'10' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2021-10-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2021-10-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2021-10-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2021-10-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL)
				AND (c.death_dt > '2021-10-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2021-10-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t11 as -- Nov 2021
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2021' 	AS denom_year,
			'11' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2021-11-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2021-11-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2021-11-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2021-11-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2021-11-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2021-11-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t12 as -- Dec 2021
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2021' 	AS denom_year,
			'12' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2021-12-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2021-12-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2021-12-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2021-12-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2021-12-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2021-12-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
union_tables AS 
	(
	SELECT * FROM T1
	UNION ALL 
	SELECT * FROM T2
	UNION ALL
	SELECT * FROM T3
	UNION ALL
	SELECT * FROM T4
	UNION ALL
	SELECT * FROM T5
	UNION ALL
	SELECT * FROM T6
	UNION ALL
	SELECT * FROM T7
	UNION ALL
	SELECT * FROM T8
	UNION ALL
	SELECT * FROM T9
	UNION ALL
	SELECT * FROM T10
	UNION ALL
	SELECT * FROM T11
	UNION ALL
	SELECT * FROM T12
	)
SELECT alf_e, sex, wob, dod, lsoa2011_cd, denom_year, denom_month, cohort, start_date, end_date FROM union_tables;
-- this creates a long table of all ALFs

COMMIT;

INSERT INTO SAILW1151V.HDR25_BMI_POP_DENOM
-- 2022
WITH t1 AS -- table for Jan 2022
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2022' 	AS denom_year,
			'1' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2022-01-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2022-01-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2022-01-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2022-01-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2022-01-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2022-01-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t2 as -- Feb 2022
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2022' 	AS denom_year,
			'2' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2022-02-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2022-02-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2022-02-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2022-02-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2022-02-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2022-02-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t3 as -- March 2022
(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2022' 	AS denom_year,
			'3' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2022-03-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2022-03-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2022-03-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2022-03-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2022-03-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2022-03-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t4 as -- April 2022
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2022' 	AS denom_year,
			'4' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2022-04-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2022-04-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2022-04-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2022-04-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2022-04-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2022-04-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t5 as -- May 2022
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2022' 	AS denom_year,
			'5' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2022-05-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2022-05-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2022-05-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2022-05-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2022-05-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2022-05-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t6 as -- June 2022
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2022' 	AS denom_year,
			'6' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2022-06-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2022-06-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2022-06-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2022-06-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2022-06-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2022-06-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t7 as -- July 2022
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2022' 	AS denom_year,
			'7' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2022-07-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2022-07-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2022-07-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2022-07-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2022-07-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2022-07-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t8 as -- Aug 2022
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2022' 	AS denom_year,
			'8' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2022-08-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2022-08-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2022-08-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2022-08-01' -- those born before the 1st of each month
					AND wob IS NOT NULL) -- who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2022-08-01' -- and alive before 1st of each month
					OR a.death_dt IS NULL) -- or still alive until present
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' --  who live in Wales
				AND '2022-08-01' BETWEEN start_date AND end_date -- that have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t9 as -- Sept 2022
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2022' 	AS denom_year,
			'9' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2022-09-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2022-09-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2022-09-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2022-09-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2022-09-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2022-09-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t10 AS -- Oct 2022
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2022' 	AS denom_year,
			'10' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2022-10-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2022-10-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2022-10-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2022-10-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL)
				AND (c.death_dt > '2022-10-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2022-10-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t11 as -- Nov 2022
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2022' 	AS denom_year,
			'11' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2022-11-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2022-11-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2022-11-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2022-11-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2022-11-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2022-11-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
t12 as -- Dec 2022
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			sex,
			wob,
			dod,
			lsoa2011_cd,
			'2022' 	AS denom_year,
			'12' 	AS denom_month,
			CASE
				WHEN (DAYS_BETWEEN('2022-12-01', WOB)/365.25) 	> 19 													THEN '1' -- if above 18 years old, flag as 1
				WHEN (DAYS_BETWEEN('2022-12-01', WOB)/365.25)	>= 2 AND (DAYS_BETWEEN('2022-12-01', WOB)/365.25) < 19	THEN '2' -- if between 2-18, flag as 2
				ELSE NULL
				END AS cohort,
			start_date,
			end_date,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY end_date desc) AS dt_order
		FROM 
			(
			SELECT DISTINCT
				a.alf_e,
				gndr_cd AS sex,
				wob,
				a.death_dt AS dod,
				b.lsoa2011_cd,
				start_date,
				end_date
			FROM
				sailwmc_v.C19_COHORT_WDSD_PER_RESIDENCE_GPREG_20230323 a
			LEFT JOIN
				sailwmc_v.C19_COHORT_WDSD_SINGLE_CLEAN_GEO_CHAR_lsoa2011 b
			ON a.alf_e = b.alf_e
			LEFT JOIN
				sailwmc_v.C19_COHORT_ADDE_DEATHS_20230323 c
			ON a.alf_e = c.alf_e
			WHERE 
				(wob <= '2022-12-01' -- those born before the 1st of each month.
					AND wob IS NOT NULL) -- those who have valid WOB
				AND (gndr_cd IN ('1', '2') AND gndr_cd IS NOT NULL) -- those with valid gndr_cd
				AND (c.death_dt > '2022-12-01' -- alive before 1st of each month.
					OR a.death_dt IS NULL) -- or still alive
				AND SUBSTRING(b.lsoa2011_cd,1,1) = 'W' -- those who live in Wales
				AND '2022-12-01' BETWEEN start_date AND end_date -- those who have a residency in Wales at the first of each month
			)
		)
	WHERE dt_order = 1
	),
union_tables AS 
	(
	SELECT * FROM T1
	UNION ALL 
	SELECT * FROM T2
	UNION ALL
	SELECT * FROM T3
	UNION ALL
	SELECT * FROM T4
	UNION ALL
	SELECT * FROM T5
	UNION ALL
	SELECT * FROM T6
	UNION ALL
	SELECT * FROM T7
	UNION ALL
	SELECT * FROM T8
	UNION ALL
	SELECT * FROM T9
	UNION ALL
	SELECT * FROM T10
	UNION ALL
	SELECT * FROM T11
	UNION ALL
	SELECT * FROM T12
	)
SELECT alf_e, sex, wob, dod, lsoa2011_cd, denom_year, denom_month, cohort, start_date, end_date FROM union_tables;
-- this creates a long table of all ALFs

COMMIT;

----
SELECT count(DISTINCT alf_e), count(*) FROM SAILW1151V.HDR25_BMI_POP_DENOM
--WHERE denom_year = 2011 AND denom_month = 1