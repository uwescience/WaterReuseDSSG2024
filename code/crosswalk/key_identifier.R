
identify_key <- function(data1, data2) {
  
  #' identifies a list of key variables
  #'
  #' @param data1 dataframe, shapefile
  #' @param data2 
  #'
  #' @return 
  #' @example output <- identify_key(data1 = data1, data2 = data2)
  #' data1 <- output[[1]]
  #' data2 <- output[[2]]
  
  
  key <- intersect(names(shape1), names(data2))
  key <- key[grep("^[0-9]", key)]
  
  for (k in key) {
    data1[[k]] <- as.character(data1[[k]])
    data2[[k]] <- as.character(data2[[k]])
    
    max_len <- max(nchar(shape[[k]]), nchar(data[[k]]))
    data1[[k]] <- str_pad(shape[[k]], width = max_len, side = "left", pad = "0")
    data2[[k]] <- str_pad(data[[k]], width = max_len, side = "left", pad = "0")
    
    print(summary(nchar(data1[[k]])))
    print(summary(nchar(data2[[k]])))
  }
  
  return(list(data1, data2))
}
