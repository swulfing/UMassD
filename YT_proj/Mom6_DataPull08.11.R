library("ncdf4")
library(sf)
library(dplyr)

# Specify the OPeNDAP server URL (using regular grid output)
url <- "http://psl.noaa.gov/thredds/dodsC/Projects/CEFI/regional_mom6/cefi_portal/northwest_atlantic/full_domain/hindcast/monthly/regrid/r20250715/tob.nwa.full.hcast.monthly.regrid.r20250715.199301-202312.nc"

# Open a NetCDF file lazily and remotely
nc <- nc_open(url)

v3      <- nc$var[[1]]
varsize <- v3$varsize
ndims   <- v3$ndims
nt      <- varsize[ndims]  # Remember timelike dim is always the LAST dimension!


tempMeans <- data.frame(Year = c(),
                        Mean = c())

for( i in 1:nt ) {
  # Initialize start and count to read one timestep of the variable.
  start <- rep(1,ndims)	# begin with start=(1,1,1,...,1)
  start[ndims] <- i	# change to start=(1,1,1,...,i) to read timestep i
  count <- varsize	# begin w/count=(nx,ny,nz,...,nt), reads entire var
  count[ndims] <- 1	# change to count=(nx,ny,nz,...,1) to read 1 tstep
  data3 <- ncvar_get( nc, v3, start=start, count=count )
  
  lon <- ncvar_get(nc, "lon")
  lat <- ncvar_get(nc, "lat")
  time <- ncvar_get(nc, "time",start = c(i), count = c(1))
  
  # Now read in the value of the timelike dimension
  tob <- ncvar_get( nc, "tob", start=c(1, 1, i), count = c(-1, -1, 1)) # tob <- ncvar_get( nc, "tob", start=i, count=1 )
  tunits <- ncatt_get(nc, "time", "units")
  datesince <- tunits$value
  datesince <- substr(datesince, nchar(datesince)-9, nchar(datesince))
  datesince
  
  # convert the number to datetime (input should be in second while the time is in unit of days)
  datetime_var <- as.POSIXct(time*86400, origin=datesince, tz="UTC")
  datetime_var
  
  
  # Create a df of all points within time step
  df <- expand.grid(X = lon, Y = lat)
  data <- as.vector(t(tob))
  df$Data <- data
  names(df) <- c("lon", "lat", "tob")
  
  # Now looking at GOM Shapefiles
  GOM_stats <- as.integer(c(464, 465, 466, 467, 511, 512, 513, 514, 515, 521))
  
  StatAreas <- read_sf('C:/Users/swulfing/Downloads/NEFSC_GIS/Statistical_Areas_2010.shp')
  
  GoM <- subset(StatAreas, subset = Id %in% GOM_stats)
  
  pnts_sf <- st_as_sf(df, coords = c('lon', 'lat'), crs = st_crs(4326))
  
  pnts_trans <- st_transform(pnts_sf, 2163)
  tt_trans <- st_transform(GoM, 2163)
  
  # Seeing which points fall within the GoM
  pnts_trans <- pnts_sf %>% mutate(
    intersection = as.integer(st_intersects( pnts_trans,tt_trans)))
  
  DataToUse <- subset(pnts_trans, subset = intersection >= 0)
  # View(DataToUse)
  
  # tempMeans$Year <- append(tempMeans$Year, as.numeric(format(datetime_var, '%Y')))
  # tempMeans$Mean <- append(tempMeans$Mean, mean(DataToUse$tob))
  tempMeans <- rbind(tempMeans, list(as.numeric(format(datetime_var, '%Y')),mean(DataToUse$tob, na.rm = TRUE)))
  
}

nc_close(nc)

saveRDS(tempMeans,'C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/tempMeans.rds')

colnames(tempMeans) <- c('Year', 'Temp')

AnnualMeans <- tempMeans %>%
  group_by(Year) %>%
  summarise(mean = mean(Temp, na.rm = TRUE),
            sd = sd(Temp, na.rm = TRUE))






# testing <- df %>%
#   filter(tob >=0)





