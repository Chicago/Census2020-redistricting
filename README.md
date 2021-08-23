

## Overview

On August 12, 2021 the US Census Bureau released the first detailed results of the 2020 census in accordance with Public Law 94-171, commonly referred to as the redistricting data. 

The release includes detailed demographic, maps associated with the release, and other documentation and variables. This repository takes a look at the results as they relate to Chicago and the region. 

Please see the articles below for some highlights regarding the release, and feel free to open issues to highlight other articles or make contributions to the repository.  

The PL94 release will not be available through normal API access initially.  The links for PL-171 and other sources are listed below the articles.  

## Getting started

Before running any analysis scripts please run `./data/unzip.sh` *from the project directory* to unzip the files in `./data`.

# Redistricting Articles

### Main press release 

Contains highlights, links to apps, census maps, etc: https://www.census.gov/newsroom/press-releases/2021/population-changes-nations-diversity.html

### Diversity index

The Chance That Two People Chosen at Random Are of Different Race or Ethnicity Groups Has Increased Since 2010.  The diversity index is based on work that began in 2015 and was tested in 2018. The US has gotten more diverse in general, but individual regions vary widely in their predominant racial makeup and level of diversity. The article contains county level maps that show how diversity varies around the US, and other visualizations. 

https://www.census.gov/library/stories/2021/08/2020-united-states-population-more-racially-ethnically-diverse-than-2010.html

https://www.census.gov/library/stories/2021/08/improved-race-ethnicity-measures-reveal-united-states-population-much-more-multiracial.html

### Main landing page

Several more articles can be found in the main landing page for PL-94-171, as well as technical information, raw data, and mapping information: https://www.census.gov/programs-surveys/decennial-census/about/rdo/summary-files.html


# Downloads and documentatation

The links below are often specific to Chicago / Cook County (County 031) / Illinois (State 17). To use for other geographies, you can usually just go up a level in the directory structure and find your geography. 

## Population statistics for PL-94-171

The raw demograhic data for IL can be found here. This file contains every variable at every available summary level for example State, County, Tract, Blockgroup, Block. <br>
https://www2.census.gov/programs-surveys/decennial/2020/data/01-Redistricting_File--PL_94-171/Illinois/

Descriptions of variables and their groups: <br>
https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/complete-tech-docs/summary-file/2020Census_PL94_171Redistricting_StatesTechDoc_English.pdf

## TIGERweb Map Data Files

Page with top level map data including maps for roads, parks, correctional facilities, colleges, military facilities, cities, etc. <br>
https://tigerweb.geo.census.gov/tigerwebmain/TIGERweb_nation_based_files.html

TIGER Illinois 2020 County Map<br>
https://www2.census.gov/geo/tiger/TIGER2020PL/LAYER/COUNTY/2020/tl_2020_17_county20.zip

TIGER Map data download selector for many states, years, geographies, and data types: https://www.census.gov/cgi-bin/geo/shapefiles/index.php


## 2020 Census (P.L. 94-171) Redistricting Data Files

The main page for redistricting data:<br> https://www.census.gov/programs-surveys/decennial-census/about/rdo/summary-files.html

The main page has:

 - tabular data sources (population variables)
 - detailed documentation
 - faq documentation
 - links to map data
 - links to crosswalks
 - sample code (R, SAS, Access)

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

## Initial file list

### Population statistics

 - `data/2020PL_R_import_scripts.zip` - Code sample from main redistricting landing page
 - `data/il2020.pl.zip` - Tabular redistricting data

### State level maps

 - `data/tl_2020_17_county20.zip` - county boundaries
 - `data/tl_2020_17_tract.zip` - tract boundaries

### County level map data 17031 (COOK COUNTY)

Several maps and geographic data files<br>
https://www2.census.gov/geo/tiger/TIGER2020PL/STATE/17_ILLINOIS/17031/

 - `data/tl_2020_17031_addr.zip`
 - `data/tl_2020_17031_addrfn.zip`
 - `data/tl_2020_17031_arealm.zip`
 - `data/tl_2020_17031_areawater.zip`
 - `data/tl_2020_17031_bg10.zip`
 - `data/tl_2020_17031_bg20.zip`
 - `data/tl_2020_17031_cousub10.zip`
 - `data/tl_2020_17031_cousub20.zip`
 - `data/tl_2020_17031_edges.zip`
 - `data/tl_2020_17031_faces.zip`
 - `data/tl_2020_17031_facesah.zip`
 - `data/tl_2020_17031_facesal.zip`
 - `data/tl_2020_17031_featnames.zip`
 - `data/tl_2020_17031_linearwater.zip`
 - `data/tl_2020_17031_pointlm.zip`
 - `data/tl_2020_17031_roads.zip`
 - `data/tl_2020_17031_tabblock10.zip`
 - `data/tl_2020_17031_tabblock20.zip`
 - `data/tl_2020_17031_tract10.zip`
 - `data/tl_2020_17031_tract20.zip`
 - `data/tl_2020_17031_vtd20.zip`

