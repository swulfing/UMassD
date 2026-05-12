library("ncdf4")
library(gifski) # If you want to make the gif animation
# tbh idk if you need all of the packages below, I'm just pulling from old code
library(sf)
library(dplyr)
library(ggplot2)
library(lubridate)

wd <- 'C:/Users/swulfing/Documents/GitHub/UMassD/MOM6_100yrForecast'
setwd(wd)

GB_BT <- read.csv('Biascorrect/GB_BT_1982_to_2025_not_detrended.csv')
GB_SST <- read.csv('Biascorrect/GB_SST_1982_to_2025_not_detrended.csv')

GOM_BT <- read.csv('Biascorrect/GOM_BT_1982_to_2025_not_detrended.csv')
GOM_SST <- read.csv('Biascorrect/GOM_SST_1982_to_2025_not_detrended.csv')

MAB_BT <- read.csv('Biascorrect/MAB_BT_1982_to_2025_not_detrended.csv')
MAB_SST <- read.csv('Biascorrect/MAB_SST_1982_to_2025_not_detrended.csv')


GB_BT$t <- as.POSIXct(GB_BT$t)
GBBT_clean <- GB_BT %>%
  group_by(year = year(t)) %>%
  summarize(mean = mean(temp))


scenario <- c('SSP585', 'SSP126', 'SSP245', 'SSP370')


###############GBK###################################

for(i in 1:length(scenario)){
  dataset <- readRDS(paste0(wd, '/BiasCorrect/MOM6 Long Term TOB/', scenario[i], '_GBK.RDS'))
  
  MOM6HistAvg <- dataset %>%
    filter(Year <= 2014)
  MOM6HistAvg <- mean(MOM6HistAvg$Mean_Tob)
  
  GLORYSHistAvg <- mean(GBBT_clean$mean)
  
  dataset$MOM6HistAvg <- MOM6HistAvg
  dataset$GLORYSHistAvg <- GLORYSHistAvg
  
  dataset <- dataset %>%
    rowwise()%>%
    mutate(Delta_i = Mean_Tob - MOM6HistAvg) %>%
    mutate(Tob_CORRECTED = Delta_i + GLORYSHistAvg)
  
  for(j in 1:nrow(dataset)){
    if(dataset$Year[j] < 1982){
      dataset$Tob_CORRECTED[j] <- NA
    }else if (dataset$Year[j] >= 1982 & dataset$Year[j] <= 2014){
      dataset$Tob_CORRECTED[j] <- GBBT_clean$mean[which(GBBT_clean$year == dataset$Year[j])]
    }
    
  }
  
  saveRDS(dataset, paste0(wd, '/BiasCorrect/', scenario[i],'_GBBiasCorrect.rds'))
}


###############EPU_WHOLE###################################

GOM_BT$t <- as.POSIXct(GOM_BT$t)
GOMBT_clean <- GOM_BT %>%
  group_by(year = year(t)) %>%
  summarize(mean = mean(temp))


MAB_BT$t <- as.POSIXct(MAB_BT$t)
MABBT_clean <- MAB_BT %>%
  group_by(year = year(t)) %>%
  summarize(mean = mean(temp))

GLORYS_EPU <- data.frame(Year = GBBT_clean$year,
                        temp = NA)

EPUs <- st_read('C:/Users/swulfing/Documents/GitHub/UMassD/MOM6_100yrForecast/EPUs/EPU_extended.shp') %>% filter(EPU != 'SS')
#sum_areas <- sum(EPUs$Shape_Area)

for(i in 1:nrow(GLORYS_EPU)){
  ###NOW TAKE WEIGHTED AVERAGE
  GLORYS_EPU$temp[i] <- ((6.162033 * GBBT_clean$mean[i]) + (7.545063 * GOMBT_clean$mean[i]) + (15.695390 * MABBT_clean$mean[i]))/(6.162033 + 7.545063 + 15.695390)
  
  
}



for(i in 1:length(scenario)){
  dataset <- readRDS(paste0(wd, '/BiasCorrect/MOM6 Long Term TOB/', scenario[i], '_EPU.RDS'))
  
  MOM6HistAvg <- dataset %>%
    filter(Year <= 2014)
  MOM6HistAvg <- mean(MOM6HistAvg$Mean_Tob)
  
  GLORYSHistAvg <- mean(GLORYS_EPU$temp)
  
  dataset$MOM6HistAvg <- MOM6HistAvg
  dataset$GLORYSHistAvg <- GLORYSHistAvg
  
  dataset <- dataset %>%
    rowwise()%>%
    mutate(Delta_i = Mean_Tob - MOM6HistAvg) %>%
    mutate(Tob_CORRECTED = Delta_i + GLORYSHistAvg)
  
  for(j in 1:nrow(dataset)){
    if(dataset$Year[j] < 1982){
      dataset$Tob_CORRECTED[j] <- NA
    }else if (dataset$Year[j] >= 1982 & dataset$Year[j] <= 2014){
      dataset$Tob_CORRECTED[j] <- GLORYS_EPU$temp[which(GLORYS_EPU$Year == dataset$Year[j])]
    }
    
  }
  
  saveRDS(dataset, paste0(wd, '/BiasCorrect/', scenario[i],'_EPUBiasCorrect.rds'))
}
