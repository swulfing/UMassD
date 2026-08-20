library(dplyr)
library(ggplot2)

wd <- 'C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/Manuscripts/Draft3'
setwd(wd)

GLORYS <- read.csv(paste0(wd, '/CI_indices.csv'))
hindcast_GLORYS <- GLORYS %>%
  filter(Year <= 2014 & Year >= 1970)

scenario <- c('SSP585', 'SSP126', 'SSP245', 'SSP370')

tempData <- data.frame(scenario = c(),
                       Year = c(),
                       Mean_Tob = c())

for (i in 1:length(scenario)){
  dataset <- readRDS(paste0(wd,'/MOM6/', scenario[i], '_TOBGBK_YT.RDS'))
  dataset$scenario <- scenario[i]
  #dataset <- merge(dataset, GLORYS, by = 'Year', all.x = TRUE)
  
  hindcast_mom <- dataset %>%
    filter(Year <= 2014 & Year >= 1970)
  
  dataset$MOM_Hindcast <- mean(hindcast_mom$Mean_Tob)
  dataset$GLORYS_Hindcast <- mean(hindcast_GLORYS$bt_temp)
  
  tempData <- rbind(tempData,dataset)
}


tempData <- tempData %>%
  rowwise() %>%
  mutate(Delta = Mean_Tob - MOM_Hindcast) %>%
  mutate(TOB_BiasCorrect = GLORYS_Hindcast + Delta)

# Temps I used
HIGH_ests <- readRDS('C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/Manuscripts/Draft3/Biases/High_data.rds') %>%
  filter(seed_no == 1) %>%
  select(Year, EM_name, Temp_EM) %>%
  filter(EM_name == 'Mod_LOWEcov' | EM_name == 'Mod_HIGHEcov')

ggplot(tempData, aes(x = Year, y = TOB_BiasCorrect, color = scenario)) +
  geom_line() +
  geom_line(data = HIGH_ests, aes(x = Year, y = Temp_EM, color = EM_name))











