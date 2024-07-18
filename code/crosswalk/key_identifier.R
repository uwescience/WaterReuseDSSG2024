# input: shape file and data
# output: a list of two dataframes that are padded with 0s.
# list[[1]] is transformed shapefile and list[[2]] is transformed dataset.
# This will allow the user to identify a list of key variables while merging and preprocess key variables.

identify_key <- function(shape, data) {
  key <- intersect(names(shape), names(data))
  key <- key[grep("^[0-9]", key)]
  
  for (k in key) {
    shape[[k]] <- as.character(shape[[k]])
    data[[k]] <- as.character(data[[k]])
    
    max_len <- max(nchar(shape[[k]]), nchar(data[[k]]))
    shape[[k]] <- str_pad(shape[[k]], width = max_len, side = "left", pad = "0")
    data[[k]] <- str_pad(data[[k]], width = max_len, side = "left", pad = "0")
    
    print(summary(nchar(shape[[k]])))
    print(summary(nchar(data[[k]])))
  }
  
  return(list(shape, data))
}

# Example usage:
#output <- identify_key(shape = map, data = data)
#shape <- output[[1]]
#data <- output[[2]]
