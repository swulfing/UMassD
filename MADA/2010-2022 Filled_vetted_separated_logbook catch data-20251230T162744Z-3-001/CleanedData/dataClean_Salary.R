setwd('C:/Users/swulfing/Documents/GitHub/UMassD/MADA/2010-2022 Filled_vetted_separated_logbook catch data-20251230T162744Z-3-001/CleanedData')

library(dplyr)
library(lubridate)
library(hms)


salary_data <- read.csv('CPUEData_Salary.csv')
# colnames(salary_data)
# summary(salary_data)
# 
# # Fix dates
# unique(salary_data$Time.depart)

salary_data$Date <- mdy(salary_data$Date)


# Time.depart Fix ==========================================
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


unique(salary_data$Time.depart)





# Time.arrive Fix =======================

unique(salary_data$Time.arrive)


salary_data$Time.arrive[salary_data$Time.arrive %in% c( "ND", "" )] <- NA

salary_data$Time.arrive[salary_data$Time.arrive %in% c( "8h", "08H00", "8H00" )] <- '08:00'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "8h30" )] <- '08:30'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "09H00", "9h", "9H", "9H00" )] <- '09:00'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "9h30", "09H30", "9H30" )] <- '09:30'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "09H50" )] <- '09:50'


salary_data$Time.arrive[salary_data$Time.arrive %in% c( "10h", "10H00", "10H", "10H " )] <- '10:00'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "10h31", "10h30", "10H30" )] <- '10:30'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "10h50", "10H50" )] <- '10:50'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "11h", "11H00", "11H", "11H ", "11" )] <- '11:00'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "11h12", "11h10" )] <- '11:10'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "11h13", "11h15" )] <- '11:15'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "11h20" )] <- '11:20'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "11h25" )] <- '11:25'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "11h30", "11H30" )] <- '11:30'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "11h41", "11h40" )] <- '11:40'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "11h46", "11h45" )] <- '11:45'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "11h50", "11h51", "11h48", "11H50" )] <- '11:50'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "11h56", "11h57", "11h55" )] <- '11:55'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "12h", "12H00", "12h ", "12H", "h12h" )] <- '12:00'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "12h10" )] <- '12:10'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "12h15" )] <- '12:15'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "12h20" )] <- '12:20'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "12h25" )] <- '12:25'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "12h30", "12H30", "112h30", "12hh30" )] <- '12:30'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "12h34", "12h35" )] <- '12:35'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "12h40", "12h38", "12H40" )] <- '12:40'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "12h45" )] <- '12:45'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "12h50", " 12H50", "12H50", "  12H" )] <- '12:50'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "12h56" )] <- '12:55'

salary_data$Time.arrive[salary_data$Time.arrive %in% c( "13h", "1H", "1h", "13H00", "13H", "13H ", "1pm" )] <- '13:00'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "1h10", "13h12h")] <- '13:10'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "1h15")] <- '13:15'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "1h20" )] <- '13:20'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "13h30", "13H30", "1h30", "1H30", "13H3O", "1330", "`13h30" )] <- '13:30'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "13h10" )] <- '13:40'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "13H50" )] <- '13:50'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "14h", "2h", "14H00", "14H", "14H " )] <- '14:00'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "14h11" )] <- '14:11'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "14h15", "14h17" )] <- '14:15'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "14h20" )] <- '14:20'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "14h30", "14H30", "2h30" )] <- '14:30'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "14h45" )] <- '14:45'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "14h50", "14H50" )] <- '14:50'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "15h", "15H00", "3h", "15H", "15H " )] <- '15:00'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "15h10" )] <- '15:10'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "15h20" )] <- '15:20'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "15h30", "3h30", "15H30" )] <- '15:30'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "15h40" )] <- '15:40'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "15h50", "15H50" )] <- '15:50'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "15h55" )] <- '15:55'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "16h", "4h", "16H", "16H00" )] <- '16:00'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "16h30", "16H30" )] <- '16:30'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "16h55")] <- '16:55'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "17h", "17H00", "5H00" )] <- '17:00'
salary_data$Time.arrive[salary_data$Time.arrive %in% c(  "5H30" )] <- '17:00'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "6h", "6H00" )] <- '18:00'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "6H30" )] <- '18:30'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "7h", "7H00" )] <- '19:00'
salary_data$Time.arrive[salary_data$Time.arrive %in% c( "7H30" )] <- '17:30'


salary_data$Time.arrive <- as_hms(as.POSIXct(salary_data$Time.arrive, format = "%H:%M"))


# CHECK THAT ALL TIMES MAKE SENSE. FROM THE RAW DATA SHEET I MANUALLY CHANGED TIMES TO MAKE SENSE. MAYBE GO CHECK AFTER
test <- salary_data %>%
  filter(Time.arrive < Time.depart)


# Gender Fix =======================

salary_data$Gender[salary_data$Gender %in% c(  "V", "V ", "V  " )] <- 'V'
salary_data$Gender[salary_data$Gender %in% c( "L", "L ","L  ","L   ","L    ","L     "," L", "L      ","L       ", "l")] <- 'L'
salary_data$Gender[salary_data$Gender %in% c(  "" )] <- NA
salary_data$Gender[salary_data$Gender %in% c(  "L/V" )] <- "BOTH" # ASK ABOUT L/V INPUTS. MAY CHANGE TO NA

# test <- salary_data %>%
#   filter(Gender == "L/V")
# 
# 
# test2 <- salary_data %>%
#   filter(Name %in% test$Name)



# MAKE A CSV SO SOMEONE CAN TRANSLATE FOR YOU =======================

Wordlist <- c(unique(salary_data$Product.type),
              unique(salary_data$Other.catch.type.1..unweigned.),
              unique(salary_data$Other.catch.type.2..unweigned.), 
              unique(salary_data$Other.catch.type.3..unweigned.), 
              unique(salary_data$Other.catch.type.4..unweigned.))

Translate_salary <- data.frame(Word_Malagasy = Wordlist)


write.csv(Translate_salary, "Malagasy_Salary.csv")







