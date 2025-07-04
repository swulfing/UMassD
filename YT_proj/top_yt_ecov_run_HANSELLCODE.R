# TRY DOING VIGS AGAIN
# TRY RESAVING WHAM INTO DIFFERENT FOLDER
# MAYBE GET ASAP GUI, CAN LOOK AT
# TRY USING KELSEY'S COMPUTER, MAYBE A REBOOT?

# pak::pkg_install("timjmiller/wham@lab", lib = "C:/Users/alex.hansell/AppData/Local/Programs/R/R-4.2.2/library/multi_wham/")
# pak::pkg_install("timjmiller/wham", lib = "C:/Users/swulfing/AppData/Local/Programs/R/R-4.4.3/library/wham_test")

library(wham) #, lib.loc = "C:/Users/swulfing/AppData/Local/Programs/R/R-4.4.3/library/wham_test")
require(tidyr)
require(dplyr)
require(readxl)
require(purrr)
require(here)
require(ggplot2) # C:\Users\swulfing\AppData\Local\Programs\R\R-4.4.3\library
# source(here("R/my_wham_functions.R"))
# source(here::here("R/calc_hindcast_mase.R"))
# source(here::here("R/fit_hindcast.R"))
# source(here::here("R/do_selftest.R"))
# source(here::here("R/sim_fn.R"))
# source(here::here("R/make_simtest_plots.R"))

write.dir <- "C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj"
setwd(write.dir)

gb_dat <- read_asap3_dat("ASAPfiles_5.14Pull/GBK.dat")

# # Memperbaiki indices
# for (i in 1:length(gb_dat[[1]][["dat"]][["IAA_mats"]])){
#  gb_dat[[1]][["dat"]][["IAA_mats"]][[i]][gb_dat[[1]][["dat"]][["IAA_mats"]][[i]] == 0] <- 0.1
# }
# 
# # Memperbaiki Catch
# gb_dat[[1]][["dat"]][["CAA_mats"]][[1]][gb_dat[[1]][["dat"]][["CAA_mats"]][[1]] == 0] <- 0.1

env.dat <- read.csv("CI_indices.csv")

env.dat<-env.dat%>%
  filter(Year > 1972)


ecov <- list(
  label = "bt_temp",
  mean = as.matrix(env.dat$bt_temp),
  logsigma = 'est_1', # estimate obs sigma, 1 value shared across years
  year = env.dat$Year,
  use_obs = matrix(1, ncol=1, nrow=dim(env.dat)[1]),
  #lag =1,# use all obs (=1)
  process_model = "ar1") #, # "rw" or "ar1"

ecov$recruitment_how <- matrix("controlling-lag-1-linear") #add recruitment how to ecov


# # Alex OG selectivity
# sel2=list(
#   model=c("age-specific",
#           "logistic","logistic","logistic"), 
#   re = c("ar1_y","none","none","none"),
#   initial_pars=list(
#     c(0.1,0.25,0.5,1,1,1), # Commercial fleet
#     c(2,0.3), # Spring NEFSC
#     c(2,0.3), # Fall NEFSC
#     c(2,0.3)), # DFO survey
#   fix_pars = list(
#     c(6),
#     c(NULL),
#     c(NULL),
#     c(NULL))
# )

#Trying to fix all selectivities
sel2=list(
  model=c("age-specific",
          "logistic","logistic","logistic"), 
  re = c("none","none","none","none"), #re = c("ar1_y","none","none","none"), use ar1 to est sel but later fixing all 
  initial_pars=list(
    c(0.1,0.25,0.5,1,1,1), # Commercial fleet
    c(2,0.3), # Spring NEFSC
    c(2,0.3), # Fall NEFSC
    c(2,0.3)), # DFO survey
  fix_pars = list(
    c(4:6), # Estimate param for each age
    c(NULL), # bc logistic, these only estimate 2 params so just want to fix first one
    c(NULL),
    c(NULL))
)


gb_datM<-gb_dat

gb_datM[[1]]$dat$M[,1]<-0.57 # From working paper on research track. Final model so not super important for us
gb_datM[[1]]$dat$M[,2]<-0.33
gb_datM[[1]]$dat$M[,3]<-0.26
gb_datM[[1]]$dat$M[,4]<-0.23
gb_datM[[1]]$dat$M[,5]<-0.22
gb_datM[[1]]$dat$M[,6]<-0.22


input3 <- prepare_wham_input(gb_dat, 
                             selectivity=sel2,
                             recruit_model=3, # This is bev-holt recruitment fxn. They use two params. 103-111 are tweaking those params
                             age_comp = "logistic-normal-pool0",
                             NAA_re = list(sigma="rec+1", cor ="iid"),
                             #ecov = ecov,
                             model_name="Run28"
                             #basic_info = list(simulate_process_error = rep(FALSE, 5))
                             
)

# input3$map$mean_rec_pars <- factor(c(2,1)) # This is a stock-recruit model. 

# mean(fit_1$rep$log_SR_a[38:50,])
# mean(fit_1$rep$log_SR_b[38:50,])
# 
# input3$par$mean_rec_pars[,1]<-c(mean(fit_1$rep$log_SR_a[38:50,]))
# input3$par$mean_rec_pars[,2]<-c(mean(fit_1$rep$log_SR_b[38:50,]))

# input3$map$mean_rec_pars <- factor(c(NA,NA)) #Why do we do this? Doesn't fix NA error

mT <- fit_wham(input3, MakeADFun.silent = FALSE ,do.osa = F, do.retro = F, do.fit = T)

mean(mT$rep$log_SR_a[38:50,])
mean(mT$rep$log_SR_b[38:50,])

# input3$par$mean_rec_pars[,1]<-c(mean(mT$rep$log_SR_a[38:50,])) # IFX THESE
# input3$par$mean_rec_pars[,2]<-c(mean(mT$rep$log_SR_b[38:50,])) # FIX THESE

mT$rep$log_SR_a
mT$rep$log_SR_b

#setwd(here("Runs/mAGE/"))
plot_wham_output(mT)

saveRDS(mT, file=paste0("mT.rds"))
check_convergence(m3)
mohns_rho(m3)
