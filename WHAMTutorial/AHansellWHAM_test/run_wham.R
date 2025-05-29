
## GB winter flounder example
## For Sophie
## 5/25

#### load packages & data ####
#require(wham)
library(wham, lib.loc = "C:/Users/swulfing/AppData/Local/Programs/R/R-4.4.3/library/wham_test")
require(tidyverse)
require(here)
require(ggplot2)

rm(list = ls())
x <- read_asap3_dat("C:/Users/swulfing/Documents/GitHub/UMassD/WHAMTutorial/AHansellWHAM_test/runspring22_asap_sample_size.dat")


#### Run 1: Like asap ####
sel=list(model=c("age-specific","age-specific","age-specific","age-specific"), 
         re = c("none","none","none","none"), 
         initial_pars=list(c(0.1,0.25,0.5,1,1,1,1),
                           c(0.1,0.25,0.5,1,1,1,1),
                           c(0.1,0.25,0.5,1,1,1,1),
                           c(0.1,0.25,0.5,1,1,1,1)),
         fix_pars = list(
           c(4:7),
           c(4:7),
           c(4:7),
           c(4:7)))

input <- prepare_wham_input(x, 
                            selectivity=sel,
                            #recruit_model=2,
                            #age_comp = list(fleets = rep("multinomial",1), 
                            #                indices = rep("multinomial", 3)),
                            #selectivity=sel,
                            # NAA_re =NAA_list,
                            #NAA_re = list(sigma="rec", cor ="iid"),
                            # catchability = q,
                            model_name="asap_like")

m1 <- fit_wham(input,do.osa = F, do.retro = F) 
check_convergence(m1)

