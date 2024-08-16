update_js_metadata <- function(geojson_data = NULL) {
  library(jsonlite)
  if (is.null(geojson_data) || !is.character(geojson_data)) {
    stop("Invalid input: geojson_data must be a non-null string.")
  }
  geojson_data <- readLines()
  num_char <- nchar(geojson_data)
  byte_size <- nchar(geojson_data, type = "bytes")
  
  updated_content <- sprintf(
    '{"files":[{"filename":"/abc.geojson","start":0,"end":%d}],"remote_package_size":%d}',
    num_char, byte_size
  )

  jsonlite::write_json(updated_content, "geo-ndxr/website_materials/output.js.metadata")
}

