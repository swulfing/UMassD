devtools::install_github("timjmiller/wham", dependencies=TRUE)
devtools::install_github("lichengxue/wham-devel", dependencies=TRUE)

devtools::install_github("lichengxue/whamMSE", dependencies=TRUE)

library(wham)
library(whamMSE)

setwd("C:/Users/swulfing/OneDrive - University of Massachusetts Dartmouth/Documents/YT_proj")


# Read in data files
# TO DO: ASK WHAT EACH OF THESE ARE (TWO GOM STOCKS, TWO SNE (but one doesn't work so idk))
# FIGURE OUT HOW TO PULL THESE YOURSELF. OR WAIT TILL DATA COMES OUT (see Jessie email) 
CCGOM <- read_asap3_dat("ASAP Dat files/CCGOM.DAT")
CCGOM_alt3 <- read_asap3_dat("ASAP Dat files/CCGOM_alt3.DAT")
GBK <- read_asap3_dat("ASAP Dat files/GBK.DAT")
# SNE_2023 <- read_asap3_dat("ASAP Dat files/sne_asap_2023_RT.DAT") this one doesnt work. WHY? Accordign to Jessie this is the right one so figure it out
SNEMA<- read_asap3_dat("ASAP Dat files/SNEMA_split.DAT")


# year_start  <- 1  # starting year in the burn-in period
# year_end    <- 20  # end year in the burn-in period
# MSE_years   <- 0     # number of years in the feedback loop
# # Note: no need to include MSE_years in simulation-estimation 
# 
# info <- generate_basic_info(n_stocks = 2,
#                             n_regions = 2,
#                             n_indices = 2,
#                             n_fleets = 2,
#                             n_seasons = 4,
#                             base.years = year_start:year_end,
#                             n_feedback_years = MSE_years,
#                             life_history = "medium",
#                             n_ages = 12,
#                             Fbar_ages = 12,
#                             recruit_model = 2,
#                             F_info = list(F.year1 = 0.2, Fhist = "constant", Fmax = 0.4, Fmin = 0.2, change_time = 0.5, user_F = NULL),
#                             catch_info = list(catch_cv = 0.1, catch_Neff = 100),
#                             index_info = list(index_cv = 0.1, index_Neff = 100, fracyr_indices = 0.625, q = 0.2),
#                             fracyr_spawn = 0.625,
#                             fracyr_seasons = NULL,
#                             # fleet_pointer = NULL,
#                             # index_pointer = NULL,
#                             user_waa = NULL,
#                             user_maturity = NULL,
#                             bias.correct.process = FALSE,
#                             bias.correct.observation = FALSE,
#                             bias.correct.BRPs = FALSE,
#                             mig_type = 0,
#                             XSPR_R_opt = 2,
#                             move_dyn = 0, # natal homing is assumed
#                             onto_move = 0,
#                             onto_move_pars = NULL,
#                             apply_re_trend = 0,
#                             trend_re_rate = NULL,
#                             apply_mu_trend = 0,
#                             trend_mu_rate = NULL, 
#                             age_mu_devs = NULL) 
# 
# basic_info = info$basic_info # collect basic information
# catch_info = info$catch_info # collect fleet catch information
# index_info = info$index_info # collect survey information
# F_info = info$F # collect fishing information

# see more details using ?generate_basic_info


# # STILL FIGURING OUT HOW TO INCORPORATE THE MULTIPLE STOCKS
# 
# stockList <- c(CCGOM, GBK) # Right now just using the stock files I know are usable
# 
# # Specify movement type and rate
# 
# # Using default bidirectional movement
# # TO DO:  FIGURE OUT MOVEMENT RATE BETWEEN STOCKS 
# basic_info <- generate_NAA_where(basic_info = stockList, move.type = 2)
# # Note: the default is "bidirectional" movement (e.g. stock 1 move to region 2 and stock 2 move to region 1)
# 
# move <- generate_move(basic_info = basic_info, move.type = 2, move.rate = c(0.3, 0.1), move.re = "constant") # Note: default is move = 0.3 (constant) for stock1 and 0.1 (constant) for the other stocks
# 
# # input1 <- prepare_wham_input(stockList, recruit_model=2, model_name="Ex 1: SNEMA Yellowtail Flounder",
# #                              selectivity=list(model=rep("age-specific",3), 
# #                                               re=rep("none",3), 
# #                                               initial_pars=list(c(0.5,0.5,0.5,1,1,0.5),c(0.5,0.5,0.5,1,0.5,0.5),c(0.5,1,1,1,0.5,0.5)),  
# #                                               fix_pars=list(4:5,4,2:4)),
# #                              NAA_re = list(sigma="rec", cor="iid"))
