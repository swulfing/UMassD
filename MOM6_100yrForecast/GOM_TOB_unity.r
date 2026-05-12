args <- commandArgs(trailingOnly = TRUE)

outdir <- args[which(args == "--outdir") + 1]

Outputs <- 'Outputs'
workfolder <- '/work/pi_gfay_umassd_edu/Wulfing/MOM6_100YrForecast/'

# install.packages("sf")

library(sf)
library(dplyr)
library(ggplot2)

scenario <- c('SSP126', 'SSP245', 'SSP370', 'SSP585')

for(i in 1:length(scenario)){
  # tryCatch({
  
  dataclip <- readRDS(paste0(workfolder, scenario[i],'.rds'))
  
  dataclip <- dataclip[!is.na(dataclip$TOB),]
  # COMMENT THIS OUT WHEN YOU RUN WHOLE THING
  # dataclip <- dataclip %>%
  #   filter(Date <= "2022-07-02")
  
  pnts_trans <- st_as_sf(dataclip, coords = c('Lon', 'Lat'), crs = st_crs(4269))
  # pnts_trans <- pnts_sf# st_transform(pnts_sf, 2163) # I have no idea if we need to care about this warning message
  
  rm(dataclip)
  
  StatAreas <- read_sf(paste0(workfolder,"NEFSC_GIS/Statistical_Areas_2010.shp"))
  
  for(j in 1:2){
    if(j == 1){
      GOM_stats <- as.integer(c(513, 514, 515, 521, 526, 541)) # COD
    }else{
      GOM_stats <- as.integer(c(464, 465, 511, 512, 513, 514, 515)) # HADDOCK
    }
    
    StatAreas <- subset(StatAreas, subset = Id %in% GOM_stats)
    
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
    
    if(j==1){
      saveRDS(data_list, paste0(workfolder,Outputs,'/', scenario[i], '_TOBGOM_COD.RDS'))
    }
    else{saveRDS(data_list, paste0(workfolder,Outputs,'/', scenario[i], '_TOBGOM_HADDOCK.RDS'))}
  }
  
  # }, error=function(e){
  #   cat("Error at timestep", i, ":", conditionMessage(e), "\n")
  # })
}
