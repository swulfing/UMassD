setwd('C:/Users/swulfing/Documents/GitHub/UMassD/MADA/Data_cleaned/2010-2022 Filled_vetted_separated_logbook catch data')

library(dplyr)
library(lubridate)
library(hms)
library(data.table)
library(anytime)



# Combining Salary datasets after ------------------------------------------------------------------

df_list <- list()

for (i in 1:13){
  if(i < 10){
    dataset <- read.csv(paste0('S0',i,'.csv'))
    df_list[[i]] <- dataset
    }
  else{
    dataset <- read.csv(paste0('S',i,'.csv'))
    df_list[[i]] <- dataset
    }
}
  

salary_data <- rbindlist(df_list, use.names = TRUE, fill = TRUE)
  
# salary_data$Date <- mdy(salary_data$Date) 

## DateTime ------------------------------------------------------------------


salary_data$Date<- anydate(salary_data$Date)


salary_data$Time.depart[salary_data$Time.depart %in% c( "2H00" )] <- "02:00"
salary_data$Time.depart[salary_data$Time.depart %in% c( "2H30", "2h30" )] <- "02:30"
salary_data$Time.depart[salary_data$Time.depart %in% c( "03H00", "3H", "3H00", "3h" )] <- "03:00"
salary_data$Time.depart[salary_data$Time.depart %in% c( "3H30", "3h30"    )] <- "03:30"
salary_data$Time.depart[salary_data$Time.depart %in% c( "04H00", "4H00", "4h", "4H" )] <- "04:00"
salary_data$Time.depart[salary_data$Time.depart %in% c( "4H20" )] <- "04:20"
salary_data$Time.depart[salary_data$Time.depart %in% c( "4H30", "4h30" )] <- "04:30"
salary_data$Time.depart[salary_data$Time.depart %in% c( "05H00", "5h", "5H", "5H ", "5H00" )] <- "05:00"
salary_data$Time.depart[salary_data$Time.depart %in% c( "5h30", "05H30", "5H30", "5h30h" )] <- "05:30"
salary_data$Time.depart[salary_data$Time.depart %in% c( "05H50" )] <- "05:50"

salary_data$Time.depart[salary_data$Time.depart %in% c( "6h", "06H00", "6H00", "6H", "6H ", "6hH", "6H  ", "6h3" )] <- "06:00"
salary_data$Time.depart[salary_data$Time.depart %in% c( "6h15" )] <- "06:15"
salary_data$Time.depart[salary_data$Time.depart %in% c( "6h30", "6H30", "06H30" )] <- "06:30"
salary_data$Time.depart[salary_data$Time.depart %in% c( "6h40" )] <- "06:40"
salary_data$Time.depart[salary_data$Time.depart %in% c( "06H50" )] <- "06:50"
salary_data$Time.depart[salary_data$Time.depart %in% c( "7h", "07H00", "7H00", "7H", "7H ", "7H  ", "7hH ", "7h H", "7g" )] <- "07:00"
salary_data$Time.depart[salary_data$Time.depart %in% c( "7h20"  )] <- "07:20"
salary_data$Time.depart[salary_data$Time.depart %in% c( "7h30", "7.3", "07H30", "7H30", "7N30", "7g30", " 7h30", "7h30 " )] <- "07:30"
salary_data$Time.depart[salary_data$Time.depart %in% c( "7h40" )] <- "07:40"
salary_data$Time.depart[salary_data$Time.depart %in% c( "7h50", "07H50" )] <- "07:50"
salary_data$Time.depart[salary_data$Time.depart %in% c( "8h", "08H00", "08H°00", "8H00", "8H", "8", "8hH", "8H ", "8h " )] <- "08:00"
salary_data$Time.depart[salary_data$Time.depart %in% c( "8h15" )] <- "08:15"
salary_data$Time.depart[salary_data$Time.depart %in% c( "8h30", "8.3", "8H30", "8H30 ", " 8h30", "8H3", "8h30 " )] <- "08:30"
salary_data$Time.depart[salary_data$Time.depart %in% c( "08H50" )] <- "08:50"

salary_data$Time.depart[salary_data$Time.depart %in% c( "9h", "09H00", "9H", "9", "9H00", "9n" )] <- "09:00"
salary_data$Time.depart[salary_data$Time.depart %in% c( "9h30", "9H30" )] <- "09:30"
salary_data$Time.depart[salary_data$Time.depart %in% c( "9h40", "9h42" )] <- "09:40"
salary_data$Time.depart[salary_data$Time.depart %in% c( "9h50" )] <- "09:50"
salary_data$Time.depart[salary_data$Time.depart %in% c( "10h", "10H00", "10", "10H" )] <- "10:00"
salary_data$Time.depart[salary_data$Time.depart %in% c( "10h30", "10H30", "10H31" )] <- "10:30"
salary_data$Time.depart[salary_data$Time.depart %in% c( "11h", "11H" )] <- "11:00"
salary_data$Time.depart[salary_data$Time.depart %in% c( "11h30", "11H30" )] <- "11:30"
salary_data$Time.depart[salary_data$Time.depart %in% c( "12h" )] <- "12:00"
salary_data$Time.depart[salary_data$Time.depart %in% c( "12h30" )] <- "12:30"

salary_data$Time.depart[salary_data$Time.depart %in% c( "1h" )] <- "13:00"
salary_data$Time.depart[salary_data$Time.depart %in% c( "13h30" )] <- "13:30"
salary_data$Time.depart[salary_data$Time.depart %in% c( "15H00" )] <- "15:00"
salary_data$Time.depart[salary_data$Time.depart %in% c( "15H30" )] <- "15:30"
salary_data$Time.depart[salary_data$Time.depart %in% c( "16H00" )] <- "16:00"
salary_data$Time.depart[salary_data$Time.depart %in% c( "18h30" )] <- "18:30"
salary_data$Time.depart[salary_data$Time.depart %in% c( "19h" )] <- "19:00"

salary_data$Time.depart[salary_data$Time.depart %in% c( "ND", "", "gh"  )] <- NA

salary_data$Time.depart <- as_hms(as.POSIXct(salary_data$Time.depart, format = "%H:%M"))


#unique(salary_data$Time.depart)


## ProductName ------------------------------------------------------------------



# TO DO:

# See SalaryProducts.csv for currently unnamed species names (highlighted are already in dataset)
# Then Open word doc of sorted data products and finish sorting (see bookmakrs)
# AFTER naming everything send to Mez/anira
# Then create new names and run the kilo/number datasets



## Kilo ------------------------------------------------------------------
# KILO AND NUMBER OF PRODUCT TO DO: FIX ALL KILOS TO BE A NUMBER THEN USE FUNCTION TO FILL IN NUMBERS OF PRODUCT CORRECTLY


# salary_data$Kilo[salary_data$Kilo %in% c(  "MARO","ND", "", "TSY MISY" )] <- NA
# salary_data$Kilo[salary_data$Kilo %in% c(  "2 tonnes" )] <- 
# salary_data$Kilo[salary_data$Kilo %in% c(  "1 tonne" )] <- 
# salary_data$Kilo[salary_data$Kilo %in% c(  "`1" )] <- 1
# salary_data$Kilo[salary_data$Kilo %in% c(  "1,5" )] <- 1.5
# salary_data$Kilo[salary_data$Kilo %in% c(  "MITAMBATSY" )] <-
# salary_data$Kilo[salary_data$Kilo %in% c(  "6,5" )] <-  6.5
# 
# kiloList <- c("2 tonnes","1 tonne","MITAMBATSY"  )
# 
# tryagain <- salary_data %>%
#   filter(Kilo %in% kiloList)

  
## Number of Product ------------------------------------------------------------------

# NoNum_list <- c("MAROBE",  "1 GONY", "1GONY",  "GONY 1","1 sac", "1 asac", "1 seau","13 sacs",  
#                 "1/2 sac","1/2 Gony",  "1/2 GONY","4 seaux", "4 sacs(gony)","maro","2 sacs","eoho eo", "1/2 SIHO",
#                 "SIO RAIKE","TAPA-GONY","LASETE 1","KOVETE 1","GONY 2","SIO 1", "SIHOA 1" ,"LAKA ROE","BASINE 1",
#                 "BIDON 1","TAPA-BIDON","BASINY 1")
# 
# indiv_cek <- c( "MAROBE", "maro")
# 
# cek_List <- salary_data %>%
#   filter(Number.of.product %in% indiv_cek)
# 
# compare_List <- salary_data%>%
#   filter(Product.type %in% cek_List$Product.type) %>%
#   rowwise() %>%
#   mutate(PRODUCTRATIO = as.numeric(Kilo)/as.numeric(Number.of.product))
# 
# getavg <- compare_List %>%
#   group_by(Product.type) %>%
#   summarize(Mean = mean(PRODUCTRATIO, na.rm = TRUE),
#             sd = sd(PRODUCTRATIO, na.rm = TRUE))

# cek <- salary_data %>%
#   filter(Kilo == "MARO")
# indiv_cek <- c( "MAROBE", "maro")
# standardize_Nums(indiv_cek)
# 
# standardize_Nums <- function(NameList){
#   
#   cek_List <- salary_data %>%
#     filter(Number.of.product %in% NameList)
#   
#   compare_List <- salary_data%>%
#     filter(Product.type %in% cek_List$Product.type) %>%
#     rowwise() %>%
#     mutate(PRODUCTRATIO = as.numeric(Kilo)/as.numeric(Number.of.product))
#   
#   getavg <- compare_List %>%
#     group_by(Product.type) %>%
#     summarize(Mean = mean(PRODUCTRATIO, na.rm = TRUE),
#               sd = sd(PRODUCTRATIO, na.rm = TRUE))
#   
#   for(i in 1:nrow(salary_data)){
#     if(salary_data$Number.of.product[i] %in% NameList){
#       salary_data$Number.of.product[i] <- as.numeric(salary_data$Kilo[i]) * getavg[getavg$Product.type == salary_data$Product.type[i]]
#       
#     }
#   }
#   return(salary_data)
# }
# 
# 
# 
# 
# # Do I want to make transformed data another column?
# salary_data$Number.of.product[salary_data$Number.of.product %in% c(  "ND", '', 'N', " ND"  )] <- NA # REmoved from list above
# salary_data$Number.of.product[salary_data$Number.of.product %in% c(  "`14"   )] <- 14 # removed from list above
# 
# 
# # Marobe: many
# salary_data$Number.of.product[salary_data$Number.of.product %in% c(  "MAROBE"  )] <-
# salary_data$Number.of.product[salary_data$Number.of.product %in% c(  "maro"   )] <- #possibly marobe?
# 
# #Gony: bag of rice
# # tapa: half
# # ARE WE CONSIDERING GONY AND SAC TO BE THE SAME SIZE?
# salary_data$Number.of.product[salary_data$Number.of.product %in% c(  "1 GONY", "1GONY",  "GONY 1"  )] <-
# salary_data$Number.of.product[salary_data$Number.of.product %in% c(  "1/2 Gony",  "1/2 GONY", "TAPA-GONY"   )] <-  
# salary_data$Number.of.product[salary_data$Number.of.product %in% c(  "GONY 2"   )] <-
# salary_data$Number.of.product[salary_data$Number.of.product %in% c(  "4 seaux", "4 sacs(gony)"  )] <-
#       
# salary_data$Number.of.product[salary_data$Number.of.product %in% c(  "1 sac", "1 asac", "1 seau"   )] <-
# salary_data$Number.of.product[salary_data$Number.of.product %in% c(  "13 sacs"  )] <-
# salary_data$Number.of.product[salary_data$Number.of.product %in% c(  "1/2 sac"  )] <-
# salary_data$Number.of.product[salary_data$Number.of.product %in% c(  "2 sacs"  )] <-
# 
# #Siho or sio: bucket
# # Raike: 1
# salary_data$Number.of.product[salary_data$Number.of.product %in% c(   "1/2 SIHO"  )] <- # possibly seaux?
# salary_data$Number.of.product[salary_data$Number.of.product %in% c(   "SIO 1", "SIHOA 1","SIO RAIKE"  )] <- #SAME?
# 
# # eoho eo: Approximately  
# salary_data$Number.of.product[salary_data$Number.of.product %in% c(  "eoho eo"  )] <-
# 
# # no fucking clue  
# salary_data$Number.of.product[salary_data$Number.of.product %in% c(  "LASETE 1"  )] <-
# salary_data$Number.of.product[salary_data$Number.of.product %in% c(  "KOVETE 1"   )] <-
# 
# # Laka: pirogue (small boat)
# # Roe: 2
# salary_data$Number.of.product[salary_data$Number.of.product %in% c(   "LAKA ROE"   )] <-
# 
# # Basine: basin ~ 45L
# salary_data$Number.of.product[salary_data$Number.of.product %in% c(  "BASINE 1", "BASINY 1"   )] <- # same?
#   
# salary_data$Number.of.product[salary_data$Number.of.product %in% c(  "BIDON 1" )] <-
# salary_data$Number.of.product[salary_data$Number.of.product %in% c(  "TAPA-BIDON"  )] <-








































