

## This import is based on the R scripts from the census:
## https://www2.census.gov/programs-surveys/decennial/rdo/about/2020-census-program/Phase3/SupportMaterials/2020PL_R_import_scripts.zip

## The source file can be found here:
## https://www2.census.gov/programs-surveys/decennial/2020/data/01-Redistricting_File--PL_94-171/Illinois/il2020.pl.zip



library(data.table)
library(magrittr)

##------------------------------------------------------------------------------
## Specify location of the files
##------------------------------------------------------------------------------
header_file_path <- "data/il2020.pl/ilgeo2020.pl"
part1_file_path  <- "data/il2020.pl/il000012020.pl"
part2_file_path  <- "data/il2020.pl/il000022020.pl"
part3_file_path  <- "data/il2020.pl/il000032020.pl"

##------------------------------------------------------------------------------
# Import the data
##------------------------------------------------------------------------------
header <- header_file_path %>% fread(., header=FALSE, colClasses="character", sep="|", na.strings = "")
part1  <- part1_file_path %>% fread(.,  header=FALSE, colClasses="character", sep="|", na.strings = "")
part2  <- part2_file_path %>% fread(.,  header=FALSE, colClasses="character", sep="|", na.strings = "")
part3  <- part3_file_path %>% fread(.,  header=FALSE, colClasses="character", sep="|", na.strings = "")

colnames(header) <- c("FILEID", "STUSAB", "SUMLEV", "GEOVAR", "GEOCOMP", "CHARITER", "CIFSN", "LOGRECNO", "GEOID", 
                      "GEOCODE", "REGION", "DIVISION", "STATE", "STATENS", "COUNTY", "COUNTYCC", "COUNTYNS", "COUSUB",
                      "COUSUBCC", "COUSUBNS", "SUBMCD", "SUBMCDCC", "SUBMCDNS", "ESTATE", "ESTATECC", "ESTATENS", 
                      "CONCIT", "CONCITCC", "CONCITNS", "PLACE", "PLACECC", "PLACENS", "TRACT", "BLKGRP", "BLOCK", 
                      "AIANHH", "AIHHTLI", "AIANHHFP", "AIANHHCC", "AIANHHNS", "AITS", "AITSFP", "AITSCC", "AITSNS",
                      "TTRACT", "TBLKGRP", "ANRC", "ANRCCC", "ANRCNS", "CBSA", "MEMI", "CSA", "METDIV", "NECTA",
                      "NMEMI", "CNECTA", "NECTADIV", "CBSAPCI", "NECTAPCI", "UA", "UATYPE", "UR", "CD116", "CD118",
                      "CD119", "CD120", "CD121", "SLDU18", "SLDU22", "SLDU24", "SLDU26", "SLDU28", "SLDL18", "SLDL22",
                      "SLDL24", "SLDL26", "SLDL28", "VTD", "VTDI", "ZCTA", "SDELM", "SDSEC", "SDUNI", "PUMA", "AREALAND",
                      "AREAWATR", "BASENAME", "NAME", "FUNCSTAT", "GCUNI", "POP100", "HU100", "INTPTLAT", "INTPTLON", 
                      "LSADC", "PARTFLAG", "UGA")
colnames(part1) <- c("FILEID", "STUSAB", "CHARITER", "CIFSN", "LOGRECNO", 
                     paste0("P00", c(10001:10071, 20001:20073)))
colnames(part2) <- c("FILEID", "STUSAB", "CHARITER", "CIFSN", "LOGRECNO", 
                     paste0("P00", c(30001:30071, 40001:40073)), 
                     paste0("H00", 10001:10003))
colnames(part3) <- c("FILEID", "STUSAB", "CHARITER", "CIFSN", "LOGRECNO",
                     paste0("P00", 50001:50010))

##------------------------------------------------------------------------------
## CHECK RESULTS
##------------------------------------------------------------------------------

# (The proposed merge is not necessary, a simple cbind is sufficient)

all.equal(header[, list(LOGRECNO, STUSAB, FILEID, CHARITER)],
          part1[, list(LOGRECNO, STUSAB, FILEID, CHARITER)])
all.equal(part2[, list(LOGRECNO, STUSAB, FILEID, CHARITER)],
          part3[, list(LOGRECNO, STUSAB, FILEID, CHARITER)])
all.equal(header[, list(LOGRECNO, STUSAB, FILEID, CHARITER)],
          part3[, list(LOGRECNO, STUSAB, FILEID, CHARITER)])

##------------------------------------------------------------------------------
## COMBINE
##------------------------------------------------------------------------------
pl_all <- cbind(header[ , !c("CIFSN")],
                part1[ , !c("CIFSN", "LOGRECNO", "STUSAB", "FILEID", "CHARITER")],
                part2[ , !c("CIFSN", "LOGRECNO", "STUSAB", "FILEID", "CHARITER")],
                part3[ , !c("CIFSN", "LOGRECNO", "STUSAB", "FILEID", "CHARITER")])

##------------------------------------------------------------------------------
## SAVE (ALL GEOGRAPHIES)
##------------------------------------------------------------------------------

## Too big, don't write
# fwrite(pl_all, "data/il2020.pl_COMBINED_ALL_GEOS.csv")


##------------------------------------------------------------------------------
## SAVE (SUB GEOGRAPHIES)
##------------------------------------------------------------------------------

pl_all[,.N,SUMLEV]

pl_all[SUMLEV=="140"] %>% str
fwrite(pl_all[SUMLEV=="140"], "data/il2020.pl_COMBINED_TRACT.csv")

pl_all[SUMLEV=="050"] %>% str
fwrite(pl_all[SUMLEV=="050"], "data/il2020.pl_COMBINED_COUNTY.csv")

pl_all[SUMLEV=="150"] %>% str
fwrite(pl_all[SUMLEV=="150"], "data/il2020.pl_COMBINED_BLOCK_GROUP.csv")

# pl_all[SUMLEV=="750"] %>% str
# pl_all[SUMLEV=="750"][COUNTY == "031"] %>% str()
# fwrite(pl_all[SUMLEV=="750"][COUNTY == "031"], "data/il2020.pl_COMBINED_BLOCK_COOK_ONLY.csv")


