

## This import is based on the R scripts from the census:
## https://www2.census.gov/programs-surveys/decennial/rdo/about/2020-census-program/Phase3/SupportMaterials/2020PL_R_import_scripts.zip

## The source file can be found here:
## https://www2.census.gov/programs-surveys/decennial/2020/data/01-Redistricting_File--PL_94-171/Illinois/il2020.pl.zip



library(data.table)
library(magrittr)

##------------------------------------------------------------------------------
## Define input / output locations
##------------------------------------------------------------------------------
workingdir <- "data/CACHE"
infile <- "data/CACHE/il2020.pl_COMBINED.csv"

outfile_tract <- "data/il2020.pl_COMBINED_TRACT.csv"
outfile_county <- "data/il2020.pl_COMBINED_COUNTY.csv"
outfile_block_group <- "data/il2020.pl_COMBINED_BLOCK_GROUP.csv"

##------------------------------------------------------------------------------
## INPUT DATA
##------------------------------------------------------------------------------
pl_all <- fread(infile, 
                keepLeadingZeros = TRUE, 
                integer64 = "character",
                nrows = -10)

##------------------------------------------------------------------------------
## SAVE (SUB GEOGRAPHIES)
##------------------------------------------------------------------------------

pl_all[,.N,SUMLEV]

pl_all[SUMLEV=="140"] %>% str
fwrite(pl_all[SUMLEV=="140"], outfile_tract)

pl_all[SUMLEV=="050"] %>% str
fwrite(pl_all[SUMLEV=="050"], outfile_county)

pl_all[SUMLEV=="150"] %>% str
fwrite(pl_all[SUMLEV=="150"], outfile_block_group )

# pl_all[SUMLEV=="750"] %>% str
# pl_all[SUMLEV=="750"][COUNTY == "031"] %>% str()
# fwrite(pl_all[SUMLEV=="750"][COUNTY == "031"], "data/il2020.pl_COMBINED_BLOCK_COOK_ONLY.csv")


