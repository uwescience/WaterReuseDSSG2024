
source(paste0(getwd(), "/geo-ndxr/prototype-dev/web_mapper.R"))

create_website <- function(data, filepath, control_list = NULL) {
  
  web_mapper(data, filepath)
  
  # Read HTML file string contents 
  html_filepath <- paste(filepath, "index.html", sep = "/")
  html_contents <- readLines(new_path)
  
  # Regex pattern to separate the script - insert point for new functions/code. 
  footer <- "</body> </html>"
  
  html_split <- strsplit(html_contents, footer)
  html_appended <- paste(html_split[1], "some javascript output", html_split[2])
  cat(html_appended, paste(filepath, "index_value.html"))
}