library("ncdf4")
library(sf)
library(dplyr)
library(ggplot2)

# Specify the OPeNDAP server URL (using regular grid output)
url <- "http://psl.noaa.gov/thredds/dodsC/Projects/CEFI/regional_mom6/cefi_portal/northwest_atlantic/full_domain/hindcast/monthly/regrid/r20250715/tob.nwa.full.hcast.monthly.regrid.r20250715.199301-202312.nc"

##### FROM AI 
safe_ncvar_get <- function(nc, varname, start, count, max_retries = 3) {
  for(attempt in 1:max_retries) {
    result <- tryCatch({
      ncvar_get(nc, varname, start = start, count = count)
    }, error = function(e) {
      if(attempt < max_retries) {
        cat("Retry", attempt, "for", varname, "\n")
        Sys.sleep(2)  # Wait 2 seconds before retry
        return(NULL)
      } else {
        stop(e)
      }
    })
    if(!is.null(result)) return(result)
  }
}
##### FROM AI STOP

tempMeans_list <- list()

for( i in 1:372 ) { # for( i in 1:nt ) { #### CHANGED BECAUSE WE MOVED THE NC OPEN TO INSIDE THE FOR LOOP. NT = 372L FOR THIS DATASET
  tryCatch({

# Open a NetCDF file lazily and remotely
nc <- nc_open(url)

v3      <- nc$var[[1]]
varsize <- v3$varsize
ndims   <- v3$ndims
nt      <- varsize[ndims]  # Remember timelike dim is always the LAST dimension!


# tempMeans <- data.frame(Year = c(),
#                         Month = c(),
#                         Mean = c())
# testingIndex <- 0
# AI FIX

  # Initialize start and count to read one timestep of the variable.
  start <- rep(1,ndims)	# begin with start=(1,1,1,...,1)
  start[ndims] <- i	# change to start=(1,1,1,...,i) to read timestep i
  count <- varsize	# begin w/count=(nx,ny,nz,...,nt), reads entire var
  count[ndims] <- 1	# change to count=(nx,ny,nz,...,1) to read 1 tstep
  data3 <- ncvar_get( nc, v3, start=start, count=count )
  
  lon <- ncvar_get(nc, "lon")
  lat <- ncvar_get(nc, "lat")
  time <- safe_ncvar_get(nc, "time",start = c(i), count = c(1))
  
  # Now read in the value of the timelike dimension
  tob <- safe_ncvar_get( nc, "tob", start=c(1, 1, i), count = c(-1, -1, 1)) # tob <- ncvar_get( nc, "tob", start=i, count=1 )
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
  
  # Now looking at GBK Shapefiles
  GBK_stats <- as.integer(c(522, 525, 541, 542, 543, 551, 552, 561, 562))
  
  StatAreas <- read_sf('C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/NEFSC_GIS/Statistical_Areas_2010.shp')
  
  GBK <- subset(StatAreas, subset = Id %in% GBK_stats)
  
  pnts_sf <- st_as_sf(df, coords = c('lon', 'lat'), crs = st_crs(4326))
  pnts_trans <- st_transform(pnts_sf, 2163)
  tt_trans <- st_transform(GBK, 2163)
  
  # Seeing which points fall within the GBK
  # pnts_trans <- pnts_sf %>% mutate(
  #   intersection = as.integer(st_intersects( pnts_trans,tt_trans)))
  # AI FIX
  pnts_trans <- pnts_trans %>% mutate(
    intersection = as.integer(st_intersects(geometry, tt_trans)))
  
  
  # AI FIX
  # DataToUse <- subset(pnts_trans, subset = intersection >= 0)
  DataToUse <- subset(pnts_trans, !is.na(intersection))
  # View(DataToUse)
  
  # tempMeans$Year <- append(tempMeans$Year, as.numeric(format(datetime_var, '%Y')))
  # tempMeans$Mean <- append(tempMeans$Mean, mean(DataToUse$tob))
  # tempMeans <- rbind(tempMeans, list(as.numeric(format(datetime_var, '%Y')), as.numeric(format(datetime_var, '%m')), mean(DataToUse$tob, na.rm = TRUE)))
  # AI FIX
  tempMeans_list[[i]] <- list(
    Year = as.numeric(format(datetime_var, '%Y')),
    Month = as.numeric(format(datetime_var, '%m')),
    Mean = mean(DataToUse$tob, na.rm = TRUE)
  )
  
  # }, error=function(e){})
  # testingIndex <- testingIndex + 1
  # AI FIX
  nc_close(nc)
  }, error=function(e){
    cat("Error at timestep", i, ":", conditionMessage(e), "\n")
  })
  
}


# AI FIX
tempMeans <- bind_rows(tempMeans_list)

saveRDS(tempMeans,'C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/tempMeans.rds')

tempMeans <- readRDS('C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/tempMeans.rds')

colnames(tempMeans) <- c('Year', 'Month','Temp')

tempMeans_avg <- tempMeans %>%  # Use the filtered data!
  group_by(Year) %>%
  summarise(mean = mean(Temp, na.rm = TRUE),
            sd = sd(Temp, na.rm = TRUE))

#Filtering for spring and then combining means
springMonths <- c(3, 4, 5)
# SpringMeans <- subset(tempMeans, subset = Month %in% springMonths)
# SpringMeans <- tempMeans %>%
#   group_by(Year) %>%
#   summarise(mean = mean(Temp, na.rm = TRUE),
#             sd = sd(Temp, na.rm = TRUE))
# AI FIX
SpringMeans <- subset(tempMeans, subset = Month %in% springMonths)
SpringMeans <- SpringMeans %>%  # Use the filtered data!
  group_by(Year) %>%
  summarise(mean = mean(Temp, na.rm = TRUE),
            sd = sd(Temp, na.rm = TRUE))

saveRDS(SpringMeans,'C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/SpringMeans.rds')

#SpringMeans <- readRDS('C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/SpringMeans.rds')

CI_indices <- read.csv('C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/CI_indices.csv')


ggplot(tempMeans_avg, aes(x = Year, y = mean)) +
  geom_line(colour = 'red') +
  geom_line(CI_indices, mapping = aes(x = Year, y = bt_temp), colour = 'black')




