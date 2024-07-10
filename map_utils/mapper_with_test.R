# This function will use all the mapping functions we created to map
# any kind of maps
source("map_utils/map_utils.R")
source("map_utils/get_shapes.R")
library(tidyverse)
library(readxl)
library(tigris)
# This function will use all the mapping functions we created to map
# any kind of maps
library(sf)
library(terra)

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



test_data2 <- read_xlsx("private/datasets/Drivers/multiyear drought risk/final_results_dissemination_NDINDC.xlsx", sheet = 1)
test_data2$FIPS <- as.character(test_data2$FIPS)
shapefile2 <- tigris::counties(year = 2023, filter_by = c(-124.7844079, -66.9513812, 24.7433195, 49.3457868))
test <-  counties(year = 2023)
mapper(data = test_data2, shapefile = shapefile2, 
       data_key = "FIPS", shape_key = "GEOID",
       variable_name = "NDI", map_path = "private/maps",
       plot_all = TRUE)


cos_vul <-  read_csv("private/datasets/Drivers/Saltwater Intrusion/SGD_Coastal_Vulnerabilities.csv")
catchment_shp <- vect("private/datasets/Mapping/Catchment_CONUS_coastline/Catchment_CONUS_coastline.shp")
catchment_shp <- st_as_sf(catchment_shp)

mapper(data = cos_vul, shapefile = catchment_shp, 
       variable_name =  "SWIVULN", plot = "points", plot_all = FALSE,
       map_path = "private/maps")
# Testing with the data provided by Carolyn
drought <-  read_csv("private/datasets/cleaned_data/drought_risk.csv")
mapper(data = drought, shapefile = shapefile2, shape_key = "GEOID",
       data_key = "FIPS", plot = "choropleth", variable_name = "NDC2NDI", 
       map_path = "private/maps")

census_tract_sf <- tracts(year = 2023, cb = TRUE, 
                          filter_by = c(-124.7844079, -66.9513812, 24.7433195, 49.3457868))
cvi <- read_csv("private/datasets/cleaned_data/CVI Data Excerpts_rename.csv")
mapper(data = cvi, shapefile = census_tract_sf, shape_key = "GEOID",
       data_key = "FIPS Code", plot = "choropleth", variable_name = "NDC2NDI", 
       map_path = "private/maps")

