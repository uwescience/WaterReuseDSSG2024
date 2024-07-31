
# Process data function
process_data <- function(data) {
  library(dplyr)
  
  data$afact <- as.numeric(data$afact)
  
  if ("county" %in% names(data) && "tract" %in% names(data)) {
    data$tract <- gsub("\\.", "", data$tract)
    data <- data %>%
      mutate(tract.census.geoid = paste0(county, tract)) %>%
      rename(county.census.geoid = county) 
  } 
  
  if ("puma22" %in% names(data)) {
    data <- data %>%
      rename_with(~ifelse(. %in% "puma22", "puma.census.geoid", .),
                  .cols = "puma22")
  } 
  
  return(data) }