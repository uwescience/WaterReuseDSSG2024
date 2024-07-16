# This function plot raster datasets

#' Plot raster data 
#'
#' @param data The dataset that contains the column of interest
#' @param layer An integer value of the layer that is to be plotted if the data is a multilayer dataset
#' @param map_title A string of the title of the map
#'
#' @return A plot of the raster data
#' @export
#'
#' @examples
plot_raster <- function(data, layer, map_title) {
  if (!inherits(data, "SpatRaster")) {
    stop("Input data is not a SpatRaster object")
  }
  require(ggplot2)
  require(terra)
  # If the raster is multi-layered, check the specified layer
  if (nlyr(data) > 1) {
    if (is.null(layer)) {
      stop("The raster has multiple layers. Please specify which layer to plot.")
    } else if (layer > nlyr(data) || layer < 1) {
      stop("Invalid layer number. Please specify a valid layer.")
    }
    raster_layer <- data[[layer]]
  } else {
    raster_layer <- data
  }
  
  # Convert the raster to a data frame for ggplot
  raster_df <- as.data.frame(raster_layer, xy = TRUE)
  colnames(raster_df)[3] <- "value"
  
  
  # Plot using ggplot2
  raster_plot <- ggplot() +
    geom_raster(data = raster_df, aes(x = x, y = y, fill = value)) +
    scale_fill_viridis_c() +
    labs(title = map_title, x = "Longitude", 
         y = "Latitude", fill = "Value") +
    theme_minimal() +
    coord_sf()
  return(raster_plot)

}








