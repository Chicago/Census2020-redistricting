

rm(list=ls())

##------------------------------------------------------------------------------
## DEPENDENCIES
##------------------------------------------------------------------------------

# install.packages("censusapi")
library(censusapi)
library(magrittr)
library(data.table)

##------------------------------------------------------------------------------
## LIST ALL (DOCUMENTED) API ENDPOINTS
## (PL data for 2020 is not listed as of 8/23/2021)
##------------------------------------------------------------------------------

apis <- listCensusApis()

##------------------------------------------------------------------------------
## LIST VARIABLES FOR PL 2000 and 2010
##------------------------------------------------------------------------------

## ERROR, 2020 not available yet
# pl20_vars <- listCensusMetadata(name = "2020/dec/pl", type = "variables") %>% 
#     as.data.table


pl10_vars <- listCensusMetadata(name = "2010/dec/pl", type = "variables") %>% 
    as.data.table


pl00_vars <- listCensusMetadata(name = "2000/dec/pl", type = "variables") %>% 
    as.data.table


###
## SAVE
###
# fwrite(apis, "data/Census APIs.csv")
# fwrite(pl10_vars, "data/pl10_variables.csv")
# fwrite(pl00_vars, "data/pl00_variables.csv")

