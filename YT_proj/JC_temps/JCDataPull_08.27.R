#Script to generate monthly bottom temperature from GLORYS for yellowtail assessment
library(terra)
library(dplyr)
library(ggplot2)

data.dir = 'C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/JC_temps'
setwd(data.dir)
data.prefix = 'MOM6_monthly_BottomTemp_'
years = 1993:2023

max.depth = 150

# stock.files = list.files(here::here('geometry','yellowtail_cod_stock_area'),pattern = '*\\.shp$',full.names = T)
# stock.names = gsub('.shp','',basename(stock.files))
stock.files <- "C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/NEFSC_GIS/GBKstock.files.shp"

#url <- "tob.nwa.full.hcast.monthly.regrid.r20250715.199301-202312.nc"
url <- 'https://psl.noaa.gov/thredds/ncss/grid/Projects/CEFI/regional_mom6/cefi_portal/northwest_atlantic/full_domain/hindcast/monthly/regrid/latest/tob.nwa.full.hcast.monthly.regrid.r20250715.199301-202312.nc?var=tob&north=40&west=-80&east=-70&south=35&horizStride=1&time_start=1993-01-16T12:00:00Z&time_end=2023-12-16T12:00:00Z&&&accept=netcdf3'
bathy = terra::rast(url)
# bathy.crop = terra::clamp(bathy,lower = 0 ,upper = max.depth,values = F)


# epu.shp = vect(here::here('geometry','EPU_NOESTUARIES.shp'))
coastLines <- "C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/JC_temps/tl_2019_us_coastline/tl_2019_us_coastline.shp"
epu.shp = vect(coastLines)
wgs84_epsg <- "EPSG:4326"
epu.shp <- project(epu.shp, wgs84_epsg)

full.shp = terra::vect(lapply(stock.files,vect))
terra::plot(bathy)
plot(full.shp)
plot(epu.shp,add = T)#, col = 2,alpha = 0.5,lty = 2)

df.ind = 1
j=2
data.month.ls = list()
for(j in 1:length(stock.files)){
  
  
  # file.shp = terra::project(),'+proj=longlat +datum=WGS84 +no_defs ')  
  file.shp =terra::vect(stock.files[1])
  #trip file.shp for only intersection with bathy.crop
  terra::crs(file.shp) = '+proj=longlat +datum=WGS84 +no_defs '
  
  i=1
  for(i in 1:length(years)){
    
    #data.file = paste0(data.dir,data.prefix,years[i],'.nc')
    
    #mask by stock area
    data.mask.stock = EDABUtilities::mask_nc_2d(data.in = bathy,#data.file,
                                                write.out = F,
                                                min.value = -10,
                                                max.value = 999,
                                                binary = F,
                                                var.name = 'tob',#'BottomT',
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
                                               var.name = 'tob',#'BottomT',
                                               shp.file = epu.shp)
    
    #Extract data
    data.month.nc = EDABUtilities::make_2d_summary_gridded(data.in = data.mask.epu,
                                                           write.out = F,
                                                           shp.file = NA,
                                                           var.name = 'tob',#'BottomT',
                                                           agg.time = 'months',
                                                           statistics = 'mean',
                                                           file.time = 'daily',
                                                           touches = T,
                                                           area.names = NA
    )[[1]] %>%
      terra::rast()
    
    terra::writeCDF(data.month.nc, paste0('TempData', years[i],'.nc'),varname = 'tob',overwrite = T) # varname = 'BottomT'
    
    data.month.stat = EDABUtilities::make_2d_summary_ts(data.in = data.mask.epu,
                                                        shp.file =NA,
                                                        var.name = 'tob',#'BottomT',
                                                        agg.time = 'months',
                                                        area.names = NA,
                                                        statistics = c('mean','sd'),
                                                        file.time = 'daily',
                                                        write.out =F)
    
    data.month.ls[[df.ind]] = dplyr::bind_rows(data.month.stat) %>%
      dplyr::mutate(month = month.name[time],
                    year = years[i]) %>%
                    #stock = stock.names[j])%>%
      select(year,month,var.name,statistic,value)
    
    #print(stock.names[j])
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