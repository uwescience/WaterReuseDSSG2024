# This function will use all the mapping functions we created to map
# any kind of maps

#' Plot choropleth, points and raster maps
#'
#' @param data The dataset that contains the column of interest
#' @param shapefile A shapefile with FIPS code
#' @param location_columns a vector of column names of the coordinates
#' @param variable_name A column name of the variable of interest.
#' @param data_key A key in the data table that can be used to merge with the shapefiles e.g. FIPS
#' @param shape_key A key in the shapefile use to my with data e.g. GEOID
#' @param plot Takes either "choropleth", "points", or  "raster" to specify either points or choropleth
#' @param map_path Specify a folder path where you will save the maps
#' @param map_title A string of the title of the map.
#' @param map_caption a string defining the caption that appears at the bottom right of the map figure
#' @param map_percentile A boolean of whether the map should display raw values of variable (=FALSE, default) or show which percentile of the data distribution the geographic unit in question falls into (=TRUE)
#' @param low_color,high_color,na_color # - low_color, high_color, na_color (strings) - the colors desigating the lowest and highest values of variable, respectively, and the color that should indicate missing data
#' @param map_font font in the title, caption, legends
#' @param base_unit a string with the base unit to be drawn on the usmap e.g 'counties'
#' @param name The name of the scale. Used as the axis or legend title.
#' @param bbox a vector of bounding box coordinates (xmin, ymin, xmax, ymax) to crop the shapefile
#' @param layer The layer to be plotted in multilayer rasters
#' @return A .png image and a ggplot object of the plotted map
#' @export 
#'
#' @examples mapper(data = cvi, shapefile = census_tract_sf, shape_key = "GEOID", data_key = "FIPS Code", plot = "choropleth", variable_name = "flood_factor2020",  map_path = "/private/maps", bbox = c(xmin = -124.7844079, ymin = 24.7433195, xmax = -66.9513812, ymax = 49.3457868))

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
  }
  # Plot points on maps
  else if (tolower(plot) == "points") {
    plot_to_save <- map_points(shapefile, data,
                               location_columns, variable_name,
                               base_unit, map_title, name, bbox)
    
  } 
  # Plot rasters
  else if (tolower(plot) == "raster") {
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

