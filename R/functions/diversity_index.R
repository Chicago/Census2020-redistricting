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
    ret <- general_table_getter(dt, "names_for_di_race_var_table")
    return(ret)
}

age_and_race_vars_table <- function(dt){
    ret <- general_table_getter(dt, "names_for_age_and_race_vars_table")
    
    ret[ , TOT_CHILD := TOT - TOT_ADULT]
    ret[ , H_CHILD := H - H_ADULT]
    ret[ , W_CHILD := W - W_ADULT]
    ret[ , B_CHILD := B - B_ADULT]
    ret[ , AIAN_CHILD := AIAN - AIAN_ADULT]
    ret[ , ASIAN_CHILD := ASIAN - ASIAN_ADULT]
    ret[ , NHPI_CHILD := NHPI - NHPI_ADULT]
    ret[ , SOR_CHILD := SOR - SOR_ADULT]
    ret[ , MULTI_CHILD := MULTI - MULTI_ADULT]
    
    return(ret)
}

general_table_getter <- function(dt, table_column_name){
    require(data.table)
    require(magrittr)
    
    # dt <- pl_2000_tract
    
    ## Pull full list of reference columns
    ref_cols <- fread("data/pl_variable_concordance.csv", na.strings = "") %>% 
        .[ , -"Description"] %>% .[]
    ## Rename desired column
    setnames(ref_cols, table_column_name, "cur_table")
    
    ## filter to just the names for this table
    ref_cols <- ref_cols[!is.na(cur_table)]
    ## Keep just the columns we need (the 2000, 2010, and 2020 names, and the 
    ## current table's names)
    ref_cols <- ref_cols[ , list(name_2000, name_2010, name_2020, cur_table)]
    
    
    ## Check if this is the 2020, 2010, or 2000 version of the pl table
    ## and then construct the return value
    if((ref_cols[!is.na(name_2020), name_2020] %in% colnames(dt)) %>% all){
        source_columns <- ref_cols[!is.na(cur_table) & !is.na(name_2020)]
        ret <- dt[ , source_columns$name_2020, with=FALSE]
        setnames(ret, source_columns$cur_table)
        ret[ , GEO_ID := gsub("1400000US", "", GEO_ID)]
    }
    if((ref_cols[!is.na(name_2010), name_2010] %in% colnames(dt)) %>% all){
        source_columns <- ref_cols[!is.na(cur_table) & !is.na(name_2010)]
        ret <- dt[ , source_columns$name_2010, with=FALSE]
        setnames(ret, source_columns$cur_table)
        ret[ , GEO_ID := gsub("1400000US", "", GEO_ID)]
    }
    if((ref_cols[!is.na(name_2000), name_2000] %in% colnames(dt)) %>% all){
        source_columns <- ref_cols[!is.na(cur_table) & !is.na(name_2000)]
        ret <- dt[ , source_columns$name_2000, with=FALSE]
        setnames(ret, source_columns$cur_table)
        ret[ , GEO_ID := gsub("1400000US", "", GEO_ID)]
    }
    
    if(exists("ret")){
        return(ret[])
    } else {
        stop("Are the appropriate column names in the data set?")
    }
}


## This is the same as the function above, but many more variables and more 
## generalized

# age_and_race_vars_table <- function(dt){
#     require(data.table)
#     require(magrittr)
#     
#     # dt <- pl_2000_tract
#     
#     ## Pull full list of reference columns
#     ref_cols <- fread("data/pl_variable_concordance.csv", na.strings = "") %>% 
#         .[ , -"Description"] %>% .[]
#     ## filter to just the names for this table
#     ref_cols <- ref_cols[!is.na(names_for_age_and_race_table)]
#     ## Keep just the columns we need (the 2000, 2010, and 2020 names, and the 
#     ## current table's names)
#     ref_cols <- ref_cols[ , list(name_2000, name_2010, name_2020,
#                                  cur_table = names_for_age_and_race_table)]
#     
#     
#     ## Check if this is the 2020, 2010, or 2000 version of the pl table
#     ## and then construct the return value
#     if((ref_cols[!is.na(name_2020), name_2020] %in% colnames(dt)) %>% all){
#         source_columns <- ref_cols[!is.na(cur_table) & !is.na(name_2020)]
#         ret <- dt[ , source_columns$name_2020, with=FALSE]
#         setnames(ret, source_columns$cur_table)
#         ret[ , GEO_ID := gsub("1400000US", "", GEO_ID)]
#     }
#     if((ref_cols[!is.na(name_2010), name_2010] %in% colnames(dt)) %>% all){
#         source_columns <- ref_cols[!is.na(cur_table) & !is.na(name_2010)]
#         ret <- dt[ , source_columns$name_2010, with=FALSE]
#         setnames(ret, source_columns$cur_table)
#         ret[ , GEO_ID := gsub("1400000US", "", GEO_ID)]
#     }
#     if((ref_cols[!is.na(name_2000), name_2000] %in% colnames(dt)) %>% all){
#         source_columns <- ref_cols[!is.na(cur_table) & !is.na(name_2000)]
#         ret <- dt[ , source_columns$name_2000, with=FALSE]
#         setnames(ret, source_columns$cur_table)
#         ret[ , GEO_ID := gsub("1400000US", "", GEO_ID)]
#     }
#     
#     if(exists("ret")){
#         ret[ , TOT_CHILD := TOT - TOT_ADULT]
#         ret[ , H_CHILD := H - H_ADULT]
#         ret[ , W_CHILD := W - W_ADULT]
#         ret[ , B_CHILD := B - B_ADULT]
#         ret[ , AIAN_CHILD := AIAN - AIAN_ADULT]
#         ret[ , ASIAN_CHILD := ASIAN - ASIAN_ADULT]
#         ret[ , NHPI_CHILD := NHPI - NHPI_ADULT]
#         ret[ , SOR_CHILD := SOR - SOR_ADULT]
#         ret[ , MULTI_CHILD := MULTI - MULTI_ADULT]
#     } else {
#         stop("Are the appropriate column names in the data set?")
#     }
#     
#     #return
#     return(ret[])
#     
# }









## Manual way of getting diversity index variables

# di_race_var_table <- function(dt){
#     require(data.table)
#     require(magrittr)
#     
#     ref_cols <- data.table(ret = c("STATE", "COUNTY", "TRACT", "GEO_ID", "LSAD_NAME",
#                                    "TOT",   # Total pop
#                                    "H",     # Hispanic or Latino
#                                    "W",     # Not Hispanic or Latino: White alone
#                                    "B",     # Not Hispanic or Latino:  Black or African American alone 
#                                    "AIAN",  # Not Hispanic or Latino:  American Indian and Alaska Native alone
#                                    "ASIAN", # Not Hispanic or Latino:  Asian alone
#                                    "NHPI",  # Not Hispanic or Latino:  Native Hawaiian and Other Pacific Islander alone
#                                    "SOR",   # Not Hispanic or Latino:  Some Other Race alone
#                                    "MULTI"), # Not Hispanic or Latino:  Population of two or more races
#                            colnames_2020 = c("STATE", "COUNTY", "TRACT", "GEO_ID", "LSAD_NAME",
#                                              "P0020001", "P0020002", "P0020005", "P0020006", "P0020007",
#                                              "P0020008", "P0020009", "P0020010", "P0020011"))
#     ref_cols$colnames_2010 <- ref_cols$colnames_2020 %>% gsub("^P00200", "P0020", .)
#     ref_cols$colnames_2000 <- ref_cols$colnames_2020 %>% gsub("^P00200", "PL0020", .)
#     
#     # colnames_2010 <- colnames_2020 %>% gsub("^P00200", "P0020", .)
#     # colnames_2000 <- colnames_2020 %>% gsub("^P00200", "PL0020", .)
#     
#     if("GEOID" %in% colnames(dt)){
#         ## in the 2020 data the geocode corresponds to geo_id
#         dt %>% setnames(., "GEOID", "GEO_ID")
#     }
#     if(!"LSAD_NAME" %in% colnames(dt)){
#         ## in the 2020 data the LSAD_NAME is missing, maybe I forgot it dl it?
#         dt[ , LSAD_NAME:= NA]
#     }
#     
#     if((ref_cols$colnames_2000 %in% colnames(dt)) %>% all){
#         ret <- dt[,ref_cols$colnames_2000,with=F]
#         setnames(ret, ref_cols$colnames_2000, ref_cols$ret)
#         ret[ , GEO_ID := gsub("1400000US", "", GEO_ID)]
#     }
#     
#     if((ref_cols$colnames_2010 %in% colnames(dt)) %>% all){
#         ret <- dt[,ref_cols$colnames_2010,with=F]
#         setnames(ret, ref_cols$colnames_2010, ref_cols$ret)
#         ret[ , GEO_ID := gsub("1400000US", "", GEO_ID)]
#     }
#     
#     if((ref_cols$colnames_2020 %in% colnames(dt)) %>% all){
#         ret <- dt[,ref_cols$colnames_2020,with=F]
#         setnames(ret, ref_cols$colnames_2020, ref_cols$ret)
#         ret[ , GEO_ID := gsub("1400000US", "", GEO_ID)]
#     }
#     
#     if(!exists("ret")) stop("Are the appropriate column names in the data set?")
#     
#     #return
#     return(ret[])
#     
# }
