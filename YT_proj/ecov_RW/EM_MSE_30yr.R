##########################################
################## MSE ###################
##########################################
library(wham)
library(whamMSE)# devtools::document("C:/Users/chengxue.li/whamMSE")
# devtools::load_all("C:/Users/chengxue.li/whamMSE")
library(dplyr)

# Set working directory and read data
setwd("C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/ecov_RW")
gb_dat <- read_asap3_dat("C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/ASAPfiles_5.14Pull/GBK.DAT")
input <- prepare_wham_input(gb_dat)

# Use the fitted OM from previous setup
om <- readRDS("om2.rds")

n_stocks = 1
n_regions = 1
n_ages = 6

# Define MSE timeframe
year_start <- 1973
year_end   <- 2022
MSE_years  <- 30
user_maturity <- array(NA, dim = c(1,80,6))
user_maturity[,1:50,] <- om$input$data$mature
for (i in 51:80) user_maturity[,i,] <- input$data$mature[, 50,, drop=FALSE]

user_waa <- list()
user_waa$waa <- array(NA, dim = c(5,80,6))
user_waa$waa[,1:50,] <- input$data$waa
for (i in 51:80) user_waa$waa[,i,] <- input$data$waa[, 50,, drop=FALSE]
user_waa$waa_pointer_fleets <- input$data$waa_pointer_fleets
user_waa$waa_pointer_indices <- input$data$waa_pointer_indices
user_waa$waa_pointer_totcatch <- input$data$waa_pointer_ssb
user_waa$waa_pointer_ssb <- input$data$waa_pointer_ssb
user_waa$waa_pointer_M <- input$data$waa_pointer_M

fracyr_spawn <- gb_dat[[1]]$dat$fracyr_spawn

catch_info <- list(
  catch_cv = 0.05,
  catch_Neff = 50,
  use_agg_catch = 1,
  use_catch_paa = 1
)

index_info <- list(
  index_cv = rep(0.5,3),
  index_Neff = rep(25,3),
  fracyr_indices = c(0.25,0.75,0.25),
  q = c(2.103e-4,2.243e-4,2.671e-4),
  use_indices = rep(1,3),
  use_index_paa = rep(1,3),
  units_indices = rep(2,3),
  units_index_paa = rep(2,3)
)

info <- generate_basic_info(n_stocks = 1L, n_regions = 1L, n_indices = 3L, n_fleets = 1L, n_seasons = 1L,
                            base.years = year_start:year_end, n_feedback_years = MSE_years, n_ages = 6,
                            catch_info = catch_info, index_info = index_info, user_waa = user_waa, 
                            user_maturity = user_maturity, fracyr_spawn = fracyr_spawn)

basic_info <- info$basic_info
catch_info_use <- info$catch_info
index_info_use <- info$index_info
F_info <- info$F
F_info$F[1:50,] <- om$rep$Fbar[,1, drop=FALSE]

sel3 <- list(
  model = c("age-specific", "logistic", "logistic", "logistic"),
  re = c("ar1_y", "none", "none", "none"),
  initial_pars = list(
    c(0.017,0.251,0.751,1,1,1),
    c(2.302,0.327),
    c(1.608,0.482),
    c(2.131,0.216)),
  fix_pars = list(c(4:6), NULL, NULL, NULL)
)

M <- list(model = "constant", initial_means = array(c(0.57, 0.33, 0.26, 0.23, 0.22, 0.22), dim = c(n_stocks,n_regions,n_ages)))

sigma_vals <- array(0.5, dim = c(n_stocks, n_regions, n_ages))
sigma_vals[,,1] <- 0.649
sigma_vals[,,2:6] <- 0.718

NAA_re <- list(
  N1_model = rep("age-specific-fe", n_stocks),
  sigma = rep("rec+1", n_stocks),
  cor = rep("iid", n_stocks),
  recruit_model = 3,
  recruit_pars = list(c(exp(8.881), 1.155e-4)),
  sigma_vals = sigma_vals
)

env.dat_me <- read.csv("C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj/CI_indices.csv") %>% filter(Year > 1971)

ecov_me <- list(
  label = "bt_temp",
  mean = as.matrix(c(env.dat_me$bt_temp,rep(mean(env.dat_me$bt_temp),31))),
  # logsigma = as.matrix(rep(log(0.4733709), 50)),
  logsigma = "est_1",
  year = 1972:2052,
  use_obs = matrix(1, ncol = 1, nrow = 81),
  process_model = "rw",
  recruitment_how = matrix("controlling-lag-1-linear")
)

input_Ecov <- prepare_wham_input(
  basic_info = basic_info, selectivity = sel3, M = M, NAA_re = NAA_re, ecov = ecov_me,
  catch_info = catch_info_use, index_info = index_info_use, F = F_info,
  age_comp = "logistic-normal-pool0")

# I forgot to add update waa pointer in the previous version
# IF I don't specify the pointer, then only the first WAA will be used 
# for all fleets, surveys, and stock. 
waa_info <- info$par_inputs$user_waa
input_Ecov <- update_waa(input_Ecov, waa_info = waa_info)

# Initialize true parameter values from OM
input_Ecov$par$Ecov_process_pars <- om$parList$Ecov_process_pars
input_Ecov$par$Ecov_beta_R <- om$parList$Ecov_beta_R

input_Ecov$par$catch_paa_pars <- om$parList$catch_paa_pars
input_Ecov$par$index_paa_pars <- om$parList$index_paa_pars
# input_Ecov$par$sel_repars[1,] <- c(log(1.050), wham:::gen.logit(c(0,0.484), -1, 1))
input_Ecov$par$sel_repars <- om$parList$sel_repars

# Initialize numbers at age
for (i in 1:n_regions) input_Ecov$par$log_N1[i,i,] <- om$parList$log_NAA[i,i,1,]

input <- prepare_wham_input(gb_dat)
input_Ecov$data$agg_index_sigma[1:50,] <- input$data$agg_index_sigma
input_Ecov$data$use_indices[1:50,] <- input$data$use_indices
input_Ecov$data$use_index_paa[1:50,] <- input$data$use_index_paa

# Remove unavailable years
generate_remove_years <- function(mat) {
  lz <- lapply(seq_len(ncol(mat)), function(j) which(mat[, j] == 0))
  max_rows <- max(sapply(lz, length))
  out <- matrix(NA, nrow = max_rows, ncol = length(lz))
  for (j in seq_along(lz)) out[1:length(lz[[j]]), j] <- lz[[j]]
  out
}
remove_agg_years1 <- generate_remove_years(input$data$use_indices)
remove_paa_years1 <- generate_remove_years(input$data$use_index_paa)

for (i in 51:80) input_Ecov$data$agg_index_sigma[i,] = input$data$agg_index_sigma[50,]

input_Ecov <- update_input_index_info(input_Ecov,
                                      agg_index_sigma = input_Ecov$data$agg_index_sigma, 
                                      index_Neff = input_Ecov$data$index_Neff,
                                      remove_agg = TRUE, remove_agg_pointer = 1:3, remove_agg_years = remove_agg_years1,
                                      remove_paa = TRUE, remove_paa_pointer = 1:3, remove_paa_years = remove_paa_years1)

# Prepare OM object
random <- input_Ecov$random
input_Ecov$random <- NULL
om <- fit_wham(input_Ecov, do.fit = FALSE, do.brps = TRUE, MakeADFun.silent = TRUE)

# Define MSE schedule
assess.interval <- 3
base.years <- year_start:year_end
assess.years <- seq(tail(base.years,1), tail(om$years,1)-assess.interval, by = assess.interval)

# Generate data from OM and simulate EM
om_with_data <- update_om_fn(om, seed = 123, random = random)

om_with_data$rep$SSB

hcr <- list(hcr.type = 1, hcr.opts = list(use_FXSPR = TRUE, percentFXSPR = 75))

library(doParallel)
library(foreach)
cluster <- makeCluster(10)
registerDoParallel(cluster)

foreach (i = 1:10) %dopar% {
  tryCatch({
  
  library(wham)
  library(whamMSE)#devtools::load_all("C:/Users/chengxue.li/whamMSE")
  
  om_with_data <- update_om_fn(om, seed = 123+i, random = random)
  
  mod <- loop_through_fn(
    om = om_with_data,
    em_info = info,
    random = random,
    M_em = M,
    sel_em = sel3,
    NAA_re_em = NAA_re,
    ecov_em = ecov_me,
    age_comp_em = "logistic-normal-pool0",
    em.opt = list(separate.em = FALSE, separate.em.type = 1, do.move = FALSE, est.move = FALSE),
    update_index_info = list(
      agg_index_sigma = input_Ecov$data$agg_index_sigma,
      index_Neff = input_Ecov$data$index_Neff,
      remove_agg = TRUE, remove_agg_pointer = 1:3, remove_agg_years = remove_agg_years1,
      remove_paa = TRUE, remove_paa_pointer = 1:3, remove_paa_years = remove_paa_years1
    ),
    update_catch_info = list(
      agg_catch_sigma = input_Ecov$data$agg_catch_sigma,
      catch_Neff = input_Ecov$data$catch_Neff
    ),
    assess_years = assess.years,
    assess_interval = assess.interval,
    base_years = base.years,
    year.use = 50,
    add.years = TRUE,
    seed = 123 + i,
    hcr = hcr,
    save.sdrep = FALSE,
    save.last.em = TRUE,
    FXSPR_init = 0.5
  )
  
  saveRDS(mod, file.path(sprintf("Mod.30yr_1_%03d.RDS", i)))
  }, error=function(e){})
}

stopCluster(cluster)


cluster <- makeCluster(10)
registerDoParallel(cluster)

foreach (i = 1:10) %dopar% {
  tryCatch({
  
  library(wham)
  library(whamMSE)#devtools::load_all("C:/Users/chengxue.li/whamMSE")
  
  om_with_data <- update_om_fn(om, seed = 123+i, random = random)
  
  ecov_none <- ecov_me
  ecov_none$recruitment_how <- matrix("none", 1, 1)
  
  mod <- loop_through_fn(
    om = om_with_data,
    em_info = info,
    random = random,
    M_em = M,
    sel_em = sel3,
    NAA_re_em = NAA_re,
    ecov_em = ecov_none,
    age_comp_em = "logistic-normal-pool0",
    em.opt = list(separate.em = FALSE, separate.em.type = 1, do.move = FALSE, est.move = FALSE),
    update_index_info = list(
      agg_index_sigma = input_Ecov$data$agg_index_sigma,
      index_Neff = input_Ecov$data$index_Neff,
      remove_agg = TRUE, remove_agg_pointer = 1:3, remove_agg_years = remove_agg_years1,
      remove_paa = TRUE, remove_paa_pointer = 1:3, remove_paa_years = remove_paa_years1
    ),
    update_catch_info = list(
      agg_catch_sigma = input_Ecov$data$agg_catch_sigma,
      catch_Neff = input_Ecov$data$catch_Neff
    ),
    assess_years = assess.years,
    assess_interval = assess.interval,
    base_years = base.years,
    year.use = 50,
    add.years = TRUE,
    seed = 123+i,
    hcr = hcr,
    save.sdrep = FALSE,
    save.last.em = TRUE,
    FXSPR_init = 0.5
  )
  
  saveRDS(mod, file.path(sprintf("Mod.30yr_2_%03d.RDS", i)))
  }, error=function(e){})
}

stopCluster(cluster)

cluster <- makeCluster(10)
registerDoParallel(cluster)

foreach (i = 1:10) %dopar% {
  tryCatch({
  
  library(wham)
  library(whamMSE)#devtools::load_all("C:/Users/chengxue.li/whamMSE")
  
  om_with_data <- update_om_fn(om, seed = 123+i, random = random)
  
  ecov_none <- ecov_me
  ecov_none$recruitment_how <- matrix("none", 1, 1)
  
  NAA_re_em <- list(
    N1_model = rep("age-specific-fe", n_stocks),
    sigma = rep("rec+1", n_stocks),
    cor = rep("iid", n_stocks),
    recruit_model = 2,
    sigma_vals = sigma_vals
  )
  
  mod <- loop_through_fn(
    om = om_with_data,
    em_info = info,
    random = random,
    M_em = M,
    sel_em = sel3,
    NAA_re_em = NAA_re_em,
    ecov_em = ecov_none,
    age_comp_em = "logistic-normal-pool0",
    em.opt = list(separate.em = FALSE, separate.em.type = 1, do.move = FALSE, est.move = FALSE),
    update_index_info = list(
      agg_index_sigma = input_Ecov$data$agg_index_sigma,
      index_Neff = input_Ecov$data$index_Neff,
      remove_agg = TRUE, remove_agg_pointer = 1:3, remove_agg_years = remove_agg_years1,
      remove_paa = TRUE, remove_paa_pointer = 1:3, remove_paa_years = remove_paa_years1
    ),
    update_catch_info = list(
      agg_catch_sigma = input_Ecov$data$agg_catch_sigma,
      catch_Neff = input_Ecov$data$catch_Neff
    ),
    assess_years = assess.years,
    assess_interval = assess.interval,
    base_years = base.years,
    year.use = 50,
    add.years = TRUE,
    seed = 123+i,
    hcr = hcr,
    save.sdrep = FALSE,
    save.last.em = TRUE,
    FXSPR_init = 0.5
  )
  
  saveRDS(mod, file.path(sprintf("Mod.30yr_3_%03d.RDS", i)))
  }, error=function(e){})
}

stopCluster(cluster)

model_nums <- 1:3
nsim <- c(1:10) # number of simulations/seed

mods <- lapply(nsim, function(r) {
  
  mod_list <- lapply(model_nums, function(m) {
    file_path <- file.path(sprintf("Mod.30yr_%d_%03d.RDS", m, r))
    readRDS(file_path)
  })
  
  names(mod_list) <- paste0("Mod", model_nums)
  
  return(mod_list)
})

saveRDS(mods, file = "MSEmods_30yr.rds")

plot_mse_output(mods,
                main_dir = getwd(),
                output_dir = "Report_30yr",
                output_format = c("png"), # or html or png
                width = 10, height = 7, dpi = 300,
                col.opt = "D",
                new_model_names = c("M_Ecov","M_noEov","M_noEcov_noBH"),
                base.model = "M_Ecov",
                start.years = 51,
                use.n.years.first = 10,
                use.n.years.last = 10)

mod_1 <- loop_through_fn(
  om = om_with_data,
  em_info = info,
  random = random,
  M_em = M,
  sel_em = sel3,
  NAA_re_em = NAA_re,
  ecov_em = ecov_me,
  age_comp_em = "logistic-normal-pool0",
  em.opt = list(separate.em = FALSE, separate.em.type = 1, do.move = FALSE, est.move = FALSE),
  update_index_info = list(
    agg_index_sigma = input_Ecov$data$agg_index_sigma,
    index_Neff = input_Ecov$data$index_Neff,
    remove_agg = TRUE, remove_agg_pointer = 1:3, remove_agg_years = remove_agg_years1,
    remove_paa = TRUE, remove_paa_pointer = 1:3, remove_paa_years = remove_paa_years1
  ),
  update_catch_info = list(
    agg_catch_sigma = input_Ecov$data$agg_catch_sigma,
    catch_Neff = input_Ecov$data$catch_Neff
  ),
  assess_years = assess.years,
  assess_interval = assess.interval,
  base_years = base.years,
  year.use = 50,
  add.years = TRUE,
  seed = 123,
  hcr = hcr,
  save.sdrep = FALSE,
  save.last.em = TRUE,
  FXSPR_init = 0.5
)

ecov_none <- ecov_me
ecov_none$recruitment_how <- matrix("none", 1, 1)

mod_2 <- loop_through_fn(
  om = om_with_data,
  em_info = info,
  random = random,
  M_em = M,
  sel_em = sel3,
  NAA_re_em = NAA_re,
  ecov_em = ecov_none,
  age_comp_em = "logistic-normal-pool0",
  em.opt = list(separate.em = FALSE, separate.em.type = 1, do.move = FALSE, est.move = FALSE),
  update_index_info = list(
    agg_index_sigma = input_Ecov$data$agg_index_sigma,
    index_Neff = input_Ecov$data$index_Neff,
    remove_agg = TRUE, remove_agg_pointer = 1:3, remove_agg_years = remove_agg_years1,
    remove_paa = TRUE, remove_paa_pointer = 1:3, remove_paa_years = remove_paa_years1
  ),
  update_catch_info = list(
    agg_catch_sigma = input_Ecov$data$agg_catch_sigma,
    catch_Neff = input_Ecov$data$catch_Neff
  ),
  assess_years = assess.years,
  assess_interval = assess.interval,
  base_years = base.years,
  year.use = 50,
  add.years = TRUE,
  seed = 123,
  hcr = hcr,
  save.sdrep = FALSE,
  save.last.em = TRUE,
  FXSPR_init = 0.5
)

mod_1$om$rep$SSB - mod_2$om$rep$SSB

# mod_1_df <- data.frame(year = mod_1$om$years, SSB = mod_1$om$rep$SSB)
# mod_2_df <- data.frame(year = mod_2$om$years, SSB = mod_2$om$rep$SSB)
# 
# ggplot(data = mod_1_df) +
#   geom_line(data = mod_1_df, aes(x = year, y = SSB), color = 'blue') +
#   geom_line(data = mod_2_df, aes(x = year, y = SSB), color = 'red') +
#   xlim(2025, 2050)










