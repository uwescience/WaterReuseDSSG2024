print("Hello world")
print("Dumb test")

index_generator <- function() {
  print("Hello world again")
  
  # change this to something local
  webr::install("toxpiR")
  webr::install("tidyverse")
  webr::install("BiocManager")
  webr::install("jsonlite")
  #BiocManager::install("BiocGenerics")
  #library(toxpiR)
  library(tidyverse)
  library(jsonlite)
  #source("toxpi-wrapper.R")
  
  # create some data
  set.seed(123)
  
  N <- 10
  var_count <- 10
  
  # Generate some data that will be our "index"
  index_data <- matrix(rnorm(N * var_count), nrow = N, ncol = var_count)
  
  weights <- rep(1, var_count)
  
  # Define a function to generate a single alphanumeric ID
  generate_id <- function(length) {
    # Define the characters to sample from: letters and digits
    chars <- c(letters, LETTERS, 0:9)
  
    # Sample the characters and collapse them into a single string
    id <- paste(sample(chars, length, replace = TRUE), collapse = "")
  
    return(id)
  }
  
  # Generate 100 alphanumeric IDs of length 8
  id_length <- 3
  ids <- replicate(N, generate_id(id_length))
  
  index_data <- as.data.frame(index_data)
  
  index_data$id <- ids
  
  # index <- create_index(df = index_data,
  #              "id",
  #              weights,
  #              "my_index")
  # 
  
  index_data$index_value <- rowMeans(index_data[, 1:var_count], na.rm = TRUE)
  
  index_data <- subset(index_data, select = -c(1:var_count))
  
  index_data <- index_data %>% toJSON()
  
  return(index_data)
}