
# CREDIT: Based on Berry Boessenkool function
# http://raw.githubusercontent.com/brry/misc/master/shp2raster.R
# https://gis.stackexchange.com/questions/17798/converting-a-polygon-into-a-raster-using-r

shp2raster <- function(
    shp=NULL,      # Shapefile Object Spatial*DataFrame. If NULL, it reads shpname with rgdal::readOGR.
    ncells=99,     # Approximate number of cells in either direction to determine cellsize.
    cellsize=NA,   # Cell size in coordinate units (usually degrees or m). Computed from ncells if NA.
    ncellwarn=1000,# Warn if there will be more cells than this. To prevent e.g. accidental degrees instead of km.
    column="",     # Name of column to use for z dimension in raster. Empty string for interactive selection.
    ...)           # More arguments passed to raster::rasterize, like overwrite=TRUE
{
    e <- raster::extent(shp) 
    if(is.na(cellsize)) {
        cellsize <- mean(c((e@xmax-e@xmin), (e@ymax-e@ymin))/ncells)
    }
    nx <- (e@xmax-e@xmin)/cellsize # this seems revertive from the previous line, but
    ny <- (e@ymax-e@ymin)/cellsize # is needed because ncells differ in both directions
    cat(paste0("Raster will be large: nx=",
               round(nx,1), ", ny=",round(ny,1)," (with cellsize=", 
               round(cellsize,4),", xmin=",
               round(e@xmin,2), ", xmax=",round(e@xmax,2),").\n"))
    r <- raster(ncol=nx, nrow=ny)
    raster::extent(r) <- extent(shp)
    resdif <- abs((yres(r) - xres(r)) / yres(r) )
    if(resdif > 0.01) {
        stop("Horizontal (",round(xres(r),3),") and vertical (", round(yres(r),3),
             ") resolutions are too different (diff=",round(resdif,3), ", but must be <0.010).\n",
             "  Use a smaller cell size to achieve this (currently ",round(cellsize,1),").")
    }
    # column selection
    possible_columns <- names(shp)
    if(!column %in% possible_columns) {
        stop("Column '",column, "' is not in Shapefile. Select one of\n", 
             paste(strwrap(toString(possible_columns)), collapse="\n"))
    }
    ras <- raster::rasterize(shp, 
                             r, 
                             field=column, 
                             proj=shp@proj4string, 
                             ...)
    # return output
    ras
}
