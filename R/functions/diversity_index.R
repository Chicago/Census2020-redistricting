diversity_index <- function(dt){
    require(magrittr)
    require(data.table)
    
    ret <- dt[ , 1 - ((H/TOT)^2 + (W/TOT)^2 + (B/TOT)^2 + (AIAN/TOT)^2 + 
                          (ASIAN/TOT)^2 + (NHPI/TOT)^2 + (SOR/TOT)^2 + 
                          (MULTI/TOT)^2)]

    return(ret)
}


fread_census <- function(fname){
    ret <- fread(fname,
                 keepLeadingZeros = TRUE,
                 integer64 = "character")
    ret
}

di_race_var_table <- function(dt){
    require(data.table)
    require(magrittr)
    
    ref_cols <- data.table(ret = c("STATE", "COUNTY", "TRACT", "GEO_ID", "LSAD_NAME",
                                   "TOT",   # Total pop
                                   "H",     # Hispanic or Latino
                                   "W",     # Not Hispanic or Latino: White alone
                                   "B",     # Not Hispanic or Latino:  Black or African American alone 
                                   "AIAN",  # Not Hispanic or Latino:  American Indian and Alaska Native alone
                                   "ASIAN", # Not Hispanic or Latino:  Asian alone
                                   "NHPI",  # Not Hispanic or Latino:  Native Hawaiian and Other Pacific Islander alone
                                   "SOR",   # Not Hispanic or Latino:  Some Other Race alone
                                   "MULTI"), # Not Hispanic or Latino:  Population of two or more races
                           colnames_2020 = c("STATE", "COUNTY", "TRACT", "GEO_ID", "LSAD_NAME",
                                             "P0020001", "P0020002", "P0020005", "P0020006", "P0020007",
                                             "P0020008", "P0020009", "P0020010", "P0020011"))
    ref_cols$colnames_2010 <- ref_cols$colnames_2020 %>% gsub("^P00200", "P0020", .)
    ref_cols$colnames_2000 <- ref_cols$colnames_2020 %>% gsub("^P00200", "PL0020", .)
    
    # colnames_2010 <- colnames_2020 %>% gsub("^P00200", "P0020", .)
    # colnames_2000 <- colnames_2020 %>% gsub("^P00200", "PL0020", .)
    
    if("GEOID" %in% colnames(dt)){
        ## in the 2020 data the geocode corresponds to geo_id
        dt %>% setnames(., "GEOID", "GEO_ID")
    }
    if(!"LSAD_NAME" %in% colnames(dt)){
        ## in the 2020 data the LSAD_NAME is missing, maybe I forgot it dl it?
        dt[ , LSAD_NAME:= NA]
    }
    
    if((ref_cols$colnames_2000 %in% colnames(dt)) %>% all){
        ret <- dt[,ref_cols$colnames_2000,with=F]
        setnames(ret, ref_cols$colnames_2000, ref_cols$ret)
        ret[ , GEO_ID := gsub("1400000US", "", GEO_ID)]
    }
    
    if((ref_cols$colnames_2010 %in% colnames(dt)) %>% all){
        ret <- dt[,ref_cols$colnames_2010,with=F]
        setnames(ret, ref_cols$colnames_2010, ref_cols$ret)
        ret[ , GEO_ID := gsub("1400000US", "", GEO_ID)]
    }
    
    if((ref_cols$colnames_2020 %in% colnames(dt)) %>% all){
        ret <- dt[,ref_cols$colnames_2020,with=F]
        setnames(ret, ref_cols$colnames_2020, ref_cols$ret)
        ret[ , GEO_ID := gsub("1400000US", "", GEO_ID)]
    }
    
    if(!exists("ret")) stop("Are the appropriate column names in the data set?")
    
    #return
    return(ret)
    
}

