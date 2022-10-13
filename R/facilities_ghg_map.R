
facilities_ghg_map <- function(facilities_map, regions, rule) {
  
  facilities_map_t <- usmap_transform(facilities_map)
  
  fac_map <- plot_usmap(include=regions,
                        labels=TRUE, 
                        fill = "#C5CFE3", 
                        alpha = 0.5) +
    ggrepel::geom_label_repel(data = facilities_map_t,
                              aes(x = x, y = y, 
                                  label = Label),
                              size = 5, alpha = 0.8,
                              label.r = unit(0.5, "lines"), label.size = 0.5,
                              segment.color = "#C60404", segment.size = 1,
                              seed = 1002) +
    geom_point(data = facilities_map_t,
               aes(x = x, y = y, size = GHG_co2e),
               color = "purple", alpha = 0.5) +
    geom_point(data = facilities_map_t,
               aes(x = x, y = y),
               color = "#C60404") +
    scale_size_continuous(range = c(1, 16),
                          label = scales::comma) +
    labs(size = expression("GHG Releases (mt CO"[2]*"e)")) +
    theme(legend.position = c(0.85, 0.1))
  
  fac_map
  
  ggsave(paste("output/",rule,"_rule/",rule,"_rule_facilities_map.png", sep=""), fac_map, width = 10, height = 6)

}





