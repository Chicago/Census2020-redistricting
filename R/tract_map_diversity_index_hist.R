

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
library(raster)

leaflet_stadia_url <- "https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png?apikey={'197c5c13-03bb-409e-8806-1a49bc7deaad'}"
leaflet_stadia_attribution <- '&copy; <a href="https://stadiamaps.com/">Stadia Maps</a>, &copy; <a href="https://openmaptiles.org/">OpenMapTiles</a> &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors'

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

hist(pl_2000_tract$DI)
hist(pl_2010_tract$DI)
hist(pl_2020_tract$DI)

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

shp_tracts_2020@data %>% head

shp_tracts_2000@data <- merge(shp_tracts_2000@data,
                              pl_2000_tract[,-c("STATE", "COUNTY", "TRACT", "LSAD_NAME")],
                              by = "GEO_ID", sort = FALSE)
shp_tracts_2010@data <- merge(shp_tracts_2010@data,
                              pl_2010_tract[,-c("STATE", "COUNTY", "TRACT", "LSAD_NAME")],
                              by = "GEO_ID", sort = FALSE)
shp_tracts_2020@data <- merge(shp_tracts_2020@data,
                              pl_2020_tract[,-c("STATE", "COUNTY", "TRACT", "LSAD_NAME")],
                              by = "GEO_ID", sort = FALSE)

shp_tracts_2000@data %>% head
shp_tracts_2010@data %>% head
shp_tracts_2020@data %>% head

shp_tracts_2000@data %>% as.data.table %>% .[chicago==TRUE, sum(TOT)]
shp_tracts_2010@data %>% as.data.table %>% .[chicago==TRUE, sum(TOT)]
shp_tracts_2020@data %>% as.data.table %>% .[chicago==TRUE, sum(TOT)]

shp_tracts_2000@data %>% as.data.table %>% .[, sum(TOT)]
shp_tracts_2010@data %>% as.data.table %>% .[, sum(TOT)]
shp_tracts_2020@data %>% as.data.table %>% .[, sum(TOT)]


shp_tracts_2000$area <- area(shp_tracts_2000)
shp_tracts_2010$area <- area(shp_tracts_2010)
shp_tracts_2020$area <- area(shp_tracts_2020)

##==============================================================================
## ADD NORMALIZED VALUES TO SHAPE DATA 
## NORMALIZED BY PERCENT OF TOTAL
## NORMALIZED BY LAND MASS
##==============================================================================

# shp_tracts_2000@data$ALAND00 <- shp_tracts_2000@data$ALAND00 %>% as.numeric
shp_tracts_2000@data <- cbind(
    shp_tracts_2000@data,
    normalize_vars(shp_tracts_2000@data,
                   c("TOT", "H", "W", "B", "AIAN", "ASIAN", "NHPI","SOR", "MULTI"),
                   "TOT") %>% setnames(.,colnames(.) %>% tolower %>% paste0(., "_pct")),
    normalize_vars(shp_tracts_2000@data,
                   c("TOT", "H", "W", "B", "AIAN", "ASIAN", "NHPI","SOR", "MULTI"),
                   "area") %>% setnames(.,colnames(.) %>% tolower %>% paste0(., "_dens")))

# shp_tracts_2010@data$ALAND10 <- shp_tracts_2010@data$ALAND10 %>% as.numeric
shp_tracts_2010@data <- cbind(
    shp_tracts_2010@data,
    normalize_vars(shp_tracts_2010@data,
                   c("TOT", "H", "W", "B", "AIAN", "ASIAN", "NHPI","SOR", "MULTI"),
                   "TOT") %>% setnames(.,colnames(.) %>% tolower %>% paste0(., "_pct")),
    normalize_vars(shp_tracts_2010@data,
                   c("TOT", "H", "W", "B", "AIAN", "ASIAN", "NHPI","SOR", "MULTI"),
                   "area") %>% setnames(.,colnames(.) %>% tolower %>% paste0(., "_dens")))

# shp_tracts_2020@data$ALAND20 <- shp_tracts_2020@data$ALAND20 %>% as.numeric
shp_tracts_2020@data <- cbind(
    shp_tracts_2020@data,
    normalize_vars(shp_tracts_2020@data,
                   c("TOT", "H", "W", "B", "AIAN", "ASIAN", "NHPI","SOR", "MULTI"),
                   "TOT") %>% setnames(.,colnames(.) %>% tolower %>% paste0(., "_pct")),
    normalize_vars(shp_tracts_2020@data,
                   c("TOT", "H", "W", "B", "AIAN", "ASIAN", "NHPI","SOR", "MULTI"),
                   "area") %>% setnames(.,colnames(.) %>% tolower %>% paste0(., "_dens")))

##==============================================================================
## Diversity index MAP
##==============================================================================

pal <- viridisLite::viridis(256, option = "D") %>%
    colorNumeric(palette = .,
                 domain = shp_tracts_2020$DI,
                 na.color = "black", alpha = F, reverse = TRUE)
leaflet(shp_tracts_2020) %>%
    addTiles(urlTemplate = leaflet_stadia_url,
             attribution = leaflet_stadia_attribution) %>%
    addPolygons(fillColor = ~pal(DI),
                fillOpacity = 0.5,
                stroke=FALSE, weight = 0.5,
                label=~paste(GEO_ID, DI)) %>%
    addLegend(pal = pal,
              values = ~DI,
              title = "Diversity Index",
              position = "bottomright")

pal <- viridisLite::viridis(256, option = "D") %>%
    colorNumeric(palette = .,
                 domain = shp_tracts_2010$DI,
                 na.color = "black", alpha = F, reverse = TRUE)
leaflet(shp_tracts_2010) %>%
    addTiles(urlTemplate = leaflet_stadia_url,
             attribution = leaflet_stadia_attribution) %>%
    addPolygons(fillColor = ~pal(DI),
                fillOpacity = 0.5,
                stroke=FALSE, weight = 0.5,
                label=~paste(GEO_ID, DI)) %>%
    addLegend(pal = pal,
              values = ~DI,
              title = "Diversity Index",
              position = "bottomright")

pal <- viridisLite::viridis(256, option = "D") %>%
    colorNumeric(palette = .,
                 domain = shp_tracts_2000$DI,
                 na.color = "black", alpha = F, reverse = TRUE)
leaflet(shp_tracts_2000) %>%
    addTiles(urlTemplate = leaflet_stadia_url,
             attribution = leaflet_stadia_attribution) %>%
    addPolygons(fillColor = ~pal(DI),
                fillOpacity = 0.5,
                stroke=FALSE, weight = 0.5,
                label=~paste(GEO_ID, DI)) %>%
    addLegend(pal = pal,
              values = ~DI,
              title = "Diversity Index",
              position = "bottomright")

## Chicago's ratio of height to width
# bbox(chi_city_outline)["y",] %>% diff %>% unname/
#     bbox(chi_city_outline)["x",] %>% diff %>% unname
# About .91



r <- shp2raster(shp_tracts_2020, column = "tot_dens",
                ncells = 1000)
plot(r)

r00 <- shp2raster(shp_tracts_2000, column = "tot_dens",
                ncells = 1000)
plot(r)
plot(r00)
plot(r-r00)


# summary(shp_tracts_2000)
# 
# r00 <- raster(shp_tracts_2000)
# summary(r00)

str(shp_tracts_2020@data)


# r <- rasterize(shp_tracts_2020, 
#                raster(ncol=700, nrow=700),
#                ext=extent(shp_tracts_2020),
#                "tot_pct")
# shp_tracts_2020$ALAND20 %>% sort %>% head
# shp_tracts_2020$tot_dens %>% sort %>% tail
# shp_tracts_2020@data[which(shp_tracts_2020$ALAND20==0),]
# which(shp_tracts_2020$tot_dens==max(shp_tracts_2020$tot_dens, na.rm=T)) %>% shp_tracts_2020@data[.,]
# 
# library(raster)
# x <- shapefile('file.shp')
# crs(x)
# plot(area(shp_tracts_2020) %>% pmin(., 1e8) , shp_tracts_2020$ALAND20)
# hist(area(shp_tracts_2020) %>% .[.<3e7] )
# area(shp_tracts_2020) %>% sort %>% head
# 
# plot(r)
# 
# 
# 
# r <- raster(ncol=700, nrow=700)
# extent(r) <- extent(shp_tracts_2020)
# shp_tracts_2020$temp <- shp_tracts_2020$TOT / as.numeric(shp_tracts_2020$ALAND20)
# rp <- rasterize(shp_tracts_2020, r, 'temp')
# plot(rp)
# 

# # ??raster
# ??bkde2D
# kde <- bkde2D(dat[ , list(longitude, latitude)],
#               bandwidth=c(.0045, .0068), gridsize = c(100,100))
# # Create Raster from Kernel Density output
# KernelDensityRaster <- raster(list(x=kde$x1 ,y=kde$x2 ,z = kde$fhat))
# 
# #create pal function for coloring the raster
# palRaster <- colorNumeric("Spectral", domain = KernelDensityRaster@data@values)
# 
# ## Leaflet map with raster
# leaflet() %>% addTiles() %>% 
#     addRasterImage(KernelDensityRaster, 
#                    colors = palRaster, 
#                    opacity = .8) %>%
#     addLegend(pal = palRaster, 
#               values = KernelDensityRaster@data@values, 
#               title = "Kernel Density of Points")





















