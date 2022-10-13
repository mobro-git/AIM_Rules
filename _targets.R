library(targets)
library(tarchetypes)

source("packages.R")

devtools::load_all(".") # load all function definitions in /R

# Set target-specific options such as packages.
tar_option_set(
  packages = c("dplyr","readr","tidyverse","datasets"), # packages to make available to targets
  imports = "AIM_Rules" # watch changes in these functions to invalidate targets
)

# End this file with a list of target objects.
tar_plan(
  
  config_allocation = list(),
  config_transition = list(),
  
  ##### External Data ----------------
  
  # ACS Data
  tar_target(acs_data_rdata, "data/acs_data/acs_data_2019_block group.Rdata", format = "file"),
  tar_target(acs_data, {
    load(acs_data_rdata)
    data}),
  
  tar_target(acs_data_ct, {
    # add the census tract to the data in case the geography is a lower resolution
    data_ct <- acs_data %>% mutate(Tract=substr(GEOID,1,11))}),
  
  tar_target(acs_shp, {
    # get the geography geometry from the acs data
    acs_shp = acs_data_ct %>%
      filter(variable=="pop") %>%
      select(GEOID,Tract) %>%
      arrange(GEOID) %>%
      st_transform(3488)}),
  
  # NATA Data
  tar_target(nata_data_xlsx, "data/nata_data/national_cancerrisk_by_tract_poll.xlsx", format = "file"),
  tar_target(nata_data, {read_excel(nata_data_xlsx) %>% rename(total_risk='Total Risk\r\n (in a million)')}),
  
  tar_target(nata_data_resp_xlsx, "data/nata_data/national_resphi_by_tract_poll.xlsx", format = "file"),
  tar_target(nata_data_resp, {
    read_excel(nata_data_resp_xlsx) %>%
      rename(total_risk_resp='Total Respiratory (hazard quotient)') %>%
      select(Tract, total_risk_resp)}),
  
  # TRI Facilities
  tar_target(tri_facilities_csv, "data/tri_data/tri_2020_us.csv", format = "file"),
  tri_facilities = read_csv(tri_facilities_csv),
  
  # NEI Facilities
  tar_target(nei_facilities_csv, "data/2019 point selected OAP facilities 20663.xlsx", format = "file"),
  nei_facilities = read_xlsx(nei_facilities_csv),
  
  # Urban Areas and Tracts
  tar_target(uac, {
    urban_areas <- urban_areas() 
    uac <- urban_areas %>% st_transform(3488)}),
  
  tar_target(urban_tracts, {urban_tracts(acs_shp, uac)}),
  
  # tar_target(urban_tracts_rds, "data/urban_tracts.rds", format = "file"),
  # urban_tracts = readRDS(urban_tracts_rds),
  
  tar_target(sq_miles, {
    sq_miles_1 <- acs_shp %>% 
      mutate(sq_miles = units::set_units(st_area(shp),"mi^2")) %>%
      select(GEOID,sq_miles)
    
    units(sq_miles$sq_miles) <- NULL
    
    sq_miles <- sq_miles_1 %>% st_set_geometry(NULL) %>% as.data.table() %>% setkey('GEOID')}),
  
  ##### Allocation Rule ----------------
  
  tar_target(allocation_facilities_xlsx, 
             "data/facilities_data/Allocation_Final_list production facilities 2022.xlsx", 
             format = "file"),
  tar_target(allocation_facilities,{
    read_excel(allocation_facilities_xlsx) %>%
      rename(Latitude = LATITUDE,
             Longitude = LONGITUDE,
             GHG_co2e = `GHG QUANTITY (METRIC TONS CO2e)`,
             City = `CITY NAME`,
             State = STATE) %>%
      mutate(Label = `FACILITY NAME`) %>%
      select(Longitude,Latitude,everything()) %>%
      filter(Label != "CHEMOURS CHAMBERS WORKS")}),
  
  tar_target(allocation_facilities_map, {
    facilities_map(allocation_facilities, uac)}),
  
  tar_target(allocation_facilities_ghg_map, {
    facilities_ghg_map(
      allocation_facilities_map,
      c(.northeast_region,.south_region,.north_central_region),
      "allocation")}),
  
  ##### Transitions Rule ----------------
  
  tar_target(transition_facilities_xlsx, 
             "data/facilities_data/hfc_facilities-4-8-22_w_additions V2_frsID_updatedlatlon.xlsx", 
             format = "file"),
  tar_target(transition_facilities, {
    read_excel(transition_facilities_xlsx) %>%
      select(Longitude,Latitude,everything()) %>%
      rename(GHG_co2e = `2020  GHG`)})
  
)

