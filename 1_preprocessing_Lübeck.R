##########################################
# preprocessing of sentinel-2 rasterdata #
##########################################

# prepare environment:

# delete all variables from environment
rm(list=ls()) 

# load packages
library(raster)

# set working directory
setwd("C:/Users/lgits/sciebo/Uni_Geoinfo/GI8_Fernerkundung+ML/L1C_T32UPE_A027418_20200921T103107_Lübeck/S2A_MSIL1C_20200921T103031_N0209_R108_T32UPE_20200921T142406.SAFE/GRANULE/L1C_T32UPE_A027418_20200921T103107/IMG_DATA")

#########################################

# build stack from needed sentinel-2 channels:

# load blue, green, red and NIR channel (resolution = 10m) as stack and visualize
sentinel10 <- stack("T32UPE_20200921T103031_B02.jp2", "T32UPE_20200921T103031_B03.jp2", "T32UPE_20200921T103031_B04.jp2", "T32UPE_20200921T103031_B08.jp2")
# plot(sentinel10)

# cut out area of interest (for reference)
# get coordinates of corner points interactively:
# plot(sentinel10$T32UPE_20200921T103031_B08)
# eckkoordinaten <- drawExtent() # click upper left und bottom right corner in plot
# eckkoordinaten
# write down adjusted coordinates (order: xmin,xmax,ymin,ymax): (602279, 621900, 5960000, 5979000)

# crop data to area of interest
sentinel10_crop <- crop(sentinel10,c(602279, 621900, 5960000, 5979000))

# plotting true colour display
# b=1 stands for: blue is channel 1 (be careful: relates to order in stack function)
plotRGB(sentinel10_crop,b=1,g=2,r=3,stretch="lin")

# build stack from 20m resolution channels
sentinel20 <- stack("T32UPE_20200921T103031_B05.jp2", "T32UPE_20200921T103031_B06.jp2", "T32UPE_20200921T103031_B07.jp2", "T32UPE_20200921T103031_B11.jp2", "T32UPE_20200921T103031_B12.jp2", "T32UPE_20200921T103031_B8A.jp2")

# crop 20m resolution stack
sentinel20_crop <- crop(sentinel20,c(602279, 621900, 5960000, 5979000))

# resample and crop 10m and 20m stack
sentinel20_crop_res <- resample(sentinel20_crop, sentinel10_crop) # resample from 20m to 10m resolution
sentinel_combined <- stack(sentinel10_crop, sentinel20_crop_res)

# rename
names(sentinel_combined) <- substr(names(sentinel_combined),
                                   nchar(names(sentinel_combined))-2, # from third last...
                                   nchar(names(sentinel_combined))) # to last
# names(sentinel_combined)
# plot(sentinel_combined)

#########################################

# add further predictors:

# calculate the NDVI and add as additional layer to the stack
sentinel_combined$NDVI <- (sentinel_combined$B08-sentinel_combined$B04)/(sentinel_combined$B08+sentinel_combined$B04)

# calculate texture as further predictors
sentinel_combined$NDVI_3x3_sd <- focal(sentinel_combined$NDVI,w=matrix(1,3,3), fun=sd)
sentinel_combined$NDVI_5x5_sd <- focal(sentinel_combined$NDVI,w=matrix(1,5,5), fun=sd)
# spplot(stack(sentinel_combined$NDVI_3x3_sd,combined$NDVI_5x5_sd))

# include coordinates
template <- sentinel_combined$B02 # get copy
template_ll <- projectRaster(template,crs="+proj=longlat +datum=WGS84 +no_defs") #reproject in lat long
coords <- coordinates(template_ll) # get table with coordinates for each pixel
lat <- template_ll # get copy
lon <- template_ll# get copy
values(lat) <- coords[,2] # write coordinates to raster
values(lon) <- coords[,1] # write coordinates to raster
coords <- stack(lat,lon) # create new stack
names(coords) <- c("lat","lon") # name coordinates
coords <- projectRaster(coords,crs=crs(sentinel_combined)) # reproject to original
coords <- resample(coords,sentinel_combined) # resample to same geometry
combined <- stack(sentinel_combined,coords) # add all together

#########################################

# set new working directory for output data
setwd("C:/Users/lgits/sciebo/Uni_Geoinfo/GI8_Fernerkundung+ML/Abschlussprojekt/R/data")

# write results
writeRaster(sentinel_combined,"sentinel_combined_Lübeck.grd")
writeRaster(combined, "predictors_Lübeck.grd")

# exporting plots
pdf("truecolor_Lübeck.pdf")
plotRGB(sentinel10_crop,b=1,g=2,r=3,stretch="lin",maxpixels=ncell(sentinel10_crop))  # ncell stands for original resolution
dev.off()  # important: terminates exporting in pdf (otherwise everything afterwards would be written into the pdf as well)

