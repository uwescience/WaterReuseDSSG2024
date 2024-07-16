# I am writing a function that assigns locations to a shape base on the given longitudes and latitudes

#' Assign shapefiles using dat
#'
#' @param dataset The dataset that contains the column of interest
#' @param longitudes A string of the longitude column name
#' @param latitudes A string of the longitude column name
#' @param census_year An integer of the census year of the shapefile generated using tigris packahge
#' @param filter_by A vector of boundary determining the bounding box 
#' @return A dataframe of shapefiles including the FIPS code
#' @export
#'
#' @examples
get_shapes <- function(dataset, longitudes, latitudes, census_year = "2023", 
                       filter_by = NULL){
  # Load the libraries
  require(tigris)
  require(sf)
  # get a county shapefile using tigris
  us_counties = counties(year = census_year, filter_by = filter_by)

  # Convert the dataframe to a spatial object and use the us_counties' crs
  points <- st_as_sf(dataset, coords = c(longitudes, latitudes), crs = st_crs(us_counties))
  
  # Perform the spatial join to find the county containing each point
  joined <- st_join(points, us_counties, join = st_within)
  # shape_data <- joined %>% select(geometry:INTPTLON)
  # return(shape_data)
  return(joined)
}
