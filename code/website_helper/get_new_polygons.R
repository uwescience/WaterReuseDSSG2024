library(dplyr)
library(jsonlite)
library(sf)
library(geojsonsf)
library(leaflet)

sf <- geojson_sf('${geoJsonString}')

# TO DO: write this function
vars_to_keep <- parse_list('${varsToKeep}')

sf <- select_vars(sf,
                  cols_to_keep = vars_to_keep)

weights <- get_pca_weights(data = sf, excluded_cols = c("geometry"))

index <- get_weighted_average(sf, weights, excluded_cols = c("geometry"))

# TO DO: convert this to geojson; include color, name info for map
return(index)