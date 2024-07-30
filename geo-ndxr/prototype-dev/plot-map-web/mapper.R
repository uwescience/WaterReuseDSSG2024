index_map() <- function(data) {
  weights <- get_pca_weights(data,
                             excluded_cols = c("GEOID", "geometry"))
  
  index <- get_weighted_average(data, weights, excluded_cols = c("GEOID", "geometry"))
  return(index)
}