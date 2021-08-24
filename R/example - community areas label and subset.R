

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



##==============================================================================
## COMMUNITY AREA MAP DATA
##==============================================================================
data("chi_community_areas")

##==============================================================================
## Generate city outline
##==============================================================================
chi_city_outline <- rgeos::gUnaryUnion(as(chi_community_areas, "SpatialPolygons"))

##==============================================================================
## SIMPLE PLOT OF COMMUNITY AREAS AND SUBSET
##==============================================================================

## Use HCL Wizard to manually pick colors:
# colorspace::hcl_wizard()

## Get colors for each ward using 4 color algorithm
pal <- colorspace::qualitative_hcl(n = 4, h = c(26, -264), c = 70, l = 70)
chi_community_areas$colors <- pal[MapColoring::getColoring(chi_community_areas)]

leaflet(chi_community_areas) %>%
    addTiles(urlTemplate = leaflet_stadia_url, 
             attribution = leaflet_stadia_attribution) %>% 
    addPolygons(data = chi_city_outline, fill = FALSE, color = "black", weight = 5) %>%
    addPolygons(fillColor = ~colors, fillOpacity = 0.5,
                weight = 0.5, label = ~paste(area_numbe, ":", community) ) %>% 
    addLabelOnlyMarkers(~lon_centroid, 
                        ~lat_centroid, label = ~paste(area_numbe, ":", community),
                        labelOptions = labelOptions(noHide = TRUE,
                                                    direction = "center",
                                                    offset = c(0, 0), opacity = 1, 
                                                    textsize = "10px", textOnly = TRUE, 
                                                    style = list("font-style" = "bold")))

samp_ca_num <- c(8,24,28,31,32,33,34,35,59,60)
ca_samp_ii <- match(samp_ca_num, chi_community_areas$area_numbe)
samp_ca_names <- chi_community_areas$community[ca_samp_ii]

# samp_ca_name <- chi_community_areas$community[
leaflet(chi_community_areas[chi_community_areas$area_numbe %in% samp_ca_num, ]) %>%
    addTiles(urlTemplate = leaflet_stadia_url, 
             attribution = leaflet_stadia_attribution) %>% 
    addPolygons(fillColor = ~colors, fillOpacity = 0.5,
                weight = 0.5, label = ~paste(area_numbe, ":", community) ) %>% 
    addLabelOnlyMarkers(~lon_centroid, 
                        ~lat_centroid, label = ~paste(area_numbe, ":", community),
                        labelOptions = labelOptions(noHide = TRUE,
                                                    direction = "center",
                                                    offset = c(0, 0), opacity = 1, 
                                                    textsize = "10px", textOnly = TRUE, 
                                                    style = list("font-style" = "bold")))
