#!/bin/bash

##
## This should be run from one level up, i.e. from the project directory
##


## Note unzip -n means do not overwrite existing data

cd ./data
# for f in *.zip; do echo $f; done
for f in *.zip; do unzip -n -d "${f%*.zip}" "$f"; done

