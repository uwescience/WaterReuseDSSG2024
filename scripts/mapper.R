# This function will use all the mapping functions we created to map
# any kind of maps
source("map_utils/map_utils.R")
source("scripts/get_shapes.R")
library(tidyverse)
library(readxl)
library(tigris)

mapper <- function(data, shapefile, location_columns = NULL, 
                   variable_names, data_key, shape_key, 
                   variable = variable_names, plot_all = TRUE, plot, 
                   map_path = NULL){
  require(tidyverse)
  if (plot_all == TRUE){
    if (is.null(location_columns)){
      chrolo_map = map_chloropleth(data, shapefile, data_key, 
                                   shape_key, variable = variable_names)
      ggsave(filename = "chloropleth_map.png", path = map_path, device = "png")
      print("The coordinate are needed to plot the points")
    } else {
      chrolo_map = map_chloropleth(data, shapefile, data_key, 
                                   shape_key, variable = variable_names, map_title)
      point_map = map_points(shapefile, data, location_columns, 
                             variable_names)
      ggsave(filename = "chloropleth_map.png", plot = chrolo_map, path = map_path, device = "png")
      ggsave(filename = "point_map.png", plot = point_map, path = map_path, device = "png")
      
    }
    
  } else if (tolower(plot) == "chloropleth"){
    chrolo_map = map_chloropleth(data, shapefile, data_key, shape_key, variable = variable_names, map_title)
    ggsave(filename = "chloropleth_map.png", path = map_path, device = "png")
    
  } else if (tolower(plot) == "points"){
    point_map = map_points(shapefile, data, location_columns, variable_names)
    ggsave(filename = "chloropleth_map.png", path = map_path, device = "png")
    
    
  } else {
    print("The map you specified cannot be plotted at the moment.")
  }
  
}

# test_data <- read_csv("datasets/Found_dataset/location_assignee.csv")
# 
# data_shapefile <- get_shapes(test_data, "LONGITUDE", "LATITUDE")
# mapper(test_data, shapefile = data_shapefile, data_key = NULL, shape_key = NULL, variable_names = "CURRENT_DESIGN_FLOW")


test_data2 <- read_xlsx("datasets/Drivers/multiyear drought risk/final_results_dissemination_NDINDC.xlsx", sheet = 1)
test_data2$FIPS <- as.character(test_data2$FIPS)
shapefile2 <- tigris::counties(year = 2023)

mapper(data = test_data2, shapefile = shapefile2, data_key = "FIPS", shape_key = "GEOID",
       variable_names = "NDI", map_path = "maps")
hold2 <- map_chloropleth(data = test_data2, shapefile = shapefile2, data_key = "FIPS", shape_key = "GEOID", variable = "NDI")
