diversity_index <- function(dt){
    require(magrittr)
    require(data.table)
    
    colnames_2020 <- c("P0020001", "P0020002", "P0020005", "P0020006", "P0020007",
                       "P0020008", "P0020009", "P0020010", "P0020011")
    colnames_2010 <- colnames_2020 %>% gsub("^P00200", "PL0020", .)
    
    if((colnames_2020 %in% colnames(dt)) %>% all){
        ret <- dt[i = TRUE, 
                  list(TOT   = P0020001, # Total pop
                       H     = P0020002, # Hispanic or Latino
                       W     = P0020005, # Not Hispanic or Latino: White alone
                       B     = P0020006, # Not Hispanic or Latino:  Black or African American alone 
                       AIAN  = P0020007, # Not Hispanic or Latino:  American Indian and Alaska Native alone
                       ASIAN = P0020008, # Not Hispanic or Latino:  Asian alone
                       NHPI  = P0020009, # Not Hispanic or Latino:  Native Hawaiian and Other Pacific Islander alone
                       SOR   = P0020010, # Not Hispanic or Latino:  Some Other Race alone
                       MULTI = P0020011 # Not Hispanic or Latino:  Population of two or more races
                  )] %>% 
            .[ , 1 - ((H/TOT)^2 + (W/TOT)^2 + (B/TOT)^2 + (AIAN/TOT)^2 + 
                          (ASIAN/TOT)^2 + (NHPI/TOT)^2 + (SOR/TOT)^2 + (MULTI/TOT)^2)]
    }
    if((colnames_2010 %in% colnames(dt)) %>% all){
        ret <- dt[i = TRUE, 
                  list(TOT   = PL002001, # Total pop
                       H     = PL002002, # Hispanic or Latino
                       W     = PL002005, # Not Hispanic or Latino: White alone
                       B     = PL002006, # Not Hispanic or Latino:  Black or African American alone 
                       AIAN  = PL002007, # Not Hispanic or Latino:  American Indian and Alaska Native alone
                       ASIAN = PL002008, # Not Hispanic or Latino:  Asian alone
                       NHPI  = PL002009, # Not Hispanic or Latino:  Native Hawaiian and Other Pacific Islander alone
                       SOR   = PL002010, # Not Hispanic or Latino:  Some Other Race alone
                       MULTI = PL002011 # Not Hispanic or Latino:  Population of two or more races
                  )] %>% 
            .[ , 1 - ((H/TOT)^2 + (W/TOT)^2 + (B/TOT)^2 + (AIAN/TOT)^2 + 
                          (ASIAN/TOT)^2 + (NHPI/TOT)^2 + (SOR/TOT)^2 + (MULTI/TOT)^2)]
    }
    
    if(!exists("ret")) stop("Are the appropriate column names in the data set?")
    
    return(ret)
}
