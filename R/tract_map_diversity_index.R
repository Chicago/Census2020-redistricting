

rm(list=ls())


##------------------------------------------------------------------------------
## Libraries
##------------------------------------------------------------------------------

library(geneorama)

library(shiny)
library(leaflet)
library(RColorBrewer)
library(rgdal)
library(rgeos)
library(sp)
library(data.table)
library(colorspace)

leaflet_stadia_url <- "https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png?apikey={'197c5c13-03bb-409e-8806-1a49bc7deaad'}"
leaflet_stadia_attribution <- '&copy; <a href="https://stadiamaps.com/">Stadia Maps</a>, &copy; <a href="https://openmaptiles.org/">OpenMapTiles</a> &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors'

sourceDir("R/functions/")

##------------------------------------------------------------------------------
## DEMOGRAPHIC DATA
##------------------------------------------------------------------------------

pl_fields <- c("GEOID", "GEOCODE", "STATE", "COUNTY", "SUMLEV", "TRACT", "BLKGRP", 
               "BLOCK", "CSA", "BASENAME", "POP100", "HU100", 
               "INTPTLAT", "INTPTLON", 
               "P0020001", # Total pop
               "P0020002", # Hispanic or Latino
               "P0020005", # Not Hispanic or Latino: White alone
               "P0020006", # Not Hispanic or Latino:  Black or African American alone 
               "P0020007", # Not Hispanic or Latino:  American Indian and Alaska Native alone
               "P0020008", # Not Hispanic or Latino:  Asian alone
               "P0020009", # Not Hispanic or Latino:  Native Hawaiian and Other Pacific Islander alone
               "P0020010", # Not Hispanic or Latino:  Some Other Race alone
               "P0020011" # Not Hispanic or Latino:  Population of two or more races
)


pl_2020_tract <- fread("data/il2020.pl_COMBINED_TRACT.csv", 
                       nrows = -10, 
                       select = pl_fields,
                       keepLeadingZeros = TRUE, 
                       integer64 = "character")

pl_2020_tract


##------------------------------------------------------------------------------
## Diversity index
##------------------------------------------------------------------------------
pl_2020_tract$div_index <- diversity_index(pl_2020_tract)

hist(pl_2020_tract$div_index)

##------------------------------------------------------------------------------
## Shape files
##------------------------------------------------------------------------------

shp_tracts_2020 <- readOGR("data/tl_2020_17031_tract20")
# shp_tracts_2020 <- readOGR("data/tl_2020_17_tract")

shp_tracts_2020@data %>% setnames(., gsub("[1-2]0", "", colnames(.)))


str(shp_tracts_2020@data)
str(pl_2020_tract)

NAsummary(shp_tracts_2020@data)
NAsummary(pl_2020_tract)
# data.table(shp_tracts_2020@data$GEOID %>% sort,pl_2020_tract$GEOCODE %>% sort)[,list(.N),V1==V2]


##==============================================================================
## COMMUNITY AREA DATA / GEOCODING
##==============================================================================
data("chi_community_areas")


shp_tracts_2020$community <- geocode_to_map(lat = shp_tracts_2020$INTPTLAT, 
                                            lon = shp_tracts_2020$INTPTLON,
                                            map = chi_community_areas,
                                            "community")

shp_tracts_2020$chicago <- !is.na(shp_tracts_2020@data$community)

##==============================================================================
## COMMUNITY AREA DATA / GEOCODING
##==============================================================================
shp_tracts_2020@data <- merge(shp_tracts_2020@data,
                              pl_2020_tract[, list(GEOID=GEOCODE, div_index)], 
                              "GEOID", sort = FALSE)

## Generate city outline
chi_city_outline <- rgeos::gUnaryUnion(as(chi_community_areas, "SpatialPolygons"))

pal <- viridisLite::viridis(256, option = "D") %>% 
    colorNumeric(palette = ., 
                 domain = shp_tracts_2020$div_index,
                 na.color = "black", alpha = F, reverse = TRUE)


leaflet(shp_tracts_2020) %>%
    addTiles(urlTemplate = leaflet_stadia_url,
             attribution = leaflet_stadia_attribution) %>%
    addPolygons(fillColor = ~pal(div_index),
                fillOpacity = 0.5, 
                stroke=FALSE, weight = 0.5,
                label=~paste(GEOID, div_index)) %>%
    addLegend(pal = pal,
              values = ~div_index,
              title = "Diversity Index",
              position = "bottomright")




# palette_function <- colorNumeric(palette = "Greens", NULL, n = 4)
# palette_function <- colorNumeric(palette = "inferno", NULL, n = 4, reverse = T)
# shp <- dat[Hard_break_event>0,
#            list(intersectionId, intersectionName,
#                 latitude, 
#                 longitude, 
#                 Hard_break_event,
#                 cols = palette_function((log(Hard_break_event))),
#                 popups = paste(intersectionId, intersectionName))]
# leaflet(shp) %>%
#     addProviderTiles("CartoDB.Positron") %>%
#     addCircleMarkers(lng = ~ longitude, lat = ~ latitude, popup = ~popups,
#                      radius = 4, color = ~cols, stroke = FALSE, 
#                      label = ~popups,
#                      fillOpacity = 0.25) %>% 
#     addLegend(pal = palette_function,
#               values = ~Hard_break_event %>% log,
#               position = "bottomright",
#               title = "Hard Brake Events")


# cols_muted <- diverging_hcl(n = 7, h = c(340, 128), c = c(60, 80), l = c(30, 97), power = c(0.8, 1.5))
# shp_tracts_2020_20$val <- runif(nrow(shp_tracts_2020_20))
# shp_tracts_2020_10$val <- runif(nrow(shp_tracts_2020_10))
# pal <- colorNumeric(palette = cols_muted, domain = shp_tracts_2020_20$val)
# 
# pal(shp_tracts_2020_20$val)
# 
# 
# leaflet(shp_tracts_2020_20[1:10,]) %>%
#     addTiles(urlTemplate = leaflet_stadia_url, 
#              attribution = leaflet_stadia_attribution) %>% 
#     addPolygons(fillColor = ~pal(val),
#                 fillOpacity = 0.5, weight = 0.5,
#                 label=~GEOID20) %>%
#     addLegend(pal = pal, 
#               values = ~val, 
#               title = "Cumulative Response Rate",
#               position = "bottomright")









library(viridisLite)

# shp <- dat[Hard_break_event>0,
#            list(intersectionId, intersectionName,
#                 latitude, 
#                 longitude, 
#                 hard_break_event = Hard_break_event)]
# shp[ , cols := colorNumeric("Greens", NULL, n = 4)(log(hard_break_event))]
# shp[ , popups := paste(intersectionId, intersectionName)]
# leaflet() %>%
#     addProviderTiles("CartoDB.Positron") %>%
#     addCircleMarkers(lng = ~ longitude, lat = ~ latitude, 
#                      data = shp, popup = ~popups,
#                      radius = 3, color = ~cols, stroke = FALSE, 
#                      fillOpacity = 0.5) 
#     # addLegend(pal = ctpal, values = log(preds), ## NOTE: USING LOG VALUES
#     #           position = "bottomright", title = "Vector Index Values")

viridisLite::viridis(256, option = "D") %>% 
    colorNumeric(palette = ., 
                 domain = "",
                 na.color = "black", alpha = F, reverse = TRUE)

palette_function <- colorNumeric(palette = "Greens", NULL, n = 4)
palette_function <- colorNumeric(palette = "inferno", NULL, n = 4, reverse = T)
shp <- dat[Hard_break_event>0,
           list(intersectionId, intersectionName,
                latitude, 
                longitude, 
                Hard_break_event,
                cols = palette_function((log(Hard_break_event))),
                popups = paste(intersectionId, intersectionName))]
leaflet(shp) %>%
    addProviderTiles("CartoDB.Positron") %>%
    addCircleMarkers(lng = ~ longitude, lat = ~ latitude, popup = ~popups,
                     radius = 4, color = ~cols, stroke = FALSE, 
                     label = ~popups,
                     fillOpacity = 0.25) %>% 
    addLegend(pal = palette_function,
              values = ~Hard_break_event %>% log,
              position = "bottomright",
              title = "Hard Brake Events")



palette_function <- colorNumeric(palette = "inferno", NULL, n = 4, reverse = T)
leaflet(shp) %>%
    addProviderTiles("CartoDB.Positron") %>%
    addCircleMarkers(lng = ~ longitude, lat = ~ latitude, popup = ~popups,
                     radius = 8, color = ~cols, stroke = FALSE, 
                     fillOpacity = 0.25) %>% 
    addLegend(pal = palette_function,
              values = ~Hard_break_event %>% log,
              position = "bottomright",
              title = "Hard Brake Events") %>% 
    fitBounds(-87.5869560241699, 41.8921189164765, -87.6624870300293, 41.8665567412712)


