###########################
# preparing training data #
###########################

# prepare environment:

# delete all variables from environment
rm(list=ls()) 

# load packages
library(raster)
library(sf)

# set working directory
setwd("C:/Users/lgits/sciebo/Uni_Geoinfo/GI8_Fernerkundung+ML/Abschlussprojekt/R/data")

######################################

# load rasterstack with predictors
combined <- stack("predictors_rheine.grd")

## load training polygons
trainingsites <- st_read("C:/Users/lgits/sciebo/Uni_Geoinfo/GI8_Fernerkundung+ML/Abschlussprojekt/data/Trainingspolygone_rheineNeu.gpkg")

## extract only those pixels from the combined data, that are within the training polygons
extr <- extract(combined, trainingsites, df=TRUE)

## Add information of labels of polygons to data
trainingsites$PolyID <- 1:nrow(trainingsites)
extr <- merge(extr, trainingsites, by.x="ID", by.y="PolyID")

## change name 'label' to 'Label'
extrRenamed <- extr
names(extrRenamed)[18] <- 'Label'
extrRenamed

## add "Region"
extrRenamed$Region = "Rheine"

## save the training data
saveRDS(extrRenamed, file="trainDataRheine.RDS")

