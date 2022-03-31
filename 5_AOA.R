
# prepare environment:

# delete all variables from environment
rm(list=ls()) 

# load packages
library(raster)
library(caret)
library(CAST)
library(doParallel) 
library(parallel)

# set working directory
setwd("C:/Users/lgits/sciebo/Uni_Geoinfo/GI8_Fernerkundung+ML/Abschlussprojekt/R/data")

######################################

# load data
sentinel_R <- stack("predictors_Rheine.grd")
sentinel_L <- stack("predictors_Lübeck.grd")
model_rheine <- readRDS("ffsmodel_Rheine.RDS")
model_germany <- readRDS("ffsmodel_Germany.RDS")

# make clusters for saving computational time
cl <- makeCluster(detectCores()-1)
registerDoParallel(cl)

# calculate DI for both models/trainingdatasets (enables reuse and therefore saves time) and export DI
DI_R <- trainDI(model=model_rheine)
saveRDS(DI_R,"DI_R.RDS")
DI_G <- trainDI(model=model_germany)
saveRDS(DI_G,"DI_G.RDS")

# estimate AOA using DI from above and export AOA
AOA_R_MR <- aoa(sentinel_R,model=model_rheine,trainDI=DI_R ,cl=cl)
saveRDS(AOA_R_MR,"AOA_R_MR.rds")
AOA_R_MG <- aoa(sentinel_R,model_germany,trainDI=DI_G ,cl=cl)
saveRDS(AOA_R_MG,"AOA_R_MG.rds")
AOA_L_MR <- aoa(sentinel_L,model_rheine,trainDI=DI_R ,cl=cl)
saveRDS(AOA_L_MR,"AOA_L_MR.rds")
AOA_L_MG <- aoa(sentinel_L,model_germany,trainDI=DI_G ,cl=cl)
saveRDS(AOA_L_MG,"AOA_L_MG.rds")


