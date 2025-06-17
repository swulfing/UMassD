---
output:
  html_document:
    df_print: paged
    keep_md: yes
  word_document: default
  pdf_document:
    fig_caption: yes
    includes:
    keep_tex: yes
    number_sections: no
title: "WHAM Figures and Tables"
header-includes:
  - \usepackage{longtable}
  - \usepackage{booktabs}
  - \usepackage{caption,graphics}
  - \usepackage{makecell}
  - \usepackage{lscape}
  - \renewcommand\figurename{Fig.}
  - \captionsetup{labelsep=period, singlelinecheck=false}
  - \newcommand{\changesize}[1]{\fontsize{#1pt}{#1pt}\selectfont}
  - \renewcommand{\arraystretch}{1.5}
  - \renewcommand\theadfont{}
---



# {.tabset}

## Figures {.tabset}

### Input

<img src="plots_png/input_data/catch_age_comp_Fleet_1_region_1.png" style="display: block; margin: auto;" /><img src="plots_png/input_data/catch_by_fleet.png" style="display: block; margin: auto;" /><img src="plots_png/input_data/index.png" style="display: block; margin: auto;" /><img src="plots_png/input_data/Index_1_region_1_age_comp.png" style="display: block; margin: auto;" /><img src="plots_png/input_data/Index_2_region_1_age_comp.png" style="display: block; margin: auto;" /><img src="plots_png/input_data/Index_3_region_1_age_comp.png" style="display: block; margin: auto;" /><img src="plots_png/input_data/maturity_stock_1.png" style="display: block; margin: auto;" /><img src="plots_png/input_data/weight_at_age_Fleet_1_fleet.png" style="display: block; margin: auto;" /><img src="plots_png/input_data/weight_at_age_Index_1_index.png" style="display: block; margin: auto;" /><img src="plots_png/input_data/weight_at_age_Index_2_index.png" style="display: block; margin: auto;" /><img src="plots_png/input_data/weight_at_age_Index_3_index.png" style="display: block; margin: auto;" /><img src="plots_png/input_data/weight_at_age_SSB_stock_1.png" style="display: block; margin: auto;" />

### Diagnostics

<img src="plots_png/diagnostics/Catch_4panel_fleet_Fleet_1_region_1.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/Catch_age_comp_Fleet_1_region_1_a.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/Catch_age_comp_Fleet_1_region_1_b.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/Catch_age_comp_Fleet_1_region_1_c.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/Catch_age_comp_fleet_Fleet_1_region_1.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/Catch_age_comp_Index_1_region_1.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/Catch_age_comp_Index_1_region_1_a.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/Catch_age_comp_Index_1_region_1_b.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/Catch_age_comp_Index_1_region_1_c.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/Catch_age_comp_Index_2_region_1.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/Catch_age_comp_Index_2_region_1_a.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/Catch_age_comp_Index_2_region_1_b.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/Catch_age_comp_Index_2_region_1_c.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/Catch_age_comp_Index_3_region_1.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/Catch_age_comp_Index_3_region_1_a.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/Catch_age_comp_Index_3_region_1_b.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/Catch_age_comp_Index_3_region_1_c.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/Catch_age_comp_resids_Fleet_1.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/Catch_age_comp_resids_Index_1.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/Catch_age_comp_resids_Index_2.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/Catch_age_comp_resids_Index_3.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/Index_4panel_Index_1_region_1.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/Index_4panel_Index_2_region_1.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/Index_4panel_Index_3_region_1.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/likelihood.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/NAA_4panel_stock_1_region_1_age_1.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/NAA_4panel_stock_1_region_1_age_2.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/NAA_4panel_stock_1_region_1_age_3.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/NAA_4panel_stock_1_region_1_age_4.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/NAA_4panel_stock_1_region_1_age_5.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/NAA_4panel_stock_1_region_1_age_6.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/Residuals_time.png" style="display: block; margin: auto;" /><img src="plots_png/diagnostics/summary_text.png" style="display: block; margin: auto;" />

### Results

<img src="plots_png/results/CV_SSB_Rec_F.png" style="display: block; margin: auto;" /><img src="plots_png/results/F_byfleet.png" style="display: block; margin: auto;" /><img src="plots_png/results/M_at_age_stock_1_.png" style="display: block; margin: auto;" /><img src="plots_png/results/MAA_tile.png" style="display: block; margin: auto;" /><img src="plots_png/results/NAA_dev_tile.png" style="display: block; margin: auto;" /><img src="plots_png/results/Numbers_at_age_proportion_stock_1_region_1.png" style="display: block; margin: auto;" /><img src="plots_png/results/Numbers_at_age_stock_1_region_1.png" style="display: block; margin: auto;" /><img src="plots_png/results/q_time_series.png" style="display: block; margin: auto;" /><img src="plots_png/results/SelAA_tile.png" style="display: block; margin: auto;" /><img src="plots_png/results/Selectivity_Fleet_1_region_1.png" style="display: block; margin: auto;" /><img src="plots_png/results/Selectivity_Index_1_region_1.png" style="display: block; margin: auto;" /><img src="plots_png/results/Selectivity_Index_2_region_1.png" style="display: block; margin: auto;" /><img src="plots_png/results/Selectivity_Index_3_region_1.png" style="display: block; margin: auto;" /><img src="plots_png/results/SSB_at_age_proportion_stock_1.png" style="display: block; margin: auto;" /><img src="plots_png/results/SSB_at_age_stock_1.png" style="display: block; margin: auto;" /><img src="plots_png/results/SSB_F_trend.png" style="display: block; margin: auto;" /><img src="plots_png/results/SSB_Rec_loglog_stock_1.png" style="display: block; margin: auto;" /><img src="plots_png/results/SSB_Rec_stock_1.png" style="display: block; margin: auto;" /><img src="plots_png/results/SSB_Rec_stock_1_fit.png" style="display: block; margin: auto;" /><img src="plots_png/results/SSB_Rec_time_stock_1.png" style="display: block; margin: auto;" />

### Retro



### Reference points

<img src="plots_png/ref_points/FSPR_absolute.png" style="display: block; margin: auto;" /><img src="plots_png/ref_points/FSPR_annual_time.png" style="display: block; margin: auto;" /><img src="plots_png/ref_points/FSPR_freq_annual_F.png" style="display: block; margin: auto;" /><img src="plots_png/ref_points/FSPR_freq_annual_YPR.png" style="display: block; margin: auto;" /><img src="plots_png/ref_points/FSPR_relative.png" style="display: block; margin: auto;" /><img src="plots_png/ref_points/Kobe_msy_status.png" style="display: block; margin: auto;" /><img src="plots_png/ref_points/Kobe_status.png" style="display: block; margin: auto;" /><img src="plots_png/ref_points/MSY_4panel_F_SSB_R.png" style="display: block; margin: auto;" /><img src="plots_png/ref_points/MSY_relative_status.png" style="display: block; margin: auto;" /><img src="plots_png/ref_points/SPR_targets_ave_plot.png" style="display: block; margin: auto;" /><img src="plots_png/ref_points/SPR_targets_ave_table.png" style="display: block; margin: auto;" /><img src="plots_png/ref_points/YPR_F_curve_plot.png" style="display: block; margin: auto;" /><img src="plots_png/ref_points/YPR_F_curve_table.png" style="display: block; margin: auto;" />

### Miscellaneous

<img src="plots_png/misc/catch_at_age_consistency_obs_Fleet_1_region_1.png" style="display: block; margin: auto;" /><img src="plots_png/misc/catch_at_age_consistency_obs_Index_1_region_1.png" style="display: block; margin: auto;" /><img src="plots_png/misc/catch_at_age_consistency_obs_Index_2_region_1.png" style="display: block; margin: auto;" /><img src="plots_png/misc/catch_at_age_consistency_obs_Index_3_region_1.png" style="display: block; margin: auto;" /><img src="plots_png/misc/catch_at_age_consistency_pred_Fleet_1_region_1.png" style="display: block; margin: auto;" /><img src="plots_png/misc/catch_at_age_consistency_pred_Index_1_region_1.png" style="display: block; margin: auto;" /><img src="plots_png/misc/catch_at_age_consistency_pred_Index_2_region_1.png" style="display: block; margin: auto;" /><img src="plots_png/misc/catch_at_age_consistency_pred_Index_3_region_1.png" style="display: block; margin: auto;" /><img src="plots_png/misc/catch_curves_Fleet_1_region_1_obs.png" style="display: block; margin: auto;" /><img src="plots_png/misc/catch_curves_Fleet_1_region_1_pred.png" style="display: block; margin: auto;" /><img src="plots_png/misc/catch_curves_Index_1_region_1_obs.png" style="display: block; margin: auto;" /><img src="plots_png/misc/catch_curves_Index_1_region_1_pred.png" style="display: block; margin: auto;" /><img src="plots_png/misc/catch_curves_Index_2_region_1_obs.png" style="display: block; margin: auto;" /><img src="plots_png/misc/catch_curves_Index_2_region_1_pred.png" style="display: block; margin: auto;" /><img src="plots_png/misc/catch_curves_Index_3_region_1_obs.png" style="display: block; margin: auto;" /><img src="plots_png/misc/catch_curves_Index_3_region_1_pred.png" style="display: block; margin: auto;" />

## Tables {.tabset}

### Parameter estimates

<table class="table" style="color: black; margin-left: auto; margin-right: auto;">
<caption>Parameter estimates, standard errors, and confidence intervals. Rounded to 3 decimal places.</caption>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Estimate </th>
   <th style="text-align:right;"> Std. Error </th>
   <th style="text-align:right;"> 95\% CI lower </th>
   <th style="text-align:right;"> 95\% CI upper </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> stock 1 B-H a </td>
   <td style="text-align:right;"> $4.429$ </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
  </tr>
  <tr>
   <td style="text-align:left;"> stock 1 B-H b </td>
   <td style="text-align:right;"> $8.491\times 10^{-5}$ </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
  </tr>
  <tr>
   <td style="text-align:left;"> stock 1 NAA $\sigma$ (age 1) </td>
   <td style="text-align:right;"> $7.067\times 10^{-4}$ </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
  </tr>
  <tr>
   <td style="text-align:left;"> stock 1 NAA $\sigma$ (ages 2-6+) </td>
   <td style="text-align:right;"> $0.346$ </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Index 1 fully selected q </td>
   <td style="text-align:right;"> $1.439\times 10^{-4}$ </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Index 2 fully selected q </td>
   <td style="text-align:right;"> $1.379\times 10^{-4}$ </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Index 3 fully selected q </td>
   <td style="text-align:right;"> $1.920\times 10^{-4}$ </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fleet 1 Mean Selectivity for age 1 (Block 1) </td>
   <td style="text-align:right;"> $0.043$ </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fleet 1 Mean Selectivity for age 2 (Block 1) </td>
   <td style="text-align:right;"> $0.299$ </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fleet 1 Mean Selectivity for age 3 (Block 1) </td>
   <td style="text-align:right;"> $0.521$ </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fleet 1 Mean Selectivity for age 4 (Block 1) </td>
   <td style="text-align:right;"> $1.000$ </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fleet 1 Mean Selectivity for age 5 (Block 1) </td>
   <td style="text-align:right;"> $1.000$ </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fleet 1 Mean Selectivity for age 6+ (Block 1) </td>
   <td style="text-align:right;"> $1.000$ </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Index 1 $a_{50}$ (Block 2) </td>
   <td style="text-align:right;"> $2.143$ </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Index 1 1/slope (increasing) (Block 2) </td>
   <td style="text-align:right;"> $0.378$ </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Index 2 $a_{50}$ (Block 3) </td>
   <td style="text-align:right;"> $1.358$ </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Index 2 1/slope (increasing) (Block 3) </td>
   <td style="text-align:right;"> $0.401$ </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Index 3 $a_{50}$ (Block 4) </td>
   <td style="text-align:right;"> $2.093$ </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Index 3 1/slope (increasing) (Block 4) </td>
   <td style="text-align:right;"> $0.246$ </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fleet 1 Selectivity RE $\sigma$ (Block 1) </td>
   <td style="text-align:right;"> $5.647\times 10^{-5}$ </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fleet 1 Selectivity RE AR1 $\rho$ (year) (Block 1) </td>
   <td style="text-align:right;"> $0.403$ </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fleet 1 age comp, logistic-normal: $\sigma$ </td>
   <td style="text-align:right;"> $12.032$ </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Index 1 age comp, logistic-normal: $\sigma$ </td>
   <td style="text-align:right;"> $7.886$ </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Index 2 age comp, logistic-normal: $\sigma$ </td>
   <td style="text-align:right;"> $7.612$ </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Index 3 age comp, logistic-normal: $\sigma$ </td>
   <td style="text-align:right;"> $7.383$ </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
   <td style="text-align:right;"> -- </td>
  </tr>
</tbody>
</table>

### Abundance at age

<table class="table" style="color: black; margin-left: auto; margin-right: auto;">
<caption>Abundance at age (1000s) for stock 1 in region 1.</caption>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> 1 </th>
   <th style="text-align:right;"> 2 </th>
   <th style="text-align:right;"> 3 </th>
   <th style="text-align:right;"> 4 </th>
   <th style="text-align:right;"> 5 </th>
   <th style="text-align:right;"> 6+ </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1973 </td>
   <td style="text-align:right;"> 44114 </td>
   <td style="text-align:right;"> 36989 </td>
   <td style="text-align:right;"> 29034 </td>
   <td style="text-align:right;"> 27167 </td>
   <td style="text-align:right;"> 10533 </td>
   <td style="text-align:right;"> 3273 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1974 </td>
   <td style="text-align:right;"> 35421 </td>
   <td style="text-align:right;"> 16991 </td>
   <td style="text-align:right;"> 14754 </td>
   <td style="text-align:right;"> 9922 </td>
   <td style="text-align:right;"> 7954 </td>
   <td style="text-align:right;"> 4548 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1975 </td>
   <td style="text-align:right;"> 29210 </td>
   <td style="text-align:right;"> 14764 </td>
   <td style="text-align:right;"> 7358 </td>
   <td style="text-align:right;"> 6080 </td>
   <td style="text-align:right;"> 2618 </td>
   <td style="text-align:right;"> 3686 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1976 </td>
   <td style="text-align:right;"> 23337 </td>
   <td style="text-align:right;"> 13769 </td>
   <td style="text-align:right;"> 9895 </td>
   <td style="text-align:right;"> 4175 </td>
   <td style="text-align:right;"> 3073 </td>
   <td style="text-align:right;"> 2917 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1977 </td>
   <td style="text-align:right;"> 22928 </td>
   <td style="text-align:right;"> 15972 </td>
   <td style="text-align:right;"> 10175 </td>
   <td style="text-align:right;"> 7747 </td>
   <td style="text-align:right;"> 1769 </td>
   <td style="text-align:right;"> 1938 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1978 </td>
   <td style="text-align:right;"> 23004 </td>
   <td style="text-align:right;"> 12881 </td>
   <td style="text-align:right;"> 9989 </td>
   <td style="text-align:right;"> 4791 </td>
   <td style="text-align:right;"> 2101 </td>
   <td style="text-align:right;"> 862 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1979 </td>
   <td style="text-align:right;"> 23182 </td>
   <td style="text-align:right;"> 28342 </td>
   <td style="text-align:right;"> 14564 </td>
   <td style="text-align:right;"> 10207 </td>
   <td style="text-align:right;"> 2566 </td>
   <td style="text-align:right;"> 831 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1980 </td>
   <td style="text-align:right;"> 28729 </td>
   <td style="text-align:right;"> 35829 </td>
   <td style="text-align:right;"> 44970 </td>
   <td style="text-align:right;"> 16234 </td>
   <td style="text-align:right;"> 7441 </td>
   <td style="text-align:right;"> 617 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1981 </td>
   <td style="text-align:right;"> 38690 </td>
   <td style="text-align:right;"> 39142 </td>
   <td style="text-align:right;"> 40411 </td>
   <td style="text-align:right;"> 45100 </td>
   <td style="text-align:right;"> 12586 </td>
   <td style="text-align:right;"> 3606 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1982 </td>
   <td style="text-align:right;"> 41199 </td>
   <td style="text-align:right;"> 43360 </td>
   <td style="text-align:right;"> 48365 </td>
   <td style="text-align:right;"> 40396 </td>
   <td style="text-align:right;"> 28341 </td>
   <td style="text-align:right;"> 6292 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1983 </td>
   <td style="text-align:right;"> 43270 </td>
   <td style="text-align:right;"> 40441 </td>
   <td style="text-align:right;"> 41768 </td>
   <td style="text-align:right;"> 36224 </td>
   <td style="text-align:right;"> 17918 </td>
   <td style="text-align:right;"> 18708 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1984 </td>
   <td style="text-align:right;"> 43257 </td>
   <td style="text-align:right;"> 26324 </td>
   <td style="text-align:right;"> 37238 </td>
   <td style="text-align:right;"> 30031 </td>
   <td style="text-align:right;"> 22439 </td>
   <td style="text-align:right;"> 13584 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1985 </td>
   <td style="text-align:right;"> 39644 </td>
   <td style="text-align:right;"> 22751 </td>
   <td style="text-align:right;"> 15664 </td>
   <td style="text-align:right;"> 24825 </td>
   <td style="text-align:right;"> 12175 </td>
   <td style="text-align:right;"> 13309 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1986 </td>
   <td style="text-align:right;"> 37062 </td>
   <td style="text-align:right;"> 18323 </td>
   <td style="text-align:right;"> 11895 </td>
   <td style="text-align:right;"> 8374 </td>
   <td style="text-align:right;"> 9132 </td>
   <td style="text-align:right;"> 8593 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1987 </td>
   <td style="text-align:right;"> 34945 </td>
   <td style="text-align:right;"> 25802 </td>
   <td style="text-align:right;"> 11153 </td>
   <td style="text-align:right;"> 8174 </td>
   <td style="text-align:right;"> 5430 </td>
   <td style="text-align:right;"> 13690 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1988 </td>
   <td style="text-align:right;"> 33711 </td>
   <td style="text-align:right;"> 30155 </td>
   <td style="text-align:right;"> 19093 </td>
   <td style="text-align:right;"> 6352 </td>
   <td style="text-align:right;"> 3912 </td>
   <td style="text-align:right;"> 9562 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1989 </td>
   <td style="text-align:right;"> 34437 </td>
   <td style="text-align:right;"> 17832 </td>
   <td style="text-align:right;"> 22270 </td>
   <td style="text-align:right;"> 15511 </td>
   <td style="text-align:right;"> 2686 </td>
   <td style="text-align:right;"> 4803 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1990 </td>
   <td style="text-align:right;"> 35061 </td>
   <td style="text-align:right;"> 21889 </td>
   <td style="text-align:right;"> 12729 </td>
   <td style="text-align:right;"> 17601 </td>
   <td style="text-align:right;"> 11033 </td>
   <td style="text-align:right;"> 2159 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1991 </td>
   <td style="text-align:right;"> 31763 </td>
   <td style="text-align:right;"> 12084 </td>
   <td style="text-align:right;"> 9364 </td>
   <td style="text-align:right;"> 6325 </td>
   <td style="text-align:right;"> 6542 </td>
   <td style="text-align:right;"> 4161 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1992 </td>
   <td style="text-align:right;"> 25114 </td>
   <td style="text-align:right;"> 9642 </td>
   <td style="text-align:right;"> 5956 </td>
   <td style="text-align:right;"> 5053 </td>
   <td style="text-align:right;"> 2753 </td>
   <td style="text-align:right;"> 5054 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1993 </td>
   <td style="text-align:right;"> 23797 </td>
   <td style="text-align:right;"> 8430 </td>
   <td style="text-align:right;"> 5295 </td>
   <td style="text-align:right;"> 3788 </td>
   <td style="text-align:right;"> 3462 </td>
   <td style="text-align:right;"> 6401 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1994 </td>
   <td style="text-align:right;"> 22255 </td>
   <td style="text-align:right;"> 8947 </td>
   <td style="text-align:right;"> 4509 </td>
   <td style="text-align:right;"> 3818 </td>
   <td style="text-align:right;"> 1801 </td>
   <td style="text-align:right;"> 5617 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1995 </td>
   <td style="text-align:right;"> 17512 </td>
   <td style="text-align:right;"> 9440 </td>
   <td style="text-align:right;"> 4991 </td>
   <td style="text-align:right;"> 2636 </td>
   <td style="text-align:right;"> 1663 </td>
   <td style="text-align:right;"> 2640 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1996 </td>
   <td style="text-align:right;"> 17694 </td>
   <td style="text-align:right;"> 8655 </td>
   <td style="text-align:right;"> 9775 </td>
   <td style="text-align:right;"> 4479 </td>
   <td style="text-align:right;"> 2092 </td>
   <td style="text-align:right;"> 3266 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1997 </td>
   <td style="text-align:right;"> 23853 </td>
   <td style="text-align:right;"> 35676 </td>
   <td style="text-align:right;"> 8717 </td>
   <td style="text-align:right;"> 23195 </td>
   <td style="text-align:right;"> 4529 </td>
   <td style="text-align:right;"> 4594 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1998 </td>
   <td style="text-align:right;"> 34271 </td>
   <td style="text-align:right;"> 22999 </td>
   <td style="text-align:right;"> 62088 </td>
   <td style="text-align:right;"> 7663 </td>
   <td style="text-align:right;"> 33828 </td>
   <td style="text-align:right;"> 6184 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1999 </td>
   <td style="text-align:right;"> 41228 </td>
   <td style="text-align:right;"> 25798 </td>
   <td style="text-align:right;"> 16882 </td>
   <td style="text-align:right;"> 32151 </td>
   <td style="text-align:right;"> 4399 </td>
   <td style="text-align:right;"> 24932 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2000 </td>
   <td style="text-align:right;"> 41466 </td>
   <td style="text-align:right;"> 33571 </td>
   <td style="text-align:right;"> 21837 </td>
   <td style="text-align:right;"> 12251 </td>
   <td style="text-align:right;"> 21588 </td>
   <td style="text-align:right;"> 28550 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2001 </td>
   <td style="text-align:right;"> 44378 </td>
   <td style="text-align:right;"> 28552 </td>
   <td style="text-align:right;"> 40347 </td>
   <td style="text-align:right;"> 25698 </td>
   <td style="text-align:right;"> 9678 </td>
   <td style="text-align:right;"> 52580 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2002 </td>
   <td style="text-align:right;"> 45932 </td>
   <td style="text-align:right;"> 42419 </td>
   <td style="text-align:right;"> 29683 </td>
   <td style="text-align:right;"> 42098 </td>
   <td style="text-align:right;"> 21673 </td>
   <td style="text-align:right;"> 26053 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2003 </td>
   <td style="text-align:right;"> 45439 </td>
   <td style="text-align:right;"> 39338 </td>
   <td style="text-align:right;"> 51833 </td>
   <td style="text-align:right;"> 29571 </td>
   <td style="text-align:right;"> 42761 </td>
   <td style="text-align:right;"> 30714 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2004 </td>
   <td style="text-align:right;"> 46333 </td>
   <td style="text-align:right;"> 27260 </td>
   <td style="text-align:right;"> 29186 </td>
   <td style="text-align:right;"> 36298 </td>
   <td style="text-align:right;"> 18611 </td>
   <td style="text-align:right;"> 41886 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2005 </td>
   <td style="text-align:right;"> 44232 </td>
   <td style="text-align:right;"> 23595 </td>
   <td style="text-align:right;"> 16505 </td>
   <td style="text-align:right;"> 14824 </td>
   <td style="text-align:right;"> 14777 </td>
   <td style="text-align:right;"> 22510 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:right;"> 41119 </td>
   <td style="text-align:right;"> 38451 </td>
   <td style="text-align:right;"> 15315 </td>
   <td style="text-align:right;"> 12987 </td>
   <td style="text-align:right;"> 7067 </td>
   <td style="text-align:right;"> 33016 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2007 </td>
   <td style="text-align:right;"> 41822 </td>
   <td style="text-align:right;"> 36297 </td>
   <td style="text-align:right;"> 56698 </td>
   <td style="text-align:right;"> 13151 </td>
   <td style="text-align:right;"> 12771 </td>
   <td style="text-align:right;"> 32243 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2008 </td>
   <td style="text-align:right;"> 44105 </td>
   <td style="text-align:right;"> 30006 </td>
   <td style="text-align:right;"> 37922 </td>
   <td style="text-align:right;"> 39602 </td>
   <td style="text-align:right;"> 10729 </td>
   <td style="text-align:right;"> 49482 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:right;"> 45655 </td>
   <td style="text-align:right;"> 39111 </td>
   <td style="text-align:right;"> 23772 </td>
   <td style="text-align:right;"> 33767 </td>
   <td style="text-align:right;"> 32617 </td>
   <td style="text-align:right;"> 59053 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:right;"> 45933 </td>
   <td style="text-align:right;"> 32368 </td>
   <td style="text-align:right;"> 39425 </td>
   <td style="text-align:right;"> 18446 </td>
   <td style="text-align:right;"> 31587 </td>
   <td style="text-align:right;"> 55653 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:right;"> 45726 </td>
   <td style="text-align:right;"> 30182 </td>
   <td style="text-align:right;"> 28464 </td>
   <td style="text-align:right;"> 44025 </td>
   <td style="text-align:right;"> 16496 </td>
   <td style="text-align:right;"> 63851 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:right;"> 45915 </td>
   <td style="text-align:right;"> 51770 </td>
   <td style="text-align:right;"> 28393 </td>
   <td style="text-align:right;"> 27749 </td>
   <td style="text-align:right;"> 34275 </td>
   <td style="text-align:right;"> 95698 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:right;"> 47394 </td>
   <td style="text-align:right;"> 34899 </td>
   <td style="text-align:right;"> 88180 </td>
   <td style="text-align:right;"> 30716 </td>
   <td style="text-align:right;"> 24875 </td>
   <td style="text-align:right;"> 163227 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:right;"> 48972 </td>
   <td style="text-align:right;"> 30161 </td>
   <td style="text-align:right;"> 31698 </td>
   <td style="text-align:right;"> 116888 </td>
   <td style="text-align:right;"> 32546 </td>
   <td style="text-align:right;"> 155777 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:right;"> 49196 </td>
   <td style="text-align:right;"> 38822 </td>
   <td style="text-align:right;"> 22562 </td>
   <td style="text-align:right;"> 25767 </td>
   <td style="text-align:right;"> 88899 </td>
   <td style="text-align:right;"> 153571 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:right;"> 48998 </td>
   <td style="text-align:right;"> 39710 </td>
   <td style="text-align:right;"> 37968 </td>
   <td style="text-align:right;"> 19447 </td>
   <td style="text-align:right;"> 18816 </td>
   <td style="text-align:right;"> 272926 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:right;"> 49220 </td>
   <td style="text-align:right;"> 27293 </td>
   <td style="text-align:right;"> 37889 </td>
   <td style="text-align:right;"> 38138 </td>
   <td style="text-align:right;"> 16882 </td>
   <td style="text-align:right;"> 147441 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:right;"> 47986 </td>
   <td style="text-align:right;"> 32213 </td>
   <td style="text-align:right;"> 21295 </td>
   <td style="text-align:right;"> 29864 </td>
   <td style="text-align:right;"> 33455 </td>
   <td style="text-align:right;"> 79838 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2019 </td>
   <td style="text-align:right;"> 46228 </td>
   <td style="text-align:right;"> 32325 </td>
   <td style="text-align:right;"> 32084 </td>
   <td style="text-align:right;"> 16739 </td>
   <td style="text-align:right;"> 24996 </td>
   <td style="text-align:right;"> 70772 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2020 </td>
   <td style="text-align:right;"> 45749 </td>
   <td style="text-align:right;"> 34060 </td>
   <td style="text-align:right;"> 28528 </td>
   <td style="text-align:right;"> 39130 </td>
   <td style="text-align:right;"> 16118 </td>
   <td style="text-align:right;"> 100432 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2021 </td>
   <td style="text-align:right;"> 46053 </td>
   <td style="text-align:right;"> 38111 </td>
   <td style="text-align:right;"> 34290 </td>
   <td style="text-align:right;"> 24654 </td>
   <td style="text-align:right;"> 44201 </td>
   <td style="text-align:right;"> 108619 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2022 </td>
   <td style="text-align:right;"> 46803 </td>
   <td style="text-align:right;"> 33443 </td>
   <td style="text-align:right;"> 32262 </td>
   <td style="text-align:right;"> 31175 </td>
   <td style="text-align:right;"> 18692 </td>
   <td style="text-align:right;"> 157600 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2023 </td>
   <td style="text-align:right;"> 47856 </td>
   <td style="text-align:right;"> 34332 </td>
   <td style="text-align:right;"> 31470 </td>
   <td style="text-align:right;"> 26485 </td>
   <td style="text-align:right;"> 27259 </td>
   <td style="text-align:right;"> 253746 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2024 </td>
   <td style="text-align:right;"> 48111 </td>
   <td style="text-align:right;"> 38465 </td>
   <td style="text-align:right;"> 23083 </td>
   <td style="text-align:right;"> 15539 </td>
   <td style="text-align:right;"> 9798 </td>
   <td style="text-align:right;"> 62297 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2025 </td>
   <td style="text-align:right;"> 41288 </td>
   <td style="text-align:right;"> 18209 </td>
   <td style="text-align:right;"> 34996 </td>
   <td style="text-align:right;"> 14273 </td>
   <td style="text-align:right;"> 6216 </td>
   <td style="text-align:right;"> 13193 </td>
  </tr>
</tbody>
</table>

### Fishing mortality at age by region

<table class="table" style="color: black; margin-left: auto; margin-right: auto;">
<caption>Total fishing mortality at age in region 1.</caption>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> 1 </th>
   <th style="text-align:right;"> 2 </th>
   <th style="text-align:right;"> 3 </th>
   <th style="text-align:right;"> 4 </th>
   <th style="text-align:right;"> 5 </th>
   <th style="text-align:right;"> 6+ </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1973 </td>
   <td style="text-align:right;"> 0.052 </td>
   <td style="text-align:right;"> 0.361 </td>
   <td style="text-align:right;"> 0.628 </td>
   <td style="text-align:right;"> 1.206 </td>
   <td style="text-align:right;"> 1.206 </td>
   <td style="text-align:right;"> 1.206 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1974 </td>
   <td style="text-align:right;"> 0.044 </td>
   <td style="text-align:right;"> 0.302 </td>
   <td style="text-align:right;"> 0.526 </td>
   <td style="text-align:right;"> 1.010 </td>
   <td style="text-align:right;"> 1.010 </td>
   <td style="text-align:right;"> 1.010 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1975 </td>
   <td style="text-align:right;"> 0.022 </td>
   <td style="text-align:right;"> 0.151 </td>
   <td style="text-align:right;"> 0.263 </td>
   <td style="text-align:right;"> 0.504 </td>
   <td style="text-align:right;"> 0.504 </td>
   <td style="text-align:right;"> 0.504 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1976 </td>
   <td style="text-align:right;"> 0.037 </td>
   <td style="text-align:right;"> 0.256 </td>
   <td style="text-align:right;"> 0.446 </td>
   <td style="text-align:right;"> 0.855 </td>
   <td style="text-align:right;"> 0.855 </td>
   <td style="text-align:right;"> 0.855 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1977 </td>
   <td style="text-align:right;"> 0.047 </td>
   <td style="text-align:right;"> 0.325 </td>
   <td style="text-align:right;"> 0.567 </td>
   <td style="text-align:right;"> 1.087 </td>
   <td style="text-align:right;"> 1.087 </td>
   <td style="text-align:right;"> 1.087 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1978 </td>
   <td style="text-align:right;"> 0.014 </td>
   <td style="text-align:right;"> 0.098 </td>
   <td style="text-align:right;"> 0.171 </td>
   <td style="text-align:right;"> 0.328 </td>
   <td style="text-align:right;"> 0.328 </td>
   <td style="text-align:right;"> 0.328 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1979 </td>
   <td style="text-align:right;"> 0.019 </td>
   <td style="text-align:right;"> 0.132 </td>
   <td style="text-align:right;"> 0.230 </td>
   <td style="text-align:right;"> 0.442 </td>
   <td style="text-align:right;"> 0.442 </td>
   <td style="text-align:right;"> 0.442 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1980 </td>
   <td style="text-align:right;"> 0.009 </td>
   <td style="text-align:right;"> 0.065 </td>
   <td style="text-align:right;"> 0.114 </td>
   <td style="text-align:right;"> 0.218 </td>
   <td style="text-align:right;"> 0.218 </td>
   <td style="text-align:right;"> 0.218 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1981 </td>
   <td style="text-align:right;"> 0.025 </td>
   <td style="text-align:right;"> 0.175 </td>
   <td style="text-align:right;"> 0.305 </td>
   <td style="text-align:right;"> 0.586 </td>
   <td style="text-align:right;"> 0.586 </td>
   <td style="text-align:right;"> 0.586 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1982 </td>
   <td style="text-align:right;"> 0.026 </td>
   <td style="text-align:right;"> 0.176 </td>
   <td style="text-align:right;"> 0.307 </td>
   <td style="text-align:right;"> 0.588 </td>
   <td style="text-align:right;"> 0.588 </td>
   <td style="text-align:right;"> 0.588 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1983 </td>
   <td style="text-align:right;"> 0.019 </td>
   <td style="text-align:right;"> 0.132 </td>
   <td style="text-align:right;"> 0.231 </td>
   <td style="text-align:right;"> 0.443 </td>
   <td style="text-align:right;"> 0.443 </td>
   <td style="text-align:right;"> 0.443 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1984 </td>
   <td style="text-align:right;"> 0.036 </td>
   <td style="text-align:right;"> 0.248 </td>
   <td style="text-align:right;"> 0.432 </td>
   <td style="text-align:right;"> 0.829 </td>
   <td style="text-align:right;"> 0.829 </td>
   <td style="text-align:right;"> 0.829 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1985 </td>
   <td style="text-align:right;"> 0.034 </td>
   <td style="text-align:right;"> 0.234 </td>
   <td style="text-align:right;"> 0.407 </td>
   <td style="text-align:right;"> 0.782 </td>
   <td style="text-align:right;"> 0.782 </td>
   <td style="text-align:right;"> 0.782 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1986 </td>
   <td style="text-align:right;"> 0.014 </td>
   <td style="text-align:right;"> 0.095 </td>
   <td style="text-align:right;"> 0.165 </td>
   <td style="text-align:right;"> 0.317 </td>
   <td style="text-align:right;"> 0.317 </td>
   <td style="text-align:right;"> 0.317 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1987 </td>
   <td style="text-align:right;"> 0.029 </td>
   <td style="text-align:right;"> 0.201 </td>
   <td style="text-align:right;"> 0.350 </td>
   <td style="text-align:right;"> 0.671 </td>
   <td style="text-align:right;"> 0.671 </td>
   <td style="text-align:right;"> 0.671 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1988 </td>
   <td style="text-align:right;"> 0.020 </td>
   <td style="text-align:right;"> 0.140 </td>
   <td style="text-align:right;"> 0.243 </td>
   <td style="text-align:right;"> 0.467 </td>
   <td style="text-align:right;"> 0.467 </td>
   <td style="text-align:right;"> 0.467 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1989 </td>
   <td style="text-align:right;"> 0.015 </td>
   <td style="text-align:right;"> 0.102 </td>
   <td style="text-align:right;"> 0.178 </td>
   <td style="text-align:right;"> 0.342 </td>
   <td style="text-align:right;"> 0.342 </td>
   <td style="text-align:right;"> 0.342 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1990 </td>
   <td style="text-align:right;"> 0.033 </td>
   <td style="text-align:right;"> 0.231 </td>
   <td style="text-align:right;"> 0.402 </td>
   <td style="text-align:right;"> 0.771 </td>
   <td style="text-align:right;"> 0.771 </td>
   <td style="text-align:right;"> 0.771 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1991 </td>
   <td style="text-align:right;"> 0.030 </td>
   <td style="text-align:right;"> 0.205 </td>
   <td style="text-align:right;"> 0.357 </td>
   <td style="text-align:right;"> 0.685 </td>
   <td style="text-align:right;"> 0.685 </td>
   <td style="text-align:right;"> 0.685 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1992 </td>
   <td style="text-align:right;"> 0.018 </td>
   <td style="text-align:right;"> 0.127 </td>
   <td style="text-align:right;"> 0.222 </td>
   <td style="text-align:right;"> 0.426 </td>
   <td style="text-align:right;"> 0.426 </td>
   <td style="text-align:right;"> 0.426 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1993 </td>
   <td style="text-align:right;"> 0.025 </td>
   <td style="text-align:right;"> 0.174 </td>
   <td style="text-align:right;"> 0.304 </td>
   <td style="text-align:right;"> 0.583 </td>
   <td style="text-align:right;"> 0.583 </td>
   <td style="text-align:right;"> 0.583 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1994 </td>
   <td style="text-align:right;"> 0.044 </td>
   <td style="text-align:right;"> 0.303 </td>
   <td style="text-align:right;"> 0.528 </td>
   <td style="text-align:right;"> 1.014 </td>
   <td style="text-align:right;"> 1.014 </td>
   <td style="text-align:right;"> 1.014 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1995 </td>
   <td style="text-align:right;"> 0.009 </td>
   <td style="text-align:right;"> 0.061 </td>
   <td style="text-align:right;"> 0.107 </td>
   <td style="text-align:right;"> 0.205 </td>
   <td style="text-align:right;"> 0.205 </td>
   <td style="text-align:right;"> 0.205 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1996 </td>
   <td style="text-align:right;"> 0.003 </td>
   <td style="text-align:right;"> 0.024 </td>
   <td style="text-align:right;"> 0.041 </td>
   <td style="text-align:right;"> 0.079 </td>
   <td style="text-align:right;"> 0.079 </td>
   <td style="text-align:right;"> 0.079 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1997 </td>
   <td style="text-align:right;"> 0.004 </td>
   <td style="text-align:right;"> 0.030 </td>
   <td style="text-align:right;"> 0.052 </td>
   <td style="text-align:right;"> 0.100 </td>
   <td style="text-align:right;"> 0.100 </td>
   <td style="text-align:right;"> 0.100 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1998 </td>
   <td style="text-align:right;"> 0.016 </td>
   <td style="text-align:right;"> 0.108 </td>
   <td style="text-align:right;"> 0.189 </td>
   <td style="text-align:right;"> 0.362 </td>
   <td style="text-align:right;"> 0.362 </td>
   <td style="text-align:right;"> 0.362 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1999 </td>
   <td style="text-align:right;"> 0.004 </td>
   <td style="text-align:right;"> 0.025 </td>
   <td style="text-align:right;"> 0.044 </td>
   <td style="text-align:right;"> 0.084 </td>
   <td style="text-align:right;"> 0.084 </td>
   <td style="text-align:right;"> 0.084 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2000 </td>
   <td style="text-align:right;"> 0.004 </td>
   <td style="text-align:right;"> 0.029 </td>
   <td style="text-align:right;"> 0.051 </td>
   <td style="text-align:right;"> 0.097 </td>
   <td style="text-align:right;"> 0.097 </td>
   <td style="text-align:right;"> 0.097 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2001 </td>
   <td style="text-align:right;"> 0.008 </td>
   <td style="text-align:right;"> 0.052 </td>
   <td style="text-align:right;"> 0.091 </td>
   <td style="text-align:right;"> 0.175 </td>
   <td style="text-align:right;"> 0.175 </td>
   <td style="text-align:right;"> 0.175 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2002 </td>
   <td style="text-align:right;"> 0.006 </td>
   <td style="text-align:right;"> 0.039 </td>
   <td style="text-align:right;"> 0.067 </td>
   <td style="text-align:right;"> 0.129 </td>
   <td style="text-align:right;"> 0.129 </td>
   <td style="text-align:right;"> 0.129 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2003 </td>
   <td style="text-align:right;"> 0.012 </td>
   <td style="text-align:right;"> 0.086 </td>
   <td style="text-align:right;"> 0.150 </td>
   <td style="text-align:right;"> 0.288 </td>
   <td style="text-align:right;"> 0.288 </td>
   <td style="text-align:right;"> 0.288 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2004 </td>
   <td style="text-align:right;"> 0.024 </td>
   <td style="text-align:right;"> 0.168 </td>
   <td style="text-align:right;"> 0.292 </td>
   <td style="text-align:right;"> 0.561 </td>
   <td style="text-align:right;"> 0.561 </td>
   <td style="text-align:right;"> 0.561 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2005 </td>
   <td style="text-align:right;"> 0.007 </td>
   <td style="text-align:right;"> 0.048 </td>
   <td style="text-align:right;"> 0.084 </td>
   <td style="text-align:right;"> 0.162 </td>
   <td style="text-align:right;"> 0.162 </td>
   <td style="text-align:right;"> 0.162 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:right;"> 0.007 </td>
   <td style="text-align:right;"> 0.046 </td>
   <td style="text-align:right;"> 0.081 </td>
   <td style="text-align:right;"> 0.155 </td>
   <td style="text-align:right;"> 0.155 </td>
   <td style="text-align:right;"> 0.155 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2007 </td>
   <td style="text-align:right;"> 0.002 </td>
   <td style="text-align:right;"> 0.015 </td>
   <td style="text-align:right;"> 0.026 </td>
   <td style="text-align:right;"> 0.049 </td>
   <td style="text-align:right;"> 0.049 </td>
   <td style="text-align:right;"> 0.049 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2008 </td>
   <td style="text-align:right;"> 0.003 </td>
   <td style="text-align:right;"> 0.022 </td>
   <td style="text-align:right;"> 0.038 </td>
   <td style="text-align:right;"> 0.074 </td>
   <td style="text-align:right;"> 0.074 </td>
   <td style="text-align:right;"> 0.074 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:right;"> 0.003 </td>
   <td style="text-align:right;"> 0.019 </td>
   <td style="text-align:right;"> 0.033 </td>
   <td style="text-align:right;"> 0.064 </td>
   <td style="text-align:right;"> 0.064 </td>
   <td style="text-align:right;"> 0.064 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:right;"> 0.002 </td>
   <td style="text-align:right;"> 0.013 </td>
   <td style="text-align:right;"> 0.022 </td>
   <td style="text-align:right;"> 0.042 </td>
   <td style="text-align:right;"> 0.042 </td>
   <td style="text-align:right;"> 0.042 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:right;"> 0.003 </td>
   <td style="text-align:right;"> 0.018 </td>
   <td style="text-align:right;"> 0.032 </td>
   <td style="text-align:right;"> 0.062 </td>
   <td style="text-align:right;"> 0.062 </td>
   <td style="text-align:right;"> 0.062 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:right;"> 0.002 </td>
   <td style="text-align:right;"> 0.014 </td>
   <td style="text-align:right;"> 0.024 </td>
   <td style="text-align:right;"> 0.046 </td>
   <td style="text-align:right;"> 0.046 </td>
   <td style="text-align:right;"> 0.046 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:right;"> 0.002 </td>
   <td style="text-align:right;"> 0.012 </td>
   <td style="text-align:right;"> 0.021 </td>
   <td style="text-align:right;"> 0.041 </td>
   <td style="text-align:right;"> 0.041 </td>
   <td style="text-align:right;"> 0.041 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:right;"> 0.003 </td>
   <td style="text-align:right;"> 0.019 </td>
   <td style="text-align:right;"> 0.033 </td>
   <td style="text-align:right;"> 0.064 </td>
   <td style="text-align:right;"> 0.064 </td>
   <td style="text-align:right;"> 0.064 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:right;"> 0.002 </td>
   <td style="text-align:right;"> 0.015 </td>
   <td style="text-align:right;"> 0.025 </td>
   <td style="text-align:right;"> 0.048 </td>
   <td style="text-align:right;"> 0.048 </td>
   <td style="text-align:right;"> 0.048 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:right;"> 0.001 </td>
   <td style="text-align:right;"> 0.007 </td>
   <td style="text-align:right;"> 0.011 </td>
   <td style="text-align:right;"> 0.022 </td>
   <td style="text-align:right;"> 0.022 </td>
   <td style="text-align:right;"> 0.022 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:right;"> 0.002 </td>
   <td style="text-align:right;"> 0.016 </td>
   <td style="text-align:right;"> 0.027 </td>
   <td style="text-align:right;"> 0.052 </td>
   <td style="text-align:right;"> 0.052 </td>
   <td style="text-align:right;"> 0.052 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:right;"> 0.002 </td>
   <td style="text-align:right;"> 0.016 </td>
   <td style="text-align:right;"> 0.028 </td>
   <td style="text-align:right;"> 0.054 </td>
   <td style="text-align:right;"> 0.054 </td>
   <td style="text-align:right;"> 0.054 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2019 </td>
   <td style="text-align:right;"> 0.000 </td>
   <td style="text-align:right;"> 0.002 </td>
   <td style="text-align:right;"> 0.004 </td>
   <td style="text-align:right;"> 0.007 </td>
   <td style="text-align:right;"> 0.007 </td>
   <td style="text-align:right;"> 0.007 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2020 </td>
   <td style="text-align:right;"> 0.007 </td>
   <td style="text-align:right;"> 0.051 </td>
   <td style="text-align:right;"> 0.089 </td>
   <td style="text-align:right;"> 0.170 </td>
   <td style="text-align:right;"> 0.170 </td>
   <td style="text-align:right;"> 0.170 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2021 </td>
   <td style="text-align:right;"> 0.003 </td>
   <td style="text-align:right;"> 0.023 </td>
   <td style="text-align:right;"> 0.039 </td>
   <td style="text-align:right;"> 0.075 </td>
   <td style="text-align:right;"> 0.075 </td>
   <td style="text-align:right;"> 0.075 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2022 </td>
   <td style="text-align:right;"> 0.001 </td>
   <td style="text-align:right;"> 0.005 </td>
   <td style="text-align:right;"> 0.008 </td>
   <td style="text-align:right;"> 0.015 </td>
   <td style="text-align:right;"> 0.015 </td>
   <td style="text-align:right;"> 0.015 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2023 </td>
   <td style="text-align:right;"> 0.033 </td>
   <td style="text-align:right;"> 0.228 </td>
   <td style="text-align:right;"> 0.398 </td>
   <td style="text-align:right;"> 0.763 </td>
   <td style="text-align:right;"> 0.763 </td>
   <td style="text-align:right;"> 0.763 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2024 </td>
   <td style="text-align:right;"> 0.038 </td>
   <td style="text-align:right;"> 0.263 </td>
   <td style="text-align:right;"> 0.458 </td>
   <td style="text-align:right;"> 0.878 </td>
   <td style="text-align:right;"> 0.878 </td>
   <td style="text-align:right;"> 0.878 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2025 </td>
   <td style="text-align:right;"> 0.037 </td>
   <td style="text-align:right;"> 0.257 </td>
   <td style="text-align:right;"> 0.448 </td>
   <td style="text-align:right;"> 0.860 </td>
   <td style="text-align:right;"> 0.860 </td>
   <td style="text-align:right;"> 0.860 </td>
  </tr>
</tbody>
</table>

### Fishing mortality at age by fleet

<table class="table" style="color: black; margin-left: auto; margin-right: auto;">
<caption>Total fishing mortality at age in Fleet 1.</caption>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> 1 </th>
   <th style="text-align:right;"> 2 </th>
   <th style="text-align:right;"> 3 </th>
   <th style="text-align:right;"> 4 </th>
   <th style="text-align:right;"> 5 </th>
   <th style="text-align:right;"> 6+ </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1973 </td>
   <td style="text-align:right;"> 0.052 </td>
   <td style="text-align:right;"> 0.361 </td>
   <td style="text-align:right;"> 0.628 </td>
   <td style="text-align:right;"> 1.206 </td>
   <td style="text-align:right;"> 1.206 </td>
   <td style="text-align:right;"> 1.206 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1974 </td>
   <td style="text-align:right;"> 0.044 </td>
   <td style="text-align:right;"> 0.302 </td>
   <td style="text-align:right;"> 0.526 </td>
   <td style="text-align:right;"> 1.010 </td>
   <td style="text-align:right;"> 1.010 </td>
   <td style="text-align:right;"> 1.010 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1975 </td>
   <td style="text-align:right;"> 0.022 </td>
   <td style="text-align:right;"> 0.151 </td>
   <td style="text-align:right;"> 0.263 </td>
   <td style="text-align:right;"> 0.504 </td>
   <td style="text-align:right;"> 0.504 </td>
   <td style="text-align:right;"> 0.504 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1976 </td>
   <td style="text-align:right;"> 0.037 </td>
   <td style="text-align:right;"> 0.256 </td>
   <td style="text-align:right;"> 0.446 </td>
   <td style="text-align:right;"> 0.855 </td>
   <td style="text-align:right;"> 0.855 </td>
   <td style="text-align:right;"> 0.855 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1977 </td>
   <td style="text-align:right;"> 0.047 </td>
   <td style="text-align:right;"> 0.325 </td>
   <td style="text-align:right;"> 0.567 </td>
   <td style="text-align:right;"> 1.087 </td>
   <td style="text-align:right;"> 1.087 </td>
   <td style="text-align:right;"> 1.087 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1978 </td>
   <td style="text-align:right;"> 0.014 </td>
   <td style="text-align:right;"> 0.098 </td>
   <td style="text-align:right;"> 0.171 </td>
   <td style="text-align:right;"> 0.328 </td>
   <td style="text-align:right;"> 0.328 </td>
   <td style="text-align:right;"> 0.328 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1979 </td>
   <td style="text-align:right;"> 0.019 </td>
   <td style="text-align:right;"> 0.132 </td>
   <td style="text-align:right;"> 0.230 </td>
   <td style="text-align:right;"> 0.442 </td>
   <td style="text-align:right;"> 0.442 </td>
   <td style="text-align:right;"> 0.442 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1980 </td>
   <td style="text-align:right;"> 0.009 </td>
   <td style="text-align:right;"> 0.065 </td>
   <td style="text-align:right;"> 0.114 </td>
   <td style="text-align:right;"> 0.218 </td>
   <td style="text-align:right;"> 0.218 </td>
   <td style="text-align:right;"> 0.218 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1981 </td>
   <td style="text-align:right;"> 0.025 </td>
   <td style="text-align:right;"> 0.175 </td>
   <td style="text-align:right;"> 0.305 </td>
   <td style="text-align:right;"> 0.586 </td>
   <td style="text-align:right;"> 0.586 </td>
   <td style="text-align:right;"> 0.586 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1982 </td>
   <td style="text-align:right;"> 0.026 </td>
   <td style="text-align:right;"> 0.176 </td>
   <td style="text-align:right;"> 0.307 </td>
   <td style="text-align:right;"> 0.588 </td>
   <td style="text-align:right;"> 0.588 </td>
   <td style="text-align:right;"> 0.588 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1983 </td>
   <td style="text-align:right;"> 0.019 </td>
   <td style="text-align:right;"> 0.132 </td>
   <td style="text-align:right;"> 0.231 </td>
   <td style="text-align:right;"> 0.443 </td>
   <td style="text-align:right;"> 0.443 </td>
   <td style="text-align:right;"> 0.443 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1984 </td>
   <td style="text-align:right;"> 0.036 </td>
   <td style="text-align:right;"> 0.248 </td>
   <td style="text-align:right;"> 0.432 </td>
   <td style="text-align:right;"> 0.829 </td>
   <td style="text-align:right;"> 0.829 </td>
   <td style="text-align:right;"> 0.829 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1985 </td>
   <td style="text-align:right;"> 0.034 </td>
   <td style="text-align:right;"> 0.234 </td>
   <td style="text-align:right;"> 0.407 </td>
   <td style="text-align:right;"> 0.782 </td>
   <td style="text-align:right;"> 0.782 </td>
   <td style="text-align:right;"> 0.782 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1986 </td>
   <td style="text-align:right;"> 0.014 </td>
   <td style="text-align:right;"> 0.095 </td>
   <td style="text-align:right;"> 0.165 </td>
   <td style="text-align:right;"> 0.317 </td>
   <td style="text-align:right;"> 0.317 </td>
   <td style="text-align:right;"> 0.317 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1987 </td>
   <td style="text-align:right;"> 0.029 </td>
   <td style="text-align:right;"> 0.201 </td>
   <td style="text-align:right;"> 0.350 </td>
   <td style="text-align:right;"> 0.671 </td>
   <td style="text-align:right;"> 0.671 </td>
   <td style="text-align:right;"> 0.671 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1988 </td>
   <td style="text-align:right;"> 0.020 </td>
   <td style="text-align:right;"> 0.140 </td>
   <td style="text-align:right;"> 0.243 </td>
   <td style="text-align:right;"> 0.467 </td>
   <td style="text-align:right;"> 0.467 </td>
   <td style="text-align:right;"> 0.467 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1989 </td>
   <td style="text-align:right;"> 0.015 </td>
   <td style="text-align:right;"> 0.102 </td>
   <td style="text-align:right;"> 0.178 </td>
   <td style="text-align:right;"> 0.342 </td>
   <td style="text-align:right;"> 0.342 </td>
   <td style="text-align:right;"> 0.342 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1990 </td>
   <td style="text-align:right;"> 0.033 </td>
   <td style="text-align:right;"> 0.231 </td>
   <td style="text-align:right;"> 0.402 </td>
   <td style="text-align:right;"> 0.771 </td>
   <td style="text-align:right;"> 0.771 </td>
   <td style="text-align:right;"> 0.771 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1991 </td>
   <td style="text-align:right;"> 0.030 </td>
   <td style="text-align:right;"> 0.205 </td>
   <td style="text-align:right;"> 0.357 </td>
   <td style="text-align:right;"> 0.685 </td>
   <td style="text-align:right;"> 0.685 </td>
   <td style="text-align:right;"> 0.685 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1992 </td>
   <td style="text-align:right;"> 0.018 </td>
   <td style="text-align:right;"> 0.127 </td>
   <td style="text-align:right;"> 0.222 </td>
   <td style="text-align:right;"> 0.426 </td>
   <td style="text-align:right;"> 0.426 </td>
   <td style="text-align:right;"> 0.426 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1993 </td>
   <td style="text-align:right;"> 0.025 </td>
   <td style="text-align:right;"> 0.174 </td>
   <td style="text-align:right;"> 0.304 </td>
   <td style="text-align:right;"> 0.583 </td>
   <td style="text-align:right;"> 0.583 </td>
   <td style="text-align:right;"> 0.583 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1994 </td>
   <td style="text-align:right;"> 0.044 </td>
   <td style="text-align:right;"> 0.303 </td>
   <td style="text-align:right;"> 0.528 </td>
   <td style="text-align:right;"> 1.014 </td>
   <td style="text-align:right;"> 1.014 </td>
   <td style="text-align:right;"> 1.014 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1995 </td>
   <td style="text-align:right;"> 0.009 </td>
   <td style="text-align:right;"> 0.061 </td>
   <td style="text-align:right;"> 0.107 </td>
   <td style="text-align:right;"> 0.205 </td>
   <td style="text-align:right;"> 0.205 </td>
   <td style="text-align:right;"> 0.205 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1996 </td>
   <td style="text-align:right;"> 0.003 </td>
   <td style="text-align:right;"> 0.024 </td>
   <td style="text-align:right;"> 0.041 </td>
   <td style="text-align:right;"> 0.079 </td>
   <td style="text-align:right;"> 0.079 </td>
   <td style="text-align:right;"> 0.079 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1997 </td>
   <td style="text-align:right;"> 0.004 </td>
   <td style="text-align:right;"> 0.030 </td>
   <td style="text-align:right;"> 0.052 </td>
   <td style="text-align:right;"> 0.100 </td>
   <td style="text-align:right;"> 0.100 </td>
   <td style="text-align:right;"> 0.100 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1998 </td>
   <td style="text-align:right;"> 0.016 </td>
   <td style="text-align:right;"> 0.108 </td>
   <td style="text-align:right;"> 0.189 </td>
   <td style="text-align:right;"> 0.362 </td>
   <td style="text-align:right;"> 0.362 </td>
   <td style="text-align:right;"> 0.362 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1999 </td>
   <td style="text-align:right;"> 0.004 </td>
   <td style="text-align:right;"> 0.025 </td>
   <td style="text-align:right;"> 0.044 </td>
   <td style="text-align:right;"> 0.084 </td>
   <td style="text-align:right;"> 0.084 </td>
   <td style="text-align:right;"> 0.084 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2000 </td>
   <td style="text-align:right;"> 0.004 </td>
   <td style="text-align:right;"> 0.029 </td>
   <td style="text-align:right;"> 0.051 </td>
   <td style="text-align:right;"> 0.097 </td>
   <td style="text-align:right;"> 0.097 </td>
   <td style="text-align:right;"> 0.097 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2001 </td>
   <td style="text-align:right;"> 0.008 </td>
   <td style="text-align:right;"> 0.052 </td>
   <td style="text-align:right;"> 0.091 </td>
   <td style="text-align:right;"> 0.175 </td>
   <td style="text-align:right;"> 0.175 </td>
   <td style="text-align:right;"> 0.175 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2002 </td>
   <td style="text-align:right;"> 0.006 </td>
   <td style="text-align:right;"> 0.039 </td>
   <td style="text-align:right;"> 0.067 </td>
   <td style="text-align:right;"> 0.129 </td>
   <td style="text-align:right;"> 0.129 </td>
   <td style="text-align:right;"> 0.129 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2003 </td>
   <td style="text-align:right;"> 0.012 </td>
   <td style="text-align:right;"> 0.086 </td>
   <td style="text-align:right;"> 0.150 </td>
   <td style="text-align:right;"> 0.288 </td>
   <td style="text-align:right;"> 0.288 </td>
   <td style="text-align:right;"> 0.288 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2004 </td>
   <td style="text-align:right;"> 0.024 </td>
   <td style="text-align:right;"> 0.168 </td>
   <td style="text-align:right;"> 0.292 </td>
   <td style="text-align:right;"> 0.561 </td>
   <td style="text-align:right;"> 0.561 </td>
   <td style="text-align:right;"> 0.561 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2005 </td>
   <td style="text-align:right;"> 0.007 </td>
   <td style="text-align:right;"> 0.048 </td>
   <td style="text-align:right;"> 0.084 </td>
   <td style="text-align:right;"> 0.162 </td>
   <td style="text-align:right;"> 0.162 </td>
   <td style="text-align:right;"> 0.162 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006 </td>
   <td style="text-align:right;"> 0.007 </td>
   <td style="text-align:right;"> 0.046 </td>
   <td style="text-align:right;"> 0.081 </td>
   <td style="text-align:right;"> 0.155 </td>
   <td style="text-align:right;"> 0.155 </td>
   <td style="text-align:right;"> 0.155 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2007 </td>
   <td style="text-align:right;"> 0.002 </td>
   <td style="text-align:right;"> 0.015 </td>
   <td style="text-align:right;"> 0.026 </td>
   <td style="text-align:right;"> 0.049 </td>
   <td style="text-align:right;"> 0.049 </td>
   <td style="text-align:right;"> 0.049 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2008 </td>
   <td style="text-align:right;"> 0.003 </td>
   <td style="text-align:right;"> 0.022 </td>
   <td style="text-align:right;"> 0.038 </td>
   <td style="text-align:right;"> 0.074 </td>
   <td style="text-align:right;"> 0.074 </td>
   <td style="text-align:right;"> 0.074 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:right;"> 0.003 </td>
   <td style="text-align:right;"> 0.019 </td>
   <td style="text-align:right;"> 0.033 </td>
   <td style="text-align:right;"> 0.064 </td>
   <td style="text-align:right;"> 0.064 </td>
   <td style="text-align:right;"> 0.064 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:right;"> 0.002 </td>
   <td style="text-align:right;"> 0.013 </td>
   <td style="text-align:right;"> 0.022 </td>
   <td style="text-align:right;"> 0.042 </td>
   <td style="text-align:right;"> 0.042 </td>
   <td style="text-align:right;"> 0.042 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:right;"> 0.003 </td>
   <td style="text-align:right;"> 0.018 </td>
   <td style="text-align:right;"> 0.032 </td>
   <td style="text-align:right;"> 0.062 </td>
   <td style="text-align:right;"> 0.062 </td>
   <td style="text-align:right;"> 0.062 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:right;"> 0.002 </td>
   <td style="text-align:right;"> 0.014 </td>
   <td style="text-align:right;"> 0.024 </td>
   <td style="text-align:right;"> 0.046 </td>
   <td style="text-align:right;"> 0.046 </td>
   <td style="text-align:right;"> 0.046 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:right;"> 0.002 </td>
   <td style="text-align:right;"> 0.012 </td>
   <td style="text-align:right;"> 0.021 </td>
   <td style="text-align:right;"> 0.041 </td>
   <td style="text-align:right;"> 0.041 </td>
   <td style="text-align:right;"> 0.041 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:right;"> 0.003 </td>
   <td style="text-align:right;"> 0.019 </td>
   <td style="text-align:right;"> 0.033 </td>
   <td style="text-align:right;"> 0.064 </td>
   <td style="text-align:right;"> 0.064 </td>
   <td style="text-align:right;"> 0.064 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:right;"> 0.002 </td>
   <td style="text-align:right;"> 0.015 </td>
   <td style="text-align:right;"> 0.025 </td>
   <td style="text-align:right;"> 0.048 </td>
   <td style="text-align:right;"> 0.048 </td>
   <td style="text-align:right;"> 0.048 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:right;"> 0.001 </td>
   <td style="text-align:right;"> 0.007 </td>
   <td style="text-align:right;"> 0.011 </td>
   <td style="text-align:right;"> 0.022 </td>
   <td style="text-align:right;"> 0.022 </td>
   <td style="text-align:right;"> 0.022 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:right;"> 0.002 </td>
   <td style="text-align:right;"> 0.016 </td>
   <td style="text-align:right;"> 0.027 </td>
   <td style="text-align:right;"> 0.052 </td>
   <td style="text-align:right;"> 0.052 </td>
   <td style="text-align:right;"> 0.052 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:right;"> 0.002 </td>
   <td style="text-align:right;"> 0.016 </td>
   <td style="text-align:right;"> 0.028 </td>
   <td style="text-align:right;"> 0.054 </td>
   <td style="text-align:right;"> 0.054 </td>
   <td style="text-align:right;"> 0.054 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2019 </td>
   <td style="text-align:right;"> 0.000 </td>
   <td style="text-align:right;"> 0.002 </td>
   <td style="text-align:right;"> 0.004 </td>
   <td style="text-align:right;"> 0.007 </td>
   <td style="text-align:right;"> 0.007 </td>
   <td style="text-align:right;"> 0.007 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2020 </td>
   <td style="text-align:right;"> 0.007 </td>
   <td style="text-align:right;"> 0.051 </td>
   <td style="text-align:right;"> 0.089 </td>
   <td style="text-align:right;"> 0.170 </td>
   <td style="text-align:right;"> 0.170 </td>
   <td style="text-align:right;"> 0.170 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2021 </td>
   <td style="text-align:right;"> 0.003 </td>
   <td style="text-align:right;"> 0.023 </td>
   <td style="text-align:right;"> 0.039 </td>
   <td style="text-align:right;"> 0.075 </td>
   <td style="text-align:right;"> 0.075 </td>
   <td style="text-align:right;"> 0.075 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2022 </td>
   <td style="text-align:right;"> 0.001 </td>
   <td style="text-align:right;"> 0.005 </td>
   <td style="text-align:right;"> 0.008 </td>
   <td style="text-align:right;"> 0.015 </td>
   <td style="text-align:right;"> 0.015 </td>
   <td style="text-align:right;"> 0.015 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2023 </td>
   <td style="text-align:right;"> 0.033 </td>
   <td style="text-align:right;"> 0.228 </td>
   <td style="text-align:right;"> 0.398 </td>
   <td style="text-align:right;"> 0.763 </td>
   <td style="text-align:right;"> 0.763 </td>
   <td style="text-align:right;"> 0.763 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2024 </td>
   <td style="text-align:right;"> 0.038 </td>
   <td style="text-align:right;"> 0.263 </td>
   <td style="text-align:right;"> 0.458 </td>
   <td style="text-align:right;"> 0.878 </td>
   <td style="text-align:right;"> 0.878 </td>
   <td style="text-align:right;"> 0.878 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2025 </td>
   <td style="text-align:right;"> 0.037 </td>
   <td style="text-align:right;"> 0.257 </td>
   <td style="text-align:right;"> 0.448 </td>
   <td style="text-align:right;"> 0.860 </td>
   <td style="text-align:right;"> 0.860 </td>
   <td style="text-align:right;"> 0.860 </td>
  </tr>
</tbody>
</table>
