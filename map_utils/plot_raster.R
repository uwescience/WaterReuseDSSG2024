# This function plot raster datasets

plot_raster <- function(data, layer, 
                            shapefile, cellsize, map_title) {
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
  
  # # Convert polygon to a data frame for ggplot
  # grid_df <- as.data.frame(grid_data)
 
  # Create a grid over the bounding box of your shapefile data
  grid <- if (is.null(cellsize)) {
    st_make_grid(shapefile)
  } else {
    st_make_grid(shapefile, cellsize = cellsize)
  }
  
  # Convert the grid to an sf object
  grid_sf <- st_sf(geometry = grid)
  
  
  # Check if CRS match, if not transform
  if (st_crs(data) != st_crs(grid_sf)){
    grid_sf <- st_transform(grid_sf, st_crs(data))
    }
  
  # Plot using ggplot2
  raster_plot <- ggplot() +
    geom_raster(data = raster_df, aes(x = x, y = y, fill = value)) +
    geom_sf(data = grid_sf, fill = NA, color = "lightblue") +
    scale_fill_viridis_c() +
    labs(title = map_title, x = "Longitude", 
         y = "Latitude", fill = "Value") +
    theme_minimal() +
    coord_sf()
  return(raster_plot)

}








