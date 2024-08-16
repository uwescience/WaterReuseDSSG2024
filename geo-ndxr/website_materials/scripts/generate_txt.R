# Function to generate metadata as a text file
generate_txt <- function(data, author, contact) {
  metadata <- list(
    dataset_name = deparse(substitute(data)),
    author = author,
    contact = contact,
    column_names = names(data),
    summary = summary(data)
  )
  metadata_json <- jsonlite::toJSON(metadata, pretty = TRUE)
  writeLines(metadata_json, "metadata_output.txt")
}

