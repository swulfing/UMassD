FIXEDplot_fbar_variation <- function (mods, is.nsim, main.dir, sub.dir, var = "Fbar", width = 10, 
                                      height = 7, dpi = 300, col.opt = "D", outlier.opt = NA, new_model_names = NULL, 
                                      base.model = NULL) 
{
  library(dplyr)
  library(tidyr)
  library(ggplot2)
  library(rlang)
  calculate_aacv <- function(values) {
    if (!is.numeric(values)) 
      stop("Input must be numeric.")
    diff_abs <- abs(diff(values))
    aacv <- sum(diff_abs)/sum(values[-length(values)])
    return(aacv)
  }
  res <- NULL
  if (!is.nsim) {
    n_fleets <- mods[[1]]$om$input$data$n_fleets[1]
    n_regions <- mods[[1]]$om$input$data$n_regions[1]
    Years <- mods[[1]]$om$years
    res <- lapply(seq_along(mods), function(i) {
      fbar_mat <- mods[[i]]$om$rep$Fbar
      aacv_fleet <- lapply(seq_len(n_fleets), function(f) {
        calculate_aacv(fbar_mat[, f])
      })
      aacv_region <- lapply(seq_len(n_regions), function(r) {
        calculate_aacv(fbar_mat[, n_fleets + r])
      })
      aacv_global <- calculate_aacv(fbar_mat[, n_fleets + 
                                               n_regions + 1])
      tmp <- data.frame(t(unlist(aacv_fleet)), t(unlist(aacv_region)), 
                        Global = aacv_global, Model = paste0("Model", 
                                                             i), Realization = 1)
      colnames(tmp)[1:n_fleets] <- paste0(var, "_Fleet", 
                                          seq_len(n_fleets))
      colnames(tmp)[(n_fleets + 1):(n_fleets + n_regions)] <- paste0(var, 
                                                                     "_Region", seq_len(n_regions))
      colnames(tmp)[n_fleets + n_regions + 1] <- paste0(var, 
                                                        "_Global")
      tmp
    }) %>% bind_rows()
  } else {
    n_fleets <- mods[[1]][[1]]$om$input$data$n_fleets[1]
    n_regions <- mods[[1]][[1]]$om$input$data$n_regions[1]
    Years <- mods[[1]][[1]]$om$years
    res <- lapply(seq_along(mods), function(r) {
      lapply(seq_along(mods[[r]]), function(m) {
        fbar_mat <- mods[[r]][[m]]$om$rep$Fbar
        aacv_fleet <- lapply(seq_len(n_fleets), function(f) {
          calculate_aacv(fbar_mat[, f])
        })
        aacv_region <- lapply(seq_len(n_regions), function(rr) {
          calculate_aacv(fbar_mat[, n_fleets + rr])
        })
        aacv_global <- calculate_aacv(fbar_mat[, n_fleets + 
                                                 n_regions + 1])
        tmp <- data.frame(t(unlist(aacv_fleet)), t(unlist(aacv_region)), 
                          Global = aacv_global, Model = paste0("Model", 
                                                               m), Realization = r)
        colnames(tmp)[1:n_fleets] <- paste0(var, "_Fleet", 
                                            seq_len(n_fleets))
        colnames(tmp)[(n_fleets + 1):(n_fleets + n_regions)] <- paste0(var, 
                                                                       "_Region", seq_len(n_regions))
        colnames(tmp)[n_fleets + n_regions + 1] <- paste0(var, 
                                                          "_Global")
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
  labels_order <- res %>% distinct(Label) %>% arrange(if_else(grepl("Global", 
                                                                    Label), 2, 1), Label) %>% pull(Label)
  res$Label <- factor(res$Label, levels = labels_order)
  if (!is.null(base.model)) {
    base_df <- res %>% filter(Model == base.model) %>% rename(base_val = AACV) %>% 
      select(Realization, Label, base_val)
    res <- left_join(res, base_df, by = c("Realization", 
                                          "Label")) %>% mutate(AACV = AACV/base_val - 1)
  }
  
  res <- res %>% filter(Label == 'Fbar_Global')
  
  p1 <- ggplot(res, aes(x = Model, y = AACV, fill = Model)) + 
    geom_boxplot(lwd = 0.8, outlier.shape = outlier.opt, color = 'black') + 
    #facet_grid(Label ~ ., scales = "free") + 
    scale_fill_viridis_d(option = col.opt) + 
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          axis.title.y = element_blank())
  
  out_dir <- file.path(main.dir, sub.dir)
  if (!dir.exists(out_dir)) 
    dir.create(out_dir, recursive = TRUE)
  new_sub_dir <- file.path(main.dir, sub.dir, "Annual_Variation_Boxplot")
  if (!file.exists(new_sub_dir)) {
    dir.create(new_sub_dir)
  }
  plot_name <- paste0(var, "_variation", ifelse(is.null(base.model), 
                                                "", "_Relative"), ".png")
  ggsave(file.path(out_dir, "Annual_Variation_Boxplot", plot_name), 
         p1, width = width, height = height, dpi = dpi)
  return(p1)
}
