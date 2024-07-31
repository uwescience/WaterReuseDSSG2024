print("R script loaded...")
func <- function(input) {
    print(paste0("This is an R script. The user input was: ", input))

    library(dplyr)
    library(jsonlite)
    library(sf)
    library(geojsonsf)
    library(leaflet)

    sf <- geojson_sf('${geoJsonString}')

    print(names(sf))

    weights <- get_pca_weights(data = sf, excluded_cols = c("geometry"))

    print(weights)

    index <- get_weighted_average(sf, weights, excluded_cols = c("geometry"))

    #return(toJSON(index))
}