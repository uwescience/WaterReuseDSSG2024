
split_html <- function(html, func) {
  # Read HTML file string contents 
  html_filepath <- paste(filepath, "index.html", sep = "/")
  html_contents <- readLines(new_path)
  
  # Regex pattern to separate the script - insert point for new functions/code. 
  footer <- "</body> </html>"
  
  html_split <- strsplit(html_contents, footer)
  html_appended <- paste(html_split[1], func(), html_split[2])
  cat(html_appended, paste(filepath, "index_value.html"))
  
}