#' Perform Management Strategy Evaluation (MSE)
#'
#' A wrapper function to iterate through the feedback period in a management strategy evaluation (MSE),
#' updating the operating model (OM), refitting the assessment model (EM), and generating catch advice.
#'
#' @param om List. The operating model containing pseudo data and simulation configurations.
#' @param em_info List. Information used to generate the assessment model (default = NULL).
#' @param random Character vector. Processes treated as random effects in the operating model (default = "log_NAA").
#' @param M_em Configuration for natural mortality in the assessment model.
#' @param sel_em Configuration for selectivity in the assessment model.
#' @param NAA_re_em Configuration for NAA in the assessment model.
#' @param move_em Configuration for movement in the assessment model.
#' @param catchability_em Configuration for survey catchability in the assessment model.
#' @param ecov_em Configuration for environmental covariates in the assessment model.
#' @param age_comp_em Character. Likelihood distribution for age composition data in the assessment model.
#'   \itemize{
#'     \item \code{"multinomial"} (default)
#'     \item \code{"dir-mult"}
#'     \item \code{"dirichlet-miss0"}
#'     \item \code{"dirichlet-pool0"}
#'     \item \code{"logistic-normal-miss0"}
#'     \item \code{"logistic-normal-ar1-miss0"}
#'     \item \code{"logistic-normal-pool0"}
#'     \item \code{"logistic-normal-01-infl"}
#'     \item \code{"logistic-normal-01-infl-2par"}
#'     \item \code{"mvtweedie"}
#'     \item \code{"dir-mult-linear"}
#'   }
#'
#' @param em.opt List. EM model options.
#'   \describe{
#'     \item{\code{separate.em}}{Logical. Use region-separated EMs (default = FALSE).}
#'     \item{\code{separate.em.type}}{Integer. Type of separation:
#'       \itemize{
#'         \item 1: Panmictic
#'         \item 2: Fleets-as-areas
#'         \item 3: Separate regional EMs
#'       }
#'     }
#'     \item{\code{do.move}, \code{est.move}}{Logical. Include/estimate movement in EM (default = FALSE).}
#'   }
#'
#' @param aggregate_catch_info List (optional). Aggregation settings for catch data.
#'   \describe{
#'     \item{\code{n_fleets}}{Integer. Number of fleets.}
#'     \item{\code{catch_cv}}{Numeric vector. CV for each fleet.}
#'     \item{\code{catch_Neff}}{Numeric vector. Effective sample sizes.}
#'     \item{\code{use_agg_catch}}{Integer vector. 0/1 for using aggregated catch.}
#'     \item{\code{use_catch_paa}}{Integer vector. 0/1 for including catch PAA.}
#'     \item{\code{fleet_pointer}}{Integer vector. Grouping fleets for aggregation (0 = exclude).}
#'     \item{\code{use_catch_weighted_waa}}{Logical. Use fleet-catch-weighted WAA.}
#'   }
#'
#' @param aggregate_index_info List (optional). Aggregation settings for index data.
#'   \describe{
#'     \item{\code{n_indices}}{Integer. Number of indices.}
#'     \item{\code{index_cv}}{Numeric vector. CV for each index.}
#'     \item{\code{index_Neff}}{Numeric vector. Effective sample sizes.}
#'     \item{\code{fracyr_indices}}{Numeric vector. Fraction of the year for each index.}
#'     \item{\code{q}}{Numeric vector. Initial catchability values.}
#'     \item{\code{use_indices}}{Integer vector. 0/1 for using the index.}
#'     \item{\code{use_index_paa}}{Integer vector. 0/1 for including index PAA.}
#'     \item{\code{units_indices}}{Integer vector. 1 = biomass, 2 = numbers.}
#'     \item{\code{units_index_paa}}{Integer vector. 1 = biomass, 2 = numbers.}
#'     \item{\code{index_pointer}}{Integer vector. Grouping indices (0 = exclude).}
#'     \item{\code{use_index_weighted_waa}}{Logical. Use survey-index-weighted WAA.}
#'   }
#'
#' @param aggregate_weights_info List (optional). Used to compute weighted average weight-at-age and maturity-at-age.
#'   \describe{
#'     \item{\code{ssb_waa_weights}}{List.
#'       \describe{
#'         \item{\code{fleet}}{Logical. Use fleet-specific weights.}
#'         \item{\code{index}}{Logical. Use index-specific weights.}
#'         \item{\code{pointer}}{Integer. Points to fleet/index group to use.}
#'       }
#'     }
#'     \item{\code{maturity_weights}}{List.
#'       \describe{
#'         \item{\code{fleet}}{Logical.}
#'         \item{\code{index}}{Logical.}
#'         \item{\code{pointer}}{Integer.}
#'       }
#'     }
#'   }
#'
#' @param reduce_region_info List (optional). Reduce regions and reassign data.
#'   \describe{
#'     \item{\code{remove_regions}}{Integer vector. 0/1 flag to remove regions.}
#'     \item{\code{reassign}}{Numeric. Region reassignment code.}
#'     \item{\code{NAA_where}}{3D array (stock × region × age) indicating stock presence.}
#'     \item{\code{sel_em}, \code{M_em}, \code{NAA_re_em}, \code{move_em}}{EM configs for reduced regions.}
#'     \item{\code{onto_move_list}}{List.
#'       \describe{
#'         \item{\code{onto_move}}{3D array (stock × region × region).}
#'         \item{\code{onto_move_pars}}{4D array (stock × region × region × 4).}
#'         \item{\code{age_mu_devs}}{4D array (stock × region × region × age).}
#'       }
#'     }
#'   }
#'
#' @param catch_alloc List. Catch allocation specifications.
#'   \describe{
#'     \item{\code{weight_type}}{Integer (1–4). Weighting method.}
#'     \item{\code{method}}{Character. Allocation method:
#'       \itemize{
#'         \item \code{"equal"}
#'         \item \code{"fleet_equal"}
#'         \item \code{"fleet_region"}
#'         \item \code{"fleet_gear"}
#'         \item \code{"fleet_combined"}
#'         \item \code{"fleet_catch"}
#'         \item \code{"index_equal"}
#'         \item \code{"index_gear"}
#'         \item \code{"multiple_index_equal"}
#'         \item \code{"multiple_index_gear"}
#'         \item \code{"user_defined_fleets"}
#'         \item \code{"user_defined_regions"}
#'       }
#'     }
#'     \item{\code{user_weights}}{Numeric vector. User-defined weights (must sum to 1).}
#'     \item{\code{weight_years}}{Integer. Number of past years used to average weights.}
#'     \item{\code{survey_pointer}}{Integer vector. Indices used for weighting (when \code{weight_type = 3}).}
#'   }
#'
#' @param add_implementation_error List (optional). Adds variability to catch realization.
#'   \describe{
#'     \item{\code{method}}{Character. Distribution type: \code{"lognormal"}, \code{"normal"}, \code{"uniform"}, or \code{"constant"}.}
#'     \item{\code{mean}}{Numeric. Mean of error distribution (log scale if lognormal).}
#'     \item{\code{cv}}{Numeric. Coefficient of variation (required for lognormal).}
#'     \item{\code{sd}}{Numeric. Standard deviation (required for normal).}
#'     \item{\code{min}}{Numeric. Lower bound for uniform distribution.}
#'     \item{\code{max}}{Numeric. Upper bound for uniform distribution.}
#'     \item{\code{constant_value}}{Numeric. Fixed multiplier (used if \code{method = "constant"}).}
#'   }
#'
#' @param filter_indices Integer vector (optional). 0/1 vector to exclude survey indices by region.
#'
#' @param update_catch_info List (optional). Update catch CV and Neff values in the assessment model.
#'   \describe{
#'     \item{\code{agg_catch_sigma}}{Matrix. Catch CVs (standard deviation of log catch).}
#'     \item{\code{catch_Neff}}{Matrix. Effective sample sizes for catch. Must match dimensions of \code{agg_catch_sigma}.}
#'   }
#'
#' @param update_index_info List (optional). Update index CV and Neff values in the assessment model.
#'   \describe{
#'     \item{\code{agg_index_sigma}}{Matrix. Aggregated survey index CVs.}
#'     \item{\code{index_Neff}}{Matrix. Effective sample sizes for index data.}
#'     \item{\code{remove_agg}}{Logical. Whether to remove aggregated index observations for specific pointers/years.}
#'     \item{\code{remove_agg_pointer}}{Integer vector. Index pointers to remove.}
#'     \item{\code{remove_agg_years}}{Integer vector or matrix. Years to remove.}
#'     \item{\code{remove_paa}}{Logical. Whether to remove index PAA observations.}
#'     \item{\code{remove_paa_pointer}}{Integer vector. Index pointers to remove PAA.}
#'     \item{\code{remove_paa_years}}{Integer vector or matrix. Years to remove index PAA data.}
#'   }
#'
#' @param hcr List. Harvest control rule.
#'   \describe{
#'     \item{\code{hcr.type}}{Integer (1: F\_XSPR, 2: constant catch, 3: hockey stick).}
#'     \item{\code{hcr.opts}}{List of options:
#'       \itemize{
#'         \item \code{use_FXSPR}
#'         \item \code{percentSPR}
#'         \item \code{percentFXSPR}
#'         \item \code{use_FMSY}
#'         \item \code{percentFMSY}
#'         \item \code{avg_yrs}
#'         \item \code{max_percent}
#'         \item \code{min_percent}
#'         \item \code{BThresh_up}
#'         \item \code{BThresh_low}
#'         \item \code{cont.M.re}
#'         \item \code{cont.move.re}
#'       }
#'     }
#'   }
#'
#' @param user_SPR_weights_info List. Update SPR weights for calculating biological reference points.
#'   \describe{
#'     \item{\code{method}}{Character. Specifies how weights are assigned to regions or stocks.}
#'     \item{\code{weight_years}}{Integer. Number of years to average catch or index values.}
#'     \item{\code{index_pointer}}{Integer. Index number used when \code{method = "index_region"}.}
#'   }
#'
#' @param assess_years Integer vector. Assessment years.
#' @param assess_interval Integer. Interval (years) between assessments.
#' @param base_years Integer vector. Burn-in period years.
#' @param year.use Integer. Years used in each EM (default = 20).
#' @param add.years Logical. Use entire time series in EM (default = FALSE).
#' @param by_fleet Logical. Calculate fleet-specific F (default = TRUE).
#' @param FXSPR_init Numeric. Initial F for reference point calculation (optional).
#' @param do.retro Logical. Run retrospective analysis (default = FALSE).
#' @param do.osa Logical. Calculate OSA residuals (default = FALSE).
#' @param do.brps Logical. Calculate reference points in OM (default = FALSE).
#' @param seed Integer. Random seed.
#' @param save.sdrep Logical. Save sdrep objects (default = FALSE).
#' @param save.last.em Logical. Save final EM (default = FALSE).
#'
#' @return List with elements.
#'   \describe{
#'     \item{\code{om}}{Updated OM.}
#'     \item{\code{em_list}}{List of EM results.}
#'     \item{\code{par.est}, \code{par.se}}{Parameter estimates and SEs.}
#'     \item{\code{adrep.est}, \code{adrep.se}}{ADMB report values and SEs.}
#'     \item{\code{opt_list}}{Optimization results.}
#'     \item{\code{converge_list}}{Convergence checks.}
#'     \item{\code{catch_advice}, \code{catch_realized}}{Advised and realized catch.}
#'     \item{\code{em_full}}{Full EM outputs.}
#'     \item{\code{em_input}}{Final EM input.}
#'     \item{\code{runtime}}{Elapsed time.}
#'     \item{\code{seed.save}}{Final random seed.}
#'   }
#'
#' @seealso \code{\link{make_em_input}}, \code{\link{update_om_fn}}, \code{\link{advice_fn}}
#' @export


loop_through_fn <- function(om, 
                            em_info = NULL, 
                            random = NULL, 
                            M_em = NULL, 
                            sel_em = NULL, 
                            NAA_re_em = NULL, 
                            move_em = NULL, 
                            catchability_em = NULL,
                            ecov_em = NULL,
                            age_comp_em = "multinomial", 
                            em.opt = list(separate.em = TRUE, separate.em.type = 1,
                                          do.move = FALSE, est.move = FALSE), 
                            aggregate_catch_info = NULL,
                            aggregate_index_info = NULL,
                            aggregate_weights_info = NULL,
                            reduce_region_info = NULL,
                            filter_indices = NULL,
                            update_catch_info = NULL,
                            update_index_info = NULL,
                            user_SPR_weights_info = NULL,
                            assess_years = NULL, 
                            assess_interval = NULL, 
                            base_years = NULL, 
                            year.use = 20, 
                            add.years = FALSE,
                            by_fleet = TRUE,
                            FXSPR_init = NULL,
                            hcr = list(hcr.type = 1, hcr.opts = NULL),
                            catch_alloc = list(weight_type = 1, method = "equal", user_weights = NULL, weight_years = 1),
                            implementation_error = NULL,
                            do.retro = FALSE, 
                            do.osa = FALSE, 
                            do.brps = FALSE,
                            seed = 123, 
                            save.sdrep = FALSE, 
                            save.last.em = FALSE
) {
  
  start.time <- Sys.time()
  
  # Helper function to check convergence
  check_conv <- function(em) {
    conv <- as.logical(1 - em$opt$convergence)
    pdHess <- as.logical(if (em$na_sdrep == FALSE & !is.na(em$na_sdrep)) 1 else 0)
    if (!conv | !pdHess) warnings("Assessment model is not converged!")
    list(conv = conv, pdHess = pdHess)
  }
  
  if (is.null(em.opt)) stop("em.opt has to be specified!")
  if (!is.null(move_em) & em.opt$separate.em) stop("move_em must be NULL if em.opt$separate.em = TRUE!")
  if (em.opt$separate.em) move_em <- NULL
  
  em_list <- list()
  par.est <- list()
  par.se <- list()
  adrep.est <- list()
  adrep.se <- list()
  opt_list <- list()
  converge_list <- list()
  catch_advice <- list()
  catch_realized <- list()
  em_full <- list()
  em_input_list <- list()
  
  if(is.null(age_comp_em)) age_comp_em = "multinomial"
  if(is.null(em_info)) stop("em_info must be specified!")
  
  if (em.opt$separate.em) {
    
    for (y in assess_years) {
      
      cat(paste0("\nNow conducting stock assessment for year ", y, "\n"))
      i <- which(assess_years == y)
      em.years <- base_years[1]:y
      
      if (add.years && i != 1) year.use = year.use + assess_interval
      
      em_input <- make_em_input(om = om, em_info = em_info, 
                                M_em = M_em, sel_em = sel_em,
                                NAA_re_em = NAA_re_em, move_em = move_em, 
                                catchability_em = catchability_em, ecov_em = ecov_em,
                                em.opt = em.opt, em_years = em.years, year.use = year.use, 
                                age_comp_em = age_comp_em,
                                aggregate_catch_info = aggregate_catch_info,
                                aggregate_index_info = aggregate_index_info,
                                aggregate_weights_info = aggregate_weights_info,
                                filter_indices = filter_indices)
      
      #cat("\nNow agg Catch is..", em_input$data$agg_catch[1,])
      
      if(!is.null(FXSPR_init)) em_input$data$FXSPR_init[] = FXSPR_init
      
      n_stocks <- om$input$data$n_stocks
      
      if (em.opt$separate.em.type == 1) {
        
        cat("\nNow fitting assessment model...\n")
        em <- fit_wham(em_input, do.retro = do.retro, do.osa = do.osa, do.brps = TRUE, MakeADFun.silent = TRUE)
        
        cat("\nNow checking convergence of assessment model...\n")
        conv <- check_conv(em)$conv
        pdHess <- check_conv(em)$pdHess
        if (conv & pdHess) cat("\nAssessment model is converged.\n") else warnings("\nAssessment model is not converged!\n")
        
        cat("\nNow using the EM to project catch...\n")
        
        em.advice <- advice_fn(em, pro.yr = assess_interval, hcr)
        
        if(is.vector(em.advice)) em.advice = matrix(em.advice, byrow = TRUE)
        
        cat("\nProject catch from assessment model is\n")
        print(em.advice)
        
        cat("\nNow allocating catch...\n")
        
        advice <- calculate_catch_advice(om, em.advice, 
                                         aggregate_catch_info, 
                                         aggregate_index_info, 
                                         final_year = y,
                                         catch_alloc)
        
        colnames(advice) <- paste0("Fleet_", 1:om$input$data$n_fleets)
        rownames(advice) <- paste0("Year_", y + 1:assess_interval)
        
        cat("\nNow generating catch advice...\n")
        print(advice)
        
        if(!is.null(implementation_error)) {
          cat("\nNow generating implementation error on catch advice...\n")
          method = implementation_error$method
          catch_mean = implementation_error$mean
          catch_cv = implementation_error$cv
          catch_sd = implementation_error$sd
          catch_min = implementation_error$min
          catch_max = implementation_error$max
          constant_value = implementation_error$constant_value
          real_catch = add_implementation_error(catch_advice = advice,
                                                method = method,
                                                mean = catch_mean,
                                                cv = catch_cv,
                                                sd = catch_sd,
                                                min = catch_min,
                                                max = catch_max,
                                                constant_value = constant_value,
                                                seed = seed)
          cat("\nRealized catch is...\n")
          print(real_catch)
          interval.info <- list(catch = real_catch, years = y + 1:assess_interval)
        } else {
          interval.info <- list(catch = advice, years = y + 1:assess_interval)
          real_catch = advice
        }
        
        cat("\nNow calculating F at age in the OM given the catch advice...\n")
        
        om <- update_om_fn(om, interval.info, seed = seed, random = random, method = "nlminb", by_fleet = by_fleet, do.brps = do.brps)
        
        em_list[[i]] <- em$rep
        par.est[[i]] <- as.list(em$sdrep, "Estimate")
        par.se[[i]] <- as.list(em$sdrep, "Std. Error")
        adrep.est[[i]] <- as.list(em$sdrep, "Estimate", report = TRUE)
        adrep.se[[i]] <- as.list(em$sdrep, "Std. Error", report = TRUE)
        opt_list[[i]] <- em$opt
        converge_list[[i]] <- conv + pdHess
        catch_advice[[i]] <- advice
        catch_realized[[i]] <- real_catch
        
        if (save.sdrep) {
          em_full[[i]] <- em
        } else {
          if (y == assess_years[length(assess_years)]) {
            em_full[[1]] <- em
          }
          if (!save.last.em) em_full[[1]] <- list()
        }
        
        em_input_list[[i]] <- em_input
        
      } else if (em.opt$separate.em.type == 2) {
        
        cat("\nNow fitting assessment model...\n")
        em <- fit_wham(em_input, do.retro = do.retro, do.osa = do.osa, do.brps = TRUE, MakeADFun.silent = TRUE)
        
        cat("\nNow checking convergence of assessment model...\n")
        conv <- check_conv(em)$conv
        pdHess <- check_conv(em)$pdHess
        if (conv & pdHess) cat("\nAssessment model is converged.\n") else warnings("\nAssessment model is not converged!\n")
        
        cat("\nNow using the EM to project catch...\n")
        # advice <- advice_fn(em, pro.yr = assess_interval, hcr.type = hcr.type, hcr.opts = hcr.opts)
        advice <- advice_fn(em, pro.yr = assess_interval, hcr)
        
        if(is.vector(advice)) advice <- as.matrix(t(advice))
        colnames(advice) <- paste0("Fleet_", 1:om$input$data$n_fleets)
        rownames(advice) <- paste0("Year_", y + 1:assess_interval)
        
        cat("\nNow generating catch advice...\n")
        print(advice)
        
        if(!is.null(implementation_error)) {
          cat("\nNow generating implementation error on catch advice...\n")
          method = implementation_error$method
          catch_mean = implementation_error$mean
          catch_cv = implementation_error$cv
          catch_sd = implementation_error$sd
          catch_min = implementation_error$min
          catch_max = implementation_error$max
          constant_value = implementation_error$constant_value
          real_catch = add_implementation_error(catch_advice = advice,
                                                method = method,
                                                mean = catch_mean,
                                                cv = catch_cv,
                                                sd = catch_sd,
                                                min = catch_min,
                                                max = catch_max,
                                                constant_value = constant_value,
                                                seed = seed)
          cat("\nRealized catch is...\n")
          print(real_catch)
          interval.info <- list(catch = real_catch, years = y + 1:assess_interval)
        } else {
          interval.info <- list(catch = advice, years = y + 1:assess_interval)
          real_catch = advice
        }
        
        cat("\nNow calculating F at age in the OM given the catch advice...\n")
        
        om <- update_om_fn(om, interval.info, seed = seed, random = random, method = "nlminb", by_fleet = by_fleet, do.brps = do.brps)
        
        em_list[[i]] <- em$rep
        par.est[[i]] <- as.list(em$sdrep, "Estimate")
        par.se[[i]] <- as.list(em$sdrep, "Std. Error")
        adrep.est[[i]] <- as.list(em$sdrep, "Estimate", report = TRUE)
        adrep.se[[i]] <- as.list(em$sdrep, "Std. Error", report = TRUE)
        opt_list[[i]] <- em$opt
        converge_list[[i]] <- conv + pdHess
        catch_advice[[i]] <- advice
        catch_realized[[i]] <- real_catch
        
        if (save.sdrep) {
          em_full[[i]] <- em
        } else {
          if (y == assess_years[length(assess_years)]) {
            em_full[[1]] <- em
          }
          if (!save.last.em) em_full[[1]] <- list()
        }
        
        em_input_list[[i]] <- em_input
        
      } else if (em.opt$separate.em.type == 3) {
        
        em_list[[i]] <- list()
        par.est[[i]] <- list()
        par.se[[i]] <- list()
        adrep.est[[i]] <- list()
        adrep.se[[i]] <- list()
        opt_list[[i]] <- list()
        converge_list[[i]] <- list()
        em_full[[i]] <- list()
        em_input_list[[i]] <- list()
        
        advice <- NULL
        em <- list()
        conv <- rep(0, n_stocks)
        pdHess <- rep(0, n_stocks)
        
        cat("\nNow generating catch advice...\n")
        for (s in 1:n_stocks) {
          
          cat("\nNow fitting assessment model...\n")
          em[[s]] <- fit_wham(em_input[[s]], do.retro = do.retro, do.osa = do.osa, do.brps = TRUE, MakeADFun.silent = TRUE)
          
          cat("\nNow checking convergence of assessment model...\n")
          conv <- check_conv(em[[s]])$conv
          pdHess <- check_conv(em[[s]])$pdHess
          if (conv & pdHess) cat("\nAssessment model is converged.\n") else warnings("\nAssessment model is not converged!\n")
          
          tmp <- advice_fn(em[[s]], pro.yr = assess_interval, hcr)
          advice <- cbind(advice, tmp)
        }
        
        if(is.vector(advice)) advice <- as.matrix(t(advice))
        colnames(advice) <- paste0("Fleet_", 1:om$input$data$n_fleets)
        rownames(advice) <- paste0("Year_", assess_years[i] + 1:assess_interval)
        
        print(advice)
        
        if(!is.null(implementation_error)) {
          cat("\nNow generating implementation error on catch advice...\n")
          method = implementation_error$method
          catch_mean = implementation_error$mean
          catch_cv = implementation_error$cv
          catch_sd = implementation_error$sd
          catch_min = implementation_error$min
          catch_max = implementation_error$max
          constant_value = implementation_error$constant_value
          real_catch = add_implementation_error(catch_advice = advice,
                                                method = method,
                                                mean = catch_mean,
                                                cv = catch_cv,
                                                sd = catch_sd,
                                                min = catch_min,
                                                max = catch_max,
                                                constant_value = constant_value,
                                                seed = seed)
          cat("\nRealized catch is...\n")
          print(real_catch)
          interval.info <- list(catch = real_catch, years = assess_years[i] + 1:assess_interval)
        } else {
          interval.info <- list(catch = advice, years = assess_years[i] + 1:assess_interval)
          real_catch = advice
        }
        
        # set the catch for the next assess_interval years
        # interval.info <- list(catch = advice, years = assess_years[i] + 1:assess_interval)
        
        cat("\nNow calculating F at age in the OM given the catch advice...\n")
        om <- update_om_fn(om, interval.info, seed = seed, random = random, method = "nlminb", by_fleet = by_fleet, do.brps = do.brps)
        
        for (s in 1:n_stocks) {
          em_list[[i]][[s]] <- em[[s]]$rep
          par.est[[i]][[s]] <- as.list(em[[s]]$sdrep, "Estimate")
          par.se[[i]][[s]] <- as.list(em[[s]]$sdrep, "Std. Error")
          adrep.est[[i]][[s]] <- as.list(em[[s]]$sdrep, "Estimate", report = TRUE)
          adrep.se[[i]][[s]] <- as.list(em[[s]]$sdrep, "Std. Error", report = TRUE)
          opt_list[[i]][[s]] <- em[[s]]$opt
          converge_list[[i]] <- sum(conv, pdHess)
          catch_advice[[i]] <- advice
          catch_realized[[i]] <- real_catch
          
          if (save.sdrep) {
            em_full[[i]][[s]] <- em[[s]]
          } else {
            if (y == assess_years[length(assess_years)]) {
              em_full[[1]][[s]] <- em[[s]]
            }
            if (!save.last.em) em_full[[1]][[s]] <- list()
          }
          em_input_list[[i]][[s]] <- em_input[[s]]
        }
      }
    }
  } else {
    for (y in assess_years) {
      
      cat(paste0("\nNow conducting stock assessment for year ", y, "\n"))
      
      i <- which(assess_years == y)
      em.years <- base_years[1]:y
      
      if (add.years && i != 1) year.use = year.use + assess_interval
      
      em_input <- make_em_input(om = om, em_info = em_info, 
                                M_em = M_em, sel_em = sel_em,
                                NAA_re_em = NAA_re_em, move_em = move_em, 
                                catchability_em = catchability_em, ecov_em = ecov_em,
                                em.opt = em.opt, em_years = em.years, year.use = year.use, 
                                age_comp_em = age_comp_em,
                                aggregate_catch_info = aggregate_catch_info,
                                aggregate_index_info = aggregate_index_info,
                                filter_indices = filter_indices,
                                reduce_region_info = reduce_region_info,
                                update_catch_info = update_catch_info,
                                update_index_info = update_index_info) 
      
      if(!is.null(user_SPR_weights_info)) {
        if(is.null(user_SPR_weights_info$method)) user_SPR_weights_info$method = "equal"
        if(is.null(user_SPR_weights_info$weight_years)) user_SPR_weights_info$weight_years = 1
        if(is.null(user_SPR_weights_info$index_pointer)) user_SPR_weights_info$index_pointer = NULL
        em_input <- update_SPR_weights(em_input, 
                                       method = user_SPR_weights$weights_method,
                                       weight_years = user_SPR_weights_info$weight_years, 
                                       index_pointer = user_SPR_weights_info$index_pointer
        )
      }
      
      if(!is.null(FXSPR_init)) em_input$data$FXSPR_init[] = FXSPR_init
      
      cat("\nNow fitting assessment model...\n")
      
      if (em.opt$do.move) {
        if (em.opt$est.move) {
          em <- fit_wham(em_input, do.retro = do.retro, do.osa = do.osa, do.brps = TRUE, MakeADFun.silent = TRUE)
        } else {
          em_input <- fix_move(em_input)
          em <- fit_wham(em_input, do.retro = do.retro, do.osa = do.osa, do.brps = TRUE, MakeADFun.silent = TRUE)
        }
      } else {
        em <- fit_wham(em_input, do.retro = do.retro, do.osa = do.osa, do.brps = TRUE, MakeADFun.silent = TRUE)
      }
      
      if (assess_interval != 0) {
        cat("\nNow checking convergence of assessment model...\n")
        conv <- check_conv(em)$conv
        pdHess <- check_conv(em)$pdHess
        if (conv & pdHess) cat("\nAssessment model is converged.\n") else warnings("\nAssessment model is not converged!\n")
        
        cat("\nNow generating catch advice...\n")
        advice <- advice_fn(em, pro.yr = assess_interval, hcr)
        if(!is.null(reduce_region_info$remove_regions)) {
          remove_regions = reduce_region_info$remove_regions
          fleets_to_remove <- which(om$input$data$fleet_regions %in% which(remove_regions == 0))  # Get fleet indices
          fleets_to_keep <- which(!om$input$data$fleet_regions %in% which(remove_regions == 0))  # Get fleet indices
          advice.tmp <- matrix(0, nrow = assess_interval, ncol = length(om$input$data$fleet_regions))
          advice.tmp[,fleets_to_keep] = advice
          if (!is.null(reduce_region_info$fleet_catch)){
            advice.tmp[,fleets_to_remove] = reduce_region_info$fleet_catch # this can be a vector then the value will be filled by vertical and then by horizontal, OR can be a matrix (nrow = assess_interval x ncol = n_fleets_to_keep).
          }
          advice <- advice.tmp
        }
        
        if(is.vector(advice)) {
          if(assess_interval == 1) {
            advice <- as.matrix(t(advice))
          } else {
            advice <- matrix(advice, byrow = T)
          }
        }
        
        colnames(advice) <- paste0("Fleet_", 1:om$input$data$n_fleets)
        rownames(advice) <- paste0("Year_", y + 1:assess_interval)
        
        cat("Catch Advice \n",advice,"\n")
        
        if(!is.null(implementation_error)) {
          cat("\nNow generating implementation error on catch advice...\n")
          method = implementation_error$method#' Generate Input Data for the Estimation Model
#'
#' This function generates input data for the estimation model used in 
#' management strategy evaluation. It constructs the necessary parameters 
#' and structures for the assessment model.
#'
#' @param om List. The operating model containing observed data and simulation outputs.
#' @param em_info List. A set of estimation model parameters used to define the model structure.
#' @param M_em List. Natural mortality random effects.
#' @param sel_em List. Selectivity random effects.
#' @param NAA_re_em List. Numbers-at-age random effects.
#' @param move_em List. Movement random effects.
#' @param em.opt List. Options for movement in the estimation model.
#'   \itemize{
#'     \item `$separate.em` Logical. `TRUE` indicates no global SPR, `FALSE` allows global SPR.
#'     \item `$separate.em.type` Integer (1–3). Specifies assessment model type if `separate.em = TRUE`:
#'       \itemize{
#'         \item `1` - Panmictic (spatially aggregated).
#'         \item `2` - Fleets-as-areas.
#'         \item `3` - Separate assessment models for each region (`n_regions` models).
#'       }
#'     \item `$do.move` Logical. Whether movement is included (if `separate.em = FALSE`).
#'     \item `$est.move` Logical. Whether movement rates are estimated (if `separate.em = FALSE`).
#'   }
#' @param em_years Vector. Years used in the assessment model.
#' @param year.use Integer. Number of years used in the assessment model.
#' @param age_comp_em Character. Likelihood distribution for age composition data.
#'   \itemize{
#'     \item `"multinomial"` (default)
#'     \item `"dir-mult"`
#'     \item `"dirichlet-miss0"`
#'     \item `"dirichlet-pool0"`
#'     \item `"logistic-normal-miss0"`
#'     \item `"logistic-normal-ar1-miss0"`
#'     \item `"logistic-normal-pool0"`
#'     \item `"logistic-normal-01-infl"`
#'     \item `"logistic-normal-01-infl-2par"`
#'     \item `"mvtweedie"`
#'     \item `"dir-mult-linear"`
#'   }
#' @param aggregate_catch_info List (optional). User-specified catch aggregation settings for panmictic models using aggregate catch.
#'   \itemize{
#'     \item `$n_fleets` Integer. Number of fleets.
#'     \item `$catch_cv` Numeric vector (`n_fleets`). CVs for annual aggregate catches by fleet.
#'     \item `$catch_Neff` Numeric vector (`n_fleets`). Effective sample sizes for fleet catches.
#'     \item `$use_agg_catch` Integer vector (`n_fleets`). 0/1 values flagging whether to use aggregate catches.
#'     \item `$use_catch_paa` Integer vector (`n_fleets`). 0/1 values flagging whether to use proportions at age observations.
#'     \item `$fleet_pointer` Integer vector (`n_fleets`). Defines fleet grouping (0 = exclude).
#'     \item `$use_catch_weighted_waa` Logical. Whether to use weighted weight-at-age based on fleet catches.
#'   }
#' @param aggregate_index_info List (optional). User-specified index aggregation settings for panmictic models using aggregate indices.
#'   \itemize{
#'     \item `$n_indices` Integer. Number of indices.
#'     \item `$index_cv` Numeric vector (`n_indices`). CVs for annual aggregate index catches.
#'     \item `$index_Neff` Numeric vector (`n_indices`). Effective sample sizes for survey indices.
#'     \item `$fracyr_indices` Numeric vector (`n_indices`). Fraction of the year for each survey index.
#'     \item `$q` Numeric vector (`n_indices`). Initial survey catchabilities.
#'     \item `$use_indices` Integer vector (`n_indices`). 0/1 values flagging whether to use survey indices.
#'     \item `$use_index_paa` Integer vector (`n_indices`). 0/1 values flagging whether to use proportions at age observations.
#'     \item `$units_indices` Integer vector (`n_indices`). 1/2 values flagging whether aggregate observations are biomass (1) or numbers (2).
#'     \item `$units_index_paa` Integer vector (`n_indices`). 1/2 values flagging whether composition observations are biomass (1) or numbers (2).
#'     \item `$index_pointer` Integer vector (`n_indices`). Defines index grouping (0 = exclude).
#'     \item `$use_index_weighted_waa` Logical. Whether to use weighted weight-at-age based on survey catches.
#'      }
#' @param aggregate_weights_info List (optional). Specifies how to compute weighted averages for
#' weight-at-age (`waa`) and maturity-at-age during data aggregation (For panmictic and fleets-as-areas models only).
#' Used for aggregating across fleets or indices to form total/stock/regional summaries.
#' \itemize{
#'   \item `$ssb_waa_weights` List. Settings for weighting weight-at-age used for spawning stock biomass.
#'     \itemize{
#'       \item `$fleet` Logical. Whether to use fleet-specific weights.
#'       \item `$index` Logical. Whether to use index-specific weights.
#'       \item `$pointer` Integer. Index pointing to the selected fleet or index group (e.g., 1 means the first valid fleet group).
#'     }
#'   \item `$maturity_weights` List. Settings for weighting maturity-at-age used for spawning stock biomass.
#'     \itemize{
#'       \item `$fleet` Logical. Whether to use fleet-specific weights.
#'       \item `$index` Logical. Whether to use index-specific weights.
#'       \item `$pointer` Integer. Index pointing to the selected fleet or index group.
#'     }
#' }
#' @param filter_indices Integer (0/1) vector (optional). User-specified which indices are excluded from the assessment model 
#' @param reduce_region_info List (optional). Remove specific regions from the assessment model. If `NULL`, no modifications are applied.
#'   The expected components include:
#'   \itemize{
#'     \item `$remove_regions` Integer vector (`n_regions`). 0/1 values flagging whether to include regions.
#'     \item `$reassign` Numeric. Specify reassignment for surveys from the "removed" regions to "remaining" regions.
#'     \item `$NAA_where_em`Integer array (`n_stocks × n_regions × n_ages`) 0/1 values flagging whether the stock from a certain age can be present in a specific region.
#'     \item `$sel_em` Selectivity configuration for the "reduced" assessment model.
#'     \item `$M_em` Natural mortality configuration for the "reduced" assessment model.
#'     \item `$NAA_re_em` Numbers-at-age configuration for the "reduced" assessment model.
#'     \item `$catchability_em` Cathability configuration for the "reduced" assessment model.
#'     \item `$move_em` Movement configuration for the "reduced" assessment model.
#'     \item `$ecov_em` Environmental covariate configuration for the "reduced" assessment model.
#'     \item `$onto_move_list` List of ontogenetic movement information for the "reduced" assessment model:
#'       \itemize{
#'         \item `$onto_move` (array, dimension: `n_stocks × n_regions × (n_regions-1)`)  
#'           Age-specific movement type.
#'         \item `$onto_move_pars` (array, dimension: `n_stocks × n_regions × (n_regions-1) × 4`)  
#'           Parameters controlling age-specific movement patterns.
#'         \item `$age_mu_devs` (array, dimension: `n_stocks × n_regions × (n_regions-1) × n_ages`)  
#'           User-specified deviations in mean movement rates across ages.
#'       }
#'   }
#' @param update_catch_info List (optional). Update catch CV and Neff in the EM.
#'   The expected components include:
#'   \itemize{
#'     \item `$agg_catch_sigma` Matrix. Either full (n_years x n_fleets) or subset (length(ind_em) x n_fleets).
#'     \item `$catch_Neff` Matrix. Same dimension as `agg_catch_sigma`.
#'   }
#' @param update_index_info List (optional). Update index CV and Neff in the EM.
#'   The expected components include:
#'   \itemize{
#'     \item `$agg_index_sigma` Matrix. Either full (n_years x n_indices) or subset (length(ind_em) x n_indices).
#'     \item `$index_Neff` Matrix. Same dimension as `agg_index_sigma`.
#'   }
#' @return List. A `wham` input object prepared for stock assessment.
#' 
#' @export
#'
#' @seealso \code{\link{loop_through_fn}}
#' 

make_em_input <- function(om, 
                          em_info, 
                          M_em, 
                          sel_em, 
                          NAA_re_em, 
                          move_em, 
                          catchability_em,
                          ecov_em,
                          em.opt, 
                          em_years, 
                          year.use,
                          age_comp_em,
                          aggregate_catch_info = NULL,
                          aggregate_index_info = NULL,
                          aggregate_weights_info = NULL,
                          filter_indices = NULL,
                          reduce_region_info = NULL,
                          update_catch_info = NULL,
                          update_index_info = NULL) {
  
  if (is.null(em.opt)) stop("em.opt must be specified!")
  
  # Determine movement type based on options
  if (em.opt$separate.em) {
    em.opt$do.move <- FALSE
    move.type <- NULL
  } else if (!em.opt$do.move) {
    move.type <- 3 # no movement
  } else if (all(move_em$stock_move)) {
    move.type <- 2 # bidirectional
  } else {
    move.type <- 1 # unidirectional
  }
  
  data <- om$input$data
  
  # Determine which years to use in the estimation model
  if (!is.null(year.use)) {
    if (year.use > length(em_years)) {
      warning("year.use must be <= em_years! Setting year.use to the length of em_years.")
      year.use <- length(em_years)
    }
    ind_em <- (length(em_years) - year.use + 1):length(em_years)
    em_years <- tail(em_years, year.use)
  } else {
    year.use <- length(em_years)
    ind_em <- (length(em_years) - year.use + 1):length(em_years)
  }
  
  if (em.opt$separate.em) {    # Non-spatial or Spatially implicit  

    if (em.opt$separate.em.type == 1) {
      
      n_fleets <- ifelse(is.null(aggregate_catch_info$n_fleets), 1, aggregate_catch_info$n_fleets)
      n_indices <- ifelse(is.null(aggregate_index_info$n_indices), 1, aggregate_index_info$n_indices)
      n_stocks = n_regions = 1
      
      em_info = make_aggregate_data(om, em_info, ind_em, aggregate_catch_info, aggregate_index_info, aggregate_weights_info)
      
      agg_catch = em_info$par_inputs$agg_catch
      catch_paa = em_info$par_inputs$catch_paa
      agg_indices = em_info$par_inputs$agg_indices
      index_paa = em_info$par_inputs$index_paa
      
      # Override any movement or trend information
      em_info$par_inputs$move_dyn <- 0
      em_info$par_inputs$onto_move <- matrix(0)
      em_info$par_inputs$apply_re_trend <- 0
      em_info$par_inputs$apply_mu_trend <- 0
      
      info <- generate_basic_info_em(em_info, em_years, n_stocks = 1, n_regions = 1, n_fleets = n_fleets, n_indices = n_indices)
      
      basic_info <- info$basic_info
      catch_info <- info$catch_info
      index_info <- info$index_info
      F_info     <- info$F
      
      # Fill in the data from the operating model simulation
      catch_info$agg_catch <- agg_catch
      catch_info$catch_paa <- catch_paa
      index_info$agg_indices <- agg_indices
      index_info$index_paa <- index_paa
      
      # Ecov Effect 
      if(!is.null(ecov_em)) {
        ecov_em_new <- ecov_em
        ecov_em_new$year <- ecov_em_new$year[ind_em]
        ecov_em_new$year <- 1:length(ecov_em_new$year)
        ecov_em_new$mean <- ecov_em_new$mean[ind_em,,drop = FALSE]
        ecov_em_new$logsigma <- ecov_em_new$logsigma[ind_em,,drop = FALSE]
        ecov_em_new$use_obs <- ecov_em_new$use_obs[ind_em,,drop = FALSE]
      } else {
        ecov_em_new <- NULL
      }
      
      em_input <- prepare_wham_input(
        basic_info = basic_info,
        selectivity = sel_em,
        M = M_em,
        NAA_re = NAA_re_em,
        move = NULL,
        catchability = catchability_em,
        ecov = ecov_em_new,
        age_comp = age_comp_em,
        catch_info = catch_info,
        index_info = index_info,
        F = F_info
      )
      
      waa_info <- info$par_inputs$user_waa
      em_input <- update_waa(em_input, waa_info = waa_info)
      
    }
    
    if (em.opt$separate.em.type == 2) {
      
      # Fleets-as-areas
      n_fleets <- data$n_fleets
      n_indices <- data$n_indices
      if(!is.null(filter_indices) && length(filter_indices) != n_indices) stop("Length of filter_indices must = n_indices!")
      fleet_regions <- em_info$catch_info$fleet_regions
      index_regions <- em_info$index_info$index_regions

      em_info <- filter_and_generate_em_info(em_info, 
                                             em.opt = em.opt, 
                                             ind_em, 
                                             fleet_regions, 
                                             index_regions, 
                                             filter_indices = filter_indices, 
                                             aggregate_weights_info = aggregate_weights_info)
      
      if (!is.null(filter_indices) & any(filter_indices == 0)) {
        n_indices = sum(filter_indices != 0)
        idx = which(filter_indices != 0)
      } 
      
      info <- generate_basic_info_em(em_info, em_years, n_stocks = 1, n_regions = 1, n_fleets = n_fleets, n_indices = n_indices, filter_indices = filter_indices)
      
      basic_info <- info$basic_info

      info$catch_info$fleet_regions[] = 1
      info$index_info$index_regions[] = 1
      
      # Fill in the data from the operating model simulation
      info$catch_info$agg_catch <- data$agg_catch[ind_em, , drop = FALSE]
      info$catch_info$catch_paa <- data$catch_paa[, ind_em, , drop = FALSE]
      info$catch_info$use_agg_catch <- data$use_agg_catch[ind_em, , drop = FALSE]
      info$catch_info$use_catch_paa <- data$use_catch_paa[ind_em, , drop = FALSE]
      
      # if (!is.null(filter_indices) & any(filter_indices == 0)) {
      #   info$index_info$agg_indices <- data$agg_indices[ind_em, idx, drop = FALSE]
      #   info$index_info$index_paa <- data$index_paa[idx, ind_em, , drop = FALSE]
      # } else {
      #   info$index_info$agg_indices <- data$agg_indices[ind_em, , drop = FALSE]
      #   info$index_info$index_paa <- data$index_paa[, ind_em, , drop = FALSE]
      # }
      
      if (!is.null(filter_indices) & any(filter_indices == 0)) {
        info$index_info$agg_indices <- data$agg_indices[ind_em, idx, drop = FALSE]
        info$index_info$index_paa <- data$index_paa[idx, ind_em, , drop = FALSE]
        info$index_info$use_indices <- data$use_indices[ind_em, idx, drop = FALSE]
        info$index_info$use_index_paa <- data$use_index_paa[ind_em, idx, drop = FALSE]
      } else {
        info$index_info$agg_indices <- data$agg_indices[ind_em, , drop = FALSE]
        info$index_info$index_paa <- data$index_paa[, ind_em, , drop = FALSE]
        info$index_info$use_indices <- data$use_indices[ind_em, , drop = FALSE]
        info$index_info$use_index_paa <- data$use_index_paa[ind_em, ,  drop = FALSE]
      }
      
      # Override any movement or trend information
      basic_info$move_dyn <- 0
      basic_info$onto_move <- NULL
      basic_info$apply_re_trend <- 0
      basic_info$apply_mu_trend <- 0
      
      if(is.null(age_comp_em)) age_comp_em = "multinomial"
      
      # Ecov Effect 
      if(!is.null(ecov_em)) {
        ecov_em_new <- ecov_em
        ecov_em_new$year <- ecov_em_new$year[ind_em]
        ecov_em_new$year <- 1:length(ecov_em_new$year)
        ecov_em_new$mean <- ecov_em_new$mean[ind_em,,drop = FALSE]
        ecov_em_new$logsigma <- ecov_em_new$logsigma[ind_em,,drop = FALSE]
        ecov_em_new$use_obs <- ecov_em_new$use_obs[ind_em,,drop = FALSE]
      } else {
        ecov_em_new <- NULL
      }
      
      em_input <- prepare_wham_input(
        basic_info = basic_info,
        selectivity = sel_em,
        M = M_em,
        NAA_re = NAA_re_em,
        move = NULL,
        catchability = catchability_em,
        ecov = ecov_em_new,
        age_comp = age_comp_em,
        catch_info = info$catch_info,
        index_info = info$index_info,
        F = info$F
      )
      
      waa_info <- info$par_inputs$user_waa
      em_input <- update_waa(em_input, waa_info = waa_info)
      
    }
    
    if (em.opt$separate.em.type == 3) {
      # Multiple regions and stocks scenario

      # fleet_regions <- em_info$catch_info$fleet_regions
      # index_regions <- em_info$index_info$index_regions
      fleet_regions <- data$fleet_regions
      index_regions <- data$index_regions
      
      em_input <- list()
      em_info_new <- filter_and_generate_em_info(em_info, 
                                                 em.opt = em.opt, 
                                                 ind_em, 
                                                 fleet_regions, 
                                                 index_regions, 
                                                 filter_indices)
      
      for (r in 1:data$n_regions) {
        
        # Generate basic info for current stock
        info <- generate_basic_info_em(em_info_new[[r]], em_years, n_stocks = 1, n_regions = 1, 
                                       n_fleets = em_info_new$par_inputs$n_fleets, 
                                       n_indices = em_info_new$par_inputs$n_indices, filter_indices)
        basic_info <- info$basic_info
        
        # Override any movement or trend information
        basic_info$move_dyn <- 0
        basic_info$onto_move <- NULL
        basic_info$apply_re_trend <- 0
        basic_info$apply_mu_trend <- 0
        
        relevant_fleets <- which(fleet_regions == r)
        
        # Fill in the data from operating model simulation
        info$catch_info$agg_catch <- data$agg_catch[ind_em, relevant_fleets, drop = FALSE]
        info$catch_info$catch_paa <- data$catch_paa[relevant_fleets, ind_em, , drop = FALSE]
        info$catch_info$use_agg_catch <- data$use_agg_catch[ind_em, relevant_fleets, drop = FALSE]
        info$catch_info$use_catch_paa <- data$use_catch_paa[ind_em, relevant_fleets, drop = FALSE]
        
        relevant_indices <- which(index_regions == r)
        
        # Apply `filter_indices` (remove excluded indices) only if provided
        if (!is.null(filter_indices)) {
          relevant_indices <- relevant_indices[filter_indices[relevant_indices] != 0]
        }
        
        info$index_info$agg_indices <- data$agg_indices[ind_em, relevant_indices, drop = FALSE]
        info$index_info$index_paa <- data$index_paa[relevant_indices, ind_em, , drop = FALSE]
        info$index_info$use_indices <- data$use_indices[ind_em, relevant_indices, drop = FALSE]
        info$index_info$use_index_paa <- data$use_index_paa[ind_em, relevant_indices, drop = FALSE]
        
        # Ecov Effect 
        if(!is.null(ecov_em)) {
          ecov_em_new <- ecov_em[[s]]
          ecov_em_new$year <- ecov_em_new$year[ind_em]
          ecov_em_new$year <- 1:length(ecov_em_new$year)
          ecov_em_new$mean <- ecov_em_new$mean[ind_em,,drop = FALSE]
          ecov_em_new$logsigma <- ecov_em_new$logsigma[ind_em,,drop = FALSE]
          ecov_em_new$use_obs <- ecov_em_new$use_obs[ind_em,,drop = FALSE]
        } else {
          ecov_em_new <- NULL
        }
        
        em_input[[r]] <- prepare_wham_input(
          basic_info = basic_info,
          selectivity = sel_em,
          M = M_em,
          NAA_re = NAA_re_em,
          move = NULL,
          catchability = catchability_em,
          ecov = ecov_em_new,
          age_comp = age_comp_em,
          catch_info = info$catch_info,
          index_info = info$index_info,
          F = info$F
        )
        
        waa_info <- basic_info[grepl("waa", names(basic_info))]
        em_input[[r]] <- update_waa(em_input[[r]], waa_info = waa_info)
      }
    }
  } 
  
  ##############################################
  ############# Spatially explicit #############
  ##############################################
  
  if (!em.opt$separate.em) { 
    
    n_fleets <- data$n_fleets
    n_indices <- data$n_indices
    fleet_regions <- em_info$catch_info$fleet_regions
    index_regions <- em_info$index_info$index_regions
    
    remove_regions <- reduce_region_info$remove_regions
    
    em_info <- filter_and_generate_em_info(em_info, 
                                           em.opt = em.opt, 
                                           ind_em, 
                                           fleet_regions, 
                                           index_regions, 
                                           filter_indices = filter_indices,
                                           reduce_region_info = reduce_region_info)
    
    if (!is.null(filter_indices) & any(filter_indices == 0)) {
      n_indices = sum(filter_indices != 0)
      idx = which(filter_indices != 0)
    } 
    
    # If remove_regions = NULL
    if (is.null(remove_regions)) {
      
      n_stocks = om$input$data$n_stocks
      n_regions = om$input$data$n_regions
      
      info <- generate_basic_info_em(em_info, 
                                     em_years,
                                     n_stocks = n_stocks, 
                                     n_regions = n_regions, 
                                     n_fleets = n_fleets, 
                                     n_indices = n_indices, 
                                     filter_indices = filter_indices)
      
      basic_info <- info$basic_info
      
      info$catch_info$agg_catch <- data$agg_catch[ind_em, , drop = FALSE]
      info$catch_info$catch_paa <- data$catch_paa[, ind_em, , drop = FALSE]
      info$catch_info$use_agg_catch <- data$use_agg_catch[ind_em, , drop = FALSE]
      info$catch_info$use_catch_paa <- data$use_catch_paa[ind_em, , drop = FALSE]
      
      # if (!is.null(filter_indices) & any(filter_indices == 0)) {
      #   info$index_info$agg_indices <- data$agg_indices[ind_em, idx, drop = FALSE]
      #   info$index_info$index_paa <- data$index_paa[idx, ind_em, , drop = FALSE]
      # } else {
      #   info$index_info$agg_indices <- data$agg_indices[ind_em, , drop = FALSE]
      #   info$index_info$index_paa <- data$index_paa[, ind_em, , drop = FALSE]
      # }
      
      if (!is.null(filter_indices) & any(filter_indices == 0)) {
        info$index_info$agg_indices <- data$agg_indices[ind_em, idx, drop = FALSE]
        info$index_info$index_paa <- data$index_paa[idx, ind_em, , drop = FALSE]
        info$index_info$use_indices <- data$use_indices[ind_em, idx, drop = FALSE]
        info$index_info$use_index_paa <- data$use_index_paa[ind_em, idx, drop = FALSE]
      } else {
        info$index_info$agg_indices <- data$agg_indices[ind_em, , drop = FALSE]
        info$index_info$index_paa <- data$index_paa[, ind_em, , drop = FALSE]
        info$index_info$use_indices <- data$use_indices[ind_em, , drop = FALSE]
        info$index_info$use_index_paa <- data$use_index_paa[ind_em, ,  drop = FALSE]
      }
      
      # Ecov Effect 
      if(!is.null(ecov_em)) {
        ecov_em_new <- ecov_em
        ecov_em_new$year <- ecov_em_new$year[ind_em]
        ecov_em_new$year <- 1:length(ecov_em_new$year)
        ecov_em_new$mean <- ecov_em_new$mean[ind_em,,drop = FALSE]
        ecov_em_new$logsigma <- ecov_em_new$logsigma[ind_em,,drop = FALSE]
        ecov_em_new$use_obs <- ecov_em_new$use_obs[ind_em,,drop = FALSE]
      } else {
        ecov_em_new <- NULL
      }
      
      if (em.opt$do.move) {
        basic_info$NAA_where = om$input$data$NAA_where
        em_input <- prepare_wham_input(
          basic_info = basic_info,
          selectivity = sel_em,
          M = M_em,
          NAA_re = NAA_re_em,
          move = move_em,
          catchability = catchability_em,
          ecov = ecov_em_new,
          age_comp = age_comp_em,
          catch_info = info$catch_info,
          index_info = info$index_info,
          F = info$F
        )
        
        waa_info <- info$par_inputs$user_waa
        em_input <- update_waa(em_input, waa_info = waa_info)
        
        if(!is.null(update_catch_info)) {
          agg_catch_sigma = update_catch_info$agg_catch_sigma
          catch_Neff = update_catch_info$catch_Neff
          remove_agg = update_catch_info$remove_agg
          remove_agg_pointer = update_catch_info$remove_agg_pointer 
          remove_agg_years = update_catch_info$remove_agg_years
          remove_paa = update_catch_info$remove_paa
          remove_paa_pointer = update_catch_info$remove_paa_pointer 
          remove_paa_years = update_catch_info$remove_paa_years
          em_input = update_input_catch_info(input = em_input, 
                                             agg_catch_sigma = agg_catch_sigma, 
                                             catch_Neff = catch_Neff,
                                             remove_agg = remove_agg,
                                             remove_agg_pointer = remove_agg_pointer,
                                             remove_agg_years = remove_agg_years,
                                             remove_paa = remove_paa,
                                             remove_paa_pointer = remove_paa_pointer, 
                                             remove_paa_years = remove_paa_years,
                                             ind_em = ind_em)
        }
        
        if(!is.null(update_index_info)) {
          agg_index_sigma = update_index_info$agg_index_sigma
          index_Neff = update_index_info$index_Neff
          remove_agg = update_index_info$remove_agg
          remove_agg_pointer = update_index_info$remove_agg_pointer 
          remove_agg_years = update_index_info$remove_agg_years
          remove_paa = update_index_info$remove_paa
          remove_paa_pointer = update_index_info$remove_paa_pointer 
          remove_paa_years = update_index_info$remove_paa_years
          em_input = update_input_index_info(input = em_input, 
                                             agg_index_sigma = agg_index_sigma, 
                                             index_Neff = index_Neff, 
                                             remove_agg = remove_agg,
                                             remove_agg_pointer = remove_agg_pointer,
                                             remove_agg_years = remove_agg_years,
                                             remove_paa = remove_paa,
                                             remove_paa_pointer = remove_paa_pointer, 
                                             remove_paa_years = remove_paa_years,
                                             ind_em = ind_em)
        }
        
      } else {
        
        # No movement
        # Override any movement or trend information
        basic_info$move_dyn <- 0
        basic_info$onto_move <- NULL
        basic_info$apply_re_trend <- 0
        basic_info$apply_mu_trend <- 0
        
        basic_info$NAA_where = NULL
        
        # Ecov Effect 
        if(!is.null(ecov_em)) {
          ecov_em_new <- ecov_em
          ecov_em_new$year <- ecov_em_new$year[ind_em]
          ecov_em_new$year <- 1:length(ecov_em_new$year)
          ecov_em_new$mean <- ecov_em_new$mean[ind_em,,drop = FALSE]
          ecov_em_new$logsigma <- ecov_em_new$logsigma[ind_em,,drop = FALSE]
          ecov_em_new$use_obs <- ecov_em_new$use_obs[ind_em,,drop = FALSE]
        } else {
          ecov_em_new <- NULL
        }
        
        # No movement
        em_input <- prepare_wham_input(
          basic_info = basic_info,
          selectivity = sel_em,
          M = M_em,
          NAA_re = NAA_re_em,
          move = NULL,
          catchability = catchability_em,
          ecov = ecov_em_new,
          age_comp = age_comp_em,
          catch_info = info$catch_info,
          index_info = info$index_info,
          F = info$F
        )
        
        waa_info <- info$par_inputs$user_waa
        em_input <- update_waa(em_input, waa_info = waa_info)
        
        if(!is.null(update_catch_info)) {
          agg_catch_sigma = update_catch_info$agg_catch_sigma
          catch_Neff = update_catch_info$catch_Neff
          remove_agg = update_catch_info$remove_agg
          remove_agg_pointer = update_catch_info$remove_agg_pointer 
          remove_agg_years = update_catch_info$remove_agg_years
          remove_paa = update_catch_info$remove_paa
          remove_paa_pointer = update_catch_info$remove_paa_pointer 
          remove_paa_years = update_catch_info$remove_paa_years
          em_input = update_input_catch_info(input = em_input, 
                                             agg_catch_sigma = agg_catch_sigma, 
                                             catch_Neff = catch_Neff,
                                             remove_agg = remove_agg,
                                             remove_agg_pointer = remove_agg_pointer,
                                             remove_agg_years = remove_agg_years,
                                             remove_paa = remove_paa,
                                             remove_paa_pointer = remove_paa_pointer, 
                                             remove_paa_years = remove_paa_years,
                                             ind_em = ind_em)
        }
        
        if(!is.null(update_index_info)) {
          agg_index_sigma = update_index_info$agg_index_sigma
          index_Neff = update_index_info$index_Neff
          remove_agg = update_index_info$remove_agg
          remove_agg_pointer = update_index_info$remove_agg_pointer 
          remove_agg_years = update_index_info$remove_agg_years
          remove_paa = update_index_info$remove_paa
          remove_paa_pointer = update_index_info$remove_paa_pointer 
          remove_paa_years = update_index_info$remove_paa_years
          em_input = update_input_index_info(input = em_input, 
                                             agg_index_sigma = agg_index_sigma, 
                                             index_Neff = index_Neff, 
                                             remove_agg = remove_agg,
                                             remove_agg_pointer = remove_agg_pointer,
                                             remove_agg_years = remove_agg_years,
                                             remove_paa = remove_paa,
                                             remove_paa_pointer = remove_paa_pointer, 
                                             remove_paa_years = remove_paa_years,
                                             ind_em = ind_em)
        }
        
      }
    } 
    
    # If there is "remove_regions" 
    if (!is.null(remove_regions)) {
      n_stocks = if(!is.null(em_info$par_inputs$n_stocks))em_info$par_inputs$n_stocks
      n_regions = if(!is.null(em_info$par_inputs$n_regions))em_info$par_inputs$n_regions
      n_fleets = if(!is.null(em_info$par_inputs$n_fleets))em_info$par_inputs$n_fleets
      n_indices = if(!is.null(em_info$par_inputs$n_indices))em_info$par_inputs$n_indices
      
      info <- generate_basic_info_em(em_info = em_info, 
                                     em_years = em_years,
                                     n_stocks = n_stocks, 
                                     n_regions = n_regions, 
                                     n_fleets = n_fleets, 
                                     n_indices = n_indices, 
                                     filter_indices = filter_indices)
                                            
      basic_info <- info$basic_info
      id_fleets = info$fleets_to_remove
      id_indices = info$indices_to_remove
      if(id_indices == 0 || is.null(id_indices)) id_indices = numeric(0)
      
      if(length(id_fleets) > 0) {
        info$catch_info$agg_catch <- data$agg_catch[ind_em, -id_fleets, drop = FALSE]
        info$catch_info$catch_paa <- data$catch_paa[-id_fleets, ind_em, , drop = FALSE]
        info$catch_info$use_agg_catch <- info$catch_info$use_agg_catch[ind_em, -id_fleets, drop = FALSE]
        info$catch_info$use_catch_paa <- info$catch_info$use_catch_paa[ind_em, -id_fleets, drop = FALSE]
      } else {
        info$catch_info$agg_catch <- data$agg_catch[ind_em, , drop = FALSE]
        info$catch_info$catch_paa <- data$catch_paa[, ind_em, , drop = FALSE]
        info$catch_info$use_agg_catch <- info$catch_info$use_agg_catch[ind_em, , drop = FALSE]
        info$catch_info$use_catch_paa <- info$catch_info$use_catch_paa[ind_em, , drop = FALSE]
      }

      if (!is.null(filter_indices) & any(filter_indices == 0)) {
        info$index_info$agg_indices <- data$agg_indices[ind_em, idx, drop = FALSE]
        info$index_info$index_paa <- data$index_paa[idx, ind_em, , drop = FALSE]
        info$index_info$use_indices <- data$use_indices[ind_em, idx, drop = FALSE]
        info$index_info$use_index_paa <- data$use_index_paa[ind_em, idx, drop = FALSE]
      } else {
        info$index_info$agg_indices <- data$agg_indices[ind_em, , drop = FALSE]
        info$index_info$index_paa <- data$index_paa[, ind_em, , drop = FALSE]
        info$index_info$use_indices <- data$use_indices[ind_em, , drop = FALSE]
        info$index_info$use_index_paa <- data$use_index_paa[ind_em, , drop = FALSE]
      }
      
      if(length(id_indices) > 0) {
        info$index_info$agg_indices <- data$agg_indices[ind_em, -id_indices, drop = FALSE]
        info$index_info$index_paa <- data$index_paa[-id_indices, ind_em, , drop = FALSE]
        info$index_info$use_indices <- data$use_indices[ind_em, -id_indices, drop = FALSE]
        info$index_info$use_index_paa <- data$use_index_paa[ind_em, -id_indices, drop = FALSE]
      } else {
        info$index_info$agg_indices <- data$agg_indices[ind_em, , drop = FALSE]
        info$index_info$index_paa <- data$index_paa[, ind_em, , drop = FALSE]
        info$index_info$use_indices <- data$use_indices[ind_em, , drop = FALSE]
        info$index_info$use_index_paa <- data$use_index_paa[ind_em, , drop = FALSE]
      }
      
      if(is.null(reduce_region_info)) Stop("Users must prepare a list of new model configuration (NAA_where, sel_em, M_em, NAA_re_em, move_em, onto_move_list) if some areas are dropped from the model!")
      
      basic_info$NAA_where = reduce_region_info$NAA_where_em
      sel_em               = reduce_region_info$sel_em
      M_em                 = reduce_region_info$M_em
      NAA_re_em            = reduce_region_info$NAA_re_em
      move_em              = reduce_region_info$move_em
      catchability_em      = reduce_region_info$catchability_em
      ecov_em              = reduce_region_info$ecov_em
      onto_move_list       = reduce_region_info$onto_move_list
      
      if(n_regions == 1) move_em = NULL # This must be NULL when n_regions = 1
      if(n_regions == 1) basic_info$NAA_where = NULL # This must be NULL when n_regions = 1
      if(n_regions == 1) {
        basic_info$move_dyn <- 0
        basic_info$onto_move <- NULL
        basic_info$apply_re_trend <- 0
        basic_info$apply_mu_trend <- 0
      }  
      
      if (em.opt$do.move) {
        
        # Ecov Effect 
        if(!is.null(ecov_em)) {
          ecov_em_new <- ecov_em
          ecov_em_new$year <- ecov_em_new$year[ind_em]
          ecov_em_new$year <- 1:length(ecov_em_new$year)
          ecov_em_new$mean <- ecov_em_new$mean[ind_em,,drop = FALSE]
          ecov_em_new$logsigma <- ecov_em_new$logsigma[ind_em,,drop = FALSE]
          ecov_em_new$use_obs <- ecov_em_new$use_obs[ind_em,,drop = FALSE]
        } else {
          ecov_em_new <- NULL
        }
        
        em_input <- prepare_wham_input(
          basic_info = basic_info,
          selectivity = sel_em,
          M = M_em,
          NAA_re = NAA_re_em,
          move = move_em,
          catchability = catchability_em,
          ecov = ecov_em_new,
          age_comp = age_comp_em,
          catch_info = info$catch_info,
          index_info = info$index_info,
          F = info$F
        )
        
        em_input <- update_waa(em_input, waa_info = em_info$par_inputs$user_waa)
        
        if(!is.null(update_catch_info)) {
          agg_catch_sigma = update_catch_info$agg_catch_sigma
          catch_Neff = update_catch_info$catch_Neff
          remove_agg = update_catch_info$remove_agg
          remove_agg_pointer = update_catch_info$remove_agg_pointer 
          remove_agg_years = update_catch_info$remove_agg_years
          remove_paa = update_catch_info$remove_paa
          remove_paa_pointer = update_catch_info$remove_paa_pointer 
          remove_paa_years = update_catch_info$remove_paa_years
          em_input = update_input_catch_info(input = em_input, 
                                             agg_catch_sigma = agg_catch_sigma, 
                                             catch_Neff = catch_Neff,
                                             remove_agg = remove_agg,
                                             remove_agg_pointer = remove_agg_pointer,
                                             remove_agg_years = remove_agg_years,
                                             remove_paa = remove_paa,
                                             remove_paa_pointer = remove_paa_pointer, 
                                             remove_paa_years = remove_paa_years,
                                             ind_em = ind_em)
        }
        
        if(!is.null(update_index_info)) {
          agg_index_sigma = update_index_info$agg_index_sigma
          index_Neff = update_index_info$index_Neff
          remove_agg = update_index_info$remove_agg
          remove_agg_pointer = update_index_info$remove_agg_pointer 
          remove_agg_years = update_index_info$remove_agg_years
          remove_paa = update_index_info$remove_paa
          remove_paa_pointer = update_index_info$remove_paa_pointer 
          remove_paa_years = update_index_info$remove_paa_years
          em_input = update_input_index_info(input = em_input, 
                                             agg_index_sigma = agg_index_sigma, 
                                             index_Neff = index_Neff, 
                                             remove_agg = remove_agg,
                                             remove_agg_pointer = remove_agg_pointer,
                                             remove_agg_years = remove_agg_years,
                                             remove_paa = remove_paa,
                                             remove_paa_pointer = remove_paa_pointer, 
                                             remove_paa_years = remove_paa_years,
                                             ind_em = ind_em)
        }
        
      } else {
        
        # No movement
        # Override any movement or trend information
        basic_info$move_dyn <- 0
        basic_info$onto_move <- NULL
        basic_info$apply_re_trend <- 0
        basic_info$apply_mu_trend <- 0
        
        basic_info$NAA_where = NULL
        
        # Ecov Effect 
        if(!is.null(ecov_em)) {
          ecov_em_new <- ecov_em
          ecov_em_new$year <- ecov_em_new$year[ind_em]
          ecov_em_new$year <- 1:length(ecov_em_new$year)
          ecov_em_new$mean <- ecov_em_new$mean[ind_em,,drop = FALSE]
          ecov_em_new$logsigma <- ecov_em_new$logsigma[ind_em,,drop = FALSE]
          ecov_em_new$use_obs <- ecov_em_new$use_obs[ind_em,,drop = FALSE]
        } else {
          ecov_em_new <- NULL
        }
        
        # No movement
        em_input <- prepare_wham_input(
          basic_info = basic_info,
          selectivity = sel_em,
          M = M_em,
          NAA_re = NAA_re_em,
          move = NULL,
          catchability = catchability_em,
          ecov = ecov_em_new,
          age_comp = age_comp_em,
          catch_info = info$catch_info,
          index_info = info$index_info,
          F = info$F
        )
        
        em_input <- update_waa(em_input, waa_info = em_info$par_inputs$user_waa)
        
        if(!is.null(update_catch_info)) {
          agg_catch_sigma = update_catch_info$agg_catch_sigma
          catch_Neff = update_catch_info$catch_Neff
          remove_agg = update_catch_info$remove_agg
          remove_agg_pointer = update_catch_info$remove_agg_pointer 
          remove_agg_years = update_catch_info$remove_agg_years
          remove_paa = update_catch_info$remove_paa
          remove_paa_pointer = update_catch_info$remove_paa_pointer 
          remove_paa_years = update_catch_info$remove_paa_years
          em_input = update_input_catch_info(input = em_input, 
                                             agg_catch_sigma = agg_catch_sigma, 
                                             catch_Neff = catch_Neff,
                                             remove_agg = remove_agg,
                                             remove_agg_pointer = remove_agg_pointer,
                                             remove_agg_years = remove_agg_years,
                                             remove_paa = remove_paa,
                                             remove_paa_pointer = remove_paa_pointer, 
                                             remove_paa_years = remove_paa_years,
                                             ind_em = ind_em)
        }
        
        if(!is.null(update_index_info)) {
          agg_index_sigma = update_index_info$agg_index_sigma
          index_Neff = update_index_info$index_Neff
          remove_agg = update_index_info$remove_agg
          remove_agg_pointer = update_index_info$remove_agg_pointer 
          remove_agg_years = update_index_info$remove_agg_years
          remove_paa = update_index_info$remove_paa
          remove_paa_pointer = update_index_info$remove_paa_pointer 
          remove_paa_years = update_index_info$remove_paa_years
          em_input = update_input_index_info(input = em_input, 
                                             agg_index_sigma = agg_index_sigma, 
                                             index_Neff = index_Neff, 
                                             remove_agg = remove_agg,
                                             remove_agg_pointer = remove_agg_pointer,
                                             remove_agg_years = remove_agg_years,
                                             remove_paa = remove_paa,
                                             remove_paa_pointer = remove_paa_pointer, 
                                             remove_paa_years = remove_paa_years,
                                             ind_em = ind_em)
        }
        
      }
    }
    
  }
  
  return(em_input)
}
          catch_mean = implementation_error$mean
          catch_cv = implementation_error$cv
          catch_sd = implementation_error$sd
          catch_min = implementation_error$min
          catch_max = implementation_error$max
          constant_value = implementation_error$constant_value
          real_catch = add_implementation_error(catch_advice = advice,
                                                method = method,
                                                mean = catch_mean,
                                                cv = catch_cv,
                                                sd = catch_sd,
                                                min = catch_min,
                                                max = catch_max,
                                                constant_value = constant_value,
                                                seed = seed)
          cat("\nRealized catch is...\n")
          print(real_catch)
          interval.info <- list(catch = real_catch, years = y + 1:assess_interval)
        } else {
          interval.info <- list(catch = advice, years = y + 1:assess_interval)
          real_catch = advice
        }
        
        cat("\nNow calculating F at age in the OM given the catch advice...\n")
        om <- update_om_fn(om, interval.info, seed = seed, random = random, method = "nlminb", by_fleet = by_fleet, do.brps = do.brps)
      } else {
        cat("\nNow performing simulation-estimation experiments...\n")
        conv = NULL
        pdHess = NULL
        advice = NULL
      }
      
      em_list[[i]] <- em$rep
      par.est[[i]] <- as.list(em$sdrep, "Estimate")
      par.se[[i]] <- as.list(em$sdrep, "Std. Error")
      adrep.est[[i]] <- as.list(em$sdrep, "Estimate", report = TRUE)
      adrep.se[[i]] <- as.list(em$sdrep, "Std. Error", report = TRUE)
      opt_list[[i]] <- em$opt
      converge_list[[i]] <- conv + pdHess
      catch_advice[[i]] <- advice
      catch_realized[[i]] <- real_catch
      
      if (save.sdrep) {
        em_full[[i]] <- em
      } else {
        if (y == assess_years[length(assess_years)]) {
          em_full[[1]] <- em
        }
        if (!save.last.em) em_full[[1]] <- list()
      }
      
      em_input_list[[i]] <- em_input
    }
  }
  
  end.time <- Sys.time()
  time.taken <- end.time - start.time
  cat("Please ignore Warning in check_projF(proj_mod).")
  cat("\nTotal Runtime = ", time.taken,"\n")
  
  return(list(om = om, em_list = em_list, par.est = par.est, par.se = par.se, 
              adrep.est = adrep.est, adrep.se = adrep.se, opt_list = opt_list, 
              converge_list = converge_list, catch_advice = catch_advice, catch_realized = catch_realized, 
              em_full = em_full, em_input = em_input_list, runtime = time.taken, seed.save = seed))
}