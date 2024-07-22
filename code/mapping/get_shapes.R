

get_shapes <- function(dataset, longitudes, latitudes, census_year = "2023"){
  #' 
  #' @description #this function assigns locations to a shape base on the given longitudes and latitudes
  #'
  #' @param dataset 
  #' @param longitudes 
  #' @param latitudes 
  #' @param census_year set at 2023 as a default
  #'
  #' 
  # Load the libraries
  require(tigris)
  require(sf)
  # get a county shapefile using tigris
  us_counties = counties(year = census_year, filter_by = c(-124.7844079, -66.9513812, 24.7433195, 49.3457868))

  # Convert the dataframe to a spatial object and use the us_counties' crs
  points <- st_as_sf(dataset, coords = c(longitudes, latitudes), crs = st_crs(us_counties))
  
  # Perform the spatial join to find the county containing each point
  joined <- st_join(points, us_counties, join = st_within)
  # shape_data <- joined %>% select(geometry:INTPTLON)
  # return(shape_data)
  return(joined)
}
