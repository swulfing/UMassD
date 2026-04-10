args <- commandArgs(trailingOnly = TRUE)

outdir <- args[which(args == "--outdir") + 1]

Outputs <- 'Outputs'
workfolder <- '/work/pi_gfay_umassd_edu/Wulfing/MOM6_100YrForecast/'

library(sf)
library(dplyr)
library(ggplot2)

scenario <- c('SSP126', 'SSP245', 'SSP370', 'SSP585')

for(i in 1:length(scenario)){

  dataclip <- readRDS(paste0(workfolder, scenario[i],'.RDS'))
  # COMMENT THIS OUT WHEN YOU RUN WHOLE THING
  dataclip <- dataclip %>%
    filter(Date >= "2099-07-02")
  
  pnts_sf <- st_as_sf(dataclip, coords = c('Lon', 'Lat'), crs = st_crs(4326))
  pnts_trans <- st_transform(pnts_sf, 2163) # I have no idea if we need to care about this warning message
  

  StatAreas <- read_sf(paste0(workfolder,"EPUs/EPU_extended.shp"))
  
  for(j in 1:2){
    
    if(j == 2){
      StatAreas <-  StatAreas %>%
        filter(EPU == 'GB')}
    
    #GOM_Data <- st_intersection(dataclip, GBK)

    tt_trans <- st_transform(StatAreas, 2163)

    # Seeing which points fall within the StatAreas
    pnts_trans <- pnts_trans %>% mutate(
      intersection = as.integer(st_intersects(geometry, tt_trans)))


    DataToUse <- subset(pnts_trans, !is.na(intersection))

    data_list <- data.frame(
      Year = as.numeric(format(DataToUse$Date, '%Y')),
      Mean = mean(DataToUse$TOB, na.rm = TRUE)
    )

    data_list <- data_list %>%
      group_by(Year) %>%
      summarise(Mean_Tob = mean(Mean))
    
    if(j==2){
      saveRDS(data_list, paste0(workfolder,Outputs,'/', scenario[i], '_GBK.RDS'))
    }
    else{saveRDS(data_list, paste0(workfolder,Outputs,'/', scenario[i], '_EPU.RDS'))}
  }
}
