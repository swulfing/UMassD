args <- commandArgs(trailingOnly = TRUE)

outdir <- args[which(args == "--outdir") + 1]

library(ggridges)
library(wham)
library(whamMSE)
library(dplyr)
library(ggplot2)
library(ggtern)


# Pull and compile simulations across projections

# model_nums <- 1:8 # CHANGE HERE Number of Projections
nsim <- c(0:99) # CHANGE HERE number of simulations/seed
ModNames_Proj <- c("Mod_AR1Ecov", "Mod_NoEcov", "Mod_HistAvgEcov", "Mod_RecWindEcov", "Mod_RecTrendEcov", "Mod_TermYear", "Mod_BadProj", "Mod_GoodProj") # CHANGE NAME HERE
ModNames_Bias <- c("Mod_AR1Ecov", "Mod_NoEcov", "Mod_LOWEcov", "Mod_MEDLOWEcov", "Mod_MEDEcov", "Mod_HIGHEcov")
assess.years_default <- c(2022, 2025, 2028, 2031, 2034, 2037, 2040, 2043, 2046, 2049, 2052, 2055, 2058, 2061, 2064, 2067, 2070) #PUT THIS BACK WHEN YOU'RE PUTTING IN CLUSTER# CHANGE ASSESSMENT YEARS HERE
assess.years_5 <-  c(2022, 2027, 2032, 2037, 2042, 2047, 2052, 2057, 2062, 2067)
#MSE_Length <- 3 # CHANGE HERE FOR 5 YR TESTS

modelLocations <- 'Outputs'

# List filepaths

ModelInfo <- list(tests = c('Proj','Proj_RE','Proj_5Yr','Bias_High','Bias_Low','Bias_Med','Bias_MedLow'),
                    
                    paths = c('/work/pi_gfay_umassd_edu/Wulfing/CEFI_Draft2/Projections/',
                              '/work/pi_gfay_umassd_edu/Wulfing/CEFI_Draft2/NAA_RE/ReduceBoth/',
                              '/work/pi_gfay_umassd_edu/Wulfing/CEFI_Draft2/5Yr/',
                              
                              '/work/pi_gfay_umassd_edu/Wulfing/CEFI_Draft2/Bias/OMHigh/',
                              '/work/pi_gfay_umassd_edu/Wulfing/CEFI_Draft2/Bias/OMLow/',
                              '/work/pi_gfay_umassd_edu/Wulfing/CEFI_Draft2/Bias/OMMed/',
                              '/work/pi_gfay_umassd_edu/Wulfing/CEFI_Draft2/Bias/OMMedLow/'),
                    
                    EM_nums = list(1:8, 1:8, 1:8, 
                                      1:6, 1:6, 1:6, 1:6),
                    
                    EM_name = list(ModNames_Proj, ModNames_Proj, ModNames_Proj, 
                                   ModNames_Bias, ModNames_Bias, ModNames_Bias, ModNames_Bias),
                    
                    assess.years = list(assess.years_default, assess.years_default, assess.years_5, 
                                        assess.years_default, assess.years_default, assess.years_default, assess.years_default),
                    
                    MSE_Length = c(3, 3, 5, rep(3,4))
                    
)

data_file <- data.frame(Test_name = c(),
                        EM_name = c(),
                        No_NonConverged = c())


for(i in 1:length(ModelInfo[["tests"]])){
  
  test <- ModelInfo[["tests"]][i]
  outputPaths <- ModelInfo[["paths"]][i]
  model_nums <- ModelInfo[["EM_nums"]][[i]]
  ModNames <- ModelInfo[["EM_name"]][[i]]
  assess.years <- ModelInfo[["assess.years"]][[i]]
  MSE_Length <- ModelInfo[["MSE_Length"]][i]

 
  
  for(m in model_nums){
    error_count <- 0
  #  tryCatch({
      for(r in nsim){
        simLocations <- paste0('Outputs/block', m)
        newr <- r + ((m - 1) * 100)
        file_path <- file.path(sprintf(paste0(outputPaths,simLocations,"/block_%d_sim_%d_output.rds"), m, newr))
        tryCatch({
          readRDS(file_path)
        }, error=function(e){error_count <<- error_count + 1})
        #print(file_path)
        
        datalist <- data.frame(Test_name = test,
                               EM_name = ModNames[m],
                               No_NonConverged = error_count)
      }
 
    data_file <- rbind(data_file, datalist)
#      names(mod_list) <- paste0("Mod", model_nums)
    
      #return(mod_list)
#  }, error=function(e){error_count <<- error_count + 1})
#})
  }
  
  
}


outfile <- file.path(outdir, "Convergence.rds")
saveRDS(data_file, file = outfile)




#saveRDS(mods, file = paste0(modelLocations,"/MSEmods_50yr.rds")) # CHANGE HERE filename

# Throw away whole seed if one of the models did not converge

# for (i in 1:length(mods)){
#   for(j in 1:length(mods[[i]])){
#     if(is.null(mods[[i]][[j]])){
#       mods[[i]] <- NA
#     }
#   }
#
# }

# mods <- readRDS('/work/pi_gfay_umassd_edu/Wulfing/CEFI_Draft2/Projections/Outputs/MSEmods_50yr.rds')

# Create Plot Output
# test <- mods
# mods[sapply(mods, is.null)] <- NULL


colnames(conv
         )


ggplot(conv, aes(x = EM_name, y = No_NonConverged)) +
  geom_boxplot()



