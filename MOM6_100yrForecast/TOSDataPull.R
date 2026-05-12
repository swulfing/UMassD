library("ncdf4")
library(gifski) # If you want to make the gif animation
# tbh idk if you need all of the packages below, I'm just pulling from old code
library(sf)
library(dplyr)
library(ggplot2)

wd <- 'C:/Users/swulfing/Documents/GitHub/UMassD/MOM6_100yrForecast'
setwd(wd)

scenario <- c('SSP585', 'SSP126', 'SSP245', 'SSP370')

for(j in 1:length(scenario)) {
  
  TempTimeseries <- data.frame(Date = c(),
                             Lon = c(),
                             Lat = c(),
                             TOB = c())

for(i in 1970:2100){
  url <- paste0('C:/Users/swulfing/OneDrive - University of Massachusetts Dartmouth/Desktop/MOM6FORECASTPULL/', scenario[j],'/',scenario[j],'/tos/tos_',i,'.nc')
  tryCatch({
    
    nc <- nc_open(url)
    
    
    timestart <- 1 # specify timestep. I'm just testing
    
    # Read the coordinate into memory
    lon <- ncvar_get(nc, "xh")
    lat <- ncvar_get(nc, "yh")
    time <- ncvar_get(nc, "time",start = c(timestart), count = c(1)) # CHANGE FROM 'init' TO 'lead' FROM THE SCRIPT YOU COPIED (Or whatever the time variable is called.). days since 1965-01-01 in gregorian calendar. Start is starting point, count is how many timestamps you want after that
    
    # Read a slice of the data into memory
    
    tos <- ncvar_get(nc, "tos", start = c(1, 1, timestart), count = c(-1, -1, 1)) # Dimensions (LAT, LON, LEAD, MEMBER (idk wtf member is)), DEPENDING ON WHAT YOU PULL, THESE DIMENSIONS MAY CHANGE ORDER. Here, I am taking all lat/lon data and just one timestep and one 'member' (again, don't know wtf that is)
    
    #MATCH YOUR SECOND ELEMENTS IWTH THE TIME START AND COUNT.
    nrow(tos) # Should match your lon dims
    ncol(tos) # should match your lat dims
    
    tunits <- ncatt_get(nc, "time", "units")
    datesince <- tunits$value
    datesince <- substr(datesince, nchar(datesince)-18, nchar(datesince))#substr(datesince, nchar(datesince)-9, nchar(datesince))
    datesince
    
    # convert the number to datetime (input should be in second while the time is in unit of days)
    datetime_var <- as.POSIXct(time*86400, origin=datesince, tz="UTC")
    datetime_var
    
    
    # Create a df of all points within time step
    df <- expand.grid(Lon = lon, Lat = lat)
    df$TOS <- as.vector(tos)   # NO t() — dimensions already match
    df$Date <- as.Date(datetime_var)
    names(df) <- c("Lon", "Lat", "TOS", 'Date')
    
 TempTimeseries <- rbind(TempTimeseries, df)
 
 nc_close(nc)
 

  }, error=function(e){
    cat("Error at timestep", i, ":", conditionMessage(e), "\n")
  })
}
  #write.csv(TempTimeseries, paste0(wd, '/', scenario[j], '.csv'))
  saveRDS(TempTimeseries, paste0(wd, '/', scenario[j], '_TOS.rds'))
}