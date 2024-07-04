check_compatibility <- function(data, shapefile, data_key, shape_key) {
  
  # Two checks are needed:
  # - data_key is a column in data & shape_key is a column in shapefile
  # - data_key and shape_key have the same type
  
  # Output: boolean - true if this combination of data, shapefile, keys
  # can be spatially joined
  
  check_result <- data_key %in% names(data) && 
    shape_key %in% names(shapefile) && 
    typeof(data_key) == typeof(shape_key)
  
  return (check_result)
}

plot_percentile <- function(data, variable, caption, title,
                            percentile=0.95,
                            low_color = "white", high_color = "red",
                            na_color = "gray"){
  percentiles <- quantile(data[[variable]], probs=c(0, percentile), na.rm=TRUE)
  
  plot_data_variable <- ggplot(data)+
    geom_sf(mapping = aes_string(fill = variable)) +
    scale_fill_gradient(name = variable, 
                        label = scales::comma_format(),
                        low=low_color,
                        high=high_color,
                        na.value = na_color,
                        limits = percentiles,
                        breaks = scales::pretty_breaks(n = 5)) + 
    labs(title = title,
         caption = caption) +
    theme(text = element_text(family = "Times New Roman"))
  
  return(plot_data_variable)
  
}

map_chloropleth <- function(data, shapefile, data_key, shape_key, value) {
  
  if (check_compatibility(data, shapefile, data_key, shape_key) == FALSE) {
    warning("This dataset & shapefile seem incompatible. 
            Please check that column names match key names and that 
            keys in data & shapefile have the same type")
  }
  if (data_key != shape_key) {
    
    data_sf <- shapefile %>% left_join(data, by = c(data_key, shape_key)) %>% 
      mutate(value = as.numeric(value))
  
  }
  
  else {
    data_sf <- shapefile %>% left_join(data, by = data_key) %>% 
      mutate(value = as.numeric(value))
  }
  
  plot_percentile(data_sf)
}


