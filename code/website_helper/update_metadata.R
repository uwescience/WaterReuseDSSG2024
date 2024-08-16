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
  updated_content <- paste0(
    '{"files":[{\"filename\":"/abc.geojson","start":0,"end":',num_char,'}],"remote_package_size":',byte_size,'}')
  print("Finished updating metadata output.")
  
  updated_content <- gsub("\\\\","",updated_content,fixed=TRUE)
  
  print("Writing output...")
  
  filecon <- file(paste0(home_path, "/geo-ndxr/website_materials/output.js.metadata"))
  writeLines(updated_content)
  close(filecon)
  #jsonlite::toJSON(metadata_js, pretty = TRUE, auto_unbox = TRUE) %>%
    #write(paste0(home_path, "/geo-ndxr/website_materials/output.js.metadata"))
}

