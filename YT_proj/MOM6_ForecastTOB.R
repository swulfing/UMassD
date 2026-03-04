library("ncdf4")
library(gifski) # If you want to make the gif animation
# tbh idk if you need all of the packages below, I'm just pulling from old code
library(sf)
library(dplyr)
library(ggplot2)

# Specify the OPeNDAP server URL (using regular grid output) as you can tell I tried this a few times

#url <- "http://psl.noaa.gov/thredds/dodsC/Projects/CEFI/regional_mom6/cefi_portal/northwest_atlantic/full_domain/decadal_forecast/monthly/regrid/latest/tob.nwa.full.dc_fcast.monthly.regrid.r20250925.enss.i196501.nc" # THIS URL ENDED IN 1974???

url <- "http://psl.noaa.gov/thredds/dodsC/Projects/CEFI/regional_mom6/cefi_portal/northwest_atlantic/full_domain/decadal_forecast/monthly/regrid/r20250925/tob.nwa.full.dc_fcast.monthly.regrid.r20250925.enss.i202501.nc" # Decadal forecast 2025-2034

# url <- "http://psl.noaa.gov/thredds/dodsC/Projects/CEFI/regional_mom6/cefi_portal/northwest_atlantic/full_domain/decadal_forecast/monthly/regrid/r20250925/tob.nwa.full.dc_fcast.monthly.regrid.r20250925.enss.i202501.nc"

# Open a NetCDF file lazily and remotely


###############################
# EXTRACTING DATA
##############################

#PULLING DATA FROM ONE TIMESTEP (in this case, days since 1960)
ncopendap <- nc_open(url)

timestart <- 120 # specify timestep. I'm just testing

# Read the coordinate into memory
lon <- ncvar_get(ncopendap, "lon")
lat <- ncvar_get(ncopendap, "lat")
time <- ncvar_get(ncopendap, "lead",start = c(timestart), count = c(1)) # CHANGE FROM 'init' TO 'lead' FROM THE SCRIPT YOU COPIED (Or whatever the time variable is called.). days since 1965-01-01 in gregorian calendar. Start is starting point, count is how many timestamps you want after that

# Read a slice of the data into memory

tob <- ncvar_get(ncopendap, "tob", start = c(1, 1, timestart, 1), count = c(-1, -1, 1, 1)) # Dimensions (LAT, LON, LEAD, MEMBER (idk wtf member is)), DEPENDING ON WHAT YOU PULL, THESE DIMENSIONS MAY CHANGE ORDER. Here, I am taking all lat/lon data and just one timestep and one 'member' (again, don't know wtf that is)

#MATCH YOUR SECOND ELEMENTS IWTH THE TIME START AND COUNT.
nrow(tob) # Should match your lon dims
ncol(tob) # should match your lat dims

# View(tob) # Only if you want to check yourself

# TURNING TIMESTEP INTO SOMETHING USEABLE

# Get the units
tunits <- ncatt_get(ncopendap, "lead", "units")
datesince <- tunits$value
datesince <- substr(datesince, nchar(datesince)-9, nchar(datesince))
datesince


# convert the number to datetime (input should be in second while the time is in unit of days)
datetime_var <- as.POSIXct(time*86400, origin=datesince, tz="UTC")
datetime_var


filled.contour(lon, lat, tob, main = paste("TOB at", datetime_var), xlab = "Longitude", ylab = "Latitude", levels = pretty(c(20,40), 20))



###############################
# Animated map making a gif
##############################
save_gif({
# for(i in 1:120) {
for(i in seq(1,120, by = 10)) { # IF YOU WANT TO VISUALIZE MORE TIMESTEPS, YOU CAN CHANGE THIS SEQUENCE
timestart <- i

# Read the coordinate into memory
lon <- ncvar_get(ncopendap, "lon")
lat <- ncvar_get(ncopendap, "lat")
time <- ncvar_get(ncopendap, "lead",start = c(timestart), count = c(1))

# Read a slice of the data into memory
# tob <- ncvar_get(ncopendap, "tob", start = c(1, 1, 1, 1), count = c(-1, -1, -1, -1))

tob <- ncvar_get(ncopendap, "tob", start = c(1, 1, timestart, 1), count = c(-1, -1, 1, 1)) # Dimensions (LAT, LON, LEAD, MEMBER (idk wtf member is))

# Get the units
tunits <- ncatt_get(ncopendap, "lead", "units")
datesince <- tunits$value
datesince <- substr(datesince, nchar(datesince)-9, nchar(datesince))
datesince


# convert the number to datetime (input should be in second while the time is in unit of days)
datetime_var <- as.POSIXct(time*86400, origin=datesince, tz="UTC")
datetime_var


filled.contour(lon, lat, tob, main = paste("TOB at", datetime_var), xlab = "Longitude", ylab = "Latitude", levels = pretty(c(20,40), 20))


  }
},gif_file = "filled_contour_animation.gif", width = 800, height = 600, delay = 0.1)



############################
# PULLING OUT AN ANNUAL AVERAGE
# FROM A SPECIFIC STOCK AREA 
# (In this case I'm looking at Georges Bank)
#############################

# Make DF

tempMeans_list <- data.frame(
  Year = c(),
  Month = c(),
  Mean = c()
)

for( i in 1:12) {
  
  tryCatch({
    
    # Open a NetCDF file lazily and remotely
    nc <- nc_open(url)
    
    v3      <- nc$var[[1]]
    varsize <- v3$varsize
    ndims   <- v3$ndims
    nt      <- varsize[(ndims-1)]  # IN THIS CASE TIME IS OUR SECOND TO LAST DIMENSION. MAY CHANGE
    
    # Initialize start and count to read one timestep of the variable.
    start <- rep(1,ndims)	# begin with start=(1,1,1,...,1)
    start[(ndims-1)] <- i	# change to start=(1,1,1,...,i) to read timestep i
    count <- varsize	# begin w/count=(nx,ny,nz,...,nt), reads entire var
    count[(ndims-1)] <- 1	# change to count=(nx,ny,nz,...,1) to read 1 tstep
    data3 <- ncvar_get( nc, v3, start=start, count=count )
    
    lon <- ncvar_get(nc, "lon")
    lat <- ncvar_get(nc, "lat")
    time <- ncvar_get(nc, "lead",start = c(i), count = c(1))
    
    # Now read in the value of the timelike dimension
    tob <- ncvar_get( nc, "tob", start = c(1, 1, i, 1), count = c(-1, -1, 1, 1)) # tob <- ncvar_get( nc, "tob", start=i, count=1 )
    tunits <- ncatt_get(nc, "lead", "units")
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
    GBK_stats <- as.integer(c(522, 525, 541, 542, 543, 551, 552, 561, 562)) # stock areas that are included in Georges bank. Change if you're looking at a different stock
    
    StatAreas <- read_sf('C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/NEFSC_GIS/Statistical_Areas_2010.shp')
    
    GBK <- subset(StatAreas, subset = Id %in% GBK_stats)
    
    pnts_sf <- st_as_sf(df, coords = c('lon', 'lat'), crs = st_crs(4326))
    pnts_trans <- st_transform(pnts_sf, 2163) # I have no idea if we need to care about this warning message
    tt_trans <- st_transform(GBK, 2163)
    
    # Seeing which points fall within the GBK
    pnts_trans <- pnts_trans %>% mutate(
      intersection = as.integer(st_intersects(geometry, tt_trans)))
    
    
    DataToUse <- subset(pnts_trans, !is.na(intersection))
    # View(DataToUse)

    # tempMeans_list[[i]] <- list(
    #   Year = as.numeric(format(datetime_var, '%Y')),
    #   Month = as.numeric(format(datetime_var, '%m')),
    #   Mean = mean(DataToUse$tob, na.rm = TRUE)
    # )
    
    data_list <- data.frame(
      Year = as.numeric(format(datetime_var, '%Y')),
      Month = as.numeric(format(datetime_var, '%m')),
      Mean = mean(DataToUse$tob, na.rm = TRUE)
    )
    
    tempMeans_list <- rbind(tempMeans_list, data_list)
    nc_close(nc)
    
  }, error=function(e){
    cat("Error at timestep", i, ":", conditionMessage(e), "\n")
  })
  
}


#tempMeans <- bind_rows(tempMeans_list)

saveRDS(tempMeans_list,'C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/MOM6tempMeans.rds')

# tempMeans <- readRDS('C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/MOM6tempMeans.rds')

tempMeans <- tempMeans_list

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

SpringMeans <- subset(tempMeans, subset = Month %in% springMonths)
SpringMeans <- SpringMeans %>%  # Use the filtered data!
  group_by(Year) %>%
  summarise(mean = mean(Temp, na.rm = TRUE),
            sd = sd(Temp, na.rm = TRUE))

saveRDS(SpringMeans,'C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/MOM6SpringMeans.rds')

#SpringMeans <- readRDS('C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/SpringMeans.rds')


### IGNORE THIS I'M JUST COMPARING TO DU PONTAVICE
CI_indices <- read.csv('C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/CI_indices.csv')


# ggplot(tempMeans_avg, aes(x = Year, y = mean)) +
#   geom_line(colour = 'red') +
#   geom_line(CI_indices, mapping = aes(x = Year, y = bt_temp), colour = 'black')

ggplot(CI_indices, mapping = aes(x = Year, y = bt_temp)) +
  geom_line(colour = 'red') 






