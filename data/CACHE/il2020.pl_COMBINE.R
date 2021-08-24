
## This import is based on the R scripts from the census:
## https://www2.census.gov/programs-surveys/decennial/rdo/about/2020-census-program/Phase3/SupportMaterials/2020PL_R_import_scripts.zip

## The source file can be found here:
## https://www2.census.gov/programs-surveys/decennial/2020/data/01-Redistricting_File--PL_94-171/Illinois/il2020.pl.zip


rm(list=ls())

library(data.table)
library(magrittr)



##------------------------------------------------------------------------------
## Define a place to unzip the PL files
##------------------------------------------------------------------------------
workingdir <- "data/CACHE/il2020.pl"


##------------------------------------------------------------------------------
## Define a place to unzip the PL files
##------------------------------------------------------------------------------
unzip("data/RAW/PL94-171-2020-ILLINOIS/il2020.pl.zip", 
      exdir=workingdir)

##------------------------------------------------------------------------------
## Specify location of the files
##------------------------------------------------------------------------------
infiles <- c(header = "ilgeo2020.pl",
             part1  = "il000012020.pl",
             part2  = "il000022020.pl",
             part3  = "il000032020.pl")
infilepaths <- file.path(workingdir, infiles)

##------------------------------------------------------------------------------
## Specify output file
##------------------------------------------------------------------------------
outfilepath <- "data/CACHE/il2020.pl_COMBINED.csv"

##------------------------------------------------------------------------------
## Import the data
##------------------------------------------------------------------------------
raw_data <- lapply(infilepaths, fread, header=FALSE, colClasses="character", 
                   sep="|", na.strings = "")
names(raw_data) <- names(infiles)

##------------------------------------------------------------------------------
## Set col names
##------------------------------------------------------------------------------
colnames(raw_data$header) <- c("FILEID", "STUSAB", "SUMLEV", "GEOVAR", "GEOCOMP", 
                               "CHARITER", "CIFSN", "LOGRECNO", "GEOID", "GEOCODE", 
                               "REGION", "DIVISION", "STATE", "STATENS", "COUNTY", 
                               "COUNTYCC", "COUNTYNS", "COUSUB", "COUSUBCC", "COUSUBNS", 
                               "SUBMCD", "SUBMCDCC", "SUBMCDNS", "ESTATE", "ESTATECC", 
                               "ESTATENS", "CONCIT", "CONCITCC", "CONCITNS", "PLACE", 
                               "PLACECC", "PLACENS", "TRACT", "BLKGRP", "BLOCK", 
                               "AIANHH", "AIHHTLI", "AIANHHFP", "AIANHHCC", "AIANHHNS", 
                               "AITS", "AITSFP", "AITSCC", "AITSNS", "TTRACT", "TBLKGRP", 
                               "ANRC", "ANRCCC", "ANRCNS", "CBSA", "MEMI", "CSA", 
                               "METDIV", "NECTA", "NMEMI", "CNECTA", "NECTADIV", 
                               "CBSAPCI", "NECTAPCI", "UA", "UATYPE", "UR", "CD116", 
                               "CD118", "CD119", "CD120", "CD121", "SLDU18", "SLDU22", 
                               "SLDU24", "SLDU26", "SLDU28", "SLDL18", "SLDL22", "SLDL24", 
                               "SLDL26", "SLDL28", "VTD", "VTDI", "ZCTA", "SDELM", 
                               "SDSEC", "SDUNI", "PUMA", "AREALAND", "AREAWATR", 
                               "BASENAME", "NAME", "FUNCSTAT", "GCUNI", "POP100", 
                               "HU100", "INTPTLAT", "INTPTLON", "LSADC", "PARTFLAG", "UGA")
colnames(raw_data$part1) <- c("FILEID", "STUSAB", "CHARITER", "CIFSN", "LOGRECNO", 
                              paste0("P00", c(10001:10071, 20001:20073)))
colnames(raw_data$part2) <- c("FILEID", "STUSAB", "CHARITER", "CIFSN", "LOGRECNO", 
                              paste0("P00", c(30001:30071, 40001:40073)), 
                              paste0("H00", 10001:10003))
colnames(raw_data$part3) <- c("FILEID", "STUSAB", "CHARITER", "CIFSN", "LOGRECNO",
                              paste0("P00", 50001:50010))

##------------------------------------------------------------------------------
## COMBINE
##------------------------------------------------------------------------------

# (The merge in the example is not necessary, a simple cbind is sufficient)

all.equal(raw_data$header[, list(LOGRECNO, STUSAB, FILEID, CHARITER)],
          raw_data$part1[, list(LOGRECNO, STUSAB, FILEID, CHARITER)])
all.equal(raw_data$part2[, list(LOGRECNO, STUSAB, FILEID, CHARITER)],
          raw_data$part3[, list(LOGRECNO, STUSAB, FILEID, CHARITER)])
all.equal(raw_data$header[, list(LOGRECNO, STUSAB, FILEID, CHARITER)],
          raw_data$part3[, list(LOGRECNO, STUSAB, FILEID, CHARITER)])

pl_all <- cbind(raw_data$header[ , !c("CIFSN")],
                raw_data$part1[ , !c("CIFSN", "LOGRECNO", "STUSAB", "FILEID", "CHARITER")],
                raw_data$part2[ , !c("CIFSN", "LOGRECNO", "STUSAB", "FILEID", "CHARITER")],
                raw_data$part3[ , !c("CIFSN", "LOGRECNO", "STUSAB", "FILEID", "CHARITER")])

##------------------------------------------------------------------------------
## SAVE
##------------------------------------------------------------------------------
fwrite(pl_all, outfilepath)


