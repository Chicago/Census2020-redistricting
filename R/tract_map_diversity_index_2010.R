acs_2010 <- fread("../Census2020/data-census-planning/cook/2010_U.S._Census_Mail_Return_Rates_and_Demographics_by_Tract.csv")

acs_2010[]
colnames(acs_2010)
acs_2010$div_index <- acs_2010[
    ,
    list(TOT   = `Total Population`, # Total pop
         H     = `Total Population Hispanic`, # Hispanic or Latino
         W     = `Total Population White`, # Not Hispanic or Latino: White alone
         B     = `Total Population Black`, # Not Hispanic or Latino:  Black or African American alone 
         AIAN  = `Total Population Native American`, # Not Hispanic or Latino:  American Indian and Alaska Native alone
         ASIAN = `Total Population Asian`, # Not Hispanic or Latino:  Asian alone
         NHPI  = `Total Population Hawaiian and Pacific Islander Decent`, # Not Hispanic or Latino:  Native Hawaiian and Other Pacific Islander alone
         SOR   = `Total Population Other Race`, # Not Hispanic or Latino:  Some Other Race alone
         MULTI = `Total Population 2 or More Races` # Not Hispanic or Latino:  Population of two or more races
    )][, 1 - ((H/TOT)^2 + (W/TOT)^2 + (B/TOT)^2 + 
                  (AIAN/TOT)^2 + (ASIAN/TOT)^2 + 
                  (NHPI/TOT)^2 + (SOR/TOT)^2 + 
                  (MULTI/TOT)^2)]

hist(acs_2010$div_index)



