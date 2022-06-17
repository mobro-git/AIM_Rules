library(targets)
library(tarchetypes)

source("packages.R")

devtools::load_all(".") # load all function definitions in /R

# Set target-specific options such as packages.
tar_option_set(
  packages = c("dplyr","readr","tidyverse","datasets"), # packages to make available to targets
  imports = "AIMRules" # watch changes in these functions to invalidate targets
)

# End this file with a list of target objects.
tar_plan(
  
  config_allocation = list(
    
  ),
  
  config_transition = list(
    
  ),
  
  ##### External Data ----------------
  
  tar_target(acs_data_rdata, "data/acs_data/acs_data_2019_block group.Rdata", format = "file"),
  acs_data = load(acs_data_rdata),
  
  tar_target(nata_data_xlsx, "data/nata_data/national_cancerrisk_by_tract_poll.xlsx", format = "file"),
  tar_target(nata_data, {read_excel(nata_data_xlsx) %>% rename(total_risk='Total Risk\r\n (in a million)')}),
  
  tar_target(nata_data_resp_xlsx, "data/nata_data/national_resphi_by_tract_poll.xlsx", format = "file"),
  tar_target(nata_data_resp, {
    read_excel(nata_data_resp_xlsx) %>%
      rename(total_risk_resp='Total Respiratory (hazard quotient)') %>%
      select(Tract, total_risk_resp)}),
  
  tar_target(tri_facilities_csv, "data/tri_data/tri_2020_us.csv", format = "file"),
  tri_facilities = read_csv(tri_facilities_csv),
  
  tar_target(nei_facilities_csv, "data/2019 point selected OAP facilities 20663.xlsx", format = "file"),
  nei_facilities = read_xlsx(nei_facilities_csv),
  
  ##### Allocation Rule ----------------
  
  tar_target(allocation_facilities_xlsx, "data/facilities_data/Allocation_Final_list production facilities 2022.xlsx", format = "file"),
  allocation_facilities = read_xlsx(allocation_facilities_xlsx),
  
  ##### Transitions Rule ----------------
  
  tar_target(transition_facilities_xlsx, "data/facilities_data/hfc_facilities-4-8-22_w_additions V2_frsID_updatedlatlon.xlsx", format = "file"),
  transition_facilities = read_xlsx(transition_facilities_xlsx),
  
  
)
