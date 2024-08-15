generate_txt <- function(data, author, contact, sources) {
  #' Function to generate metadata as a text file
  #' @param data geojson dataset
  #' @param author string. name of the author
  #' @param contact string. contact information
  #' @param sources list of data sources
  #' @example generate_txt(data, author = "JB", 
  #' contact = "jb_at_uw_edu", 
  #' sources = list("source1", "source2"))
  #' 
  metadata <- list(
    "Dataset Name" = deparse(substitute(data)),
    "Author" = author,
    "Contact" = contact,
    "Column Names" = names(data),
    "Sources" = sources
  )
  
  formatted_metadata <- paste(
    paste("Dataset Name:", metadata[["Dataset Name"]]),
    paste("Author:", metadata[["Author"]]),
    paste("Contact:", metadata[["Contact"]]),
    "Column Names:",
    paste(metadata[["Column Names"]], collapse = "\n"),
    "Sources:",
    paste(metadata[["Sources"]], collapse = "\n"),
    sep = "\n\n"
  )
  
  # Write the formatted metadata to a .txt file
  writeLines(formatted_metadata, "metadata_output.txt")
}
