
# prepare environment:

# delete all variables from environment
rm(list=ls()) 

# load packages
library(raster)
library(tmap)

# set working directory
setwd("C:/Users/lgits/sciebo/Uni_Geoinfo/GI8_Fernerkundung+ML/Abschlussprojekt/R/data")

######################################

# load data
rheine <- stack("predictors_rheine.grd")
luebeck <- stack("predictors_lübeck.grd")
AOA_R_MR <- readRDS("AOA_R_MR.rds")
AOA_R_MG <- readRDS("AOA_R_MG.rds")
AOA_L_MR <- readRDS("AOA_L_MR.rds")
AOA_L_MG <- readRDS("AOA_L_MG.rds")
pred_RR <- raster("prediction_RR.grd")
pred_RG <- raster("prediction_RG.grd")
pred_LR <- raster("prediction_LR.grd")
pred_LG <- raster("prediction_LG.grd")
predprob_RR <- stack("pred_prob_RR.grd")
predprob_RG <- stack("pred_prob_RG.grd")
predprob_LR <- stack("pred_prob_LR.grd")
predprob_LG <- stack("pred_prob_LG.grd")
trainDatG <- readRDS("traindata_Germany.RDS")
model_R <- readRDS("ffsmodel_Rheine.RDS")
model_G <- readRDS("ffsmodel_Germany.RDS")


# map: rgb Rheine
png("RGB_Rheine.png")
rheineRGB <- plotRGB(rheine,b=1,g=2,r=3,stretch="lin",maxpixels=ncell(rheine))
dev.off()
png("RGB_Lübeck.png")
luebeckRGB <- plotRGB(luebeck,b=1,g=2,r=3,stretch="lin",maxpixels=ncell(luebeck))
dev.off()

# colors for all the labels
cols_all <-unique(trainDatG[,c("Label","Color")])

# map: prediction Rheine, model Rheine
### colors
predlabels <- levels(pred_RR)[[1]]$value
cols <- cols_all$Color[cols_all$Label%in%predlabels]
## map
map <- tm_shape(deratify(pred_RR),
                raster.downsample = FALSE) +
  tm_raster(palette = cols,title = "LUC")+
  tm_scale_bar(bg.color="white",
               bg.alpha = 0.5)+
  tm_grid(n.x=4,n.y=4,projection="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")+
  tm_layout(legend.outside = TRUE,
            legend.outside.position = c("left"),
            legend.bg.color = "white")
map
tmap_save(map, "map_prediction_rheine_MR.png")

# map: prediction Rheine, model Germany
### colors
predlabels <- levels(pred_RG)[[1]]$value
cols <- cols_all$Color[cols_all$Label%in%predlabels]
## map
map <- tm_shape(deratify(pred_RG),
                raster.downsample = FALSE) +
  tm_raster(palette = cols,title = "LUC")+
  tm_scale_bar(bg.color="white",
               bg.alpha = 0.5)+
  tm_grid(n.x=4,n.y=4,projection="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")+
  tm_layout(legend.outside = TRUE,
            legend.outside.position = c("left"),
            legend.bg.color = "white")
map
tmap_save(map, "map_prediction_rheine_MG.png")

# map: prediction Lübeck, model Rheine
### colors
predlabels <- levels(pred_LR)[[1]]$value
cols <- cols_all$Color[cols_all$Label%in%predlabels]
## map
map <- tm_shape(deratify(pred_LR),
                raster.downsample = FALSE) +
  tm_raster(palette = cols,title = "LUC")+
  tm_scale_bar(bg.color="white",
               bg.alpha = 0.5)+
  tm_grid(n.x=4,n.y=4,projection="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")+
  tm_layout(legend.outside = TRUE,
            legend.outside.position = c("left"),
            legend.bg.color = "white")
map
tmap_save(map, "map_prediction_lübeck_MR.png")

# map: prediction Lübeck, model Germany
### colors
predlabels <- levels(pred_LG)[[1]]$value
cols <- cols_all$Color[cols_all$Label%in%predlabels]
## map
map <- tm_shape(deratify(pred_LG),
                raster.downsample = FALSE) +
  tm_raster(palette = cols,title = "LUC")+
  tm_scale_bar(bg.color="white",
               bg.alpha = 0.5)+
  tm_grid(n.x=4,n.y=4,projection="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")+
  tm_layout(legend.outside = TRUE,
            legend.outside.position = c("left"),
            legend.bg.color = "white")
map
tmap_save(map, "map_prediction_lübeck_MG.png")


# map: AOA Rheine, model Rheine
# set colours
predlabels <- levels(pred_RR)[[1]]$value
cols <- cols_all$Color[cols_all$Label%in%predlabels]
pred_RR[AOA_R_MR$AOA == 0] <- NA

map <- tm_shape(deratify(pred_RR),
                raster.downsample = FALSE) +
  tm_raster(palette = cols,title = "LUC")+
  tm_scale_bar(bg.color="white",
               bg.alpha = 0.5)+
  tm_grid(n.x=4,n.y=4,projection="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")+
  tm_layout(legend.outside = TRUE,
            legend.outside.position = c("left"),
            legend.bg.color = "white",
            bg.color = "black")+
  tm_add_legend(type = "fill",
                col="black",
                labels = "Outside AOA")
map
tmap_save(map, "AOA_R-MR.png")

# map: AOA Rheine, model Germany
# set colours
predlabels <- levels(pred_RG)[[1]]$value
cols <- cols_all$Color[cols_all$Label%in%predlabels]
pred_RG[AOA_R_MG$AOA == 0] <- NA

map <- tm_shape(deratify(pred_RG),
                raster.downsample = FALSE) +
  tm_raster(palette = cols,title = "LUC")+
  tm_scale_bar(bg.color="white",
               bg.alpha = 0.5)+
  tm_grid(n.x=4,n.y=4,projection="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")+
  tm_layout(legend.outside = TRUE,
            legend.outside.position = c("left"),
            legend.bg.color = "white",
            bg.color = "black")+
  tm_add_legend(type = "fill",
                col="black",
                labels = "Outside AOA")
map
tmap_save(map, "AOA_R-MG.png")

# map: AOA Lübeck, model Rheine
# set colours
predlabels <- levels(pred_LR)[[1]]$value
cols <- cols_all$Color[cols_all$Label%in%predlabels]
pred_LR[AOA_L_MR$AOA == 0] <- NA

map <- tm_shape(deratify(pred_LR),
                raster.downsample = FALSE) +
  tm_raster(palette = cols,title = "LUC")+
  tm_scale_bar(bg.color="white",
               bg.alpha = 0.5)+
  tm_grid(n.x=4,n.y=4,projection="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")+
  tm_layout(legend.outside = TRUE,
            legend.outside.position = c("left"),
            legend.bg.color = "white",
            bg.color = "black")+
  tm_add_legend(type = "fill",
                col="black",
                labels = "Outside AOA")
map
tmap_save(map, "AOA_L-MR.png")

# map: AOA Lübeck, model Germany
# set colours
predlabels <- levels(pred_LG)[[1]]$value
cols <- cols_all$Color[cols_all$Label%in%predlabels]
pred_LG[AOA_L_MG$AOA == 0] <- NA

map <- tm_shape(deratify(pred_LG),
                raster.downsample = FALSE) +
  tm_raster(palette = cols,title = "LUC")+
  tm_scale_bar(bg.color="white",
               bg.alpha = 0.5)+
  tm_grid(n.x=4,n.y=4,projection="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")+
  tm_layout(legend.outside = TRUE,
            legend.outside.position = c("left"),
            legend.bg.color = "white",
            bg.color = "black")+
  tm_add_legend(type = "fill",
                col="black",
                labels = "Outside AOA")
map
tmap_save(map, "AOA_L-MG.png")


# From the classification: present only areas within AOA and with probability >0.5

# map: Rheine, model Rheine
predlabels <- levels(pred_RR)[[1]]$value
cols <- cols_all$Color[cols_all$Label%in%predlabels]
pred_RR <- mask(pred_RR,resample(AOA_R_MR$AOA,pred_RR),maskvalue=0)
pred_RR[values(predprob_RR$prob_all)<0.5] <- NA
map <- tm_shape(deratify(pred_RR),
                raster.downsample = FALSE) +
  tm_raster(palette = cols,title = "LUC")+
  tm_scale_bar(bg.color="white",
               bg.alpha = 0.5)+
  tm_grid(n.x=4,n.y=4,projection="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")+
  tm_layout(legend.outside = TRUE,
            legend.outside.position = c("left"),
            legend.bg.color = "white",
            bg.color = "black")+
  tm_add_legend(type = "fill",
                col="black",
                labels = "No Data")

map
tmap_save(map, "AOA+prob_RR.png")

# map: Rheine, model Germany
predlabels <- levels(pred_RG)[[1]]$value
cols <- cols_all$Color[cols_all$Label%in%predlabels]
pred_RG <- mask(pred_RG,resample(AOA_R_MG$AOA,pred_RG),maskvalue=0)
pred_RG[values(predprob_RG$prob_all)<0.5] <- NA
map <- tm_shape(deratify(pred_RG),
                raster.downsample = FALSE) +
  tm_raster(palette = cols,title = "LUC")+
  tm_scale_bar(bg.color="white",
               bg.alpha = 0.5)+
  tm_grid(n.x=4,n.y=4,projection="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")+
  tm_layout(legend.outside = TRUE,
            legend.outside.position = c("left"),
            legend.bg.color = "white",
            bg.color = "black")+
  tm_add_legend(type = "fill",
                col="black",
                labels = "No Data")

map
tmap_save(map, "AOA+prob_RG.png")

# map: Lübeck, model Rheine
predlabels <- levels(pred_LR)[[1]]$value
cols <- cols_all$Color[cols_all$Label%in%predlabels]
pred_LR <- mask(pred_LR,resample(AOA_L_MR$AOA,pred_LR),maskvalue=0)
pred_LR[values(predprob_LR$prob_all)<0.5] <- NA
map <- tm_shape(deratify(pred_LR),
                raster.downsample = FALSE) +
  tm_raster(palette = cols,title = "LUC")+
  tm_scale_bar(bg.color="white",
               bg.alpha = 0.5)+
  tm_grid(n.x=4,n.y=4,projection="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")+
  tm_layout(legend.outside = TRUE,
            legend.outside.position = c("left"),
            legend.bg.color = "white",
            bg.color = "black")+
  tm_add_legend(type = "fill",
                col="black",
                labels = "No Data")

map
tmap_save(map, "AOA+prob_LR.png")

# map: Lübeck, model Germany
predlabels <- levels(pred_LG)[[1]]$value
cols <- cols_all$Color[cols_all$Label%in%predlabels]
pred_LG <- mask(pred_LG,resample(AOA_L_MG$AOA,pred_LG),maskvalue=0)
pred_LG[values(predprob_LG$prob_all)<0.5] <- NA
map <- tm_shape(deratify(pred_LG),
                raster.downsample = FALSE) +
  tm_raster(palette = cols,title = "LUC")+
  tm_scale_bar(bg.color="white",
               bg.alpha = 0.5)+
  tm_grid(n.x=4,n.y=4,projection="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")+
  tm_layout(legend.outside = TRUE,
            legend.outside.position = c("left"),
            legend.bg.color = "white",
            bg.color = "black")+
  tm_add_legend(type = "fill",
                col="black",
                labels = "No Data")

map
tmap_save(map, "AOA+prob_LG.png")
