update_js_metadata <- function(data_folder = "/data") {

  js_metadata_path <- "output.js.metadata"
  geojson_files <- list.files(path = data_folder, pattern = "\\.geojson$", full.names = TRUE)
  data <- readLines(geojson_file_path, warn = FALSE)

  data_string <- paste(data, collapse = "\n")
  
  byte_size <- nchar(data_string, type = "bytes")
  char_count <- nchar(data_string)
  
  updated_content <- sprintf(
    '{
      "files": [
        {
          "filename": "%s",
          "start": 0,
          "end": %d
        }
      ],
      "remote_package_size": %d
    }',
    geojson_file_path, byte_size, byte_size
  )
  
  writeLines(updated_content, js_metadata_path)
  
  message(sprintf("Updated %s with byte size: %d and character count: %d", js_metadata_path, byte_size, char_count))
}

# Call the function to update the metadata
update_js_metadata()
