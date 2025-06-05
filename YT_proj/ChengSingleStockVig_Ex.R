library(wham)
library(whamMSE)

main.dir <- "C:/Users/swulfing/Documents/GitHub/UMassD/YT_proj"
setwd(main.dir)

year_start  <- 1  # starting year in the burn-in period
year_end    <- 20  # end year in the burn-in period
MSE_years   <- 3     # number of years in the feedback loop
# Note: no need to include MSE_years in simulation-estimation 


### GENERATE BASIC INFO ###
info <- generate_basic_info(n_stocks = 1,
                            n_regions = 1,
                            n_indices = 1,
                            n_fleets = 1,
                            n_seasons = 1,
                            base.years = year_start:year_end,
                            n_feedback_years = MSE_years,
                            life_history = "medium",
                            n_ages = 12) 

basic_info = info$basic_info # collect basic information
catch_info = info$catch_info # collect fleet catch information
index_info = info$index_info # collect survey information
F_info = info$F # collect fishing information


### CONFIGURE S, M, NAA ###
n_stocks  <- as.integer(basic_info['n_stocks'])
n_regions <- as.integer(basic_info['n_regions'])
n_fleets  <- as.integer(basic_info['n_fleets'])
n_indices <- as.integer(basic_info['n_indices'])
n_ages    <- as.integer(basic_info['n_ages'])

# Selectivity Configuration
fleet_pars <- c(5,1)
index_pars <- c(2,1)
sel <- list(model=rep("logistic",n_fleets+n_indices),
            initial_pars=c(rep(list(fleet_pars),n_fleets),rep(list(index_pars),n_indices)))

# M Configuration
M <- list(model="constant",initial_means=array(0.2, dim = c(n_stocks,n_regions,n_ages)))

# NAA Configuration
sigma        <- "rec+1"
re_cor       <- "iid"
ini.opt      <- "equilibrium" 
sigma_vals   <-  array(0.5, dim = c(n_stocks, n_regions, n_ages)) # NAA sigma

NAA_re <- list(N1_model=rep(ini.opt,n_stocks),
               sigma=rep(sigma,n_stocks),
               cor=rep(re_cor,n_stocks),
               recruit_model = 2,  # rec random around the mean
               sigma_vals = sigma_vals) # NAA_where must be specified in basic_info!

### GENERATE WHAM INPUT###
input <- prepare_wham_input(basic_info = basic_info, 
                            selectivity = sel, 
                            M = M, 
                            NAA_re = NAA_re, 
                            catch_info = catch_info, 
                            index_info = index_info, 
                            F = F_info)

# Generate OM
random = input$random # check what processes are random effects
input$random = NULL # so inner optimization won't change simulated RE
om <- fit_wham(input, do.fit = F, do.brps = T, MakeADFun.silent = TRUE)
# Note: do.fit must be FALSE (no modeling fitting yet)

# Generate DAtaset
om_with_data <- update_om_fn(om, seed = 123, random = random)

# Specify Asses year and interval in feedback loop
assess.interval <- 3 # Note: assessment interval is 3 years, given the feedback period is 3 years, there will be only 1 assessment
base.years      <- year_start:year_end # Burn-in period
first.year      <- head(base.years,1)
terminal.year   <- tail(base.years,1)
assess.years    <- seq(terminal.year, tail(om$years,1)-assess.interval,by = assess.interval)

# USE EM same as OM for MSE
mod = loop_through_fn_TEST(om = om_with_data,
                      em_info = info, 
                      random = random,
                      M_em = M, 
                      sel_em = sel,
                      NAA_re_em = NAA_re, 
                      age_comp_em = "multinomial",
                      em.opt = list(separate.em = FALSE, 
                                    separate.em.type = 3, 
                                    do.move = FALSE, 
                                    est.move = FALSE),
                      assess_years = assess.years, 
                      assess_interval = assess.interval, 
                      base_years = base.years,
                      year.use = 20,
                      add.years = TRUE, 
                      # add.years=TRUE: assessment will use 20 years of data from historical period + new years in the feedback period
                      seed = 123,
                      save.sdrep = TRUE,
                      save.last.em = TRUE,
                      do.retro = TRUE, # Perform retrospective analysis
                      do.osa = TRUE) # Perform OSA residual analysis

# Output analysis
par(mfrow = c(1,2))
SSB_s1 <- lapply(mod, function(mods) mod[["om"]][["rep"]][["SSB"]])
plot(SSB_s1[[1]][14:23], type = "l", col = "blue", ylab = "SSB", xlab = "Year", ylim = c(20000,80000), main = "Stock 1") # only extract SSB from the last 10 years
# colors <- c("red","green","purple","orange")
# for (i in 2:5) {
#   lines(SSB_s1[[i]][14:23], col = colors[i-1],lty = i)
# }
# legend("topleft",legend = paste0("EM ", 1:5), col = c("blue",colors),lty=1:5, cex=0.8)

Catch_s1 <- lapply(mod, function(mods) mod[["om"]][["rep"]][["pred_catch"]])
plot(Catch_s1[[1]][14:23], type = "l", col = "blue", ylab = "Catch", xlab = "Year", ylim = c(1000,15000), main = "Stock 2")
# colors <- c("red","green","purple","orange")
# for (i in 2:5) {
#   lines(Catch_s1[[i]][14:23], col = colors[i-1],lty = i)
# }