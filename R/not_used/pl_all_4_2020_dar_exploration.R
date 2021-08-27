

rm(list=ls())

library(geneorama)
library(data.table)
library(magrittr)


#
# See data_documentation\PL94-171-DataDictionary.xlsx
#


## Read in all the data 
pl_all <- fread("data/pl_all.csv", 
                keepLeadingZeros = TRUE, 
                integer64 = "character",
                nrows = -10)
str(pl_all, list.len=Inf)


## Example of reading in just a one column
# fread("data/pl_all.csv", nrows = -10, select = c("REGION"))


## COPY SOME TABLES IN JSON TO EXCEL USING TEMP FILE
if(FALSE){
    source("R/functions/jsontotempfile.R")
    
    tf <- tempfile() %>% paste0(.,".txt")

    pl_all[, .N]
    pl_all[, .N, GEOVAR] %>% jsontotempfile(.,outfile = tf)
    pl_all[, .N, GEOCOMP] %>% jsontotempfile(.,outfile = tf)
    pl_all[, .N, STATENS] %>% jsontotempfile(.,outfile = tf)
    pl_all[, .N, PLACE] %>% .[order(-N)] %>% jsontotempfile(.,outfile = tf)
    pl_all[, .N, CONCIT] %>% .[order(-N)] %>% jsontotempfile(.,outfile = tf)
    pl_all[, .N, CONCITCC] %>% .[order(-N)] %>% jsontotempfile(.,outfile = tf)
    pl_all[, .N, PARTFLAG] %>% jsontotempfile(.,outfile = tf)
    
    unlink(tf)
    rm(tf)
}


pl_all[, .N, keyby = COUNTY]


pl_all[COUNTY=="031" & SUMLEV == "060", list(.N), list(BASENAME)]
pl_all[COUNTY=="031" & SUMLEV == "050", list(.N), list(BASENAME)]

pl_all[COUNTY=="031" & SUMLEV == "050", 
       list(P0010001, P0010002,
            P0030001, P0030002,
            H0010001, H0010002, H0010003)]

pl_all[COUNTY=="031" & SUMLEV == "050", 
       list(TOT = P0020001, # Total pop
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


pl_all[, 
       list(TOT = P0020001, # Total pop
            H     = P0020002, # Hispanic or Latino
            W     = P0020005, # Not Hispanic or Latino: White alone
            B     = P0020006, # Not Hispanic or Latino:  Black or African American alone 
            AIAN  = P0020007, # Not Hispanic or Latino:  American Indian and Alaska Native alone
            ASIAN = P0020008, # Not Hispanic or Latino:  Asian alone
            NHPI  = P0020009, # Not Hispanic or Latino:  Native Hawaiian and Other Pacific Islander alone
            SOR   = P0020010, # Not Hispanic or Latino:  Some Other Race alone
            MULTI = P0020011 # Not Hispanic or Latino:  Population of two or more races
       )] %>% 
    .[ , div_index := 1 - ((H/TOT)^2 + (W/TOT)^2 + (B/TOT)^2 + (AIAN/TOT)^2 + 
                  (ASIAN/TOT)^2 + (NHPI/TOT)^2 + (SOR/TOT)^2 + (MULTI/TOT)^2)]

pl_all[COUNTY=="031", list(.N), SUMLEV]
pl_all[COUNTY=="031", list(COUNTY, .N), SUMLEV]




pl




