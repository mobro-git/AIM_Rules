
facilities_map <- function(facilities, uac) {
  
  facilities_lat_lon <- facilities %>% 
    select(Longitude,Latitude,Label) %>%
    rename(lon = Longitude,
           lat = Latitude) 
  
  facilities_sf = st_as_sf(facilities, 
                           coords=c(x="Longitude",y="Latitude"), 
                           crs=4326) %>%
    st_transform(3488) 
  
  ### Indicating rural vs urban facilities. 1 = rural, 0 = urban
  
  facilities_sf_urban <- st_intersection(facilities_sf,uac) %>%
    mutate(rural = 0)
  
  facilities_sf_rural <- facilities_sf %>%
    mutate(rural = fifelse(Label %in% unique(facilities_sf_urban$Label),0,1)) %>%
    as.data.frame() %>%
    select(rural,Label)
  
  facilities_map <- facilities_sf %>%
    left_join(facilities_sf_rural, by = "Label") %>%
    left_join(facilities_lat_lon, by = "Label")
  
}

  
  




