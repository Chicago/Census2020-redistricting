
# Folder structure / purpose


 - `data/RAW` - Contains copies of source data files, usually in compressed format. Files that are in use have been extracted to `./data` either directly or using a script. 

 - `data/CACHE` - This folder has scripts which were used to create temporary folders and to perform extractions for the project.  
   - For example `il2020.pl_COMBINE.R` unzips, combines, labels, and saves the PL data from `data/RAW/PL94-171-2020-ILLINOIS/il2020.pl.zip` to `data/CACHE/il2020.pl_COMBINED.csv`
   - Then `il2020.pl_COMBINED_FILTER.R` reads in the combined file and filters the table to the Block, Tract, and County levels (for the state of Illinois). 

 - `data/DOCUMENTATION` contains documentation of course
   - `data/RAW/DOCUMENTATION/PL94-171_redistricting/FrequentSummaryLevels.pdf` - very helpful for understanding the SUMLEV variable, which is used for filtering the PL data to one geography level. 
   - `data/RAW/DOCUMENTATION/PL94-171_redistricting/2020Census_PL94_171Redistricting_StatesTechDoc_English.pdf` - Describes the variables available in the demographic table, geographies, etc.  
   - `data/RAW/DOCUMENTATION/Diversity Index Equation.pdf` - Documentation for the diversity index. 
   
   
## Notable files: 

 - `data/PL94-171_2020_DataDictionary.xlsx` - Description of variables extracted from the script files. 
 - `data/download_pl_2000_2010.R` - Used to make api calls to download PL data for past years
 - `data/download_api_info.R` - Used to make api calls to download complete list of APIs (stored in `data/Census APIs.xlsx`)







