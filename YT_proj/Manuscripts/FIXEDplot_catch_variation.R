FIXEDplot_catch_variation <- function (mods, is.nsim, main.dir, sub.dir, var = "Catch", width = 10, 
          height = 7, dpi = 300, col.opt = "D", outlier.opt = NA, new_model_names = NULL, 
          base.model = NULL) 
{
  library(dplyr)
  library(tidyr)
  library(ggplot2)
  library(rlang)
  calculate_aacv <- function(catch_values) {
    if (!is.numeric(catch_values)) {
      stop("Input catch_values must be a numeric vector.")
    }
    catch_diff <- abs(diff(catch_values))
    aacv <- sum(catch_diff)/sum(catch_values[-length(catch_values)])
    return(aacv)
  }
  res <- NULL
  if (!is.nsim) {
    n_fleets <- ncol(mods[[1]]$om$rep$pred_catch)
    Years <- mods[[1]]$om$years
    res <- lapply(seq_along(mods), function(i) {
      catch_mat <- mods[[i]]$om$rep$pred_catch
      aacv_list <- lapply(seq_len(n_fleets), function(f) {
        calculate_aacv(catch_mat[, f])
      })
      global_aacv <- calculate_aacv(rowSums(catch_mat))
      tmp <- data.frame(Local = t(unlist(aacv_list)), Global = global_aacv, 
                        Model = paste0("Model", i), Realization = 1)
      colnames(tmp)[1:n_fleets] <- paste0(var, "_Fleet", 
                                          seq_len(n_fleets))
      colnames(tmp)[n_fleets + 1] <- paste0(var, "_Global")
      tmp
    }) %>% bind_rows()
  } else {
    n_fleets <- ncol(mods[[1]][[1]]$om$rep$pred_catch)
    Years <- mods[[1]][[1]]$om$years
    res <- lapply(seq_along(mods), function(r) {
      lapply(seq_along(mods[[r]]), function(m) {
        catch_mat <- mods[[r]][[m]]$om$rep$pred_catch
        aacv_list <- lapply(seq_len(n_fleets), function(f) {
          calculate_aacv(catch_mat[, f])
        })
        global_aacv <- calculate_aacv(rowSums(catch_mat))
        tmp <- data.frame(Local = t(unlist(aacv_list)), 
                          Global = global_aacv, Model = paste0("Model", 
                                                               m), Realization = r)
        colnames(tmp)[1:n_fleets] <- paste0(var, "_Fleet", 
                                            seq_len(n_fleets))
        colnames(tmp)[n_fleets + 1] <- paste0(var, "_Global")
        tmp
      }) %>% bind_rows()
    }) %>% bind_rows()
  }
  if (!is.null(new_model_names)) {
    if (length(new_model_names) != length(unique(res$Model))) {
      stop("Length of new_model_names must match the number of models.")
    }
    res$Model <- factor(res$Model, levels = paste0("Model", 
                                                   seq_along(new_model_names)), labels = new_model_names)
    if (!is.null(base.model)) {
      if (!(base.model %in% new_model_names)) {
        warning("base.model does not match any of the new_model_names.")
      }
    }
  }
  res <- pivot_longer(res, cols = starts_with(var), names_to = "Label", 
                      values_to = "AACV")
  if (!is.null(base.model)) {
    base_df <- res %>% filter(Model == base.model) %>% rename(base_val = AACV) %>% 
      select(Realization, Label, base_val)
    res <- left_join(res, base_df, by = c("Realization", 
                                          "Label")) %>% mutate(AACV = AACV/base_val - 1)
  }
  
  res <- res %>% filter(Label == 'Catch_Global')
  
  p1 <- ggplot(res, aes(x = Model, y = AACV, fill = Model)) + 
    geom_boxplot(lwd = 0.8, outlier.shape = outlier.opt, color = 'black') + 
    #facet_grid(Label ~ ., scales = "free") + 
    scale_fill_viridis_d(option = col.opt) + 
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          axis.title.y = element_blank())
plot_name <- paste0(var, "_variation", ifelse(is.null(base.model), "", "_Relative"), ".png")
  new_sub_dir <- file.path(main.dir, sub.dir, "Annual_Variation_Boxplot")
  if (!file.exists(new_sub_dir)) {
    dir.create(new_sub_dir)
  }
  ggsave(file.path(main.dir, sub.dir, "Annual_Variation_Boxplot", 
                   plot_name), p1, width = width, height = height, dpi = dpi)
  return(p1)
}
