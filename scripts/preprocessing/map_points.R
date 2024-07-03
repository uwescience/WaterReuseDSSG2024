
#To do: separate types of files? vastly different needs when mapping shapefiles vs. other types of files
map_points <- function(shape_file, variable_data, location_columns, variable_names) {
  # Args: 
    #shapefile: optional file path providing relevant boundaries e.g state, county, HUC. If no file to provide, write FALSE 
    #data: data points to be visualized on the map 
    #location_columns: a list of column names (strings) that contain location data e.g c('lat', 'lon') or c('State')
    #variable_name: a list of column names (string) that contain the variables of interest to be mapped e.g c('saltwater', 'Population Total')
  # Outputs; 
    #Points on a map of the U.S. Will produce a map for each variable name listed in variable_names
  require(usmap)
  
  for (variable in variable_names) {
    if (length(location_columns) > 0) {
      # Read and convert files to shapefiles 
      if (shape_file) {
        shape_file_sf <- sf::st_read(system.file(shape_file, package="sf"))
      }
      data_sf <- st_as_sf(variable_data, coords = location_columns, crs = st_crs(4326))
      
      # Plot combined data
      p<- ggplot() +
        #geom_sf(data = shape_file_sf, fill = "lightblue", color = "black") +
        geom_sf(data = data_sf, color = "red") +
        theme_minimal() +
        labs(title = "Mapping the United States",
             subtitle = variable,
             x = "Longitude",
             y = "Latitude")
      print(p)
    } else {
      #shape_file_df <- st_transform(variable_data, crs = 4326)
        p <- usmap::plot_usmap() +
          geom_point(data = variable_data, aes(x = location_columns[1], y = location_columns[2])) + 
          theme_minimal()
        print(p)
    }
  }
}

library(pacman)
p_load(tidycensus,tidyverse,sf,data.table,tigris,
       srvyr,survey,rio,car,janitor,rmapshaper,scales,santoku,viridis, urbnmapr, usmap)

cwns <- read_csv('Downloads/cwns-flow.csv')

map_points(FALSE, cwns, c('LATITUDE', 'LONGITUDE'), FALSE)
