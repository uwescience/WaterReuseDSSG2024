update_js_metadata <- function(geojson_data = NULL) {
  if (is.null(geojson_data) || !is.character(geojson_data)) {
    stop("Invalid input: geojson_data must be a non-null string.")
  }
  num_char <- nchar(geojson_data)
  byte_size <- nchar(geojson_data, type = "bytes")
  
  updated_content <- sprintf(
    '{"files":[{"filename":"/abc.geojson","start":0,"end":%d}],"remote_package_size":%d}',
    num_char, byte_size
  )
  
  # Write the updated content to the metadata file
  writeLines(updated_content, "output.js.metadata")
}
