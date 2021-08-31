

rm(list=ls())

##------------------------------------------------------------------------------
## DEPENDENCIES
##------------------------------------------------------------------------------

# install.packages("censusapi")
library(censusapi)
library(data.table)

## Note, this requires a file ./config/census.yaml with a census key. 
## You can easily register for an API key from the census bureau
Sys.setenv(CENSUS_KEY = yaml::read_yaml("config/census.yaml")$census_key)


##------------------------------------------------------------------------------
## EXAMINE VARIABLE NAMES
##------------------------------------------------------------------------------

pl10_vars <- listCensusMetadata(name = "2010/dec/pl", type = "variables") %>% 
    as.data.table

pl00_vars <- listCensusMetadata(name = "2000/dec/pl", type = "variables") %>% 
    as.data.table

pl00_vars[grep("PL001002", name)]


##------------------------------------------------------------------------------
## DEFINE POPULATION FIELDS
##------------------------------------------------------------------------------
pop_fields <- c("SUMLEVEL", "GEO_ID", "GEOCOMP", "LSAD_NAME", 
                "STATE", "COUNTY", "COUSUB", "TRACT", "BLKGRP", "BLOCK", 
                "PLACE", "CONCIT", "SLDL", "SLDU", "VTD", 
                "P001001", "P001002", "P001003", "P001004", "P001005",
                "P001006", "P001007", "P001008", "P001009", "P001010",
                "P001026", "P001047", "P001063", "P001070", "P002001",
                "P002002", "P002003", "P002004", "P002005", "P002006",
                "P002007", "P002008", "P002009", "P002010", "P002011",
                "P002012", "P002028", "P002049", "P002065", "P002072",
                "P003001", "P003002", "P003003", "P003004", "P003005",
                "P003006", "P003007", "P003008", "P003009", "P003010",
                "P003026", "P003047", "P003063", "P003070", "P004001",
                "P004002", "P004003", "P004004", "P004005", "P004006",
                "P004007", "P004008", "P004009", "P004010", "P004011",
                "P004012", "P004028", "P004049", "P004065", "P004072",
                "H001001", "H001002", "H001003")
pop_fields_2010 <- pop_fields 
pop_fields_2000 <- pop_fields %>% gsub("P0","PL0",.) %>% 
    grep("^H", ., invert=T, value=T)


##------------------------------------------------------------------------------
## DOWNLOAD 00 REDISTRICTING DATA
##------------------------------------------------------------------------------

pl_2000_il_tract <- getCensus(name = "dec/pl",
                              vintage = 2000,
                              vars = pop_fields_2000,
                              regionin="state:17+county:*",
                              region = "tract:*") %>% 
    as.data.table
pl_2000_il_tract[,sum(PL001001)] %>% format(., big.mark=",")
pl_2000_il_tract

pl_2000_us_county <- getCensus(name = "dec/pl",
                               vintage = 2000,
                               vars = pop_fields_2000,
                               regionin="state:*",
                               region = "county:*") %>% 
    as.data.table
pl_2000_us_county[,sum(PL001001)] %>% format(., big.mark=",")
pl_2000_us_county

##------------------------------------------------------------------------------
## DOWNLOAD 10 REDISTRICTING DATA
##------------------------------------------------------------------------------

pl_2010_il_tract <- getCensus(name = "dec/pl",
                              vintage = 2010,
                              vars = pop_fields_2010,
                              regionin="state:17+county:*",
                              region = "tract:*") %>% 
    as.data.table
pl_2010_il_tract[,sum(P001001)] %>% format(., big.mark=",")
pl_2010_il_tract

pl_2010_us_county <- getCensus(name = "dec/pl",
                               vintage = 2010,
                               vars = pop_fields_2010,
                               regionin="state:*",
                               region = "county:*") %>% 
    as.data.table
pl_2010_us_county[,sum(P001001)] %>% format(., big.mark=",")
pl_2010_us_county



##------------------------------------------------------------------------------
## WRITE CSVS
##------------------------------------------------------------------------------
fwrite(pl_2000_il_tract, "data/pl_2000_il_tract.csv")
fwrite(pl_2000_us_county, "data/pl_2000_us_county.csv")
fwrite(pl_2010_il_tract, "data/pl_2010_il_tract.csv")
fwrite(pl_2010_us_county, "data/pl_2010_us_county.csv")








##------------------------------------------------------------------------------
## EXAMPLE - NOT RUN
## It is also possible to directly download, except for the limitations on 
## the length of the API request
##------------------------------------------------------------------------------

##------------------------------------------------------------------------------
## EXAMPLE - TOTAL POP FOR COOK
##------------------------------------------------------------------------------
sprintf("https://api.census.gov/data/2010/dec/pl?get=%s&for=county:%s&in=state:%s&key=%s",
        "GEO_ID,NAME,P001001",
        "031", # county, e.g. "*"
        "17", # state, e.g. "*"
        Sys.getenv("CENSUS_KEY")) %>% 
    httr::GET() %>% 
    httr::content(as = "text") %>% 
    jsonlite::fromJSON()

# ##------------------------------------------------------------------------------
# ## DOWNLOAD POPULATION DATA
# ##------------------------------------------------------------------------------
# pop_fields_ex_10 <- c("GEO_ID,NAME,P002001,P002002,P002005,P002006,P002007,",
#                       "P002008,P002009,P002010,P002011") %>% paste(., collapse="")
# pop_fields_ex_00 <- pop_fields_ex_10 %>% gsub("P0","PL0",.)
# 
# pop_2010_us_county <- sprintf(
#     "https://api.census.gov/data/2010/dec/pl?get=%s&for=county:%s&in=state:%s&key=%s",
#     pop_fields_ex_10, "*", "*", Sys.getenv("CENSUS_KEY")) %>% 
#     httr::GET() %>%  httr::content(as = "text") %>%  jsonlite::fromJSON() %>% 
#     apply(.,1, paste, collapse = "|") %>% paste(., collapse = "\n") %>% 
#     fread(text=., sep="|")
# pop_2010_us_county
# 
# pop_2010_il_county <- sprintf(
#     "https://api.census.gov/data/2010/dec/pl?get=%s&for=county:%s&in=state:%s&key=%s",
#     pop_fields_ex_10, "*", "17", Sys.getenv("CENSUS_KEY")) %>% 
#     httr::GET() %>%  httr::content(as = "text") %>%  jsonlite::fromJSON() %>% 
#     apply(.,1, paste, collapse = "|") %>% paste(., collapse = "\n") %>% 
#     fread(text=., sep="|")
# pop_2010_il_county
# 
# pop_2010_cook_tract <- sprintf(
#     "https://api.census.gov/data/2010/dec/pl?get=%s&for=tract:%s&in=state:%s&in=county:%s&key=%s",
#     pop_fields_ex_10, "*", "17","031", Sys.getenv("CENSUS_KEY")) %>% 
#     httr::GET() %>% httr::content(as = "text") %>% jsonlite::fromJSON() %>% 
#     apply(.,1, paste, collapse = "|") %>% paste(., collapse = "\n") %>% 
#     fread(text=., sep="|")
# pop_2010_cook_tract
# 
# 
# pop_2000_us_county <- sprintf(
#     "https://api.census.gov/data/2000/dec/pl?get=%s&for=county:%s&in=state:%s&key=%s",
#     pop_fields_ex_00, "*", "*", Sys.getenv("CENSUS_KEY")) %>%
#     httr::GET() %>%  httr::content(as = "text") %>%  jsonlite::fromJSON() %>%
#     apply(.,1, paste, collapse = "|") %>% paste(., collapse = "\n") %>%
#     fread(text=., sep="|")
# pop_2000_us_county
# 
# pop_2000_il_county <- sprintf(
#     "https://api.census.gov/data/2000/dec/pl?get=%s&for=county:%s&in=state:%s&key=%s",
#     pop_fields_ex_00, "*", "17", Sys.getenv("CENSUS_KEY")) %>% 
#     httr::GET() %>%  httr::content(as = "text") %>%  jsonlite::fromJSON() %>% 
#     apply(.,1, paste, collapse = "|") %>% paste(., collapse = "\n") %>% 
#     fread(text=., sep="|")
# pop_2000_il_county
# 
# pop_2000_cook_tract <- sprintf(
#     "https://api.census.gov/data/2000/dec/pl?get=%s&for=tract:%s&in=state:%s&in=county:%s&key=%s",
#     pop_fields_ex_00, "*", "17","031", Sys.getenv("CENSUS_KEY")) %>% 
#     httr::GET() %>% httr::content(as = "text") %>% jsonlite::fromJSON() %>% 
#     apply(.,1, paste, collapse = "|") %>% paste(., collapse = "\n") %>% 
#     fread(text=., sep="|")
# pop_2000_cook_tract



