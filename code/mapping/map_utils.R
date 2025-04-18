check_compatibility <- function(data, 
                                shapefile, 
                                data_key, 
                                shape_key) {
  
  #' Check if the data and the shapefile can be merged
  #' 
  #' @description
    #' Performs two checks to confirm that the data file and the 
    #' shapefile called by the plotting functions are compatible 
    #' with each other
  #' 
  #' This function checks that 
  #' - data_key is a column in data & shape_key is a column in shapefile
  #' - data_key and shape_key have the same type
  #' 
  #' Outputs TRUE if this combination of data, shapefile, & keys can
  #' be spatially joined
  #' 
  #' Helper function to map_choropleth()
  
  check_result <- data_key %in% names(data) && 
    shape_key %in% names(shapefile) && 
    typeof(data_key) == typeof(shape_key)
  
  source("code/crosswalk/key_identifier.R")
  identify_key(data, shapefile)
  
  return(check_result)
}

plot_absolute <- function(data, 
                          variable, 
                          caption, 
                          title,
                          low_color = "white", 
                          high_color = "red",
                          na_color = "gray",
                          map_font = "Arial" 
                      ){
  
  #' Plots unmodified values of variable
  #' 
  #' @description
    #' Plots the values of the variable WITHOUT converting them to
    #' percentiles; serves as a helper function to map_choropleth()
  #'
  #' Inputs:
  #' 
  #' @param data (dataframe) - expects a dataframe containing a geometry
  #' and a variable of interest. Usually, this dataframe will result
  #' from merging (1) a raw data file, indexed by a geographic region
  #' identifier like FIPS, with (2) a shapefile that specifies the
  #' geographic regions in question
  #'
  #' @param variable (string) - a string containing the NAME of the column in
  #' data that contains the variable that should be used to make the map
  #'
  #' @param caption (string) - a string defining the caption that appears
  #' at the bottom right of the map figure
  #'
  #' @param title (string) - the map title
  #'
  #' @param low_color (strings) - the colors designating the lowest values of variable
  #' @param high_color (strings) - the colors designating the highest values of variable
  #' @param na_color (strings) - the colors indicating missing data
  #'
  #' @param map_font (string) - font in the title, caption, legends
  #'
  #'
  #' @Outputs:
  #' - a ggplot2 object mapping the shapes defined in the dataset and
  #' color-coding them according to the un-adjusted value of variable
  #'
  #'

  plot_data_variable <- ggplot(data) +
    geom_sf(mapping = aes_string(fill = variable)) +
    scale_fill_gradient(name = variable, 
                        label = scales::comma_format(),
                        low = low_color,
                        high = high_color,
                        na.value = na_color,
                        breaks = scales::pretty_breaks(n = 5)) + 
    labs(title = title,
         caption = caption) +
    theme(text = element_text(family = map_font))
  
  return(plot_data_variable)
  
}

plot_percentile <- function(data, 
                            variable, 
                            caption, 
                            title,
                            low_color = "white", 
                            high_color = "red",
                            na_color = "gray",
                            map_font = "Arial") {
  
  #' Plots the values of a variable converted to percentile scores
  #' 
  #' Plot the percentile score of a variable, converted from 
  #' its unmodified value; serves as helper function to map_choropleth()
  #' 
  #' Inputs:
  #' @param data (dataframe) - expects a dataframe containing a geometry
  #' and a variable of interest. Usually, this dataframe will result
  #' from merging (1) a raw data file, indexed by a geographic region
  #' identifier like FIPS, with (2) a shapefile that specifies the
  #' geographic regions in question
  #' 
  #' @param variable (string) - a string containing the NAME of the column in 
  #' data that contains the variable that should be used to make the map
  #' @param caption (string) - a string defining the caption that appears
  #' at the bottom right of the map figure
  #' 
  #' @param title (string) - the map title
  #' 
  #' @param low_color (strings) - the colors designating the lowest values of variable
  #' @param high_color (strings) - the colors designating the highest values of variable
  #' @param na_color (strings) - the colors indicating missing data
  #'
  #' @param map_font (string) - font in the title, caption, legends
  #' 
  #' @param Outputs:
  #' 
  #' - a ggplot2 object mapping the shapes defined in the dataset and
  #' color-coding them according to the value of variable; instead of
  #' plotting the RAW value of variable, this function coverts them
  #' to percentile scores and maps the percentile scores
  
  ecdf_function <- ecdf(data[[variable]])
  
  percentiles <- ecdf_function(data[[variable]])
  
  plot_data_variable <- ggplot(data) +
    geom_sf(mapping = aes_string(fill = percentiles)) +
    scale_fill_gradient(name = paste(variable, "\n(percentile)"), 
                        label = scales::comma_format(),
                        low = low_color,
                        high = high_color,
                        na.value = na_color,
                        limits = c(min(percentiles), 
                                   max(percentiles)),
                        breaks = scales::pretty_breaks(n = 5)) + 
    labs(title = title,
         caption = caption) +
    theme(text = element_text(family = map_font))
  
  return(plot_data_variable)
  
}

# main mapping utility for plotting shapes (as opposed to points)
map_choropleth <- function(data, 
                            shapefile, 
                            data_key, 
                            shape_key, 
                            variable, 
                            map_title="Title", 
                            map_caption="Caption",
                            map_percentile=FALSE, 
                            low_color = "white", 
                            high_color = "red",
                            na_color = "gray",
                            map_font = "Arial") {
  
  #' Creates a choropleth map
  #' 
  #' Given a dataset, shapefile, and variable of interest, plots a choropleth map
  #' 
  #' Inputs:
  #' @param data (dataframe) - expects a dataframe containing a variable of
  #'   interest, indexed by a geographic region identifier like FIPS
  #'
  #' @param shape (dataframe) - a shapefile that specifies the
  #'   geographic regions in question; must contain a 'geometry' column
  #'
  #' @param data_key (string) - a string that contains the name of column in
  #'   data that should be used to merge it with the shapefile. This
  #'   should be something like "FIPS"
  #'
  #' @param shape_key (string) - a string that contains the name of column in
  #'   the shapefile that should be used to merge it with the data. This
  #'   should be something like "FIPS"
  #'
  #' @param variable (string) - a string containing the name of the column in
  #'   data that contains the variable that should be used to make the map
  #'
  #' @param map_title (string) - the map title
  #'
  #' @param map_caption (string) - a string defining the caption that appears
  #'   at the bottom right of the map figure
  #'
  #' @param map_percentile (boolean) - whether the map should display raw values
  #'   of variable (=FALSE, default) or show which percentile of the
  #'   data distribution the geographic unit in question falls into (=TRUE)
  #'
  #' @param low_color (strings) - the colors designating the lowest values of variable
  #' @param high_color (strings) - the colors designating the highest values of variable
  #' @param na_color (strings) - the colors indicating missing data
  #'
  #' @param map_font (string) - font in the title, caption, legends
  #'
  #' @Outputs:
  #' 
  #' - a ggplot2 object mapping the shapes defined in the dataset and
  #'   color-coding them according to the value of variable; instead of
  #'   plotting the RAW value of variable, this function converts them
  #'   to percentile scores and maps the percentile scores
  
  # CONTROL FLOW:
  # Case 1: both data and shapefile are NULL. Throw error. 
  # Case 2: data or shapefile are NULL. No merge necessary. Try to plot non-null table.
  # Case 3: data and shapefile are not NULL. Merge then plot combined table.
  
  #####################################################################################
  # Case 1
  #####################################################################################
  
  if (is.null(data) && is.null(shapefile)) {
    stop("data and shapefile passed to map_chloropleth() are null!")
  }
  
  #####################################################################################
  # Case 2
  #####################################################################################
  
  if (is.null(shapefile)) {
    
    if (map_percentile == TRUE) {
      
      plot <- plot_percentile(data, 
                      variable, 
                      title = map_title, 
                      caption = map_caption,
                      low_color = low_color, 
                      high_color = high_color,
                      na_color = na_color,
                      map_font = map_font)
      return(plot)
    }

    
    else {
      
      plot_absolute(data, 
                    variable, 
                    title = map_title, 
                    caption = map_caption,
                    low_color = low_color, 
                    high_color = high_color,
                    na_color = na_color,
                    map_font = map_font)
      
    }
  }
  
  else if (is.null(data)) {
    if (map_percentile == TRUE) {
      
      plot_percentile(shapefile, 
                      variable, 
                      title = map_title, 
                      caption = map_caption,
                      low_color = low_color, 
                      high_color = high_color,
                      na_color = na_color,
                      map_font = map_font)
      
    }
    
    else {
      
      plot_absolute(shapefile, 
                    variable, 
                    title = map_title, 
                    caption = map_caption,
                    low_color = low_color, 
                    high_color = high_color,
                    na_color = na_color,
                    map_font = map_font)
      
    }
  }
  
  #####################################################################################
  # Case 3
  #####################################################################################
  else {
    if (check_compatibility(data, shapefile, data_key, shape_key) == FALSE) {
      warning("This dataset & shapefile seem incompatible. 
              Please check that column names match key names and that 
              keys in data & shapefile have the same type")
    }
    
    if (data_key != shape_key) {
      
  
      colnames(shapefile)[which(colnames(shapefile)==shape_key)] <- data_key
  
      data_sf <- shapefile %>% left_join(data, by = data_key)
      
      data[[variable]] <- as.numeric(data[[variable]])
    
    }
    
    else {
      
      data_sf <- shapefile %>% left_join(data, by = data_key)
      
      data[[variable]] <- as.numeric(data[[variable]])
      
    }
    
    if (map_percentile == TRUE) {
      
      plot_percentile(data_sf, 
                      variable, 
                      title = map_title, 
                      caption = map_caption,
                      low_color = low_color, 
                      high_color = high_color,
                      na_color = na_color,
                      map_font = map_font)
    
      }
    
    else {
      
      plot_absolute(data_sf, 
                    variable, 
                    title = map_title, 
                    caption = map_caption,
                    low_color = low_color, 
                    high_color = high_color,
                    na_color = na_color,
                    map_font = map_font)
    
    }
  }
}