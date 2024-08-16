update_js_metadata <- function(geojson_path = NULL, home_path) {
  require(jsonlite)
  print("Loaded dependency...")
  if (is.null(geojson_data) || !is.character(geojson_data)) {
    stop("Invalid input: geojson_data must be a non-null string.")
  }
  print("Starting to read input JSON...")
  geojson_data <- readLines(geojson_path)
  num_char <- nchar(geojson_data)
  byte_size <- nchar(geojson_data, type = "bytes")

  print("Updating metadata output...")
  updated_content <- sprintf(
    '{"files":[{"filename":"/abc.geojson","start":0,"end":%d}],"remote_package_size":%d}',
    num_char, byte_size
  )
  print("Finished updating metadata output.")

  print("Writing output...")
  jsonlite::write_json(updated_content, paste0(home_path, "/geo-ndxr/website_materials/output.js.metadata"))
  print("Complete.")
}

