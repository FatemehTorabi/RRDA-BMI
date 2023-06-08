Code created by m.j.childs@swansea.ac.uk

This folder contains scripts used to generate TableOne (yearly breakdown and grouped into 5 years at a time) and preservation of BMI (1 year, 5 years, and across the study).

The extraction of BMI records should have been already done (see appropriate folder for your cohort, i.e., CYP / Adults)

00. Report for the algorithm
    -- This code was used to create the consort, upset plots, and individual's contribution to the BMI data.

        1. Consort chunk:
        EXTRACTING ENTRIES FROM DATA SOURCES
            Layer 1.1. We count the number of distinct (valid) alf and total entries from each database 
            Layer 1.2. We then exclude those alfs and entries that were
                a. outside the study period (dt < study start date OR dt > study end date) -- before or after the study start date
                b. do not have a good quality link (sts_cd NOT IN ('1', '4', '39').
            Layer 1.3. We then count how many distinct alfs and total entries are eligible in our study
                a. dt between study_start AND study_end dates
                b. sts_cd in ('1', '4', '39')
            Layer 1.4. We then count distinct alfs and total entries that are not related to BMI
                a. WLGP - those with Read codes outside the BMI Lookup table
                b. PEDW - those with diagnoses outside Obesity
                c. MIDS - those with no height AND weight entries
                d. NCCH - those with no height AND weight entries
            Layer 1.5. We count the distinct alfs and total entries that are BMI related
                a. WLGP - those with Read codes from BMI Lookup table
                b. PEDW - those with diagnoses of Obesity
                c. MIDS - those with at least one height OR one weight entries
                d. NCCH - those with at least one height OR weight entries  

        PUTTING TOGETHER ENTRIES FROM DATA SOURCES IN ONE TABLE
            Layer 2.1 Counting distinct entries from all the data sources put together (we then link this table to WDSD)
            Layer 2.2 Removing distinct alfs and entries with no valid demographic information:
                a. invalid WOB,
                b. invalid gndr_cd,
                c. died before the study start date
                d. died < 31 days after the study start date.
            Layer 2.3 Counting the final general COMBO table.

        BRANCHING TO ADULT COHORT
            Layer 3.1.1 Branching to adult cohort
                a. Removing height entries that were not the most recent
                b. Removing entries that were done when ALF was not an adult (0-18)
                c. Removing entries that were from NCCH data source
            Layer 3.1.2 Counting the distinct alf and total entries for Adult cohort
            Layer 4.1.1 Counting entries that are flagged as inconsistent
            Layer 4.1.2 Flagged as 1
            Layer 4.1.3 Flagged as 3
            Layer 4.1.4 Flagged as 2/4
            Layer 4.1.5 Entries not flagged
            Layer 5.1 Counting distinct alf and total entries for ADULT final output.

        BRANCHING TO CYP COHORT
            Layer 3.2.1 Removing entries when ALF were 0-1 and 19-100yo
            Layer 3.2.2 Removing height and weight pairs that were > 180 days gap
            Layer 3.2.3 Removing BMI value entries with no percentile or z-score
            Layer 3.2.4 Counting the distinct alf and total entries for CYP cohort
            Layer 4.2.1 Counting entries that are flagged as inconsistent
            Layer 4.2.2 Flagged as 1
            Layer 4.2.3 Flagged as 2
            Layer 4.2.4 Entries not flagged
            Layer 5.2 Counting distinct alf and total entries for CYP final output.

        2. BMI yearly counts.
            This section first calculates the number of days the ALF has contributed to the data (up to 1 year - up to 23 years). Record contribution for ALFs have been set to the study start date or the earliest available record, and the contribution stops on their date of death or when they moved out. Additionally, for children (up to 1 year - up to 19 years), they stop contributing to the CYP cohort after they turned 18.

            When individuals have a BMI reading for that year, they get a count of 1, and then this was summed up to get a total count of how many years they have a BMI record for.

            We then aggregate on contibution to get the proportion of individuals with yearly counts for each length of contribution years.
            This generates table BMI_YEARLY_COUNTS_ADULTS/CYP.
        
        3. Upset plots chunk
            -- This section counts the number of ALFs with sources from only one source or those with multiple sources. This is used to determine the improvement on completeness rates of BMI records when adding other data sources to WLGP.
            This is divided into three sections:
                1. Upset plot table for ALL ALFs with at least 1 BMI record. This uses the general BMI_COMBO and gives the counts of the contribution before any hierarchy or data cleaning has been applied.
                2. Upset plot table for CYP - uses BMI_UNCLEAN_CYP to count the contribution of data before removal of flags and lesser hierarchy entries.
                3. Upset plot table for Adults - uses BMI_UNCLEAN_Adults
        

    


01. Creating population denominator table
   This code is the first step to creating TableOne. Here we get a monthly population denominator between 2000-2022.
    1. Find ALFs who lived in Wales for the particular month, e.g. Jan 2000.
    2. Allocate whether this ALF is an adult (1) or CYP (2) in that month.
    3. We only keep records that have a valid ALF, valid WOB, gndr_cd (1, 2), those who were alive on that month.
        NOTES: When an ALF dies within that month, they will not be included in that month, 
                e.g. if an ALF died on the 15th Feb, we will only collect information from them until 31 January.
                Each month will have a different distinct alf count as there will be deaths/movement in and out of Wales.
   4. This code is divided into yearly chunks (2000-2022) which creates a long table of all the individuals in Wales with their LSOA2011 information for each month-year. (BMI_POP_DENOM table)


02. TableOne - yearly breakdown:
    How to use this code:
        1. Input the following variables:
            a. Use ctrl + f to change the following:
                i. XXXX - input your schema number
                ii. alf_e - alter the alf_e format if needed
            b. Define your tables
                i. Cohort table - list of ALFs, sex, WOB, DOD, (set to NULL as appropriate), and lsoa2011_cd that you want to extract BMI records for. (see generation of BMI_POP_DENOM)
                ii. BMI output table - the output generated by the algorithm (if you haven't changed the names in the script, this will be SAILWXXXXV.BMI_CLEAN_CYP)
                iii. Ethnicity table - currently set to SAILW1151V.RRDA_ETHN. This table contains harmonised ethnicity data using 20 data sources.
                iv. WDSD table - this code used the single view WDSD table.
                v. WIMD2019 table - will need to have a table with LSOA code and WIMD2019 categories for residency information.
                vi. RURAL_URBAN table - will attach the rural urban classification to the dates of residency present for that year
    
    This script attaches the following to your cohort:
        1. BMI information from the algorithm output 
            (age band -- their age_band at time of BMI reading, 
            bmi_dt, -- when the BMI was recorded
            percentile_bmi_cat, -- allocated BMI category using percentiles (based from age in months and sex) from WHO guidelines
            bmi_year, -- year of BMI recording
            source_db), -- data source of BMI record.
        2. demographic information 
            (sex, 
            wod, 
            dod, 
            ethnicity) 
        3. residency information
            lsoa2011_cd,
            start_date,
            end_date, 
            wimd2019_quintile,
            rural_urban

    How the script works:
        1. The first stage of the script ('With T1 as' chunk) 
            a. takes all the ALFs (and their WOB, sex, dod, lsoa2011_cd) from your cohort, 
            b. attaches the ethnicity information from ETHNICITY TABLE
            c. if they are living in Wales for that year, for example, 2000:
                -- if they have a BMI reading in 2000, the most recent BMI data will be kept for that year, along with their age_band, bmi_dt, percentile_bmi_cat, bmi_year, and source_db.
                -- if they do not have a BMI reading in 2000,  they will be allocated 'Unknown' for percentile_bmi_cat and source_db. 
                    -- ALFs will be allocated an age_band using their WOB and end of year date.
                    -- ALFs will be allocated the bmi_year '2000' to reflect that they are living in Wales in 2000, but do not have a BMI reading.

        2. The second stage of the script (t2 chunk)
            a. Using LSOA2011_CD, we left join the WIMD2019 and rural urban data and remove duplicates.
            b. This will have LSOA2011_CD, WIMD2019, RURAL_URBAN columns that will be ready to attach to T1.

        3. The  third stage of the stage (t3 chunk)
            a. Attaches t1 to t2 using LSOA2011_CD.
            b. This creates a table for that particular year, e.g. 2000 - where all individuals living in Wales for that year will have BMI, demographic, and residency information.

    This is repeated for all the years you'd like to do. In this case, we have a yearly breakdown of characteristics between 2000-2022.
    NOTES: 
        1. There will be entries with bmi_year is NULL - this means they are not living in Wales for that year and will not be included in your TableOne.

03. TableOne - 5 year grouped
    The version with 5 year grouped runs the same as above, instead of having a yearly breakdown, it aggregates information from 2000-2004, 2005-2009, 2010-2014, 2015-2019, 2020-2022. This is the table we used for our main manuscript. The yearly breakdown was included in the Supplementary Material.


04. Preservation Tables:
     How to use this code:
        1. Input the following variables:
            a. Use ctrl + f to change the following:
                i. XXXX - input your schema number
                ii. alf_e - alter the alf_e format if needed
        2. Input your tables:
            a. Cohort table - This will use ALF_E, WOB, and DOD
            b. Output table - takes the most recent percentile_bmi_cat until the month-year that you are interested in.
        
    How the code works:
        1. It takes all the ALFs from your cohort (main chunk), then LEFT JOINS those ALFs living in Wales for the month-year period that you want to cover (T1 - T12).
        2. This code is divided into three sections: 1 year lookback, 5 year lookback, and all years lookback. 
            -- This means the script takes the most recent BMI record from 
                within 1 year of the date, 
                    for example, to get the 1 year lookback for January 2000: (where bmi_dt between date('2000-02-01) - 1 year AND '2000-02-01) all readings in the last year of 2000-02-01, i.e, including the last day of January.
                5 years, (where bmi_dt between date('2000-02-01) - 5 year AND '2000-02-01)
                or the most recent record (bmi_dt < 2000-02-01) -- the most recent record before the start of February.
            -- This is repeated for each month, with the month and year (bmi_month) being changed as appropriate.
            -- if no percentile_bmi_cat was recorded for that bmi_month, ALFs are allocated 'Unknown'.
        3. We then use UNION to put together the alf_e, bmi_month, bmi_year, percentile_bmi_cat.
        4. This creates a long table for for each lookback period separately:
            a. SAILWXXXXV.BMI_CAT_DENOM_CYP_LONG_1yr
            b. SAILWXXXXV.BMI_CAT_DENOM_CYP_LONG_5yr
            c. SAILWXXXXV.BMI_CAT_DENOM_CYP_LONG
        5. These long tables are then put together in SAILWXXXXV.percentile_bmi_cat_DENOM_AGG_TABLE which has the aggregate counts of how many BMI categories were there for each month-year period with the following fields:
            lookback 			VARCHAR(10), (1YR, 5YR, ALL)
            bmi_year			CHAR(4),   
            bmi_month			VARCHAR(50), 
            percentile_bmi_cat	VARCHAR(50),
            counts				integer
            -- This is the table used to create the stacked plots in R.



xx. BMI_R_Report.rmd
    This is the rmd file used to generate data visualisation that was used for the manuscript.
    This covers the objectives, methods, and procedures of the BMI algorithm and the results from the algorithm itself: Consort, BMI yearly counts, Upsetplots.

    Next, we presented the results from TableOne (grouped version) where we attached the BMI output to the population-level.

    Finally, we presented the results from Preservation table where we show the improvements in BMI data when we preserve within 1year or 5years before the study end date, and across the study period.

    Supplementary materials were also included.


