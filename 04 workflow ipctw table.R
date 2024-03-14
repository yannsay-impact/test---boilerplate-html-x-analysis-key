library(analysistools)
library(tidyverse)
library(srvyr)
library(presentresults)

## part 1 checks 
## part 2 cleaning 
## part 3 composition
data_main<- readxl::read_excel("outputs/02 - composition/data.list.xlsx")
data_main$fcs_condiments <- as.numeric(data_main$fcs_condiments)

## part 4 analysis
ipctw_loa <- read.csv("inputs/ipctwg_table_loa.csv")
ipctw_table_design <- srvyr::as_survey_design(data_main)

ipctw_table_results_analysis <- create_analysis(design = ipctw_table_design, loa =ipctw_loa, sm_separator = "/")

## part 5 outputs
no_na_rows <- ipctw_table_results_analysis$results_table %>% filter(!(analysis_type == "prop_select_one" & is.na(analysis_var_value)))
example_ipc <- create_ipctwg_table(
  results_table = no_na_rows,
  dataset = data_main,
  cluster_name = "cluster",
  fclc_matrix_var = "fclcm_phase",
  fclc_matrix_values = c("Phase 1 FCLC", "Phase 2 FCLC", "Phase 3 FCLC", "Phase 4 FCLC", "Phase 5 FCLC"),
  fc_matrix_var = "fc_phase",
  fc_matrix_values = c("Phase 1 FC", "Phase 2 FC", "Phase 3 FC", "Phase 4 FC", "Phase 5 FC"),
  with_fclc = TRUE,
  fcs_set = c("fcs_cereal", "fcs_legumes", "fcs_dairy",
              "fcs_meat", "fcs_veg", "fcs_fruit",
              "fcs_oil", "fcs_sugar", "fcs_condiments"),
  rcsi_set = c("rcsi_lessquality", "rcsi_borrow", "rcsi_mealsize", "rcsi_mealadult",
               "rcsi_mealnb"),
  lcsi_set = c(
    "lcsi_stress1",
    "lcsi_stress2",
    "lcsi_stress3",
    "lcsi_stress4",
    "lcsi_crisis1",
    "lcsi_crisis2",
    "lcsi_crisis3",
    "lcsi_emergency1",
    "lcsi_emergency2",
    "lcsi_emergency3"
  )
)
example_ipc %>% 
  create_xlsx_group_x_variable(table_name = "ipctwg_table", 
                               file_path = "outputs/04 - ipctwtable/ipc_table.xlsx", 
                               overwrite = T)





