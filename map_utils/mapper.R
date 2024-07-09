# This function will use all the mapping functions we created to map
# any kind of maps

mapper <- function(data = NULL, shapefile = NULL, 
                   location_columns = NULL, 
                   variable_name = NULL,
                   data_key = NULL, 
                   shape_key = NULL, 
                   plot_all = FALSE, 
                   plot = NULL, 
                   map_path, 
                   map_title = NULL,
                   map_caption="Caption",
                   map_percentile=FALSE, 
                   low_color = "white", 
                   high_color = "red",
                   na_color = "gray",
                   map_font = "Arial",
                   base_unit = NULL){
  # data: The dataset that contains the column of interest
  # shapefile: A shapefile with FIPS
  # location: a vector of column names of the coordinates
  # variable_name: A column name of the variable of interest.
  # data_key: A key in the data table that can be used to merge with the shapefiles e.g. FIPS
  # shape_key: A key in the shapefile use to my with data e.g. GEOID
  # plot_all: if TRUE, it maps both the choropleth and points if all the required variables are available
  # plot: Takes either "choropleth" or "points" to specify either points or choropleth
  # map_path: Specify a folder path where you will save the maps
  # map_title: A string of the title of the map.
  # base_unit: a string with the base unit to be drawn on the usmap e.g 'counties'
  
  # Get the required packages and functions
  require(tidyverse)
  require(usmap)
  source("map_utils/map_utils.R")
  source("map_utils/get_shapes.R")
  source("map_utils/map_points.R")
  if (plot_all == TRUE){
    if (is.null(location_columns)){
      choro_map = map_choropleth(data, shapefile, data_key, 
                                 shape_key, variable = variable_name,
                                 map_title, map_caption="Caption",
                                 map_percentile, low_color, 
                                 high_color, na_color, map_font)
      ggsave(filename = paste0(variable_name, ".png"), plot = choro_map,
             path = map_path, device = "png")
      print("The coordinate are needed to plot the points")
    } else {
      choro_map = map_choropleth(data, shapefile, data_key, 
                                 shape_key, variable = variable_name,
                                 map_title, map_caption="Caption",
                                 map_percentile, low_color, 
                                 high_color, na_color, map_font)
      point_map = map_points(shapefile, data, location_columns, 
                             variable_name, base_unit)
      ggsave(filename = paste0(variable_name, ".png"), 
             plot = choro_map, path = map_path, device = "png")
      ggsave(filename = paste0(variable_name, ".png"), 
             plot = point_map, path = map_path, device = "png")
      
    }
    
  } else if (tolower(plot) == "choropleth"){
    choro_map = map_choropleth(data, shapefile, data_key, 
                               shape_key, variable = variable_name,
                               map_title, map_caption="Caption",
                               map_percentile, low_color, 
                               high_color, na_color, map_font)
    ggsave(filename = paste0(variable_name, ".png"),
           plot = choro_map, path = map_path, device = "png")
    
  } else if (tolower(plot) == "points"){
    point_map = map_points(shapefile, data, 
                           location_columns, variable_name, base_unit)
    ggsave(filename = paste0(variable_name, ".png"), 
           plot = point_map, path = map_path, device = "png")    
    
  } else {
    print("The map you specified cannot be plotted at the moment.")
  }
  
}


