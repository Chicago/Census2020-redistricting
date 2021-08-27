

rm(list=ls())


##------------------------------------------------------------------------------
## Libraries
##------------------------------------------------------------------------------

library(geneorama)
library(magrittr)

library(shiny)
library(leaflet)
library(RColorBrewer)
library(rgdal)
library(rgeos)
library(sp)
library(data.table)
library(colorspace)

stadia_key <- yaml::read_yaml("./config/stadia.yaml")
leaflet_stadia_url <- c("https://tiles.stadiamaps.com/tiles/alidade_smooth_dark",
                        "/{z}/{x}/{y}{r}.png?apikey={'%s'}") %>% 
    paste0(., collapse="") %>% sprintf(., stadia_key)
leaflet_stadia_attribution <- c('&copy; <a href="https://stadiamaps.com/">Stadia Maps</a>, ',
                                '&copy; <a href="https://openmaptiles.org/">OpenMapTiles</a> ',
                                '&copy; <a href="http://openstreetmap.org">OpenStreetMap</a> ',
                                'contributors') %>% paste0(., collapse="")

##------------------------------------------------------------------------------
## Shape files
##------------------------------------------------------------------------------

shp_tracts_2020_10 <- readOGR("data/tl_2020_17031_tract10")
shp_tracts_2020_20 <- readOGR("data/tl_2020_17031_tract20")

str(shp_tracts_2020_10@data)
str(shp_tracts_2020_20@data)

##==============================================================================
## COMMUNITY AREA DATA / GEOCODING
##==============================================================================
data("chi_community_areas")

shp_tracts_2020_10$community <- geocode_to_map(lat = shp_tracts_2020_10$INTPTLAT10, 
                                               lon = shp_tracts_2020_10$INTPTLON10,
                                               map = chi_community_areas,
                                               "community")
shp_tracts_2020_20$community <- geocode_to_map(lat = shp_tracts_2020_20$INTPTLAT20, 
                                               lon = shp_tracts_2020_20$INTPTLON20,
                                               map = chi_community_areas,
                                               "community")

shp_tracts_2020_10 <- shp_tracts_2020_10[!is.na(shp_tracts_2020_10@data$community), ]
shp_tracts_2020_20 <- shp_tracts_2020_20[!is.na(shp_tracts_2020_20@data$community), ]

## Generate city outline
chi_city_outline <- rgeos::gUnaryUnion(as(chi_community_areas, "SpatialPolygons"))


##==============================================================================
## SIMPLE PLOT OF COMMUNITY AREAS AND SUBSET
##==============================================================================

samp_ca_num <- c(8,24,28,31,32,33,34,35,59,60)
ca_samp_ii <- match(samp_ca_num, chi_community_areas$area_numbe)
samp_ca_names <- chi_community_areas$community[ca_samp_ii]

##==============================================================================
##  PLOT COMMUNITY AREAS
##==============================================================================

##*************************************************
## for example of labeling / subseting see:
## R/example - community areas label and subset.R
##*************************************************

plot(shp_tracts_2020_10)
plot(shp_tracts_2020_20)




# cols_bright <- diverging_hcl(n = 7, h = c(360, 138), c = c(144, 42), l = c(67, 82), power = c(0.45, 1.1))
cols_muted <- diverging_hcl(n = 7, h = c(340, 128), c = c(60, 80), l = c(30, 97), power = c(0.8, 1.5))
shp_tracts_2020_20$val <- runif(nrow(shp_tracts_2020_20))
shp_tracts_2020_10$val <- runif(nrow(shp_tracts_2020_10))
pal <- colorNumeric(palette = cols_muted, domain = shp_tracts_2020_20$val)


leaflet(shp_tracts_2020_20[1:10,]) %>%
    addTiles(urlTemplate = leaflet_stadia_url, 
             attribution = leaflet_stadia_attribution) %>% 
    addPolygons(fillColor = ~pal(val),
                fillOpacity = 0.5, weight = 0.5,
                label=~GEOID20) %>%
    addLegend(pal = pal, 
              values = ~val, 
              title = "Cumulative Response Rate",
              position = "bottomright")



