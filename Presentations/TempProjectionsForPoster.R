library(dplyr)

env.dat <- read.csv("C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/CI_indices.csv")

env.dat_me <- read.csv("C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/CI_indices.csv") %>% filter(Year > 1971)

om_trend <- summary(lm(bt_temp ~ Year, data = env.dat_me))
om_trend[["coefficients"]][1]

projection_om <- data.frame(year_proj = c(2022:2052))
error_sd <- om_trend[["coefficients"]][4]*sqrt(nrow(projection_om))
projection_om$SD <-  rnorm(n= nrow(projection_om), mean = 0, sd = error_sd)

projection_om <- projection_om %>% 
  rowwise() %>%
  mutate(Temp_proj = om_trend[["coefficients"]][1] + (om_trend[["coefficients"]][2] * year_proj) + (SD *10))


####################################################################################################

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

ecov_AR1 <- readRDS("C:/Users/swulfing/OneDrive - University of Massachusetts Dartmouth/Desktop/eocv_AR1.RDS")

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

HistAvg <- NA
NewWind <- NA
NewTrend <- data.frame(year = ecov_me$year,
                       Temp = NA)
k <- 51


HistAvg[1:31] <- mean(env.dat$bt_temp)
NewWind[1:31] <- mean(ecov_om$mean[(47:51)])
om_RecentTrend <- summary(lm(ecov_om$mean[(37:51)] ~ ecov_om$year[(37:51)]))

for(i in 1:31){
  NewTrend$Temp[i] <- om_RecentTrend[["coefficients"]][1] +
    (om_RecentTrend[["coefficients"]][2] * ecov_om$year[(i + 50)])
}


ecov_HistAvg <- ecov_me
ecov_HistAvg$mean[51:81,] <- HistAvg[1:31]
# ecov_HistAvg$mean[51:81,] <- 0

ecov_NewWind <- ecov_me
ecov_NewWind$mean[51:81,] <- NewWind[1:31]

ecov_NewTrend <- ecov_me
ecov_NewTrend$mean[51:81,] <- NewTrend$Temp[1:31]
# ecov_NewTrend$mean[51:81,] <- 10000000



####################### PLOTTING ###############################################
p <- ggplot(data.frame(ecov_om), aes(x = year, y = mean)) +
  #geom_line(aes(color = "OM")) +
  geom_line( aes(x = ecov_AR1$year, y = ecov_AR1$mean, color = 'AR1')) +
  geom_line( aes(x = ecov_HistAvg$year, y = ecov_HistAvg$mean, color = 'HistAvg')) +
  geom_line( aes(x = ecov_NewWind$year, y = ecov_NewWind$mean, color = 'NewWind')) +
  geom_line( aes(x = ecov_NewTrend$year, y = ecov_NewTrend$mean, color = 'NewTrend')) +
  geom_line(aes(color = "OM")) +
  scale_color_manual(name='Model',
                     breaks=c('OM', 'AR1', 'NewWind', 'HistAvg', 'NewTrend'),
                     values=c('OM'="#000000", 
                              'AR1'="#CD0BBC",
                              'NewWind' = "#F5C710" ,
                              'HistAvg' =  "#3283FE",
                              'NewTrend' = "#00BA38" )) +
  # ylab("Bottom Temperature (°C)") +
  # xlab("Year") +
  # scale_x_continuous(breaks = 2017:2027) +
  # xlim(2017,2027) +
  labs(
    # subtitle = "Yearly Stat",
    # color = "Statistics",
    y = "Bottom Temperature (°C)",
    x = "Year"
  ) +
  scale_x_continuous(breaks = 2017:2027) 

p + xlim(2017,2027)
