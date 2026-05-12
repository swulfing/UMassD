library(sf)
library(dplyr)
library(ggplot2)

scenario <- c('SSP126', 'SSP245', 'SSP370', 'SSP585')

for(i in 1:length(scenario)){

  dataclip <- readRDS(paste0('C:/Users/swulfing/Documents/GitHub/UMassD/MOM6_100yrForecast/', scenario[i],'.RDS'))
  
  dataclip <- dataclip[!is.na(dataclip$TOB),]
  # COMMENT THIS OUT WHEN YOU RUN WHOLE THING
  dataclip <- dataclip %>%
    filter(Date <= "2022-07-02")
  
  pnts_trans <- st_as_sf(dataclip, coords = c('Lon', 'Lat'), crs = st_crs(4269))
  #pnts_trans <- pnts_sf# st_transform(pnts_sf, 2163) # I have no idea if we need to care about this warning message
  
  rm(dataclip)
  

  StatAreas <- read_sf("C:/Users/swulfing/Documents/GitHub/UMassD/MOM6_100yrForecast/EPUs/EPU_extended.shp")
  
  for(j in 1:2){
    
    if(j == 2){
      StatAreas <-  StatAreas %>%
        filter(EPU == 'GB')
      }
    
    #GOM_Data <- st_intersection(dataclip, GBK)

    tt_trans <- st_make_valid(StatAreas) # tt_trans <- st_transform(StatAreas, 2163)

    # Seeing which points fall within the StatAreas
    pnts_trans <- pnts_trans %>% mutate(
      intersection = as.integer(st_intersects(geometry, tt_trans)))


    DataToUse <- subset(pnts_trans, !is.na(intersection))
    
    # rm(pnts_trans)

    data_list <- data.frame(
      Year = as.numeric(format(DataToUse$Date, '%Y')),
      Mean = DataToUse$TOB
    )

    data_list <- data_list %>%
      group_by(Year) %>%
      summarise(Mean_Tob = mean(Mean, na.rm = TRUE))
    
    if(j==2){
      saveRDS(data_list, paste0('C:/Users/swulfing/Documents/GitHub/UMassD/MOM6_100yrForecast/EPU_TOB/', scenario[i], '_GBK.RDS'))
    }
    else{saveRDS(data_list, paste0('C:/Users/swulfing/Documents/GitHub/UMassD/MOM6_100yrForecast/EPU_TOB/', scenario[i], '_EPU.RDS'))}
  }
}
