library(tidyr)
library(dplyr)
library(ggplot2)

cohortsN <- data.frame(readRDS('C:/Users/swulfing/Downloads/Cohort_dataNAARE.rds'))
cohortsP <- data.frame(readRDS('C:/Users/swulfing/Downloads/Cohort_dataPROJ.rds'))
cohorts5 <- data.frame(readRDS('C:/Users/swulfing/Downloads/Cohort_data5YR.rds'))

for(i in 1:nrow(cohortsN)){
  cohortsN$BH[i] <- (exp(cohortsN$SR_Alpha[i]) * cohortsN$SSB[i])/(exp(cohortsN$SR_Beta[i]) + cohortsN$SSB[i])
  cohortsN$TempEffect[i] <- cohortsN$Ecov_beta_R_OM[i] * cohortsN$Temp_OM[i]
  cohortsN$Epsilon[i] <- cohortsN$OM_NAA_devs[i]
}

cohorts_NAARE <- cohortsN %>%
  mutate(R_t = log(BH) + TempEffect + Epsilon) %>%
  mutate(Ecov_t = log(BH) + TempEffect) %>%
  group_by(EM_name, seed_no) %>%
  summarize(var_Ecovt = var(Ecov_t),
            var_Rt = var(R_t)) %>%
  mutate(contribution = var_Ecovt/var_Rt)



for(i in 1:nrow(cohortsP)){
  cohortsP$BH[i] <- (exp(cohortsP$SR_Alpha[i]) * cohortsP$SSB[i])/(exp(cohortsP$SR_Beta[i]) + cohortsP$SSB[i])
  cohortsP$TempEffect[i] <- cohortsP$Ecov_beta_R_OM[i] * cohortsP$Temp_OM[i]
  cohortsP$Epsilon[i] <- cohortsP$OM_NAA_devs[i]
}

cohorts_PROJ <- cohortsP %>%
  mutate(R_t = log(BH) + TempEffect + Epsilon) %>%
  mutate(Ecov_t = log(BH) + TempEffect) %>%
  group_by(EM_name, seed_no) %>%
  summarize(var_Ecovt = var(Ecov_t),
            var_Rt = var(R_t)) %>%
  mutate(contribution = var_Ecovt/var_Rt)


for(i in 1:nrow(cohorts5)){
  cohorts5$BH[i] <- (exp(cohorts5$SR_Alpha[i]) * cohorts5$SSB[i])/(exp(cohorts5$SR_Beta[i]) + cohorts5$SSB[i])
  cohorts5$TempEffect[i] <- cohorts5$Ecov_beta_R_OM[i] * cohorts5$Temp_OM[i]
  cohorts5$Epsilon[i] <- cohorts5$OM_NAA_devs[i]
}

cohorts_5YR <- cohorts5 %>%
  mutate(R_t = log(BH) + TempEffect + Epsilon) %>%
  mutate(Ecov_t = log(BH) + TempEffect) %>%
  group_by(EM_name, seed_no) %>%
  summarize(var_Ecovt = var(Ecov_t),
            var_Rt = var(R_t)) %>%
  mutate(contribution = var_Ecovt/var_Rt)
  


cohorts_NAARE$Experiment <- 'Reduced NAA Variation'
cohorts_PROJ$Experiment <- 'Three-Year Assessment (default)'
cohorts_5YR$Experiment <- 'Five-Year Assessment'

cohort_combine <- rbind(cohorts_NAARE, cohorts_PROJ, cohorts_5YR)


ggplot(cohort_combine, aes(x = EM_name, y = contribution, fill = Experiment)) +
  geom_boxplot() +
  ylab('Percent Contribution of Ecov \n to Recruitment Variation') +
  scale_x_discrete(labels = c('Ar(1)','Bad Projection','Good Projection','Historical Average','No Ecov','Recent Trend','Recent Window','Terminal Year')) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

