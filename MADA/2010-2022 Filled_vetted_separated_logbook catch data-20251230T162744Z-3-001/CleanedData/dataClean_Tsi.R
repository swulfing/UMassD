setwd('C:/Users/swulfing/Documents/GitHub/UMassD/MADA/2010-2022 Filled_vetted_separated_logbook catch data-20251230T162744Z-3-001/CleanedData')

library(dplyr)
library(lubridate)
library(hms)


Tsi_data <- read.csv('CPUEData_Tsi.csv')
# colnames(salary_data)
# summary(salary_data)
# 
# # Fix dates
# unique(salary_data$Time.depart)

Tsi_data$Date <- mdy(Tsi_data$Date)

Tsi_data$ID <- paste(Tsi_data$X, Tsi_data$Collector, Tsi_data$Date, sep = '_')


# Time.depart Fix ==========================================

Tsi_data$Time.depart[Tsi_data$Time.depart %in% c( "07H300", "007H3" )] <- "07:30"
Tsi_data$Time.depart[Tsi_data$Time.depart %in% c( "09HH" )] <- "09:00"
Tsi_data$Time.depart[Tsi_data$Time.depart %in% c( "06H12H" )] <- "06:12"
Tsi_data$Time.depart[Tsi_data$Time.depart %in% c( "ND", "")] <- NA

Tsi_data$Time.depart <- gsub('HH',':', Tsi_data$Time.depart)
Tsi_data$Time.depart <- gsub('H',':', Tsi_data$Time.depart)
Tsi_data$Time.depart <- gsub('n',':', Tsi_data$Time.depart)
Tsi_data$Time.depart <- gsub('h',':', Tsi_data$Time.depart)

for(i in 1:nrow(Tsi_data)){
  x <- Tsi_data$Time.depart[i]
  if(!is.na(Tsi_data$Time.depart[i]) & substr(x, nchar(x)-1+1, nchar(x)) == ':'){
    Tsi_data$Time.depart[i] <- paste0(Tsi_data$Time.depart[i],"00")
  }
}

#d$a=paste0(d$a,"_at")
#(Tsi_data$Time.depart)

Tsi_data$Time.depart[Tsi_data$Time.depart %in% c( "08:00 ", "08:0" )] <- "08:00"


Tsi_data$Time.depart <- as_hms(as.POSIXct(Tsi_data$Time.depart, format = "%H:%M"))


#unique(Tsi_data$Time.depart)


# Time.arrive Fix ==========================================

unique(Tsi_data$Time.arrive)


Tsi_data$Time.arrive[Tsi_data$Time.arrive %in% c( "ND" )] <- NA
Tsi_data$Time.arrive[Tsi_data$Time.arrive %in% c( "13h12h", "13H11H" )] <- '13:12'
Tsi_data$Time.arrive[Tsi_data$Time.arrive %in% c( "10H30 " )] <- '10:30'
Tsi_data$Time.arrive[Tsi_data$Time.arrive %in% c( "11h0" )] <- '11:00'
Tsi_data$Time.arrive[Tsi_data$Time.arrive %in% c( "16H000"  )] <- '16:00'
Tsi_data$Time.arrive[Tsi_data$Time.arrive %in% c( "222H00" )] <- '22:00'
Tsi_data$Time.arrive[Tsi_data$Time.arrive %in% c( "12H300"  )] <- '12:30'
Tsi_data$Time.arrive[Tsi_data$Time.arrive %in% c( "1200H", " 12H00", "12:000" )] <- '12:00'
Tsi_data$Time.arrive[Tsi_data$Time.arrive %in% c( "2H300" )] <- '02:30'
Tsi_data$Time.arrive[Tsi_data$Time.arrive %in% c( " 11H29" )] <- '11:29'
Tsi_data$Time.arrive[Tsi_data$Time.arrive %in% c( "117H40" )] <- '17:40' # note: I am ASSUMING this is 17:40 and not 11:40. See Tsi_data[2514,] for datapoint
Tsi_data$Time.arrive[Tsi_data$Time.arrive %in% c( "110H30" )] <- '10:30' # note: I am ASSUMING this is 10:30 and not 11:30. See Tsi_data[c(8541, 8542, 8543, 8544),] for datapoints
Tsi_data$Time.arrive[Tsi_data$Time.arrive %in% c( "0" )] <- NA # Couldn't tell what time was supposed to be. See Tsi_data[8723,]
Tsi_data$Time.arrive[Tsi_data$Time.arrive %in% c( "122H30" )] <- '12:30' #Note: I am ASSUMING this is 12:30 and not 22:30. See Tsi_data[c(9341, 9342, 9343, 9344),] for datapoints


# look <- c("13H11H", "117H40", "110H30", "0", "122H30")
# 
# which(Tsi_data$Time.arrive == look[5])

Tsi_data$Time.arrive <- gsub('H',':', Tsi_data$Time.arrive)
Tsi_data$Time.arrive <- gsub('h',':', Tsi_data$Time.arrive)

for(i in 1:nrow(Tsi_data)){
  x <- Tsi_data$Time.arrive[i]
  if(!is.na(Tsi_data$Time.arrive[i]) & substr(x, nchar(x)-1+1, nchar(x)) == ':'){
    Tsi_data$Time.arrive[i] <- paste0(Tsi_data$Time.arrive[i],"00")
  }
}

Tsi_data$Time.arrive <- as_hms(as.POSIXct(Tsi_data$Time.arrive, format = "%H:%M"))

####################################################################################################
##################### WHAT I'M DOING BELOW IS TRYING TO FIX THE 24 HOUR CLOCKS. ####################
################# I'M ASSUMING SOME OVERNIGHT FISHING AND SOME WHERE THE COLLECTOR #################
############ INTERCHANGED A 12 AND 14 HOUR CLOCK. NEED TO ASK IF THIS MAKES SENSE ##################
####################################################################################################

test <- Tsi_data %>%
  filter(Time.arrive < Time.depart) #### NEED TO CHANGE ALL OF THESE TO 24 HR TIME CLOCK

for(i in 1:nrow(test)){
  if(!is.na(test$Time.arrive[i]) & !is.na(test$Time.depart[i]) & test$Time.arrive[i] < test$Time.depart[i]){
    test$Time.arrive[i] <- test$Time.arrive[i] + as.duration(period(12, units = "hours"))
  }
}

test2 <- test %>%
  filter(Time.arrive < Time.depart)

for(i in 1:nrow(Tsi_data)){
  if(!is.na(Tsi_data$Time.arrive[i]) & !is.na(Tsi_data$Time.depart[i]) & Tsi_data$Time.arrive[i] < Tsi_data$Time.depart[i]){
    Tsi_data$Time.arrive[i] <- Tsi_data$Time.arrive[i] + as.duration(period(12, units = "hours"))
  }
}

Tsi_data[match(test2$ID, Tsi_data$ID), ] <- test2

####################################################################################################
############################################## DONE ################################################
####################################################################################################

# Gender Fix ==========================================

unique(Tsi_data$Gender)



Tsi_data$Gender[Tsi_data$Gender %in% c( " V" )] <- 'V'
Tsi_data$Gender[Tsi_data$Gender %in% c( "L(2)/V(1)", "L1/V4", "L1/V2",  "L1/V3", "L/V" )] <- 'BOTH'
Tsi_data$Gender[Tsi_data$Gender %in% c( "" )] <- NA
Tsi_data$Gender[Tsi_data$Gender %in% c( "1" )] <- 'L'



look <- c("L/V", "", "1")
#which(Tsi_data$Gender == look[1])
test <- Tsi_data %>%
  filter(Gender == look[3])

View(test)

# MAKE A CSV SO SOMEONE CAN TRANSLATE FOR YOU =======================

Wordlist <- c(unique(Tsi_data$Product.type),
              unique(Tsi_data$Other.catch.type.1..unweigned.),
              unique(Tsi_data$Other.catch.type.2..unweigned.), 
              unique(Tsi_data$Other.catch.type.3..unweigned.), 
              unique(Tsi_data$Other.catch.type.4..unweigned.))

Translate_Tsi <- data.frame(Word_Malagasy = Wordlist)


write.csv(Translate_Tsi, "Malagasy_Tsi.csv")
