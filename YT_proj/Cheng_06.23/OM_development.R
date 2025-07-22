# Load libraries
library(wham)
# devtools::document("C:/Users/chengxue.li/whamMSE")
# devtools::load_all("C:/Users/chengxue.li/whamMSE")
library(dplyr)
library(whamMSE)

# Set working directory and read data
setwd("C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj")
gb_dat <- read_asap3_dat("ASAPfiles_5.14Pull/GBK.DAT")
input <- prepare_wham_input(gb_dat)

# Define years
year_start <- 1973
year_end   <- 2022
MSE_years  <- 0

# Extract maturity-at-age (MAA)
user_maturity = array(NA, dim = c(1,50,6))
user_maturity[,1:50,] = input$data$mature

# Extract weight-at-age (WAA)
user_waa <- list()
user_waa$waa = array(NA, dim = c(5,50,6))
user_waa$waa[,1:50,] = input$data$waa
user_waa$waa_pointer_fleets = input$data$waa_pointer_fleets
user_waa$waa_pointer_indices = input$data$waa_pointer_indices
user_waa$waa_pointer_totcatch = input$data$waa_pointer_ssb
user_waa$waa_pointer_ssb = input$data$waa_pointer_ssb
user_waa$waa_pointer_M = input$data$waa_pointer_M

# Spawning fraction
fracyr_spawn = gb_dat[[1]]$dat$fracyr_spawn

# Configure catch info
catch_info <- list(
  catch_cv = 0.05,
  catch_Neff = 50,
  use_agg_catch = 1,
  use_catch_paa = 1
)

# Configure index info
index_info <- list(
  index_cv = rep(0.5, 3),
  index_Neff = rep(25, 3),
  fracyr_indices = c(0.25, 0.75, 0.25),
  q = rep(0.2, 3),
  use_indices = rep(1, 3),
  use_index_paa = rep(1, 3),
  units_indices = rep(2, 3),
  units_index_paa = rep(2, 3)
)

# Generate basic OM input
info <- generate_basic_info(
  n_stocks = 1L, n_regions = 1L, n_indices = 3L,
  n_fleets = 1L, n_seasons = 1L,
  base.years = year_start:year_end,
  n_feedback_years = MSE_years, n_ages = 6,
  catch_info = catch_info, index_info = index_info,
  user_waa = user_waa, user_maturity = user_maturity,
  fracyr_spawn = fracyr_spawn
)

# Extract info objects
basic_info <- info$basic_info
catch_info_use <- info$catch_info
index_info_use <- info$index_info
F_info <- info$F

# Fill catch and index data
catch_info_use$agg_catch[1:50,] <- input$data$agg_catch
catch_info_use$catch_paa[,1:50,] <- input$data$catch_paa
index_info_use$agg_indices[1:50,] <- input$data$agg_indices
index_info_use$index_paa[,1:50,] <- input$data$index_paa
index_info_use$use_indices[1:50,] <- input$data$use_indices
index_info_use$use_index_paa[1:50,] <- input$data$use_index_paa

# Selectivity configuration
sel2 <- list(
  model = c("age-specific", "logistic", "logistic", "logistic"),
  re = c("ar1_y", "none", "none", "none"),
  initial_pars = list(
    c(0.1,0.25,0.5,1,1,1),
    c(2,0.3), c(2,0.3), c(2,0.3)),
  fix_pars = list(c(4:6), NULL, NULL, NULL)
)

# Natural mortality setup
n_stocks <- as.integer(basic_info['n_stocks'])
n_regions <- as.integer(basic_info['n_regions'])
n_ages <- as.integer(basic_info['n_ages'])
M <- list(
  model="constant",
  initial_means=array(c(0.57, 0.33, 0.26, 0.23, 0.22, 0.22), dim=c(n_stocks,n_regions,n_ages))
)

# Recruitment and NAA model
sigma_vals <- array(0.5, dim = c(n_stocks, n_regions, n_ages))
NAA_re <- list(
  N1_model = rep("equilibrium", n_stocks),
  sigma = rep("rec+1", n_stocks),
  cor = rep("iid", n_stocks),
  recruit_model = 3,
  sigma_vals = sigma_vals
)

# Environmental covariate
env.dat_me <- read.csv("CI_indices.csv") %>% filter(Year > 1971)
ec_me <- list(
  label = "bt_temp",
  mean = as.matrix(env.dat_me$bt_temp),
  logsigma = as.matrix(rep(log(0.2), length(env.dat_me$bt_temp))),
  year = env.dat_me$Year,
  use_obs = matrix(1, ncol = 1, nrow = nrow(env.dat_me)),
  process_model = "ar1",
  recruitment_how = matrix("controlling-lag-1-linear")
)

# Prepare full WHAM input
input_Ecov <- prepare_wham_input(
  basic_info = basic_info,
  selectivity = sel2,
  M = M,
  NAA_re = NAA_re,
  ecov = ec_me,
  catch_info = catch_info_use,
  index_info = index_info_use,
  F = F_info,
  age_comp = "logistic-normal-pool0"
)

# Copy over updated index-related data from ASAP
input <- prepare_wham_input(gb_dat)
input_Ecov$data$agg_index_sigma[1:50,] <- input$data$agg_index_sigma
input_Ecov$data$use_indices[1:50,] <- input$data$use_indices
input_Ecov$data$use_index_paa[1:50,] <- input$data$use_index_paa

# Identify and remove unusable years for indices
generate_remove_years <- function(mat) {
  lz <- lapply(seq_len(ncol(mat)), function(j) which(mat[, j] == 0))
  max_rows <- max(sapply(lz, length))
  out <- matrix(NA, nrow = max_rows, ncol = length(lz))
  for (j in seq_along(lz)) out[1:length(lz[[j]]), j] <- lz[[j]]
  out
}

remove_agg_years1 <- generate_remove_years(input$data$use_indices)
remove_paa_years1 <- generate_remove_years(input$data$use_index_paa)

# Update index info
input_Ecov <- update_input_index_info(
  input_Ecov,
  agg_index_sigma = input_Ecov$data$agg_index_sigma,
  index_Neff = input_Ecov$data$index_Neff,
  remove_agg = TRUE, remove_agg_pointer = 1:3, remove_agg_years = remove_agg_years1,
  remove_paa = TRUE, remove_paa_pointer = 1:3, remove_paa_years = remove_paa_years1
)

# Fit OM
om <- fit_wham(input_Ecov, do.fit = TRUE, do.brps = TRUE, MakeADFun.silent = FALSE)
check_convergence(om)
plot_wham_output(om, out.type = "html")

# Self-simulation function
sim_fn <- function(om, self.fit = FALSE) {
  input <- om$input
  input$data <- om$simulate(complete = TRUE)
  if (self.fit) {
    fit <- fit_wham(input, do.osa = FALSE, do.retro = TRUE, MakeADFun.silent = TRUE)
    return(fit)
  } else return(input)
}

# Cross-simulation function (no ecov)
sim_fn2 <- function(om, cross.fit = FALSE) {
  input <- om$input
  input$data <- om$simulate(complete = TRUE)
  input <- set_ecov(input, ecov = NULL)
  if (cross.fit) {
    fit <- fit_wham(input, do.osa = FALSE, do.retro = TRUE, MakeADFun.silent = TRUE)
    return(fit)
  } else return(input)
}

# Cross-simulation function (with Ecov but recruitment_how = 'none')
sim_fn3 <- function(om, cross.fit = FALSE) {
  input <- om$input
  input$data <- om$simulate(complete = TRUE)
  ec_me$recruitment_how = matrix("none", input$data$n_Ecov, input$data$n_stocks)
  input <- set_ecov(input, ecov = ec_me)
  if (cross.fit) {
    fit <- fit_wham(input, do.osa = FALSE, do.retro = TRUE, MakeADFun.silent = TRUE)
    return(fit)
  } else return(input)
}

# Run self/cross simulations
set.seed(12345)
self_fit <- sim_fn(om, self.fit = TRUE)
cross_fit <- sim_fn2(om, cross.fit = TRUE)
cross_fit2 <- sim_fn3(om, cross.fit = TRUE)

# Compare models (exclude cross_fit without ecov)
compare_wham_models(mods = list(mod1 = self_fit, mod3 = cross_fit2))

# Fit OM with Ecov sigma estimated
ec_me$logsigma <- "est_1"
ec_me$recruitment_how <- matrix("controlling-lag-1-linear")
input_Ecov <- prepare_wham_input(
  basic_info = basic_info,
  selectivity = sel2,
  M = M,
  NAA_re = NAA_re,
  ecov = ec_me,
  catch_info = catch_info_use,
  index_info = index_info_use,
  F = F_info,
  age_comp = "logistic-normal-pool0"
)
input_Ecov$data$agg_index_sigma[1:50,] <- input$data$agg_index_sigma
input_Ecov$data$use_indices[1:50,] <- input$data$use_indices
input_Ecov$data$use_index_paa[1:50,] <- input$data$use_index_paa

# Update input again for Ecov sigma-estimation run
input_Ecov <- update_input_index_info(
  input_Ecov,
  agg_index_sigma = input_Ecov$data$agg_index_sigma,
  index_Neff = input_Ecov$data$index_Neff,
  remove_agg = TRUE, remove_agg_pointer = 1:3, remove_agg_years = remove_agg_years1,
  remove_paa = TRUE, remove_paa_pointer = 1:3, remove_paa_years = remove_paa_years1
)

om2 <- fit_wham(input_Ecov, do.fit = TRUE, do.brps = TRUE, MakeADFun.silent = FALSE)
check_convergence(om2)
plot_wham_output(om2, out.type = "html")

# Self-test and cross-test with estimated sigma
default_seed <- 123
set.seed(default_seed)
self_fit_ecov_est <- sim_fn(om2, self.fit = TRUE)
set.seed(default_seed)
cross_fit2_ecov_est <- sim_fn3(om2, cross.fit = TRUE)

compare_wham_models(mods = list(mod1 = self_fit_ecov_est, mod3 = cross_fit2_ecov_est))

# Save the above models
saveRDS(om, "om.rds")
saveRDS(input_Ecov, "input_Ecov.rds")
saveRDS(self_fit, "self_fit.rds")
saveRDS(cross_fit2, "cross_fit2.rds")
saveRDS(om2, "om2.rds")
saveRDS(self_fit_ecov_est, "self_fit_ecov_est.rds")
saveRDS(cross_fit2_ecov_est, "cross_fit2_ecov_est.rds")

# om <- readRDS("om.rds")
# input_Ecov <- readRDS("input_Ecov.rds")
# self_fit <- readRDS("self_fit.rds")
# cross_fit2 <- readRDS("cross_fit2.rds")
# om2 <- readRDS("om2.rds")
# self_fit_ecov_est <- readRDS("self_fit_ecov_est.rds")
# cross_fit2_ecov_est <- readRDS("cross_fit2_ecov_est.rds")


# Try to simulate data from om2
random = input_Ecov$random
om_with_data <- update_om_fn(om2, seed = 123, random = random)

# Plot SSB on left y-axis
plot(om_with_data$rep$SSB[1:50], type = "l", col = "blue", lwd = 2,
     ylab = "SSB", xlab = "Year")

# Add a new plot layer
par(new = TRUE)

# Plot Ecov_x on right y-axis
plot(om_with_data$rep$Ecov_x[1:50], type = "l", col = "red", lwd = 2,
     axes = FALSE, xlab = "", ylab = "")
axis(side = 4) # Add right-side y-axis
mtext("Ecov_x", side = 4, line = 3)

# Add legend
legend("topright", legend = c("SSB", "Ecov_x"),
       col = c("blue", "red"), lty = 1, lwd = 2)
