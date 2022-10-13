
urban_tracts <- function(acs_shp, uac) {
  
  tr <- acs_shp %>% group_by(Tract) %>% summarize(geometry=st_union(geometry))
  saveRDS(tr, "data/tr.rds")
  
  tr_pts <- tr %>% st_centroid()
  
  urban_tracts <- st_intersection(tr_pts,uac)
  saveRDS(urban_tracts,"data/urban_tracts.rds")
  
}

