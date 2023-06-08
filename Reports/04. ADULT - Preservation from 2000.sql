-- Code by m.j.childs@swansea.ac.uk

-- Functions used: DROP, CREATE, INSERT, JOINS, UNIONS

------------------------------------------------------------------------
-- This code creates the tables to use to create stacked bars in R.
-- creating preservation tables from 2000-2022 with one year lookback (-- 1 yr lookback)
-- next section has five year lookback (-- 5yr lookback)
-- last section has all years preserved (-- all years lookback)
------------------------------------------------------------------------


---- Section 1. 1yr lookback
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG_1yr');

CREATE TABLE SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG_1yr
(
	alf_e			BIGINT,
	bmi_month		VARCHAR(50),
	bmi_year		CHAR(4),
	bmi_cat			VARCHAR(50)

);

-- year 2000
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG_1yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2000-02-01') - 1 year AND '2000-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2000 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2000-03-01') - 1 year AND '2000-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2000 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2000-04-01') - 1 year AND '2000-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2000 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2000-05-01') - 1 year AND '2000-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2000 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2000-06-01') - 1 year AND '2000-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2000 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2000-07-01') - 1 year AND '2000-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2000 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2000-08-01') - 1 year AND '2000-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2000 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2000-09-01') - 1 year AND '2000-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2000 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2000-10-01') - 1 year AND '2000-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2000 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2000-11-01') - 1 year AND '2000-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2000 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2000-12-01') - 1 year AND '2000-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2000 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2001-01-01') - 1 year AND '2001-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2000 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2001
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG_1yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2001-02-01') - 1 year AND '2001-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2001 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2001-03-01') - 1 year AND '2001-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2001 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2001-04-01') - 1 year AND '2001-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2001 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2001-05-01') - 1 year AND '2001-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2001 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2001-06-01') - 1 year AND '2001-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2001 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2001-07-01') - 1 year AND '2001-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2001 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2001-08-01') - 1 year AND '2001-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2001 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2001-09-01') - 1 year AND '2001-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2001 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2001-10-01') - 1 year AND '2001-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2001 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2001-11-01') - 1 year AND '2001-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2001 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2001-12-01') - 1 year AND '2001-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2001 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2002-01-01') - 1 year AND '2002-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2001 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2002
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG_1yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2002-02-01') - 1 year AND '2002-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2002 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2002-03-01') - 1 year AND '2002-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2002 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2002-04-01') - 1 year AND '2002-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2002 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2002-05-01') - 1 year AND '2002-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2002 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2002-06-01') - 1 year AND '2002-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2002 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2002-07-01') - 1 year AND '2002-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2002 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2002-08-01') - 1 year AND '2002-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2002 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2002-09-01') - 1 year AND '2002-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2002 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2002-10-01') - 1 year AND '2002-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2002 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2002-11-01') - 1 year AND '2002-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2002 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2002-12-01') - 1 year AND '2002-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2002 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2003-01-01') - 1 year AND '2003-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2002 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2003
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG_1yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2003-02-01') - 1 year AND '2003-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2003 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2003-03-01') - 1 year AND '2003-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2003 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2003-04-01') - 1 year AND '2003-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2003 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2003-05-01') - 1 year AND '2003-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2003 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2003-06-01') - 1 year AND '2003-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2003 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2003-07-01') - 1 year AND '2003-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2003 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2003-08-01') - 1 year AND '2003-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2003 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2003-09-01') - 1 year AND '2003-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2003 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2003-10-01') - 1 year AND '2003-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2003 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2003-11-01') - 1 year AND '2003-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2003 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2003-12-01') - 1 year AND '2003-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2003 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2004-01-01') - 1 year AND '2004-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2003 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2004
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG_1yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2004-02-01') - 1 year AND '2004-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2004 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2004-03-01') - 1 year AND '2004-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2004 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2004-04-01') - 1 year AND '2004-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2004 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2004-05-01') - 1 year AND '2004-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2004 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2004-06-01') - 1 year AND '2004-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2004 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2004-07-01') - 1 year AND '2004-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2004 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2004-08-01') - 1 year AND '2004-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2004 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2004-09-01') - 1 year AND '2004-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2004 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2004-10-01') - 1 year AND '2004-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2004 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2004-11-01') - 1 year AND '2004-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2004 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2004-12-01') - 1 year AND '2004-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2004 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2005-01-01') - 1 year AND '2005-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2004 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2005
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG_1yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2005-02-01') - 1 year AND '2005-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2005 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2005-03-01') - 1 year AND '2005-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2005 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2005-04-01') - 1 year AND '2005-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2005 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2005-05-01') - 1 year AND '2005-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2005 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2005-06-01') - 1 year AND '2005-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2005 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2005-07-01') - 1 year AND '2005-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2005 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2005-08-01') - 1 year AND '2005-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2005 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2005-09-01') - 1 year AND '2005-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2005 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2005-10-01') - 1 year AND '2005-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2005 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2005-11-01') - 1 year AND '2005-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2005 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2005-12-01') - 1 year AND '2005-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2005 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2006-01-01') - 1 year AND '2006-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2005 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2006
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG_1yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2006-02-01') - 1 year AND '2006-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2006 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2006-03-01') - 1 year AND '2006-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2006 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2006-04-01') - 1 year AND '2006-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2006 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2006-05-01') - 1 year AND '2006-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2006 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2006-06-01') - 1 year AND '2006-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2006 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2006-07-01') - 1 year AND '2006-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2006 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2006-08-01') - 1 year AND '2006-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2006 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2006-09-01') - 1 year AND '2006-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2006 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2006-10-01') - 1 year AND '2006-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2006 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2006-11-01') - 1 year AND '2006-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2006 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2006-12-01') - 1 year AND '2006-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2006 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2007-01-01') - 1 year AND '2007-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2006 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2007
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG_1yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2007-02-01') - 1 year AND '2007-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2007 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2007-03-01') - 1 year AND '2007-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2007 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2007-04-01') - 1 year AND '2007-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2007 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2007-05-01') - 1 year AND '2007-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2007 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2007-06-01') - 1 year AND '2007-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2007 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2007-07-01') - 1 year AND '2007-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2007 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2007-08-01') - 1 year AND '2007-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2007 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2007-09-01') - 1 year AND '2007-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2007 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2007-10-01') - 1 year AND '2007-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2007 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2007-11-01') - 1 year AND '2007-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2007 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2007-12-01') - 1 year AND '2007-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2007 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2008-01-01') - 1 year AND '2008-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2007 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2008
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG_1yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2008-02-01') - 1 year AND '2008-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2008 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2008-03-01') - 1 year AND '2008-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2008 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2008-04-01') - 1 year AND '2008-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2008 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2008-05-01') - 1 year AND '2008-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2008 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2008-06-01') - 1 year AND '2008-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2008 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2008-07-01') - 1 year AND '2008-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2008 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2008-08-01') - 1 year AND '2008-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2008 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2008-09-01') - 1 year AND '2008-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2008 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2008-10-01') - 1 year AND '2008-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2008 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2008-11-01') - 1 year AND '2008-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2008 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2008-12-01') - 1 year AND '2008-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2008 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2009-01-01') - 1 year AND '2009-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2008 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2009
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_1yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2009-02-01') - 1 year AND '2009-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2009 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2009-03-01') - 1 year AND '2009-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2009 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2009-04-01') - 1 year AND '2009-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2009 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2009-05-01') - 1 year AND '2009-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2009 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2009-06-01') - 1 year AND '2009-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2009 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2009-07-01') - 1 year AND '2009-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2009 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2009-08-01') - 1 year AND '2009-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2009 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2009-09-01') - 1 year AND '2009-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2009 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2009-10-01') - 1 year AND '2009-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2009 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2009-11-01') - 1 year AND '2009-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2009 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2009-12-01') - 1 year AND '2009-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2009 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2010-01-01') - 1 year AND '2010-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2009 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2010
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_1yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2010-02-01') - 1 year AND '2010-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2010 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2010-03-01') - 1 year AND '2010-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2010 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2010-04-01') - 1 year AND '2010-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2010 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2010-05-01') - 1 year AND '2010-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2010 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2010-06-01') - 1 year AND '2010-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2010 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2010-07-01') - 1 year AND '2010-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2010 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2010-08-01') - 1 year AND '2010-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2010 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2010-09-01') - 1 year AND '2010-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2010 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2010-10-01') - 1 year AND '2010-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2010 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2010-11-01') - 1 year AND '2010-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2010 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2010-12-01') - 1 year AND '2010-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2010 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2011-01-01') - 1 year AND '2011-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2010 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2011
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_1yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2011-02-01') - 1 year AND '2011-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2011 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2011-03-01') - 1 year AND '2011-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2011 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2011-04-01') - 1 year AND '2011-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2011 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2011-05-01') - 1 year AND '2011-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2011 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2011-06-01') - 1 year AND '2011-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2011 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2011-07-01') - 1 year AND '2011-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2011 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2011-08-01') - 1 year AND '2011-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2011 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2011-09-01') - 1 year AND '2011-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2011 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2011-10-01') - 1 year AND '2011-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2011 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2011-11-01') - 1 year AND '2011-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2011 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2011-12-01') - 1 year AND '2011-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2011 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2012-01-01') - 1 year AND '2012-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2011 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2012
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_1yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2012-02-01') - 1 year AND '2012-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2012 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2012-03-01') - 1 year AND '2012-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2012 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2012-04-01') - 1 year AND '2012-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2012 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2012-05-01') - 1 year AND '2012-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2012 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2012-06-01') - 1 year AND '2012-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2012 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2012-07-01') - 1 year AND '2012-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2012 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2012-08-01') - 1 year AND '2012-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2012 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2012-09-01') - 1 year AND '2012-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2012 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2012-10-01') - 1 year AND '2012-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2012 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2012-11-01') - 1 year AND '2012-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2012 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2012-12-01') - 1 year AND '2012-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2012 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2013-01-01') - 1 year AND '2013-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2012 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2013
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_1yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2013-02-01') - 1 year AND '2013-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2013 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2013-03-01') - 1 year AND '2013-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2013 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2013-04-01') - 1 year AND '2013-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2013 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2013-05-01') - 1 year AND '2013-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2013 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2013-06-01') - 1 year AND '2013-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2013 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2013-07-01') - 1 year AND '2013-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2013 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2013-08-01') - 1 year AND '2013-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2013 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2013-09-01') - 1 year AND '2013-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2013 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2013-10-01') - 1 year AND '2013-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2013 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2013-11-01') - 1 year AND '2013-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2013 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2013-12-01') - 1 year AND '2013-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2013 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2014-01-01') - 1 year AND '2014-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2013 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2014
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_1yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2014-02-01') - 1 year AND '2014-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2014 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2014-03-01') - 1 year AND '2014-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2014 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2014-04-01') - 1 year AND '2014-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2014 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2014-05-01') - 1 year AND '2014-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2014 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2014-06-01') - 1 year AND '2014-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2014 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2014-07-01') - 1 year AND '2014-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2014 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2014-08-01') - 1 year AND '2014-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2014 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2014-09-01') - 1 year AND '2014-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2014 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2014-10-01') - 1 year AND '2014-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2014 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2014-11-01') - 1 year AND '2014-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2014 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2014-12-01') - 1 year AND '2014-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2014 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2015-01-01') - 1 year AND '2015-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2014 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2015
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_1yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2015-02-01') - 1 year AND '2015-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2015 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2015-03-01') - 1 year AND '2015-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2015 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2015-04-01') - 1 year AND '2015-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2015 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2015-05-01') - 1 year AND '2015-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2015 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2015-06-01') - 1 year AND '2015-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2015 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2015-07-01') - 1 year AND '2015-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2015 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2015-08-01') - 1 year AND '2015-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2015 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2015-09-01') - 1 year AND '2015-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2015 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2015-10-01') - 1 year AND '2015-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2015 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2015-11-01') - 1 year AND '2015-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2015 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2015-12-01') - 1 year AND '2015-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2015 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2016-01-01') - 1 year AND '2016-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2015 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2016
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_1yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2016-02-01') - 1 year AND '2016-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2016 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2016-03-01') - 1 year AND '2016-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2016 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2016-04-01') - 1 year AND '2016-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2016 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2016-05-01') - 1 year AND '2016-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2016 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2016-06-01') - 1 year AND '2016-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2016 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2016-07-01') - 1 year AND '2016-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2016 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2016-08-01') - 1 year AND '2016-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2016 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2016-09-01') - 1 year AND '2016-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2016 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2016-10-01') - 1 year AND '2016-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2016 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2016-11-01') - 1 year AND '2016-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2016 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2016-12-01') - 1 year AND '2016-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2016 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2017-01-01') - 1 year AND '2017-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2016 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2017
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_1yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2017-02-01') - 1 year AND '2017-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2017 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2017-03-01') - 1 year AND '2017-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2017 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2017-04-01') - 1 year AND '2017-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2017 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2017-05-01') - 1 year AND '2017-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2017 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2017-06-01') - 1 year AND '2017-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2017 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2017-07-01') - 1 year AND '2017-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2017 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2017-08-01') - 1 year AND '2017-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2017 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2017-09-01') - 1 year AND '2017-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2017 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2017-10-01') - 1 year AND '2017-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2017 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2017-11-01') - 1 year AND '2017-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2017 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2017-12-01') - 1 year AND '2017-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2017 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2018-01-01') - 1 year AND '2018-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2017 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2018
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_1yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2018-02-01') - 1 year AND '2018-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2018 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2018-03-01') - 1 year AND '2018-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2018 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2018-04-01') - 1 year AND '2018-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2018 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2018-05-01') - 1 year AND '2018-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2018 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2018-06-01') - 1 year AND '2018-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2018 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2018-07-01') - 1 year AND '2018-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2018 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2018-08-01') - 1 year AND '2018-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2018 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2018-09-01') - 1 year AND '2018-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2018 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2018-10-01') - 1 year AND '2018-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2018 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2018-11-01') - 1 year AND '2018-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2018 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2018-12-01') - 1 year AND '2018-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2018 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2019-01-01') - 1 year AND '2019-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2018 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2019
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_1yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2019-02-01') - 1 year AND '2019-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2019 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2019-03-01') - 1 year AND '2019-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2019 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2019-04-01') - 1 year AND '2019-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2019 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2019-05-01') - 1 year AND '2019-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2019 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2019-06-01') - 1 year AND '2019-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2019 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2019-07-01') - 1 year AND '2019-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2019 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2019-08-01') - 1 year AND '2019-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2019 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2019-09-01') - 1 year AND '2019-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2019 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2019-10-01') - 1 year AND '2019-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2019 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2019-11-01') - 1 year AND '2019-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2019 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2019-12-01') - 1 year AND '2019-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2019 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2020-01-01') - 1 year AND '2020-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2019 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2020
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_1yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2020-02-01') - 1 year AND '2020-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2020 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2020-03-01') - 1 year AND '2020-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2020 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2020-04-01') - 1 year AND '2020-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2020 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2020-05-01') - 1 year AND '2020-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2020 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2020-06-01') - 1 year AND '2020-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2020 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2020-07-01') - 1 year AND '2020-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2020 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2020-08-01') - 1 year AND '2020-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2020 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2020-09-01') - 1 year AND '2020-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2020 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2020-10-01') - 1 year AND '2020-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2020 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2020-11-01') - 1 year AND '2020-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2020 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2020-12-01') - 1 year AND '2020-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2020 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2021-01-01') - 1 year AND '2021-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2020 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2021
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_1yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2021-02-01') - 1 year AND '2021-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2021 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2021-03-01') - 1 year AND '2021-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2021 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2021-04-01') - 1 year AND '2021-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2021 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2021-05-01') - 1 year AND '2021-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2021 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2021-06-01') - 1 year AND '2021-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2021 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2021-07-01') - 1 year AND '2021-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2021 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2021-08-01') - 1 year AND '2021-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2021 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2021-09-01') - 1 year AND '2021-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2021 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2021-10-01') - 1 year AND '2021-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2021 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2021-11-01') - 1 year AND '2021-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2021 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2021-12-01') - 1 year AND '2021-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2021 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2022-01-01') - 1 year AND '2022-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2021 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2022
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_1yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2022-02-01') - 1 year AND '2022-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2022 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2022-03-01') - 1 year AND '2022-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2022 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2022-04-01') - 1 year AND '2022-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2022 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2022-05-01') - 1 year AND '2022-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2022 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2022-06-01') - 1 year AND '2022-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2022 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2022-07-01') - 1 year AND '2022-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2022 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2022-08-01') - 1 year AND '2022-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2022 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2022-09-01') - 1 year AND '2022-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2022 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2022-10-01') - 1 year AND '2022-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2022 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2022-11-01') - 1 year AND '2022-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2022 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2022-12-01') - 1 year AND '2022-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2022 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2023-01-01') - 1 year AND '2023-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2022 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;


-- Section 2. 5yr lookback

CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG_5yr');

CREATE TABLE SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG_5yr
(
	alf_e			BIGINT,
	bmi_month		VARCHAR(50),
	bmi_year		CHAR(4),
	bmi_cat			VARCHAR(50)

);

-- year 2000
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG_5yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2000-02-01') - 5 year AND '2000-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2000 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2000-03-01') - 5 year AND '2000-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2000 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2000-04-01') - 5 year AND '2000-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2000 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2000-05-01') - 5 year AND '2000-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2000 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2000-06-01') - 5 year AND '2000-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2000 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2000-07-01') - 5 year AND '2000-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2000 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2000-08-01') - 5 year AND '2000-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2000 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2000-09-01') - 5 year AND '2000-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2000 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2000-10-01') - 5 year AND '2000-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2000 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2000-11-01') - 5 year AND '2000-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2000 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2000-12-01') - 5 year AND '2000-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2000 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2001-01-01') - 5 year AND '2001-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2000 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2001
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG_5yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2001-02-01') - 5 year AND '2001-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2001 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2001-03-01') - 5 year AND '2001-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2001 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2001-04-01') - 5 year AND '2001-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2001 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2001-05-01') - 5 year AND '2001-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2001 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2001-06-01') - 5 year AND '2001-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2001 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2001-07-01') - 5 year AND '2001-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2001 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2001-08-01') - 5 year AND '2001-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2001 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2001-09-01') - 5 year AND '2001-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2001 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2001-10-01') - 5 year AND '2001-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2001 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2001-11-01') - 5 year AND '2001-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2001 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2001-12-01') - 5 year AND '2001-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2001 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2002-01-01') - 5 year AND '2002-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2001 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2002
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG_5yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2002-02-01') - 5 year AND '2002-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2002 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2002-03-01') - 5 year AND '2002-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2002 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2002-04-01') - 5 year AND '2002-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2002 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2002-05-01') - 5 year AND '2002-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2002 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2002-06-01') - 5 year AND '2002-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2002 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2002-07-01') - 5 year AND '2002-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2002 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2002-08-01') - 5 year AND '2002-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2002 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2002-09-01') - 5 year AND '2002-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2002 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2002-10-01') - 5 year AND '2002-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2002 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2002-11-01') - 5 year AND '2002-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2002 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2002-12-01') - 5 year AND '2002-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2002 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2003-01-01') - 5 year AND '2003-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2002 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2003
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG_5yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2003-02-01') - 5 year AND '2003-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2003 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2003-03-01') - 5 year AND '2003-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2003 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2003-04-01') - 5 year AND '2003-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2003 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2003-05-01') - 5 year AND '2003-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2003 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2003-06-01') - 5 year AND '2003-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2003 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2003-07-01') - 5 year AND '2003-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2003 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2003-08-01') - 5 year AND '2003-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2003 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2003-09-01') - 5 year AND '2003-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2003 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2003-10-01') - 5 year AND '2003-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2003 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2003-11-01') - 5 year AND '2003-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2003 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2003-12-01') - 5 year AND '2003-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2003 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2004-01-01') - 5 year AND '2004-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2003 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2004
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG_5yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2004-02-01') - 5 year AND '2004-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2004 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2004-03-01') - 5 year AND '2004-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2004 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2004-04-01') - 5 year AND '2004-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2004 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2004-05-01') - 5 year AND '2004-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2004 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2004-06-01') - 5 year AND '2004-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2004 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2004-07-01') - 5 year AND '2004-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2004 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2004-08-01') - 5 year AND '2004-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2004 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2004-09-01') - 5 year AND '2004-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2004 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2004-10-01') - 5 year AND '2004-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2004 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2004-11-01') - 5 year AND '2004-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2004 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2004-12-01') - 5 year AND '2004-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2004 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2005-01-01') - 5 year AND '2005-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2004 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2005
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG_5yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2005-02-01') - 5 year AND '2005-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2005 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2005-03-01') - 5 year AND '2005-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2005 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2005-04-01') - 5 year AND '2005-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2005 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2005-05-01') - 5 year AND '2005-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2005 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2005-06-01') - 5 year AND '2005-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2005 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2005-07-01') - 5 year AND '2005-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2005 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2005-08-01') - 5 year AND '2005-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2005 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2005-09-01') - 5 year AND '2005-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2005 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2005-10-01') - 5 year AND '2005-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2005 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2005-11-01') - 5 year AND '2005-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2005 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2005-12-01') - 5 year AND '2005-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2005 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2006-01-01') - 5 year AND '2006-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2005 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2006
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG_5yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2006-02-01') - 5 year AND '2006-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2006 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2006-03-01') - 5 year AND '2006-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2006 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2006-04-01') - 5 year AND '2006-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2006 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2006-05-01') - 5 year AND '2006-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2006 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2006-06-01') - 5 year AND '2006-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2006 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2006-07-01') - 5 year AND '2006-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2006 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2006-08-01') - 5 year AND '2006-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2006 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2006-09-01') - 5 year AND '2006-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2006 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2006-10-01') - 5 year AND '2006-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2006 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2006-11-01') - 5 year AND '2006-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2006 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2006-12-01') - 5 year AND '2006-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2006 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2007-01-01') - 5 year AND '2007-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2006 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2007
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG_5yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2007-02-01') - 5 year AND '2007-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2007 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2007-03-01') - 5 year AND '2007-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2007 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2007-04-01') - 5 year AND '2007-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2007 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2007-05-01') - 5 year AND '2007-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2007 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2007-06-01') - 5 year AND '2007-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2007 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2007-07-01') - 5 year AND '2007-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2007 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2007-08-01') - 5 year AND '2007-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2007 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2007-09-01') - 5 year AND '2007-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2007 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2007-10-01') - 5 year AND '2007-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2007 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2007-11-01') - 5 year AND '2007-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2007 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2007-12-01') - 5 year AND '2007-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2007 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2008-01-01') - 5 year AND '2008-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2007 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2008
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG_5yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2008-02-01') - 5 year AND '2008-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2008 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2008-03-01') - 5 year AND '2008-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2008 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2008-04-01') - 5 year AND '2008-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2008 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2008-05-01') - 5 year AND '2008-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2008 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2008-06-01') - 5 year AND '2008-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2008 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2008-07-01') - 5 year AND '2008-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2008 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2008-08-01') - 5 year AND '2008-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2008 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2008-09-01') - 5 year AND '2008-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2008 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2008-10-01') - 5 year AND '2008-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2008 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2008-11-01') - 5 year AND '2008-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2008 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2008-12-01') - 5 year AND '2008-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2008 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2009-01-01') - 5 year AND '2009-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2008 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2009
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_5yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2009-02-01') - 5 year AND '2009-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2009 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2009-03-01') - 5 year AND '2009-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2009 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2009-04-01') - 5 year AND '2009-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2009 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2009-05-01') - 5 year AND '2009-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2009 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2009-06-01') - 5 year AND '2009-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2009 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2009-07-01') - 5 year AND '2009-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2009 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2009-08-01') - 5 year AND '2009-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2009 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2009-09-01') - 5 year AND '2009-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2009 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2009-10-01') - 5 year AND '2009-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2009 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2009-11-01') - 5 year AND '2009-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2009 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2009-12-01') - 5 year AND '2009-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2009 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2010-01-01') - 5 year AND '2010-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2009 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2010
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_5yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2010-02-01') - 5 year AND '2010-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2010 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2010-03-01') - 5 year AND '2010-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2010 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2010-04-01') - 5 year AND '2010-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2010 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2010-05-01') - 5 year AND '2010-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2010 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2010-06-01') - 5 year AND '2010-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2010 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2010-07-01') - 5 year AND '2010-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2010 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2010-08-01') - 5 year AND '2010-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2010 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2010-09-01') - 5 year AND '2010-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2010 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2010-10-01') - 5 year AND '2010-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2010 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2010-11-01') - 5 year AND '2010-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2010 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2010-12-01') - 5 year AND '2010-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2010 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2011-01-01') - 5 year AND '2011-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2010 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2011
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_5yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2011-02-01') - 5 year AND '2011-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2011 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2011-03-01') - 5 year AND '2011-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2011 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2011-04-01') - 5 year AND '2011-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2011 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2011-05-01') - 5 year AND '2011-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2011 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2011-06-01') - 5 year AND '2011-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2011 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2011-07-01') - 5 year AND '2011-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2011 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2011-08-01') - 5 year AND '2011-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2011 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2011-09-01') - 5 year AND '2011-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2011 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2011-10-01') - 5 year AND '2011-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2011 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2011-11-01') - 5 year AND '2011-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2011 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2011-12-01') - 5 year AND '2011-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2011 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2012-01-01') - 5 year AND '2012-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2011 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2012
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_5yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2012-02-01') - 5 year AND '2012-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2012 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2012-03-01') - 5 year AND '2012-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2012 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2012-04-01') - 5 year AND '2012-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2012 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2012-05-01') - 5 year AND '2012-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2012 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2012-06-01') - 5 year AND '2012-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2012 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2012-07-01') - 5 year AND '2012-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2012 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2012-08-01') - 5 year AND '2012-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2012 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2012-09-01') - 5 year AND '2012-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2012 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2012-10-01') - 5 year AND '2012-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2012 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2012-11-01') - 5 year AND '2012-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2012 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2012-12-01') - 5 year AND '2012-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2012 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2013-01-01') - 5 year AND '2013-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2012 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2013
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_5yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2013-02-01') - 5 year AND '2013-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2013 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2013-03-01') - 5 year AND '2013-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2013 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2013-04-01') - 5 year AND '2013-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2013 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2013-05-01') - 5 year AND '2013-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2013 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2013-06-01') - 5 year AND '2013-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2013 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2013-07-01') - 5 year AND '2013-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2013 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2013-08-01') - 5 year AND '2013-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2013 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2013-09-01') - 5 year AND '2013-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2013 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2013-10-01') - 5 year AND '2013-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2013 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2013-11-01') - 5 year AND '2013-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2013 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2013-12-01') - 5 year AND '2013-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2013 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2014-01-01') - 5 year AND '2014-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2013 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2014
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_5yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2014-02-01') - 5 year AND '2014-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2014 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2014-03-01') - 5 year AND '2014-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2014 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2014-04-01') - 5 year AND '2014-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2014 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2014-05-01') - 5 year AND '2014-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2014 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2014-06-01') - 5 year AND '2014-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2014 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2014-07-01') - 5 year AND '2014-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2014 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2014-08-01') - 5 year AND '2014-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2014 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2014-09-01') - 5 year AND '2014-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2014 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2014-10-01') - 5 year AND '2014-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2014 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2014-11-01') - 5 year AND '2014-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2014 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2014-12-01') - 5 year AND '2014-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2014 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2015-01-01') - 5 year AND '2015-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2014 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2015
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_5yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2015-02-01') - 5 year AND '2015-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2015 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2015-03-01') - 5 year AND '2015-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2015 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2015-04-01') - 5 year AND '2015-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2015 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2015-05-01') - 5 year AND '2015-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2015 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2015-06-01') - 5 year AND '2015-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2015 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2015-07-01') - 5 year AND '2015-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2015 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2015-08-01') - 5 year AND '2015-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2015 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2015-09-01') - 5 year AND '2015-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2015 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2015-10-01') - 5 year AND '2015-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2015 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2015-11-01') - 5 year AND '2015-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2015 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2015-12-01') - 5 year AND '2015-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2015 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2016-01-01') - 5 year AND '2016-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2015 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2016
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_5yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2016-02-01') - 5 year AND '2016-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2016 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2016-03-01') - 5 year AND '2016-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2016 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2016-04-01') - 5 year AND '2016-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2016 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2016-05-01') - 5 year AND '2016-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2016 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2016-06-01') - 5 year AND '2016-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2016 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2016-07-01') - 5 year AND '2016-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2016 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2016-08-01') - 5 year AND '2016-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2016 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2016-09-01') - 5 year AND '2016-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2016 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2016-10-01') - 5 year AND '2016-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2016 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2016-11-01') - 5 year AND '2016-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2016 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2016-12-01') - 5 year AND '2016-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2016 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2017-01-01') - 5 year AND '2017-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2016 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2017
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_5yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2017-02-01') - 5 year AND '2017-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2017 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2017-03-01') - 5 year AND '2017-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2017 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2017-04-01') - 5 year AND '2017-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2017 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2017-05-01') - 5 year AND '2017-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2017 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2017-06-01') - 5 year AND '2017-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2017 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2017-07-01') - 5 year AND '2017-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2017 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2017-08-01') - 5 year AND '2017-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2017 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2017-09-01') - 5 year AND '2017-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2017 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2017-10-01') - 5 year AND '2017-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2017 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2017-11-01') - 5 year AND '2017-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2017 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2017-12-01') - 5 year AND '2017-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2017 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2018-01-01') - 5 year AND '2018-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2017 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2018
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_5yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2018-02-01') - 5 year AND '2018-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2018 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2018-03-01') - 5 year AND '2018-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2018 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2018-04-01') - 5 year AND '2018-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2018 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2018-05-01') - 5 year AND '2018-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2018 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2018-06-01') - 5 year AND '2018-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2018 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2018-07-01') - 5 year AND '2018-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2018 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2018-08-01') - 5 year AND '2018-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2018 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2018-09-01') - 5 year AND '2018-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2018 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2018-10-01') - 5 year AND '2018-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2018 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2018-11-01') - 5 year AND '2018-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2018 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2018-12-01') - 5 year AND '2018-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2018 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2019-01-01') - 5 year AND '2019-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2018 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2019
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_5yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2019-02-01') - 5 year AND '2019-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2019 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2019-03-01') - 5 year AND '2019-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2019 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2019-04-01') - 5 year AND '2019-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2019 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2019-05-01') - 5 year AND '2019-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2019 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2019-06-01') - 5 year AND '2019-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2019 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2019-07-01') - 5 year AND '2019-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2019 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2019-08-01') - 5 year AND '2019-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2019 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2019-09-01') - 5 year AND '2019-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2019 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2019-10-01') - 5 year AND '2019-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2019 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2019-11-01') - 5 year AND '2019-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2019 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2019-12-01') - 5 year AND '2019-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2019 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2020-01-01') - 5 year AND '2020-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2019 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2020
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_5yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2020-02-01') - 5 year AND '2020-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2020 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2020-03-01') - 5 year AND '2020-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2020 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2020-04-01') - 5 year AND '2020-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2020 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2020-05-01') - 5 year AND '2020-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2020 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2020-06-01') - 5 year AND '2020-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2020 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2020-07-01') - 5 year AND '2020-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2020 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2020-08-01') - 5 year AND '2020-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2020 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2020-09-01') - 5 year AND '2020-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2020 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2020-10-01') - 5 year AND '2020-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2020 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2020-11-01') - 5 year AND '2020-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2020 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2020-12-01') - 5 year AND '2020-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2020 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2021-01-01') - 5 year AND '2021-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2020 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2021
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_5yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2021-02-01') - 5 year AND '2021-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2021 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2021-03-01') - 5 year AND '2021-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2021 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2021-04-01') - 5 year AND '2021-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2021 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2021-05-01') - 5 year AND '2021-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2021 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2021-06-01') - 5 year AND '2021-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2021 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2021-07-01') - 5 year AND '2021-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2021 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2021-08-01') - 5 year AND '2021-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2021 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2021-09-01') - 5 year AND '2021-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2021 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2021-10-01') - 5 year AND '2021-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2021 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2021-11-01') - 5 year AND '2021-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2021 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2021-12-01') - 5 year AND '2021-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2021 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2022-01-01') - 5 year AND '2022-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2021 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2022
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_Long_5yr
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2022-02-01') - 5 year AND '2022-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2022 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2022-03-01') - 5 year AND '2022-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2022 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2022-04-01') - 5 year AND '2022-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2022 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2022-05-01') - 5 year AND '2022-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2022 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2022-06-01') - 5 year AND '2022-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2022 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2022-07-01') - 5 year AND '2022-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2022 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2022-08-01') - 5 year AND '2022-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2022 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2022-09-01') - 5 year AND '2022-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2022 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2022-10-01') - 5 year AND '2022-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2022 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2022-11-01') - 5 year AND '2022-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2022 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2022-12-01') - 5 year AND '2022-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2022 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt BETWEEN date('2023-01-01') - 5 year AND '2023-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2022 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- Section 3. all years lookback


CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG');

CREATE TABLE SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG
(
	alf_e			BIGINT,
	bmi_month		VARCHAR(50),
	bmi_year		CHAR(4),
	bmi_cat			VARCHAR(50)

);

-- year 2000
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2000-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2000 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2000-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2000 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2000-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2000 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2000-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2000 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2000-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2000 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2000-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2000 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2000-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2000 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2000-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2000 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2000-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2000 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2000-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2000 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2000-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2000 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2000' AS bmi_month,
	'2000' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2001-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2000 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2001
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2001-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2001 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2001-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2001 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2001-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2001 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2001-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2001 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2001-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2001 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2001-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2001 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2001-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2001 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2001-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2001 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2001-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2001 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2001-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2001 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2001-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2001 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2001' AS bmi_month,
	'2001' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2002-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2001 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2002
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2002-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2002 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2002-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2002 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2002-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2002 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2002-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2002 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2002-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2002 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2002-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2002 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2002-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2002 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2002-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2002 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2002-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2002 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2002-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2002 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2002-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2002 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2002' AS bmi_month,
	'2002' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2003-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2002 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;


-- year 2003
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2003-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2003 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2003-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2003 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2003-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2003 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2003-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2003 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2003-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2003 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2003-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2003 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2003-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2003 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2003-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2003 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2003-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2003 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2003-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2003 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2003-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2003 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2003' AS bmi_month,
	'2003' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2004-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2003 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2004
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2004-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2004 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2004-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2004 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2004-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2004 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2004-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2004 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2004-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2004 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2004-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2004 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2004-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2004 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2004-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2004 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2004-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2004 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2004-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2004 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2004-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2004 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2004' AS bmi_month,
	'2004' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2005-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2004 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2005
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2005-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2005 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2005-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2005 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2005-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2005 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2005-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2005 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2005-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2005 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2005-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2005 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2005-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2005 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2005-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2005 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2005-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2005 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2005-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2005 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2005-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2005 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2005' AS bmi_month,
	'2005' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2006-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2005 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2006
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2006-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2006 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2006-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2006 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2006-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2006 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2006-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2006 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2006-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2006 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2006-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2006 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2006-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2006 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2006-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2006 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2006-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2006 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2006-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2006 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2006-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2006 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2006' AS bmi_month,
	'2006' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2007-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2006 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2007
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2007-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2007 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2007-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2007 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2007-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2007 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2007-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2007 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2007-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2007 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2007-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2007 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2007-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2007 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2007-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2007 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2007-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2007 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2007-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2007 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2007-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2007 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2007' AS bmi_month,
	'2007' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2008-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2007 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2008
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2008-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2008 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2008-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2008 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2008-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2008 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2008-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2008 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2008-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2008 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2008-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2008 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2008-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2008 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2008-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2008 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2008-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2008 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2008-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2008 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2008-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2008 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2008' AS bmi_month,
	'2008' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2009-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2008 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2009
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2009-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2009 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2009-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2009 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2009-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2009 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2009-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2009 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2009-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2009 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2009-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2009 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2009-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2009 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2009-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2009 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2009-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2009 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2009-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2009 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2009-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2009 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2009' AS bmi_month,
	'2009' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2010-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2009 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;



-- year 2010
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2010-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2010 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2010-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2010 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2010-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2010 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2010-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2010 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2010-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2010 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2010-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2010 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2010-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2010 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2010-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2010 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2010-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2010 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2010-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2010 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2010-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2010 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2010' AS bmi_month,
	'2010' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2011-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2010 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;


-- year 2011
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2011-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2011 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2011-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2011 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2011-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2011 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2011-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2011 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2011-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2011 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2011-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2011 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2011-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2011 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2011-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2011 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2011-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2011 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2011-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2011 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2011-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2011 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2011' AS bmi_month,
	'2011' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2012-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2011 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2012
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2012-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2012 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2012-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2012 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2012-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2012 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2012-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2012 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2012-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2012 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2012-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2012 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2012-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2012 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2012-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2012 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2012-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2012 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2012-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2012 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2012-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2012 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2012' AS bmi_month,
	'2012' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2013-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2012 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;


-- year 2013
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2013-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2013 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2013-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2013 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2013-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2013 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2013-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2013 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2013-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2013 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2013-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2013 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2013-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2013 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2013-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2013 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2013-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2013 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2013-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2013 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2013-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2013 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2013' AS bmi_month,
	'2013' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2014-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2013 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2014
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2014-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2014 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2014-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2014 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2014-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2014 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2014-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2014 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2014-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2014 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2014-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2014 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2014-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2014 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2014-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2014 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2014-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2014 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2014-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2014 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2014-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2014 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2014' AS bmi_month,
	'2014' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2015-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2014 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2015
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2015-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2015 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2015-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2015 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2015-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2015 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2015-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2015 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2015-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2015 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2015-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2015 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2015-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2015 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2015-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2015 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2015-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2015 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2015-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2015 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2015-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2015 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2015' AS bmi_month,
	'2015' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2016-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2015 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2016
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2016-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2016 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2016-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2016 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2016-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2016 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2016-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2016 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2016-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2016 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2016-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2016 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2016-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2016 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2016-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2016 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2016-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2016 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2016-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2016 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2016-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2016 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2016' AS bmi_month,
	'2016' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2017-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2016 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2017
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2017-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2017 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2017-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2017 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2017-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2017 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2017-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2017 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2017-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2017 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2017-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2017 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2017-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2017 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2017-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2017 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2017-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2017 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2017-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2017 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2017-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2017 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2017' AS bmi_month,
	'2017' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2018-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2017 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2018
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2018-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2018 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2018-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2018 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2018-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2018 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2018-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2018 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2018-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2018 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2018-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2018 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2018-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2018 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2018-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2018 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2018-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2018 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2018-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2018 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2018-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2018 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2018' AS bmi_month,
	'2018' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2019-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2018 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2019
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2019-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2019 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2019-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2019 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2019-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2019 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2019-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2019 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2019-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2019 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2019-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2019 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2019-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2019 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2019-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2019 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2019-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2019 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2019-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2019 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2019-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2019 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2019' AS bmi_month,
	'2019' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2020-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2019 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;


-- year 2020
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2020-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2020 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2020-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2020 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2020-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2020 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2020-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2020 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2020-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2020 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2020-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2020 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2020-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2020 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2020-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2020 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2020-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2020 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2020-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2020 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2020-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2020 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2020' AS bmi_month,
	'2020' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2021-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2020 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2021
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2021-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2021 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2021-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2021 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2021-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2021 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2021-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2021 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2021-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2021 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2021-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2021 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2021-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2021 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2021-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2021 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2021-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2021 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2021-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2021 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2021-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2021 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2021' AS bmi_month,
	'2021' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2022-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2021 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

-- year 2022
INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG
WITH main AS 
(
SELECT DISTINCT 
	ALF_E
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM
),
t1 AS 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'01-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2022-02-01'
		) 
	WHERE dt_order = 1
	) jan
ON main.alf_e = jan.alf_e
WHERE denom_year = 2022 AND denom_month = 1 AND cohort = 1
),
t2 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'02-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2022-03-01'
		) 
	WHERE dt_order = 1
	) feb
ON main.alf_e = feb.alf_e
WHERE denom_year = 2022 AND denom_month = 2 AND cohort = 1
),
t3 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'03-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2022-04-01'
		) 
	WHERE dt_order = 1
	) mar
ON main.alf_e = mar.alf_e
WHERE denom_year = 2022 AND denom_month = 3 AND cohort = 1
),
t4 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'04-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2022-05-01'
		) 
	WHERE dt_order = 1
	) apr
ON main.alf_e = apr.alf_e
WHERE denom_year = 2022 AND denom_month = 4 AND cohort = 1
),
t5 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'05-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2022-06-01'
		) 
	WHERE dt_order = 1
	) may
ON main.alf_e = may.alf_e
WHERE denom_year = 2022 AND denom_month = 5 AND cohort = 1
),
t6 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'06-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmicat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2022-07-01'
		) 
	WHERE dt_order = 1
	) jun
ON main.alf_e = jun.alf_e
WHERE denom_year = 2022 AND denom_month = 6 AND cohort = 1
),
t7 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'07-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2022-08-01'
		) 
	WHERE dt_order = 1
	) jul
ON main.alf_e = jul.alf_e
WHERE denom_year = 2022 AND denom_month = 7 AND cohort = 1
),
t8 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'08-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2022-09-01'
		) 
	WHERE dt_order = 1
	) aug
ON main.alf_e = aug.alf_e
WHERE denom_year = 2022 AND denom_month = 8 AND cohort = 1
),
t9 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'09-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2022-10-01'
		) 
	WHERE dt_order = 1
	) sep
ON main.alf_e = sep.alf_e
WHERE denom_year = 2022 AND denom_month = 9 AND cohort = 1
),
t10 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'10-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2022-11-01'
		) 
	WHERE dt_order = 1
	) oct
ON main.alf_e = oct.alf_e
WHERE denom_year = 2022 AND denom_month = 10 AND cohort = 1
),
t11 as
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'11-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2022-12-01'
		) 
	WHERE dt_order = 1
	) nov
ON main.alf_e = nov.alf_e
WHERE denom_year = 2022 AND denom_month = 11 AND cohort = 1
),
t12 as 
(
SELECT 
	main.alf_e,
	wob,
	dod,
	'12-2022' AS bmi_month,
	'2022' AS bmi_year,
	CASE
		WHEN bmi_cat IS NOT NULL THEN bmi_cat
		ELSE 'Unknown'
		END AS bmi_cat
FROM
	SAILW1151V.HDR25_BMI_POP_DENOM main
LEFT JOIN
	(
	SELECT 
		*
	FROM
		(
		SELECT
			alf_e,
			bmi_cat,
			ROW_NUMBER() OVER (PARTITION BY alf_e ORDER BY bmi_dt desc) AS dt_order
		FROM
			SAILW1151V.HDR25_BMI_CLEAN_ADULTS 
		WHERE bmi_dt < '2023-01-01'
		) 
	WHERE dt_order = 1
	) dece
ON main.alf_e = dece.alf_e
WHERE denom_year = 2022 AND denom_month = 12 AND cohort = 1
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
SELECT 
	alf_e, 
	bmi_month, 
	bmi_year, 
	bmi_cat 
FROM union_tables;

------ SECTION 4 - creating counts OF BMI categories FOR preservation tables
CALL FNC.DROP_IF_EXISTS ('SAILW1151V.HDR25_BMI_CAT_DENOM_AGG_TABLE');

CREATE TABLE SAILW1151V.HDR25_BMI_CAT_DENOM_AGG_TABLE
(
	lookback 			VARCHAR(10),
	bmi_year			CHAR(4),
	bmi_month			VARCHAR(50),
	BMI_CAT				VARCHAR(50),
	counts				integer
);

INSERT INTO SAILW1151V.HDR25_BMI_CAT_DENOM_AGG_TABLE
SELECT
	*
FROM
	(
	SELECT
		'1YR' AS lookback,
		bmi_year,
		bmi_month,
		BMI_CAT,
		count(alf_e) AS counts
	FROM 
		SAILW1151V.HDR25_BMI_CAT_DENOM_adult_LONG_1YR
	GROUP BY bmi_year, bmi_month, BMI_CAT
	UNION ALL
	SELECT
		'5YR' AS lookback,
		bmi_year,
		bmi_month,
		BMI_CAT,
		count(alf_e) AS counts 
	FROM 
		SAILW1151V.HDR25_BMI_CAT_DENOM_adult_LONG_5YR
	GROUP BY bmi_year, bmi_month, BMI_CAT
	UNION ALL 
	SELECT 
		'ALL' AS lookback,
		bmi_year,
		bmi_month,
		BMI_CAT,
		count(alf_e) AS counts
	FROM SAILW1151V.HDR25_BMI_CAT_DENOM_ADULT_LONG
	GROUP BY bmi_year, bmi_month, BMI_CAT
	)
WHERE counts > 10;
