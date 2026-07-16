args <- commandArgs(trailingOnly = TRUE)

outdir <- args[which(args == "--outdir") + 1]

library(ggridges)
library(wham)
library(whamMSE)
library(dplyr)
library(ggplot2)
library(ggtern)


# Pull and compile simulations across projections

model_nums <- 1:8 # CHANGE HERE Number of Projections
nsim <- c(0:99) # CHANGE HERE number of simulations/seed
ModNames <- c("Mod_AR1Ecov", "Mod_NoEcov", "Mod_HistAvgEcov", "Mod_RecWindEcov", "Mod_RecTrendEcov", "Mod_TermYear", "Mod_BadProj", "Mod_GoodProj") # CHANGE NAME HERE
assess.years <- c(2022, 2027, 2032, 2037, 2042, 2047, 2052, 2057, 2062, 2067)
# assess.years <- c(2022, 2025, 2028, 2031, 2034, 2037, 2040, 2043, 2046, 2049, 2052, 2055, 2058, 2061, 2064, 2067, 2070) #PUT THIS BACK WHEN YOU'RE PUTTING IN CLUSTER# CHANGE ASSESSMENT YEARS HERE
MSE_Length <- 5 # CHANGE HERE FOR 5 YR TESTS

modelLocations <- 'Outputs'


filepath <- '/work/pi_gfay_umassd_edu/Wulfing/CEFI_Draft2/5Yr/Outputs'


# PROJECTIONS
mods <- readRDS(paste0(filepath,'/MSEmods_50yr.rds'))
mods[sapply(mods, is.null)] <- NULL



Cohort_ests <- data.frame(Year = c(),
                        EM_name = c(),
                        seed_no = c(),
                        Temp_OM = c(),
                        SSB_OM = c(), # SSB_real
                        Ecov_beta_R_OM = c(), #logitrho for ecov param
                        OM_NAA_devs = c(),
                        CAA1 = c(),
                        CAA2 = c(),
                        CAA3 = c(),
                        CAA4 = c(),
                        CAA5 = c(),
                        CAA6 = c(),
                        SR_Alpha = c(),
                        SR_Beta = c()
)


pad_na <- function(x, target_len) {
  length(x) <- target_len
  return(x)
}

for(i in 1:length(mods)){ # i = seed, j = model
  if(!is.null(mods[[i]])){
    for(k in 1:length(ModNames)){
      
      years <- min(mods[[i]][[paste0("Mod",k)]][["em_full"]][[1]][["years"]]):(max(mods[[i]][[paste0("Mod",k)]][["em_full"]][[1]][["years"]]) + 3)
      em_name <- rep(ModNames[k], length(years))
      Seed <- rep(i, length(years))
      om_ecovx <- mods[[i]][[paste0("Mod",k)]][["om"]][["rep"]][["Ecov_x"]][1:101,1]
      SSB_om <- mods[[i]][[paste0("Mod",k)]][["om"]][["rep"]][["SSB"]]
      ecov_beta_r_OM <- rep(mods[[i]][[paste0("Mod",k)]][["om"]][["par"]][["Ecov_beta_R"]], length(years))
      om_naa_devs <- mods[[i]][[paste0("Mod",k)]][["om"]][["rep"]][["NAA_devs"]][1,1,,1]
      sr_alpha <- mods[[i]][[paste0("Mod",k)]][["om"]][["rep"]][["log_SR_a"]]
      sr_beta <- mods[[i]][[paste0("Mod",k)]][["om"]][["rep"]][["log_SR_b"]]
      caa1 <- mods[[i]][[paste0("Mod",k)]][["om"]][["rep"]][["pred_CAA"]][,,1]
      caa2 <- mods[[i]][[paste0("Mod",k)]][["om"]][["rep"]][["pred_CAA"]][,,2]
      caa3 <- mods[[i]][[paste0("Mod",k)]][["om"]][["rep"]][["pred_CAA"]][,,3]
      caa4 <- mods[[i]][[paste0("Mod",k)]][["om"]][["rep"]][["pred_CAA"]][,,4]
      caa5 <- mods[[i]][[paste0("Mod",k)]][["om"]][["rep"]][["pred_CAA"]][,,5]
      caa6 <- mods[[i]][[paste0("Mod",k)]][["om"]][["rep"]][["pred_CAA"]][,,6]
 
      # Compute max length across all vectors going into data_List
      max_len <- max(
        length(years), length(em_name), length(Seed),
        length(om_ecovx), length(SSB_om), length(ecov_beta_r_OM),
        length(om_naa_devs), length(sr_alpha), length(sr_beta),
        length(caa1)
      )
      
      data_List <- data.frame(
        Year                  = pad_na(years,                            max_len),
        EM_name               = pad_na(em_name,                          max_len),
        seed_no               = pad_na(Seed,                             max_len),
        Temp_OM               = pad_na(om_ecovx,                         max_len),
        SSB                   = pad_na(SSB_om,                           max_len),
        Ecov_beta_R_OM        = pad_na(ecov_beta_r_OM,                   max_len),
        OM_NAA_devs           = pad_na(om_naa_devs,                      max_len),
        SR_Alpha              = pad_na(sr_alpha,                         max_len),
        SR_Beta               = pad_na(sr_beta,                          max_len),
        CAA1                  = pad_na(caa1,                             max_len),
        CAA2                  = pad_na(caa2,                             max_len),
        CAA3                  = pad_na(caa3,                             max_len),
        CAA4                  = pad_na(caa4,                             max_len),
        CAA5                  = pad_na(caa5,                             max_len),
        CAA6                  = pad_na(caa6,                             max_len)
        
      )
      
      Cohort_ests <- rbind(Cohort_ests, data_List)
    }
  }
}

Cohort_ests <- Cohort_ests[!is.na(Cohort_ests$Year), ]


outfile <- file.path(outdir, "Cohort_data.rds")
saveRDS(Cohort_ests, file = outfile)