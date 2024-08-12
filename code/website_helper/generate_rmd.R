generate_rmd <- function(data, author, contact) {
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
  writeLines(rmd_content, "metadata.Rmd")
  
  # Render the Rmd file to an HTML document
  rmarkdown::render("metadata.Rmd")
  
  message("Rmd file generated and rendered successfully.")
}

# Example usage:
# myfunction(data = your_dataframe, author = "Your Name", contact = "your.email@example.com")
