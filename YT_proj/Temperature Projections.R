library(dplyr)
library(ggplot2)


####################### OM ######################################################
env.dat_me <- read.csv("C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/CI_indices.csv") %>% filter(Year > 1971)

om_trend <- summary(lm(bt_temp ~ Year, data = env.dat_me))
om_trend[["coefficients"]][1]

projection_om <- data.frame(year_proj = c(2022:2052))
error_sd <- om_trend[["coefficients"]][4]*sqrt(nrow(projection_om))
projection_om$SD <-  rnorm(n= nrow(projection_om), mean = 0, sd = error_sd)

projection_om <- projection_om %>% 
  rowwise() %>%
  mutate(Temp_proj = om_trend[["coefficients"]][1] + (om_trend[["coefficients"]][2] * year_proj) + (SD *3))

#projected_values_with_error <- predicted_values + rnorm(n = length(predicted_values), mean = 0, sd = error_sd)

####################### EM ######################################################

env.dat_me <- read.csv("C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/CI_indices.csv") %>% filter(Year > 1971)

ecov_om <- list(
  label = "bt_temp",
  mean = as.matrix(c(env.dat_me$bt_temp,rep(mean(env.dat_me$bt_temp),31))),
  # logsigma = as.matrix(rep(log(0.4733709), 50)),
  logsigma = "est_1",
  year = 1972:2052,
  use_obs = matrix(1, ncol = 1, nrow = 81),
  process_model = "ar1",
  recruitment_how = matrix("controlling-lag-1-linear")
)

ecov_om$mean[51:81,] <- projection_om$Temp_proj

ecov_me <- list(
  label = "bt_temp",
  mean = as.matrix(c(env.dat_me$bt_temp,rep(mean(env.dat_me$bt_temp),31))),
  # logsigma = as.matrix(rep(log(0.4733709), 50)),
  logsigma = "est_1",
  year = 1972:2052,
  use_obs = matrix(1, ncol = 1, nrow = 81),
  process_model = "ar1",
  recruitment_how = matrix("controlling-lag-1-linear")
)

ecov_AR1 <- ecov_me ###NOT DOING THIS ONE YET. NEED TO FIGURE OUT
# ecov_none <- ecov_me
# ecov_none$recruitment_how = matrix("none", input$data$n_Ecov, input$data$n_stocks)

HistAvg <- NA
RecWind <- NA
RecTrend <- data.frame(year = ecov_me$year,
                       Temp = NA)
k <- 51

for(i in 0:31){
  if (i %% 3 == 0){
    HistAvg[(i+1):(i+3)] <- mean(ecov_om$mean[(1:k)])
    RecWind[(i+1):(i+3)] <- mean(ecov_om$mean[((k-4):k)])
    om_RecentTrend <- summary(lm(ecov_om$mean[((k-4):k)] ~ ecov_om$year[((k-4):k)]))
    RecTrend$Temp[(i+1):(i+3)] <- om_RecentTrend[["coefficients"]][1] + (om_RecentTrend[["coefficients"]][2] * ecov_om$year[k])
  }
  k <- k + 1
}

ecov_HistAvg <- ecov_me
ecov_HistAvg$mean[51:81,] <- HistAvg[1:31]

ecov_RecWind <- ecov_me
ecov_RecWind$mean[51:81,] <- RecWind[1:31]

ecov_RecTrend <- ecov_me
ecov_RecTrend$mean[51:81,] <- RecTrend$Temp[1:31]



####################### PLOTTING ###############################################
ggplot(data.frame(ecov_om), aes(x = year, y = mean)) +
  geom_line(aes(color = "OM")) +
  geom_line( aes(x = ecov_AR1$year, y = ecov_AR1$mean, color = 'AR1')) +
  geom_line( aes(x = ecov_HistAvg$year, y = ecov_HistAvg$mean, color = 'HistAvg')) +
  geom_line( aes(x = ecov_RecWind$year, y = ecov_RecWind$mean, color = 'RecWind')) +
  geom_line( aes(x = ecov_RecTrend$year, y = ecov_RecTrend$mean, color = 'RecTrend')) +
  scale_color_manual(name='Model',
                     breaks=c('OM', 'AR1', 'RecWind', 'HistAvg', 'RecTrend'),
                     values=c('OM'='black', 
                              'AR1'='blue',
                              'RecWind' = 'red',
                              'HistAvg' = 'purple',
                              'RecTrend' = 'green')) +
  xlim(2019,2052)
