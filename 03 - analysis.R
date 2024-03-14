library(analysistools)
library(tidyverse)
library(srvyr)

sheet_names <- readxl::excel_sheets(path = "outputs/02 - composition/data.list.xlsx")
data.list <- map(sheet_names, ~readxl::read_excel("outputs/02 - composition/data.list.xlsx", sheet = .x)) %>% 
  set_names(sheet_names)

my_loa<- readxl::read_xlsx("inputs/daf_example (1).xlsx")

loa_list <- purrr::map(data.list, ~dplyr::filter(my_loa, analysis_var %in% names(.x)))

design_list <- map(data.list, ~srvyr::as_survey_design(.x))


results_analysis <- map2(design_list, loa_list, ~create_analysis(design = .x, loa =.y, sm_separator = "/"))

results_analysis %>% 
  write_rds("outputs/03 - analysis/all_analysis.rds")
full_results_table <- results_analysis %>% 
  map(\(x) x[["results_table"]]) %>% 
  bind_rows()
full_results_table %>%  
  writexl::write_xlsx("outputs/03 - analysis/full_results_table.xlsx")
results_analysis %>% 
  map(\(x) x[["dataset"]]) %>% 
  writexl::write_xlsx("outputs/03 - analysis/dataset_with_indicators.xlsx")
results_analysis %>% 
  map(\(x) x[["loa"]]) %>% 
  writexl::write_xlsx("outputs/03 - analysis/dataset_with_indicators.xlsx")
