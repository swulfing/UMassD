library(dplyr)

setwd('C:/Users/swulfing/Documents/GitHub/UMassD/MADA/LocalNames')

l1 <- read.csv('LN1.csv')
colnames(l1) <- c("FileName", "Year", "Month", "Day", "Region", "Names", "Age",
                  "Location", "ToolsBaitUsed",  "ScientificName",
                  "HarvestPressure", "PriceKiloAR", "Gender", "LocationOcean",
                  "LocalName", "Time" )

l2 <- read.csv('LN2.csv')
colnames(l2) <- c("FileName", "Year", "Month", "Day", "Region" , "Village", 
                  "Gender", "Age", "Names", "ToolsBaitUsed", "Gender_2", 
                  "LocationOcean", "ToolsBaitUsed_2", "ScientificName", 
                  "HarvestPressure", "PriceKiloAR", "LocalName" , "Time", "Notes")


l3 <- read.csv('LN3.csv')
colnames(l3) <- c("Year", "FileName", "Month", "Day", "Region", "Village", 
                  "Gender", "Age", "Names", "ToolsBaitUsed", "Gender_2",
                  "LocationOcean", "ToolsBaitUsed_2",  "ScientificName",
                  "HarvestPressure", "PriceKiloAR", "LocalName", "Time", "Notes",
                  "X" ,"X.1" , "IndicatorCategory","X.2", "X.3", "X.4")

l4 <- read.csv('LN4.csv')
colnames(l4) <- c("FileName", "Year", "Month", "Day", "Region", "Village", "Gender",      
                  "Age", "Names", "ToolsBaitUsed", "Gender_2", "LocationOcean",  
                  "ToolsBaitUsed_2", "ScientificName", "HarvestPressure", "PriceKiloAR" ,
                  "LocalName", "Time", "Notes", "X", "X.1", "X.2", "X.3", "X.4",
                  "X.5", "X.6", "X.7", "X.8")

l5 <- read.csv('LN5.csv')
colnames(l5) <- c("FileName", "Year", "Month", "Day", "Region", "Village",  "Gender",
                  "Age",  "Names","ToolsBaitUsed", "Gender_2", "LocationOcean",
                  "ToolsBaitUsed_2", "ScientificName", "HarvestPressure", "PriceKiloAR",
                  "LocalName", "Time", "Notes", "X", "X.1", "X.2", "X.3", "X.4",
                  "X.5", "X.6", "X.7", "X.8", "X.9",  "X.10", "X.11", "X.12", "X.13",
                  "X.14", "X.15", "X.16", "X.17", "X.18", "X.19", "X.20")

l6 <- read.csv('LN6.csv')
colnames(l6) <- c("FileName", "Year", "Month", "Day", "Region", "Village", "Gender",
                  "Age", "Names", "ToolsBaitUsed", "Gender_2", "LocationOcean",
                  "ToolsBaitUsed_2", "ScientificName", "HarvestPressure", "PriceKiloAR",
                  "LocalName", "Time", "Notes", "X", "X.1", "X.2", "X.3", "X.4",
                  "X.5" ,"X.6")

l7 <- read.csv('LN7.csv')
colnames(l7) <- c("FileName", "Year", "Month",  "Day", "Region", "Village", "Gender",
                  "Age", "Names", "ToolsBaitUsed", "Gender_2", "LocationOcean",
                  "ToolsBaitUsed_2", "ScientificName", "HarvestPressure", 
                  "PriceKiloAR", "LocalName", "Time", "Notes", "X",  "X.1", "X.2", 
                  "X.3", "X.4", "X.5", "X.6","X.7", "X.8", "X.9", "X.10", "X.11",
                  "X.12", "X.13", "X.14", "X.15","X.16", "X.17", "X.18", "X.19")


datalist <- list(l1,l2,l3,l4,l5,l6,l7)

for(i in 1:length(datalist)){
  datalist[[i]]$Month <- as.character(datalist[[i]]$Month)
  datalist[[i]]$Age <- as.character(datalist[[i]]$Age)
  datalist[[i]]$HarvestPressure <- as.character(datalist[[i]]$HarvestPressure)
  datalist[[i]]$PriceKiloAR <- as.character(datalist[[i]]$PriceKiloAR)
  datalist[[i]]$LocalName <- as.character(datalist[[i]]$LocalName)
}

combined_Names <- bind_rows( datalist)

colnames(combined_Names)

# wtf_list <- c("4000","3000","2500","1500","5000", "2000", "6000", "4500")
# 
# cekProb <- combined_Names %>%
#   filter(LocalName %in% wtf_list)

write.csv(sort(unique(combined_Names$LocalName)), 'Namelist.csv')















