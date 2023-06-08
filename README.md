# Bridging the gap: Development of a methodology for retrieving and harmonising Body Mass Index (BMI) from population-level linked electronic health records.

### Michael Jeanne Childs <sup>1*</sup> , Sarah J Aldridge <sup>1</sup>, Helen Daniels <sup>1</sup>, Gareth Davies <sup>1</sup>, Victoria Best <sup>1</sup>, Hoda Abbasizanjani <sup>1</sup>, Ronan A Lyons <sup>1</sup>, Fatemeh Torabi <sup>1a</sup>, Ashley Akbari <sup>1a</sup> <br>
 
<sup>1</sup> Population Data Science, Swansea University Medical School, Faculty of Medicine, Health & Life Science, Swansea University, Wales, UK. SA2 8PP.<br> 

<sup>*</sup> Corresponding author<br>
<sup>a</sup>  Senior authors <br>

### Abstract 

**Background** Body Mass Index (BMI) is directly recorded in routinely-collected electronic health record (EHR) data or can be derived from recorded height and weight. The quality and consistency of these records are variable over time and between systems resulting in a high percentage of reported missingness. It is unknown whether accessing BMI data from multiple linked data sources over a longitudinal period will result in improved record capture and reduced missingness. We aimed to assess improvements in the completeness of available BMI records across the whole population of Wales through longitudinal linked data sources. 

**Methods** We assessed BMI records over 23 years (2000 to 2022) from four routinely-collected EHR data sources. Records were extracted for the entire population of Wales-UK, and the effect of longitudinal record capturing was assessed using three approaches: I) preserving all records for the entire study period II) preserving records in 5-year intervals and III) only preserving annual recorded measures. BMI completeness was assessed separately for children and young people (CYP; 2-18 years old) and adults (19-100 years old) through an annual record completeness percentage. The whole methodology for records extraction and processing is documented and packaged in a methodological algorithm which enables any research study to generate a harmonised longitudinal research ready data asset (RRDA) from population-scale EHR data. 

**Results** We retrieved a total of 53.42 million records for 3.435 million individuals across 23 years of longitudinal data.  Of individuals who have >= 5 years of follow-up data, only 1.94% of CYP and 25% of adults have a BMI record for >= 5 year. We achieved an overall completeness rate of 64% and 73% coverage for the CYP and adult cohorts respectively for the study period (2000-2022) and for 31% and 50% of the CYP and adult cohorts respectively for five years preservation (2018-2022). This dropped to 9% and 25% for the CYP and adult cohorts respectively when preserving for 1 year only (2021-2022). 

**Conclusions** This methodology improved overall CYP cohort BMI coverage by 54% and adult cohort coverage by less than 2% when using all data available in SAIL Databank compared to only using primary care data. The current methodology also showed that preserving annual BMI records across the study period has increased the coverage by 36% for CYP and 23% for the adult cohort compared to only preserving for 5 years. Our methodology and RRDA provide a reproducible and maintainable approach to the extraction and harmonisation of BMI data which many research studies could replicate in other trusted research environments (TRE) and settings that contain similar EHR data. 

### Content

This repository holds the BMI algorithm which can be impelemented in any data environment following these steps and correct setting of parameters:
* To extract data from base data sources see <a href="[/about/about_team.htm](https://swanseauniversity.sharepoint.com/:w:/r/sites/HDR-UK-TeamAndProjects-UsrGrp/_layouts/15/Doc.aspx?sourcedoc=%7B814A024F-C958-4624-9182-C1F0C5B24175%7D&file=Manuscript%20.docx&action=default&mobileredirect=true)">this</a> 
* To combine and clean data see <a href="https://github.com/SwanseaUniversityMedical/BMI_algorithm/tree/a8a817c33a2c08ca9c51caa7042c50c08772004a/Algorithm">this</a> <br>

If you are interested in development and collaboration on this work please get in touch with the lead and senior authors<br>