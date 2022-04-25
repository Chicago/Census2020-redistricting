
##
## Export Chicago Community Area (CCA) Summary
##

##  Based on ex-misc_questions.Rmd


## Libraries
library(geneorama)
library(shiny)
library(leaflet)
library(RColorBrewer)
library(rgdal)
library(rgeos)
library(sp)
library(data.table)
library(colorspace)
library(raster)

library(plotly)

# geneorama::set_project_dir("Census2020-redistricting")
sourceDir("R/functions/")

##------------------------------------------------------------------------------
## DEMOGRAPHIC DATA
##------------------------------------------------------------------------------

## READ IN FROM SOURCE
pl_2000_tract <- "data/pl_2000_il_tract.csv" %>% 
    fread_census %>% age_and_race_vars_table %>% .[,DI:=diversity_index(.)] %>% 
    .[COUNTY=="031"]
pl_2010_tract <- "data/pl_2010_il_tract.csv" %>% 
    fread_census %>% age_and_race_vars_table %>% .[,DI:=diversity_index(.)] %>% 
    .[COUNTY=="031"]
pl_2020_tract <- "data/il2020.pl_COMBINED_TRACT.csv" %>% 
    fread_census %>% age_and_race_vars_table %>% .[,DI:=diversity_index(.)] %>% 
    .[COUNTY=="031"]


##------------------------------------------------------------------------------
## SHAPEFILES
##------------------------------------------------------------------------------
shp_tracts_2000 <- readOGR("data/tl_2010_17031_tract00")
shp_tracts_2010 <- readOGR("data/tl_2010_17031_tract10")
shp_tracts_2020 <- readOGR("data/tl_2020_17031_tract20")

##==============================================================================
## COMMUNITY AREA DATA / GEOCODING
##==============================================================================
data("chi_community_areas")
cca_info <- fread("data/ChicagoCommunityArea-Districts.csv")
chi_community_areas@data <- merge(chi_community_areas@data, cca_info, "community", sort=F)


## Generate city outline
chi_city_outline <- rgeos::gUnaryUnion(as(chi_community_areas, "SpatialPolygons"))


shp_tracts_2000$community <- geocode_to_map(lat = shp_tracts_2000$INTPTLAT00, 
                                            lon = shp_tracts_2000$INTPTLON00,
                                            map = chi_community_areas,
                                            "community")
shp_tracts_2010$community <- geocode_to_map(lat = shp_tracts_2010$INTPTLAT10, 
                                            lon = shp_tracts_2010$INTPTLON10,
                                            map = chi_community_areas,
                                            "community")
shp_tracts_2020$community <- geocode_to_map(lat = shp_tracts_2020$INTPTLAT20, 
                                            lon = shp_tracts_2020$INTPTLON20,
                                            map = chi_community_areas,
                                            "community")

shp_tracts_2000$chicago <- !is.na(shp_tracts_2000@data$community)
shp_tracts_2010$chicago <- !is.na(shp_tracts_2010@data$community)
shp_tracts_2020$chicago <- !is.na(shp_tracts_2020@data$community)


inin(pl_2000_tract$GEO_ID, shp_tracts_2000$CTIDFP00)
inin(pl_2010_tract$GEO_ID, shp_tracts_2010$GEOID10)
inin(pl_2020_tract$GEO_ID, shp_tracts_2020$GEOID20)

setnames(shp_tracts_2000@data,"CTIDFP00", "GEO_ID")
setnames(shp_tracts_2010@data,"GEOID10", "GEO_ID")
setnames(shp_tracts_2020@data,"GEOID20", "GEO_ID")


##------------------------------------------------------------------------------
## MERGE TRACT / CA MAPPING INTO DATA TABLES
##------------------------------------------------------------------------------

pl_2000_ca <- merge(pl_2000_tract[,-c("STATE", "COUNTY", "TRACT", "LSAD_NAME", "DI")],
                    shp_tracts_2000@data %>% data.table %>% .[,list(GEO_ID, community, chicago)],
                    by = "GEO_ID", sort = FALSE)
pl_2010_ca <- merge(pl_2010_tract[,-c("STATE", "COUNTY", "TRACT", "LSAD_NAME", "DI")],
                    shp_tracts_2010@data %>% data.table %>% .[,list(GEO_ID, community, chicago)],
                    by = "GEO_ID", sort = FALSE)
pl_2020_ca <- merge(pl_2020_tract[,-c("STATE", "COUNTY", "TRACT", "DI")],
                    shp_tracts_2020@data %>% data.table %>% .[,list(GEO_ID, community, chicago)],
                    by = "GEO_ID", sort = FALSE)

##------------------------------------------------------------------------------
## AGGREGATE TO CA
##------------------------------------------------------------------------------

pl_2000_ca <- pl_2000_ca[i = TRUE, 
                         lapply(.SD, sum), 
                         .SDcols = c("TOT", "H", "W", "B", "AIAN", "ASIAN", "NHPI", "SOR", "MULTI",
                                     "TOT_ADULT", "H_ADULT", "W_ADULT", "B_ADULT", "AIAN_ADULT", 
                                     "ASIAN_ADULT", "NHPI_ADULT", "SOR_ADULT", "MULTI_ADULT",
                                     "TOT_CHILD", "H_CHILD", "W_CHILD", "B_CHILD", "AIAN_CHILD", 
                                     "ASIAN_CHILD", "NHPI_CHILD", "SOR_CHILD", "MULTI_CHILD"),
                         keyby = list(community, chicago)]
pl_2010_ca <- pl_2010_ca[i = TRUE, 
                         lapply(.SD, sum), 
                         .SDcols = c("TOT", "H", "W", "B", "AIAN", "ASIAN", "NHPI", "SOR", "MULTI",
                                     "TOT_ADULT", "H_ADULT", "W_ADULT", "B_ADULT", "AIAN_ADULT", 
                                     "ASIAN_ADULT", "NHPI_ADULT", "SOR_ADULT", "MULTI_ADULT",
                                     "TOT_CHILD", "H_CHILD", "W_CHILD", "B_CHILD", "AIAN_CHILD", 
                                     "ASIAN_CHILD", "NHPI_CHILD", "SOR_CHILD", "MULTI_CHILD",
                                     "HOUSING_TOT", "HOUSING_OCC", "HOUSING_VAC"),
                         keyby = list(community, chicago)]
pl_2020_ca <- pl_2020_ca[i = TRUE, 
                         lapply(.SD, sum), 
                         .SDcols = c("TOT", "H", "W", "B", "AIAN", "ASIAN", "NHPI", "SOR", "MULTI",
                                     "TOT_ADULT", "H_ADULT", "W_ADULT", "B_ADULT", "AIAN_ADULT", 
                                     "ASIAN_ADULT", "NHPI_ADULT", "SOR_ADULT", "MULTI_ADULT",
                                     "TOT_CHILD", "H_CHILD", "W_CHILD", "B_CHILD", "AIAN_CHILD", 
                                     "ASIAN_CHILD", "NHPI_CHILD", "SOR_CHILD", "MULTI_CHILD",
                                     "GC_TOT", "GC_INST", "GC_CORR", "GC_JUV", "GC_NURS", "GC_INST_OTHER", 
                                     "GC_NONINST", "GC_NONINST_COLLEGE", "GC_NONINST_MIL", "GC_NONINST_OTHER",
                                     "HOUSING_TOT", "HOUSING_OCC", "HOUSING_VAC"),
                         keyby = list(community, chicago)]

##------------------------------------------------------------------------------
## Calculate diversity index
##------------------------------------------------------------------------------

pl_2000_ca$DI <- pl_2000_ca %>% diversity_index
pl_2010_ca$DI <- pl_2010_ca %>% diversity_index
pl_2020_ca$DI <- pl_2020_ca %>% diversity_index


##------------------------------------------------------------------------------
## Combine and write to CSV
##------------------------------------------------------------------------------

cca_summary <- list(cbind(vintage = 2000, pl_2000_ca),
                    cbind(vintage = 2010, pl_2010_ca),
                    cbind(vintage = 2020, pl_2020_ca) ) %>% 
    rbindlist(., fill=T)

## Experimental SAS Export (The SAS users said it didn't work)
# dir.create("SAS")
# haven::write_sas(cca_summary,
#                  "SAS/CCA_SUMMARY.sas7bdat")

fwrite(cca_summary,
       "SAS/CCA_SUMMARY.csv")
