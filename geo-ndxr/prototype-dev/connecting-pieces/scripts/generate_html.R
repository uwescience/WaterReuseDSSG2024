
generate_html <- function(author, contact, references) {
  # Create metadata list
  metadata <- list(
    author = author,
    contact = contact,
    references = references
  )
  
  # Create HTML content
  html_content <- paste(
    "<!DOCTYPE html>",
    "<html lang='en'>",
    "<head>",
    "<meta charset='UTF-8'>",
    "<meta name='viewport' content='width=device-width, initial-scale=1.0'>",
    "<title>Metadata</title>",
    "</head>",
    "<body>",
    "<h1>Metadata</h1>",
    "<p><strong>Author:</strong> ", metadata$author, "</p>",
    "<p><strong>Contact:</strong> ", metadata$contact, "</p>",
    "<p><strong>References:</strong></p>",
    "<ul>",
    paste(sapply(metadata$references, function(ref) paste("<li>", ref, "</li>")), collapse = "\n"),
    "</ul>",
    "</body>",
    "</html>",
    sep = "\n"
  )
  
  # Write HTML content to file
  writeLines(html_content, "geo-ndxr/prototype-dev/connecting-pieces/metadata_output.html")
}

# Example usage
generate_html("Mbye", "ms123@gmail.com", c("abc", "jihyeon", "world bank"))
