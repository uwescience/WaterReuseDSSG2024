
# There are 3 cases for inputs: 
# 1: Shapefile with a location label (str) AND a dataset with a location label (str). 
# 2: Dataset with lat, lon columns or a geometry containing lat. 
# 3: Shapefile that can automatically be mapped with usmap. Please check the package's location data requirements for this. 
map_points <- function(shapefile, data, location_columns, variable_name, base_unit) {
  
  # Args: 
  #shapefile: optional file path providing relevant boundaries e.g state, county, HUC. If no file to provide, write NULL 
  #data: dataset containing points to be visualized on the map 
  #location_columns: a list of column names (strings) that contain location data e.g c('lat', 'lon') or c('State')
  #variable_name: a list of column names (string) that contain the variables of interest to be mapped e.g c('saltwater', 'Population Total')
  #base_unit: a string with the base unit to be drawn on the usmap e.g 'counties'
  # Outputs; 
  #Points on a map of the U.S. Will produce a map for each variable name listed in variable_name
  
  #For case type 1 
  if (length(location_columns) == 1) {
    usmap <- usmap_transform(shapefile)
    plot_data <- usmap %>% left_join(data, by = location_columns[1], relationship = "many-to-many")
    
    p <- plot_usmap(base_unit, color = "gray80") + 
      geom_sf(data = plot_data, color = "lightblue", size = 0.2) +
      geom_point(data = plot_data,
                 aes(color = SWIVULN, size = SWIVULN, geometry = geometry),
                 alpha = 0.2,
                 color = "red",
                 stat = "sf_coordinates") +
      scale_size_continuous(name = "Saltwater Vulnerability",
                            labels = scales::comma_format(),
                            range = c(0.01, 7)) +
      scale_color_gradient(name = "Saltwater Vulnerability",
                           low = "bisque", high = "red") +
      theme(legend.position = "bottom") +
      labs(title = "Saltwater Vulnerability") +
      theme(text = element_text(family = "Times New Roman"))
    print(p)
    
    #For case type 2
  } else if (length(location_columns) == 2) {
    map_data <- data %>%
      select(location_columns[1], location_columns[2], variable_name) %>%
      rename(lat = location_columns[1], lon = location_columns[2]) %>%
      usmap_transform()
    
    # Plot combined data
    p <- usmap::plot_usmap() +
      geom_sf(data = map_data, color = "red") +
      theme_minimal() +
      labs(title = "Mapping the United States",
           subtitle = variable_name,
           x = "Longitude",
           y = "Latitude")
    print(p)
    
    #For case type 3
  } else if (is.null(location_columns)) {
    
    # Plot combined data
    shapefile <- shapefile %>%
      rename(lat = location_columns[1], lon = location_columns[2]) %>%
      usmap_transform()
    
    p <- usmap::plot_usmap() +
      geom_sf(data = shapefile, color = "red") +
      theme_minimal() +
      labs(title = "Mapping the United States",
           subtitle = variable_name,
           x = "Longitude",
           y = "Latitude")
    print(p)
  }
}
