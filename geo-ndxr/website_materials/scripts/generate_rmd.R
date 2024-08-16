generate_rmd <- function(data, author, contact) {
  #' generates .Rmd file with column names
  #' @param data data_frame name
  #' @param author string. 
  #' @param contact string. contact info. 
  #' @example generate_rmd(echo_cleaned, "Jihyeon", "emailaddress_at_uw.edu" )
  # Ensure the data is available in the environment
  data_name <- deparse(substitute(data))
  
  # Define the Rmd content
  rmd_content <- paste0(
    "---\n",
    "title: \"Generated Report\"\n",
    "author: \"", author, "\"\n",
    "contact: \"", contact, "\"\n",
    "output: html_document\n",
    "---\n\n",
    "```{r setup, include=FALSE}\n",
    "knitr::opts_chunk$set(echo = TRUE)\n",
    "```\n\n",
    "# Introduction\n\n",
    "This report was generated using the dataset: `", data_name, "`.\n\n",
    "# Summary Table\n\n",
    "The following is a summary of all columns in the dataset:\n\n",
    "```{r summary_table}\n",
    "names(", data_name, ")\n",
    "```\n"
  )
  
  # Write the content to an .Rmd file
  rmd_file_path <- "/path/to/your/webserver/directory/metadata.Rmd"
  writeLines(rmd_content, rmd_file_path)
  
  # Render the Rmd file to an HTML document (optional)
  rmarkdown::render(rmd_file_path)
  
  message("Rmd file generated and rendered successfully.")
}
