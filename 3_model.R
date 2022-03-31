
# prepare environment:

# delete all variables from environment
rm(list=ls()) 

# load packages
library(raster)
library(caret)
library(CAST)

# set working directory
setwd("C:/Users/lgits/sciebo/Uni_Geoinfo/GI8_Fernerkundung+ML/Abschlussprojekt/R/data")

######################################

# load data
trainDat_R <- readRDS("trainDataRheine.RDS")
trainDat_G <- readRDS("trainData_Germany.RDS")

# delete Rheine from Germany dataset
trainDat_G <- trainDat_G[!(trainDat_G$Region=="Rheine"),]

# reclassify dataset Germany: "Dorf" -> "Stadt"
trainDat_G$Label [trainDat_G$Label=="Dorf"] <- "Stadt"
trainDat_G$Label_en [trainDat_G$Label_en=="village"] <- "city"
trainDat_G$ClassID [trainDat_G$ClassID==16] <- 17
trainDat_G$Color [trainDat_G$Color=="red"] <- "darkorange"

# reduce datasets to relevant classes
targetlabels <- c("Laubwald","Nadelwald","Mischwald","Gruenland",
                  "Acker_bepflanzt","Nadelwald_abgestorben","Acker_unbepflanzt","Salzwiese",
                  "Heide","Moor","See","Fliessgewaesser","Meer","Watt","Strand","Dorf","Stadt","Industrie")

trainDat_R <- trainDat_R[trainDat_R$Label%in%targetlabels,]
trainDat_G <- trainDat_G[trainDat_G$Label%in%targetlabels,]

## define the predictor names
predictors <- c("B02","B03","B04","B08","B05","B06","B07","B11",
                "B12","B8A","NDVI","NDVI_3x3_sd","NDVI_5x5_sd")

# limit data 
# 10% from each training polygon (Rheine)
trainIDs_R <- createDataPartition(trainDat_R$ID,p=0.1,list = FALSE)
trainDat_R <- trainDat_R[trainIDs_R,]
# 1% from each training polygon (Germany, dataset is larger)
trainIDs_G <- createDataPartition(trainDat_G$uniquePoly,p=0.01,list = FALSE)
trainDat_G <- trainDat_G[trainIDs_G,]

# make sure no NA in training data
trainDat_R <- trainDat_R[complete.cases(trainDat_R[,predictors]),]
trainDat_G <- trainDat_G[complete.cases(trainDat_G[,predictors]),]

# create space folds for leave polygon out CV
trainids_R <- CreateSpacetimeFolds(trainDat_R,spacevar="ID",class="Label",k=3)
trainids_G <- CreateSpacetimeFolds(trainDat_G,spacevar="uniquePoly",class="Label",k=3)

# train model with forward feature selection and spatial CV (training data Rheine)
model_ffs_R <- CAST::ffs(trainDat_R[,predictors],
                         trainDat_R$Label,
                         method="rf",
                         metric = "Kappa",
                         ntree=500,
                         tuneGrid=data.frame("mtry"=2:15),
                         trControl=trainControl(method="cv",index=trainids_R$index),
                         savePrediction=TRUE)

saveRDS(model_ffs_R,file="ffsmodel_Rheine.RDS")
plot_ffs(model_ffs_R)
plot_ffs(model_ffs_R,plotType="selected")

# train model with forward feature selection and spatial CV (training data Germany)
model_ffs_G <- CAST::ffs(trainDat_G[,predictors],
                         trainDat_G$Label,
                         method="rf",
                         metric = "Kappa",
                         ntree=500,
                         tuneGrid=data.frame("mtry"=2:15),
                         trControl=trainControl(method="cv",index=trainids_G$index),
                         savePrediction=TRUE)

saveRDS(model_ffs_G,file="ffsmodel_Germany.RDS")
plot_ffs(model_ffs_G)
plot_ffs(model_ffs_G,plotType="selected")

# get confusion matrix
confusionMatrix(factor(model_ffs_R$pred$pred),factor(model_ffs_R$pred$obs))
confusionMatrix(factor(model_ffs_G$pred$pred),factor(model_ffs_G$pred$obs))

