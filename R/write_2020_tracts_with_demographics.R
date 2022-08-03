
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

sourceDir("R/functions/")

##------------------------------------------------------------------------------
## DEMOGRAPHIC DATA
##------------------------------------------------------------------------------

## READ IN FROM SOURCE
pl_2000_tract <- "data/pl_2000_il_tract.csv" %>% 
    fread_census %>% di_race_var_table %>% .[,DI:=diversity_index(.)] %>% 
    .[COUNTY=="031"]
pl_2010_tract <- "data/pl_2010_il_tract.csv" %>% 
    fread_census %>% di_race_var_table %>% .[,DI:=diversity_index(.)] %>% 
    .[COUNTY=="031"]
pl_2020_tract <- "data/il2020.pl_COMBINED_TRACT.csv" %>% 
    fread_census %>% di_race_var_table %>% .[,DI:=diversity_index(.)] %>% 
    .[COUNTY=="031"]

pl_2000_tract
pl_2010_tract
pl_2020_tract

##------------------------------------------------------------------------------
## crosswalk data
##------------------------------------------------------------------------------

cw <- fread("data/crosswalk_for_chicago.csv", 
            integer64 = "character", keepLeadingZeros = T) %>% 
    .[ , zip := as.character(zip)] %>% .[]

# 
# cw[ , list(hh = sum(households)), list(tract_2020, tract_2010)]
# 
# 
# cw[, sum(households), list(tract_2020, tract_2010)] %>% 
#   .[,.N,tract_2020] %>% .[N>1, tract_2020]
# 
# cw[, sum(households), list(tract_2020, tract_2010)][tract_2020%in%
# (cw[, sum(households), list(tract_2020, tract_2010)] %>% 
#   .[,.N,tract_2020] %>% .[N>1, tract_2020])] %>% .[order(tract_2020)]



##------------------------------------------------------------------------------
## import map data
##------------------------------------------------------------------------------
data("chi_census_tracts_2000")
data("chi_census_tracts_2010")
il_census_tracts_2020 <- readOGR("data/tl_2020_17_tract") 
cook_census_tracts_2020 <- il_census_tracts_2020[il_census_tracts_2020$COUNTYFP=="031", ]
data("chi_community_areas")
data("chi_wards_2015")
data("chi_zip_codes")

##------------------------------------------------------------------------------
## geocode community area and label for chicago / non chicago
##------------------------------------------------------------------------------

## Subset cook census tracts to just Chicago
cook_census_tracts_2020@data %>% head

## From the crosswalk some tracts don't have people so geocode again to check 
## if tract is in chicago
cook_census_tracts_2020@data %>% data.table
cook_census_tracts_2020$community1 <- 
    geocode_to_map(cook_census_tracts_2020@data$INTPTLAT %>% as.numeric,
                   cook_census_tracts_2020@data$INTPTLON %>% as.numeric,
                   map = chi_community_areas,
                   map_field_name = "community")
cook_census_tracts_2020$community2 <- cw[match(cook_census_tracts_2020$GEOID, 
                                               cw$tract_2020), community]

cook_census_tracts_2020$chicago <- 
    !is.na(cook_census_tracts_2020$community1) |
    !is.na(cook_census_tracts_2020$community2)
cook_census_tracts_2020$chicago %>% table


##------------------------------------------------------------------------------
## a test to compare community area geocoding
##------------------------------------------------------------------------------

if(FALSE){
    ## Compare the matching of the tracts
    cook_census_tracts_2020@data %>% data.table %>% .[ , .N, community1==community2]
    cook_census_tracts_2020@data %>% data.table %>% 
        .[,list(c1=ifelse(is.na(community1),"", community1), 
                c2=ifelse(is.na(community2),"", community2))] %>% 
        .[ , .N, c1==c2]
    ii_cca_nomatch <- cook_census_tracts_2020@data %>% data.table %>% 
        .[,list(c1=ifelse(is.na(community1),"", community1), 
                c2=ifelse(is.na(community2),"", community2))] %>% 
        .[,which(!c1==c2)]
    ii_cca_nomatch_cols <- c("red", "orange", "yellow", "green","blue", "purple","brown")
    cook_census_tracts_2020@data %>% data.table %>% .[ii_cca_nomatch]
    plot(cook_census_tracts_2020[cook_census_tracts_2020$chicago==TRUE,])
    plot(cook_census_tracts_2020[ii_cca_nomatch, ], add=T, 
         col=ii_cca_nomatch_cols)
    
    cook_census_tracts_2020@data %>% data.table %>% 
        .[ii_cca_nomatch, list(TRACTCE, NAME, NAMELSAD, ALAND, AWATER,
                               INTPTLAT, INTPTLON, community1, community2)] 
    # %>% knitr::kable(., 
    #                  format.args = list(decimal.mark = ".", 
    #                                     big.mark = ","),
    #                  format = c("pipe", "rst")[1] )
    
    # |TRACTCE |NAME    |NAMELSAD             |ALAND    |AWATER |INTPTLAT    |INTPTLON     |community1      |community2  |
    # |:-------|:-------|:--------------------|:--------|:------|:-----------|:------------|:---------------|:-----------|
    # |841000  |8410    |Census Tract 8410    |1054201  |296569 |+41.8475444 |-087.6101983 |NEAR SOUTH SIDE |NA          |
    # |030702  |307.02  |Census Tract 307.02  |22158    |0      |+41.9808148 |-087.6545286 |EDGEWATER       |NA          |
    # |834500  |8345    |Census Tract 8345    |464133   |0      |+41.7860320 |-087.6253618 |WASHINGTON PARK |NA          |
    # |381700  |3817    |Census Tract 3817    |196802   |0      |+41.8055502 |-087.6274463 |GRAND BOULEVARD |NA          |
    # |770602  |7706.02 |Census Tract 7706.02 |5390210  |153161 |+42.0119110 |-087.9074973 |NA              |OHARE       |
    # |980000  |9800    |Census Tract 9800    |19890200 |92402  |+41.9794191 |-087.9024376 |OHARE           |NA          |
    # |823304  |8233.04 |Census Tract 8233.04 |3553267  |0      |+41.6814296 |-087.7027507 |NA              |MORGAN PARK |
    
    
    rm(ii_cca_nomatch, ii_cca_nomatch_cols)
}

##------------------------------------------------------------------------------
## manual check for 8104
##------------------------------------------------------------------------------

if(FALSE){
    cw[grep("8104",tract_2020)] 
    # %>% 
    #   knitr::kable(., 
    #                format.args = list(decimal.mark = ".",
    #                                   big.mark = ","),
    #                format = c("pipe", "rst")[1] )
    
    # |zip   |tract_2000  |tract_2010  |tract_2020  |block_2010      |block_2020      |community |ward_2015 | population| households|
    # |:-----|:-----------|:-----------|:-----------|:---------------|:---------------|:---------|:---------|----------:|----------:|
    # |60631 |17031810400 |17031810400 |17031810400 |170318104003030 |170318104003034 |          |NA        |      2,130|        858|
    
    plot(cook_census_tracts_2020[cook_census_tracts_2020$chicago==TRUE,])
    plot(cook_census_tracts_2020[cook_census_tracts_2020$NAME=="8104", ], add=T, col="red")
}

##------------------------------------------------------------------------------
## select best community area geocoding result
##------------------------------------------------------------------------------

chi_census_tracts_2020 <- cook_census_tracts_2020[cook_census_tracts_2020$chicago == TRUE,]
chi_census_tracts_2020$community <- chi_census_tracts_2020$community1
chi_census_tracts_2020$community[is.na(chi_census_tracts_2020$community1)] <-
    chi_census_tracts_2020$community2[is.na(chi_census_tracts_2020$community1)]
chi_census_tracts_2020$community1 <- NULL
chi_census_tracts_2020$community2 <- NULL

if(FALSE){
    chi_census_tracts_2020@data %>% data.table %>% 
        .[, lapply(.SD, 
                   function(x)
                       ifelse(x=="", NA,x)
        )]%>% NAsummary()
    
    ## Why? 
    chi_census_tracts_2020@data %>% data.table %>% .[community==""]
    
    plot(cook_census_tracts_2020[cook_census_tracts_2020$chicago==TRUE,])
    plot(cook_census_tracts_2020[cook_census_tracts_2020$GEOID=="17031810400", ], add=T, col="red")
}

##------------------------------------------------------------------------------
## check and finalize
##------------------------------------------------------------------------------

chi_census_tracts_2000@data %>% head
chi_census_tracts_2010@data %>% head
chi_community_areas@data %>% head
chi_wards_2015@data %>% head

chi_census_tracts_2020@data %>% str

pl_2020_tract
pl_2020_tract_copy <- copy(pl_2020_tract)
pl_2020_tract_copy %>% setnames(., "GEO_ID", "GEOID")

chi_census_tracts_2020@data <- merge(chi_census_tracts_2020@data,
                                     pl_2020_tract_copy,
                                     "GEOID", sort = FALSE)
##------------------------------------------------------------------------------
## write to geojson and csv
##------------------------------------------------------------------------------

fname_json <- "data/chi_census_tracts_2020_with_demographics.json"
fname_csv <- "data/chi_census_tracts_2020_with_demographics.csv"

"GeoJSON" %in% ogrDrivers()$name
if(file.exists(fname_json))unlink(fname_json)
writeOGR(chi_census_tracts_2020, fname_json, "GeoJSON", driver="GeoJSON")

fwrite(chi_census_tracts_2020@data,
       file = "data/chi_census_tracts_2020_with_demographics.csv")

## Test import
test <- readOGR("data/chi_census_tracts_2020_with_demographics.json")
str(test, 2)

