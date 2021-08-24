

## Overview

On August 12, 2021 the US Census Bureau released the first detailed results of the 2020 census in accordance with Public Law 94-171, commonly referred to as the redistricting data. The release includes detailed demographics, updated maps, and other documentation and variables. 

This repository takes a look at the results as they relate to Chicago and the region, and comparing the 2020 results to past vintages. 

The PL94-171 release will not be available through normal API access initially.  The links for PL-171 and other sources are listed below the articles.  


# Related Articles

### Main press release for PL94-171

Contains highlights, links to apps, census maps, etc:<br> https://www.census.gov/newsroom/press-releases/2021/population-changes-nations-diversity.html

### Diversity index

The diversity index is based on work that began in 2015 and was tested in 2018. The US has gotten more diverse in general, but individual regions vary widely in their predominant racial makeup and level of diversity. The article contains county level maps that show how diversity varies around the US, and other visualizations. 

https://www.census.gov/library/stories/2021/08/2020-united-states-population-more-racially-ethnically-diverse-than-2010.html

https://www.census.gov/library/stories/2021/08/improved-race-ethnicity-measures-reveal-united-states-population-much-more-multiracial.html

Details and the equation to calculate the Census Bureau's Diversity Index can be found in this project here: `.\\data\\RAW\\DOCUMENTATION\\Diversity Index Equation.pdf` (this was obtained by request, it's not online from the Bureau directly, yet.)


# Data Release and Documentation

## 2020 Census (P.L. 94-171) Redistricting Main Landing Page

https://www.census.gov/programs-surveys/decennial-census/about/rdo/summary-files.html

The main page has:

 - tabular data sources (population variables)
 - detailed documentation
 - faq documentation
 - links to map data
 - links to crosswalks
 - sample code (R, SAS, Access)


## Population statistics for PL-94-171

The raw 2020 demograhic data for IL can be found here. This file contains every variable at every available summary level for example State, County, Tract, Blockgroup, Block. <br>
https://www2.census.gov/programs-surveys/decennial/2020/data/01-Redistricting_File--PL_94-171/Illinois/

Descriptions of variables and their groups: <br>
https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/complete-tech-docs/summary-file/2020Census_PL94_171Redistricting_StatesTechDoc_English.pdf

The raw has been copied here: `.\\data\\RAW\\PL94-171-2020-ILLINOIS\\il2020.pl.zip`.  

The scripts to process the raw population are here: 

 - `data\\CACHE\\il2020.pl_COMBINE.R` - unzip a local copy
 - `data\\CACHE\\il2020.pl_COMBINED_FILTER.R` - Create useful subsets

Useful subsets for PL-94-171 for the vintages 2020, 2010, and 2000 have been saved in `.\\data`.  This directory also contains a data dictionary and variable documentation. 


## Map files (2020 PL-94-171)

Links and notes from  redistricting landing page:

TIGER Line Shapefiles<br>
Use the 2020 Tab of the linked page.<br>
https://www.census.gov/geographies/mapping-files/time-series/geo/tiger-line-file.html

Block Assignment Files (BAFs):<br>
Use the 2020 Tab of the linked page. BAFs are meant to be used in conjunction with the NLTs.<br>
https://www.census.gov/geographies/reference-files/time-series/geo/block-assignment-files.html

Name Look-up Tables (NLTs):<br>
Use the 2020 Tab of the linked page. NLTs are meant to be used in conjunction with the BAFs.<br>
https://www.census.gov/geographies/reference-files/time-series/geo/name-lookup-tables.html

2010 to 2020 Tabulation Block Crosswalk Tables<br>
Use the 2020 Tab of the linked page. Select Block Relationship Files.<br>
https://www.census.gov/geographies/reference-files/time-series/geo/relationship-files.html

State tract map copied here:<br>
`data\\tl_2020_17_tract` - tract boundaries


## Map files (2010 and 2000)

Historical maps for 2000 and 2010:<br>
https://www2.census.gov/geo/tiger/tiger2k/il/tgr17031.zip<br> (not a regular map folder)
https://www2.census.gov/geo/tiger/TIGER2010/TRACT/2000/tl_2010_17_tract00.zip<br>
https://www2.census.gov/geo/tiger/TIGER2010/TRACT/2010/tl_2010_17_tract10.zip<br>
https://www2.census.gov/geo/tiger/TIGER2010/TRACT/2000/tl_2010_17013_tract00.zip<br>
https://www2.census.gov/geo/tiger/TIGER2010/TRACT/2010/tl_2010_17013_tract10.zip<br>

files copied to `data\\RAW\\MAPS`, unzipped to `data`


## TIGERweb Map Data Files

Page with top level map data including maps for roads, parks, correctional facilities, colleges, military facilities, cities, etc. <br>
https://tigerweb.geo.census.gov/tigerwebmain/TIGERweb_nation_based_files.html

TIGER Illinois 2020 County Map<br>
https://www2.census.gov/geo/tiger/TIGER2020PL/LAYER/COUNTY/2020/tl_2020_17_county20.zip<br>
`data/tl_2020_17_county20.zip` - county boundaries


TIGER Map data download selector for many states, years, geographies, and data types: https://www.census.gov/cgi-bin/geo/shapefiles/index.php<br>


### County level map data for 2020 for 17031 (COOK COUNTY)

Several maps and geographic data files<br>
https://www2.census.gov/geo/tiger/TIGER2020PL/STATE/17_ILLINOIS/17031/

 - `data\\RAW\\MAPS\\TL_2020_17031_COOK\\tl_2020_17031_addr.zip`
 - `data\\RAW\\MAPS\\TL_2020_17031_COOK\\tl_2020_17031_addrfn.zip`
 - `data\\RAW\\MAPS\\TL_2020_17031_COOK\\tl_2020_17031_arealm.zip`
 - `data\\RAW\\MAPS\\TL_2020_17031_COOK\\tl_2020_17031_areawater.zip`
 - `data\\RAW\\MAPS\\TL_2020_17031_COOK\\tl_2020_17031_bg10.zip`
 - `data\\RAW\\MAPS\\TL_2020_17031_COOK\\tl_2020_17031_bg20.zip`
 - `data\\RAW\\MAPS\\TL_2020_17031_COOK\\tl_2020_17031_cousub10.zip`
 - `data\\RAW\\MAPS\\TL_2020_17031_COOK\\tl_2020_17031_cousub20.zip`
 - `data\\RAW\\MAPS\\TL_2020_17031_COOK\\tl_2020_17031_edges.zip`
 - `data\\RAW\\MAPS\\TL_2020_17031_COOK\\tl_2020_17031_faces.zip`
 - `data\\RAW\\MAPS\\TL_2020_17031_COOK\\tl_2020_17031_facesah.zip`
 - `data\\RAW\\MAPS\\TL_2020_17031_COOK\\tl_2020_17031_facesal.zip`
 - `data\\RAW\\MAPS\\TL_2020_17031_COOK\\tl_2020_17031_featnames.zip`
 - `data\\RAW\\MAPS\\TL_2020_17031_COOK\\tl_2020_17031_linearwater.zip`
 - `data\\RAW\\MAPS\\TL_2020_17031_COOK\\tl_2020_17031_pointlm.zip`
 - `data\\RAW\\MAPS\\TL_2020_17031_COOK\\tl_2020_17031_roads.zip`
 - `data\\RAW\\MAPS\\TL_2020_17031_COOK\\tl_2020_17031_tabblock10.zip`
 - `data\\RAW\\MAPS\\TL_2020_17031_COOK\\tl_2020_17031_tabblock20.zip`
 - `data\\RAW\\MAPS\\TL_2020_17031_COOK\\tl_2020_17031_tract10.zip`
 - `data\\RAW\\MAPS\\TL_2020_17031_COOK\\tl_2020_17031_tract20.zip`
 - `data\\RAW\\MAPS\\TL_2020_17031_COOK\\tl_2020_17031_vtd20.zip`

