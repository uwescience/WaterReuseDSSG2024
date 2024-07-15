# This function will use all the mapping functions we created to map
# any kind of maps

mapper <- function(data = NULL, 
                   shapefile = NULL, 
                   location_columns = NULL, 
                   variable_name = NULL,
                   data_key = NULL, 
                   shape_key = NULL, 
                   plot = NULL, 
                   map_path, 
                   map_title = NULL,
                   map_caption="Caption",
                   map_percentile=FALSE, 
                   low_color = "white", 
                   high_color = "red",
                   na_color = "gray",
                   map_font = "Arial",
                   base_unit = NULL,
                   name = NULL,
                   bbox = NULL,
                   layer = NULL){
  # data: The dataset that contains the column of interest
  # shapefile: A shapefile with FIPS
  # location: a vector of column names of the coordinates
  # variable_name: A column name of the variable of interest.
  # data_key: A key in the data table that can be used to merge with the shapefiles e.g. FIPS
  # shape_key: A key in the shapefile use to my with data e.g. GEOID
  # plot: Takes either "choropleth", "points", or  "raster" to specify either points or choropleth
  # map_path: Specify a folder path where you will save the maps
  # map_title: A string of the title of the map.
  # base_unit: a string with the base unit to be drawn on the usmap e.g 'counties'
  # bbox: a vector of bounding box coordinates (xmin, ymin, xmax, ymax) to crop the shapefile
  # layer: The layer to be plotted in multilayer rasters
  
  # Get the required packages and functions
  require(tidyverse)
  require(usmap)
  source("~/DSSG/WaterReuseDSSG2024/map_utils/map_utils.R")
  source("~/DSSG/WaterReuseDSSG2024/map_utils/get_shapes.R")
  source("~/DSSG/WaterReuseDSSG2024/map_utils/map_points.R")
  source("~/DSSG/WaterReuseDSSG2024/map_utils/plot_raster.R")
  
  
  # crop the shapefile if the bbox is not NULL
  if (!is.null(bbox) & !is.null(shapefile)){
    
    # Define the bounding box
    bbox = st_bbox(bbox, crs = st_crs(shapefile))
    
    # Convert the bbox to an sf object
    bbox_sf <- st_as_sfc(bbox)
    # Get the intersection of the shapefile and bbox
    shapefile = st_intersection(shapefile, bbox_sf)
  }

    # plot choropleth map
  if (tolower(plot) == "choropleth") {
    plot_to_save <- map_choropleth(data, shapefile, data_key, 
                                   shape_key, variable = variable_name,
                                   map_title, map_caption,
                                   map_percentile, low_color, 
                                   high_color, na_color, map_font)
  } else if (tolower(plot) == "points") {
    plot_to_save <- map_points(shapefile, data, 
                               location_columns, variable_name,
                               base_unit, map_title, name, bbox)
  } else if (tolower(plot) == "raster") {
    plot_to_save <- plot_raster(data, layer, map_title)
  } else {
    print("The map you specified cannot be plotted at the moment.")
    return(NULL) # Exit function early if the plot type is not supported
  }
  
  ggsave(filename = ifelse(is.null(variable_name), paste0(plot, ".png"), paste0(variable_name, ".png")),
         plot = plot_to_save, path = map_path, device = "png")
  
  # Return the ggplot object
  return(plot_to_save)
  
}

