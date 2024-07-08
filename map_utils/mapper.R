# This function will use all the mapping functions we created to map
# any kind of maps

mapper <- function(data, shapefile, location_columns = NULL, 
                   variable_names, data_key, shape_key, 
                   variable = variable_names, plot_all = TRUE, plot, 
                   map_path = NULL){
  require(tidyverse)
  source("map_utils/map_utils.R")
  source("scripts/get_shapes.R")
  if (plot_all == TRUE){
    if (is.null(location_columns)){
      chrolo_map = map_chloropleth(data, shapefile, data_key, 
                                   shape_key, variable = variable_names)
      ggsave(filename = paste0(variable_names, ".png"), path = map_path, device = "png")
      print("The coordinate are needed to plot the points")
    } else {
      chrolo_map = map_chloropleth(data, shapefile, data_key, 
                                   shape_key, variable = variable_names, map_title)
      point_map = map_points(shapefile, data, location_columns, 
                             variable_names)
      ggsave(filename = paste0(variable_names, ".png"), plot = chrolo_map, path = map_path, device = "png")
      ggsave(filename = paste0(variable_names, ".png"), plot = point_map, path = map_path, device = "png")
      
    }
    
  } else if (tolower(plot) == "chloropleth"){
    chrolo_map = map_chloropleth(data, shapefile, data_key, shape_key, variable = variable_names, map_title)
    ggsave(filename = paste0(variable_names, ".png"), path = map_path, device = "png")
    
  } else if (tolower(plot) == "points"){
    point_map = map_points(shapefile, data, location_columns, variable_names)
    ggsave(filename = paste0(variable_names, ".png"), path = map_path, device = "png")
    
    
  } else {
    print("The map you specified cannot be plotted at the moment.")
  }
  
}
