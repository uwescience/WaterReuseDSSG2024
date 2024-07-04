library(tidyverse)
library(usmap)
library(sf)
test_loc_assignee <- read_csv("datasets/Found_dataset/location_assignee.csv")


# I am writing a function that assigns locations to a shape base on the given longitudes and latitudes
get_shapes <- function(dataset, longitudes, latitudes){
  # get a county shapefile using tigris
  us_counties = counties(year = "2023")

  # Convert the dataframe to a spatial object and use the us_counties' crs
  points <- st_as_sf(dataset, coords = c(longitudes, latitudes), crs = st_crs(us_counties))
  
  # Perform the spatial join to find the county containing each point
  joined <- st_join(points, us_counties, join = st_within)
  return(joined)
}

