# Jihyeon's code

# source()

# Nora's code

# source()

crosswalk <- function(data = NULL, 
                      shapefile = NULL, 
                      source_scale, 
                      key = NULL, 
                      target_scale) {
  
  if (is.null(shapefile)) {
    
    crosswalk_data(data = data, 
                   source_scale = source_scale,
                   key = key, 
                   target_scale = target_scale)
  }
  
  else if (is.null(data)) {
    
    crosswalk_geom(shapefile = shapefile, 
                   data = data, 
                   source_scale = source_scale,
                   target_scale = target_scale)
  }
  
  else {
    stop("data and shapefile passed to the crosswalk() function are both null.\n
         At least one must be non-null")
  }
}