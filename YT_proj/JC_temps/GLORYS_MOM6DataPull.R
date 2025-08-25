# Script to generate monthly bottom temperature from GLORYS for yellowtail assessment
# devtools::install_github("https://github.com/NEFSC/READ_EDAB_Utilities")

# CURRENTLY STUCK ON COMPILING THE DATA INTO YEARLY AVGS
# EDABUtilities::mask_nc_2d >>>THIS IS THE SHAPE FILE YOU WANT TO CROP INPUT FILE TO. CHANGE THIS TO A GBK SHAPE FILE ONCE YOU FIGURE OUT ISSUE

library(terra)
library(dplyr)
library(ggplot2)
library(EDABUtilities)
library(raster)
library("ncdf4")
library(sf)

#################### SETUP  #####################################

data.dir = 'C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/JC_temps'
data.prefix = 'MOM6_monthly_BottomTemp_'
years = 1993:2023

max.depth = 150

# stock.files = list.files(here::here('geometry','yellowtail_cod_stock_area'),pattern = '*\\.shp$',full.names = T)
# stock.names = gsub('.shp','',basename(stock.files))
# stock.files <- "C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/JC_temps/stock-areas-20150315-noaa-garfo/Stock_Areas/Stock_Areas.shp"
NOAA_StatAreas <- "C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/NEFSC_GIS/Statistical_Areas_2010.shp"
StatAreas <- read_sf(NOAA_StatAreas)
GBK_stats <- as.integer(c(522, 525, 541, 542, 543, 551, 552, 561, 562))
GBK <- subset(StatAreas, subset = Id %in% GBK_stats)

st_write(obj = GBK, dsn = "C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/NEFSC_GIS/GBKstock.files.shp", driver = "ESRI Shapefile")

stock.files <- "C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/NEFSC_GIS/GBKstock.files.shp"



#bathy = terra::rast(here::here('geometry','GLORYS_bathymetry_east_coast_crop.nc'))
#bathy.crop = terra::clamp(bathy,lower = 0 ,upper = max.depth,values = F)

url <- "http://psl.noaa.gov/thredds/dodsC/Projects/CEFI/regional_mom6/cefi_portal/northwest_atlantic/full_domain/hindcast/monthly/regrid/r20250715/tob.nwa.full.hcast.monthly.regrid.r20250715.199301-202312.nc"


# Open a NetCDF file lazily and remotely
# nc <- nc_open(url)
bathy <- raster(url, varname = 'tob')
writeRaster(x = bathy, filename = "C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/JC_temps/tob_file.tif", format = "GTiff", overwrite = TRUE)

testing <- bathy
values(testing) <- 1:ncell(testing)
#s_raster <- rast(testing)
#my_srast <- rast(url)

# r <- rast(xmin=-85, xmax=-75, ymin=40, ymax=50)

################### PLOTTING ###################

# Example: Define extent for a region
xmin <- -72  # Minimum longitude
xmax <- -63  # Maximum longitude
ymin <- 38   # Minimum latitude
ymax <- 44   # Maximum latitude

cropping_extent <- c(xmin, xmax, ymin, ymax)#raster::extent(xmin, xmax, ymin, ymax)
cropped_raster <- raster::crop(bathy, extent(cropping_extent)) # Using an Extent object

coastLines <- "C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/JC_temps/tl_2019_us_coastline/tl_2019_us_coastline.shp"
epu.shp = vect(coastLines)

# Changing cropping for the shp file
xmin <- -75
xmax <- -60

full.shp = terra::vect(NOAA_StatAreas)
e <- ext(xmin, xmax, ymin, ymax)
idk <- crop(full.shp, e)



#plot(full.shp)
raster::plot(cropped_raster, legend.shrink=1,
             legend.mar=3.3,
             legend.args = list(text = 'Bottom \nTemperature \n(°C)'))#, legend = FALSE)
raster::plot(bathy, add = T, legend = FALSE)
plot(idk, add = T)

#################################### AG FILES ############################
df.ind = 1
j=1
data.month.ls = list()

  
  
  # file.shp = terra::project(),'+proj=longlat +datum=WGS84 +no_defs ')  
  file.shp =terra::vect(stock.files[j])
  #trip file.shp for only intersection with bathy.crop
  terra::crs(file.shp) = '+proj=longlat +datum=WGS84 +no_defs '
  
  i=1
  for(i in 1:length(years)){
    
    data.file = paste0(data.dir,data.prefix,years[i],'.nc')
    
    wgs84_epsg <- "EPSG:4326"
    wgs84_points_from_epsg <- project(epu.shp, wgs84_epsg)
    
    #mask by stock area
    data.mask.stock = EDABUtilities::mask_nc_2d(data.in = "C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/JC_temps/tob_file.tif",#bathy,#data.in = data.file,
                                                write.out = F,
                                                min.value = -10,
                                                max.value = 999,
                                                binary = F,
                                                var.name = 'tob',#'Sea.Water.Potential.Temperature.at.Sea.Floor',#'BottomT',
                                                shp.file = file.shp) # THIS IS THE SHAPE FILE YOU WANT TO CROP EVERYTHING INTO. CHANGE THIS TO JUST GBK ONCE YOU FIX
    
    # bathy.stock = terra::crop(bathy.crop,data.mask.stock[[1]])
    #mask by depth limit
    
    # data.mask.depth =  EDABUtilities::mask_nc_2d(data.in = data.mask.stock,
    #                                              write.out = F,
    #                                              min.value = -10,
    #                                              max.value = 999,
    #                                              binary = F,
    #                                              var.name = 'BottomT',
    #                                              shp.file = bathy.stock)
    data.mask.epu =  EDABUtilities::mask_nc_2d(data.in = data.mask.stock,
                                               write.out = F,
                                               min.value = -10,
                                               max.value = 999,
                                               binary = F,
                                               var.name = 'tob',#'BottomT',
                                               shp.file = wgs84_points_from_epsg)#epu.shp)
    
    #Extract data
    data.month.nc = EDABUtilities::make_2d_summary_gridded(data.in = data.mask.stock,#data.mask.epu,
                                                           write.out = F,
                                                           shp.file = NA,
                                                           var.name = 'tob',#'BottomT',
                                                           agg.time = 'months',
                                                           statistics = 'mean',
                                                           file.time = 'annual',
                                                           touches = T,
                                                           area.names = NA
    )[[1]] %>%
      terra::rast()
    
    terra::writeCDF(data.month.nc, 'C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/JC_temps/data.month.nc',varname = 'BottomT',overwrite = T)
    
    data.month.stat = EDABUtilities::make_2d_summary_ts(data.in = data.mask.epu,
                                                        shp.file =NA,
                                                        var.name = 'tob',#'BottomT',
                                                        agg.time = 'months',
                                                        area.names = NA,
                                                        statistics = c('mean','sd'),
                                                        file.time = 'annual',
                                                        write.out =F)
    
    data.month.ls[[df.ind]] = dplyr::bind_rows(data.month.stat) %>%
      dplyr::mutate(month = month.name[time],
                    year = years[i])%>%
      dplyr::select(year,month,var.name,statistic,value)
    print(nrow(data.month.ls[[df.ind]]))
    df.ind = df.ind +1 
    print(df.ind)
    
    # data.month.ls[[df.ind]] = dplyr::bind_rows(data.month.stat) %>%
    #   dplyr::mutate(month = month.name[time],
    #                 year = years[i],
    #                 stock = stock.names[j])%>%
    #   select(year,month,stock,var.name,statistic,value)
    # 
    # print(stock.names[j])
    # print(nrow(data.month.ls[[df.ind]]))
    # df.ind = df.ind +1 
    # print(df.ind)
  } 

data.month.out = dplyr::bind_rows(data.month.ls)

write.csv(data.month.out,'C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/JC_temps/data.month.out.csv',row.names = F)

#Test March April May

data.month.out =read.csv('C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/JC_temps/data.month.out.csv')
spring = data.month.out |> 
  filter(month %in% c('March','April','May') & statistic == 'mean') |> 
  group_by(year) |> 
  summarize(value = mean(value,na.rm=T))

ggplot(spring, aes(x = year, y= value))+
  geom_line()
  #facet_wrap(~stock)


nc_close(nc) # DO I EVEN NEED THIS
