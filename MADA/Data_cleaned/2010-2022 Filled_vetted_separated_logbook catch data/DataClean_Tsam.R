setwd('C:/Users/swulfing/Documents/GitHub/UMassD/MADA/Data_cleaned/2010-2022 Filled_vetted_separated_logbook catch data')

library(dplyr)
library(lubridate)
library(hms)
library(data.table)
library(anytime)



# Salary ------------------------------------------------------------------

df_list <- list()

for (i in 1:16){
  if(i < 10){
    dataset <- read.csv(paste0('T0',i,'.csv'))
    df_list[[i]] <- dataset
  }
  else{
    dataset <- read.csv(paste0('T',i,'.csv'))
    df_list[[i]] <- dataset
  }
}


Tsiandamba_data <- rbindlist(df_list, use.names = TRUE, fill = TRUE)

#Tsiandamba_data$Date<- anydate(Tsiandamba_data$Date)


t_products <- toupper(unique(c(Tsiandamba_data$Product.type, Tsiandamba_data$Other.catch.type.1..unweigned.,
                       Tsiandamba_data$Other.catch.type.2..unweigned.,
                       Tsiandamba_data$Other.catch.type.3..unweigned.,
                       Tsiandamba_data$Other.catch.type.4..unweigned.,
                       Tsiandamba_data$Other.catch.type.5..unweigned.,
                       Tsiandamba_data$Other.catch.type.6..unweigned.)))


s_products <- toupper(unique(c(salary_data$Product.type,
                       salary_data$Other.catch.type.1..unweigned.,
                       salary_data$Other.catch.type.2..unweigned.,
                       salary_data$Other.catch.type.3..unweigned.,
                       salary_data$Other.catch.type.4..unweigned.,
                       salary_data$Other.catch.type.5..unweigned.)))


setdiff(t_products, s_products)







