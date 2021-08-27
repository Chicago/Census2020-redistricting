

## Simple raster steps
# library(raster)
# r <- raster(ncol=700, nrow=700)
# extent(r) <- extent(shp_tracts_2020)
# shp_tracts_2020$tot <- shp_tracts_2020$TOT / as.numeric(shp_tracts_2020$ALAND20)
# rp <- rasterize(shp_tracts_2020, r, 'tot')
# plot(rp)
