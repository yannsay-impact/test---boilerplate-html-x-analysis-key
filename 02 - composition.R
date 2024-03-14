library(tidyverse)

sheet_names <- readxl::excel_sheets(path = "inputs/IPHRA_COUNTRY_CODE_final_anonymized_data240311.xlsx")
data.list <- map(sheet_names, ~readxl::read_excel("inputs/IPHRA_COUNTRY_CODE_final_anonymized_data240311.xlsx",
                                              sheet = .x)) %>% 
  set_names(sheet_names)

strings <- data.frame('population_estimation' = 100000)

source("R/format_dataset.R")

my_loa<- readxl::read_xlsx("inputs/daf_example (1).xlsx")

loa_list <- purrr::map(data.list, ~dplyr::filter(my_loa, analysis_var %in% names(.x)))
num_var_list <- map(loa_list, \(x) x %>% filter(analysis_type == "mean") %>% pull(analysis_var) %>% unique())
data.list <- map2(.x = data.list, .y = num_var_list, 
                  ~mutate(.x,across(.cols = any_of(.y), .fns = as.numeric)))

saveRDS(data.list, "outputs/02 - composition/data.list.rds")
writexl::write_xlsx(data.list, "outputs/02 - composition/data.list.xlsx")
