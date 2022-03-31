
# prepare environment:

# delete all variables from environment
rm(list=ls()) 

# load packages
library(raster)
library(caret)
library(CAST)
library(tmap)

# set working directory
setwd("C:/Users/lgits/sciebo/Uni_Geoinfo/GI8_Fernerkundung+ML/Abschlussprojekt/R/data")

######################################

# load data

rheine <- stack("predictors_rheine.grd")
luebeck <- stack("predictors_lübeck.grd")
model_R <- readRDS("ffsmodel_Rheine.RDS")
model_G <- readRDS("ffsmodel_Germany.RDS")

# predictions (normal)
pred_RR <- predict(rheine, model_R)
pred_RG <- predict(rheine, model_G)
pred_LR <- predict(luebeck, model_R)
pred_LG <- predict(luebeck, model_G)

# probabilities for each class
predprob_RR <- predict(rheine, model_R, type='prob', index=1:length(unique(model_R$trainingData$.outcome))) 
names(predprob_RR) <- levels(model_R$trainingData$.outcome)
predprob_RG <- predict(rheine, model_G, type='prob', index=1:length(unique(model_G$trainingData$.outcome))) 
names(predprob_RG) <- levels(model_G$trainingData$.outcome)
predprob_LR <- predict(luebeck, model_R, type='prob', index=1:length(unique(model_R$trainingData$.outcome))) 
names(predprob_LR) <- levels(model_R$trainingData$.outcome)
predprob_LG <- predict(luebeck, model_G, type='prob', index=1:length(unique(model_G$trainingData$.outcome))) 
names(predprob_LG) <- levels(model_G$trainingData$.outcome)

# Extract probability for the majority class
## Rheine, Model Rheine
allpreds_RR <- data.frame(as.data.frame(pred_RR),as.data.frame(predprob_RR)) # probabilities
allpreds_RR$prob <- NA
for (i in unique(allpreds_RR$value)){
  if (is.na(i)){next()}
  allpreds_RR$prob[allpreds_RR$value==i&!is.na(allpreds_RR$value==i)] <- allpreds_RR[allpreds_RR$value==i&!is.na(allpreds_RR$value==i),i]
}
## Rheine, Modell Germany
allpreds_RG <- data.frame(as.data.frame(pred_RG),as.data.frame(predprob_RG)) # probabilities
allpreds_RG$prob <- NA
for (i in unique(allpreds_RG$value)){
  if (is.na(i)){next()}
  allpreds_RG$prob[allpreds_RG$value==i&!is.na(allpreds_RG$value==i)] <- allpreds_RG[allpreds_RG$value==i&!is.na(allpreds_RG$value==i),i]
}
## Lübeck, Modell Rheine
allpreds_LR <- data.frame(as.data.frame(pred_LR),as.data.frame(predprob_LR)) # probabilities
allpreds_LR$prob <- NA
for (i in unique(allpreds_LR$value)){
  if (is.na(i)){next()}
  allpreds_LR$prob[allpreds_LR$value==i&!is.na(allpreds_LR$value==i)] <- allpreds_LR[allpreds_LR$value==i&!is.na(allpreds_LR$value==i),i]
}
## Lübeck, Modell Germany
allpreds_LG <- data.frame(as.data.frame(pred_LG),as.data.frame(predprob_LG)) # probabilities
allpreds_LG$prob <- NA
for (i in unique(allpreds_LG$value)){
  if (is.na(i)){next()}
  allpreds_LG$prob[allpreds_LG$value==i&!is.na(allpreds_LG$value==i)] <- allpreds_LG[allpreds_LG$value==i&!is.na(allpreds_LG$value==i),i]
}

# Write this probability values to the raster
## Rheine, Modell Rheine
predprob_RR$prob_all <- predprob_RR[[1]]
values(predprob_RR$prob_all) <- allpreds_RR$prob
writeRaster(predprob_RR,"pred_prob_RR.grd",overwrite=TRUE)
## Rheine, Modell Germany
predprob_RG$prob_all <- predprob_RG[[1]]
values(predprob_RG$prob_all) <- allpreds_RG$prob
writeRaster(predprob_RG,"pred_prob_RG.grd",overwrite=TRUE)
## Lübeck, Modell Lübeck
predprob_LR$prob_all <- predprob_LR[[1]]
values(predprob_LR$prob_all) <- allpreds_LR$prob
writeRaster(predprob_LR,"pred_prob_LR.grd",overwrite=TRUE)
## Lübeck, Modell Germany
predprob_LG$prob_all <- predprob_LG[[1]]
values(predprob_LG$prob_all) <- allpreds_LG$prob
writeRaster(predprob_LG,"pred_prob_LG.grd",overwrite=TRUE)

