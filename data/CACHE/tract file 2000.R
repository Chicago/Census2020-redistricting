
## This import is based on the R scripts from the census:
## https://www2.census.gov/programs-surveys/decennial/rdo/about/2020-census-program/Phase3/SupportMaterials/2020PL_R_import_scripts.zip

## The source file can be found here:
## https://www2.census.gov/programs-surveys/decennial/2020/data/01-Redistricting_File--PL_94-171/Illinois/il2020.pl.zip


rm(list=ls())

library(rgdal)
library(data.table)
library(magrittr)



##------------------------------------------------------------------------------
## Define a place to unzip the PL files
##------------------------------------------------------------------------------
workingdir <- "data/CACHE/tracts_17031_2000"
outputdir <- "data/tl_2000_17031"


##------------------------------------------------------------------------------
## Define a place to unzip the PL files
##------------------------------------------------------------------------------
unzip("data/RAW/MAPS/Tracts for cook county 2000/tgr17031.zip", 
      exdir=workingdir)


system.time(shp_tracts_2000 <- readOGR(outputdir))

ogrListLayers(workingdir)
#  [1] "CompleteChain"   "AltName"         "FeatureIds"      "ZipCodes"
#  [5] "Landmarks"       "AreaLandmarks"   "KeyFeatures"     "Polygon"
#  [9] "EntityNames"     "IDHistory"       "PolyChainLink"   "SpatialMetadata"
# [13] "PIP"             "TLIDRange"       "ZipPlus4"
# attr(,"driver")
# [1] "TIGER"
# attr(,"nlayers")
# [1] 15

## Writes something, I don't know if it's useful / correct
## TRACT isn't even one of the original layers
writeOGR(shp_tracts_2000, outputdir, layer="TRACT", driver="ESRI Shapefile")

