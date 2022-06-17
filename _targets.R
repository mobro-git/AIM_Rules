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
  
  ##### Facilities ----------------
  
  tar_target(allocation_facilities_xlsx, "data/facilities_data/Allocation_Final_list production facilities 2022.xlsx", format = "file"),
  allocation_facilities = read_xlsx(allocation_facilities_xlsx),
  
  tar_target(transition_facilities_xlsx, "data/facilities_data/hfc_facilities-4-8-22_w_additions V2_frsID_updatedlatlon.xlsx", format = "file"),
  transition_facilities = read_xlsx(transition_facilities_xlsx),
  
)
