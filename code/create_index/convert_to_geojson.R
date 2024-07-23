convert_to_geojson <- function(final_df) {
  # Convert data from a shapefile or csv to a geojson 
  # Wrapper function for geojsonio functions
  require(geojsonsf)
  if (inherits(final_df, "sf")) {
    final_geojson <- sf_geojson(final_df)
  }
  return(final_geojson)
}

