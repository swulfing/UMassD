# Script to generate monthly bottom temperature from GLORYS for yellowtail assessment
# devtools::install_github("https://github.com/NEFSC/READ_EDAB_Utilities")

# CURRENTLY STUCK ON TURNING THE NC FILE INTO A RASTER FILE:
# https://www.google.com/search?q=convert+NetCDF+to+raster+in+r&rlz=1C1GCEA_enUS1156US1156&oq=convert+NetCDF+to+raster+in+r&gs_lcrp=EgZjaHJvbWUyCggAEEUYFhgeGDkyCAgBEAAYFhgeMgoIAhAAGIAEGKIEMgcIAxAAGO8FMgcIBBAAGO8FMgoIBRAAGIAEGKIEMgYIBhBFGDzSAQg3NTA3ajBqNKgCALACAQ&sourceid=chrome&ie=UTF-8
# https://gis.stackexchange.com/questions/435439/r-terra-not-reading-attributes-from-netcdf-file
# https://gis.stackexchange.com/questions/271779/r-netcdf-to-raster

library(terra)
library(dplyr)
library(ggplot2)
library(EDABUtilities)
library("ncdf4")

data.dir = 'C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/JC_temps'
data.prefix = 'MOM6_monthly_BottomTemp_'
years = 1993:2023

max.depth = 150

# stock.files = list.files(here::here('geometry','yellowtail_cod_stock_area'),pattern = '*\\.shp$',full.names = T)
# stock.names = gsub('.shp','',basename(stock.files))
# stock.files <- "C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/JC_temps/stock-areas-20150315-noaa-garfo/Stock_Areas/Stock_Areas.shp"
stock.files <- "C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/NEFSC_GIS/Statistical_Areas_2010.shp"


#bathy = terra::rast(here::here('geometry','GLORYS_bathymetry_east_coast_crop.nc'))
#bathy.crop = terra::clamp(bathy,lower = 0 ,upper = max.depth,values = F)

url <- "http://psl.noaa.gov/thredds/dodsC/Projects/CEFI/regional_mom6/cefi_portal/northwest_atlantic/full_domain/hindcast/monthly/regrid/r20250715/tob.nwa.full.hcast.monthly.regrid.r20250715.199301-202312.nc"

# Open a NetCDF file lazily and remotely
nc <- nc_open(url)
bathy = terra::rast(nc)


coastLines <- "C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/JC_temps/tl_2019_us_coastline/tl_2019_us_coastline.shp"
epu.shp = vect(coastLines)
full.shp = terra::vect(stock.files)
terra::plot(bathy.crop)
plot(full.shp)
plot(epu.shp,add = T, col = 2,alpha = 0.5,lty = 2)

df.ind = 1
j=2
data.month.ls = list()
for(j in 1:length(stock.files)){
  
  
  # file.shp = terra::project(),'+proj=longlat +datum=WGS84 +no_defs ')  
  file.shp =terra::vect(stock.files[j])
  #trip file.shp for only intersection with bathy.crop
  terra::crs(file.shp) = '+proj=longlat +datum=WGS84 +no_defs '
  
  i=1
  for(i in 1:length(years)){
    
    data.file = paste0(data.dir,data.prefix,years[i],'.nc')
    
    #mask by stock area
    data.mask.stock = EDABUtilities::mask_nc_2d(data.in = data.file,
                                                write.out = F,
                                                min.value = -10,
                                                max.value = 999,
                                                binary = F,
                                                var.name = 'BottomT',
                                                shp.file = file.shp)
    
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
                                               var.name = 'BottomT',
                                               shp.file = epu.shp)
    
    #Extract data
    data.month.nc = EDABUtilities::make_2d_summary_gridded(data.in = data.mask.epu,
                                                           write.out = F,
                                                           shp.file = NA,
                                                           var.name = 'BottomT',
                                                           agg.time = 'months',
                                                           statistics = 'mean',
                                                           file.time = 'annual',
                                                           touches = T,
                                                           area.names = NA
    )[[1]] %>%
      terra::rast()
    
    terra::writeCDF(data.month.nc,here::here('data','yellowtail',paste0('GLORYS_BottomT_monthly_yellowtail_',stock.names[j],years[i],'.nc')),varname = 'BottomT',overwrite = T)
    
    data.month.stat = EDABUtilities::make_2d_summary_ts(data.in = data.mask.epu,
                                                        shp.file =NA,
                                                        var.name = 'BottomT',
                                                        agg.time = 'months',
                                                        area.names = NA,
                                                        statistics = c('mean','sd'),
                                                        file.time = 'annual',
                                                        write.out =F)
    
    data.month.ls[[df.ind]] = dplyr::bind_rows(data.month.stat) %>%
      dplyr::mutate(month = month.name[time],
                    year = years[i],
                    stock = stock.names[j])%>%
      select(year,month,stock,var.name,statistic,value)
    
    print(stock.names[j])
    print(nrow(data.month.ls[[df.ind]]))
    df.ind = df.ind +1 
    print(df.ind)
  } 
}
data.month.out = dplyr::bind_rows(data.month.ls)

write.csv(data.month.out,here::here('data','yellowtail','GLORYS_monthly_BottomT_ECOMON6_1993_2024.csv'),row.names = F)

#Test March April May

data.month.out =read.csv(here::here('data','yellowtail','GLORYS_monthly_BottomT_ECOMON6_1993_2024.csv'))
spring = data.month.out |> 
  filter(month %in% c('March','April','May') & statistic == 'mean') |> 
  group_by(year,stock) |> 
  summarize(value = mean(value,na.rm=T))

ggplot(spring, aes(x = year, y= value))+
  geom_line()+
  facet_wrap(~stock)


nc_close(nc) # DO I EVEN NEED THIS
