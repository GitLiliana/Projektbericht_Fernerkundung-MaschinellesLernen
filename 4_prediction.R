
# prepare environment:

# delete all variables from environment
rm(list=ls()) 

# load packages
library(raster)

# set working directory
setwd("C:/Users/lgits/sciebo/Uni_Geoinfo/GI8_Fernerkundung+ML/Abschlussprojekt/R/data")

######################################

# load data
sentinel_R <- stack("predictors_Rheine.grd")
sentinel_L <- stack("predictors_Lübeck.grd")
model_ffs_R <- readRDS("ffsmodel_Rheine.RDS")
model_ffs_G <- readRDS("ffsmodel_Germany.RDS")

# prediction
prediction_RR <- predict(sentinel_R,model_ffs_R)
prediction_RG <- predict(sentinel_R,model_ffs_G)
prediction_LR <- predict(sentinel_L,model_ffs_R)
prediction_LG <- predict(sentinel_L,model_ffs_G)

# export prediction
writeRaster(prediction_RR,"prediction_RR.grd",overwrite=TRUE)
writeRaster(prediction_RG,"prediction_RG.grd",overwrite=TRUE)
writeRaster(prediction_LR,"prediction_LR.grd",overwrite=TRUE)
writeRaster(prediction_LG,"prediction_LG.grd",overwrite=TRUE)


