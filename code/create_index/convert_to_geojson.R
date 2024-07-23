convert_geojson_sf <- function(df) {
  # Wrapper function for:
  # geojson -> shapefile
  # shapefile -> geojson
  require(geojsonsf)
  require(sf)
  if (inherits(df, "sf")) {
    final_geojson <- sf_geojson(df)
    return(final_geojson)
  } else {
    final_sf <- read_sf(df)
    return(final_sf)
  }
}