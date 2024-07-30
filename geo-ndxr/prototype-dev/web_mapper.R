
#' Index Mapper on open street map
#' @description
#' This function plot choropleth on openstreetmap. It is specifically design to plot
#' calculated index values.
#' 
#' @param data_with_shapes A dataframe with a geometry column and the index value
#' @param index_value_column A column name containing the index values to be plotted 
#' @param name_column A column name containing the counties or state to be plotted
#' @param map_path The path in which the created map will be saved
#' @param map_name the name of created map
#'  
#' @return A html file with the map
#' @export
#'
#' @examples
web_mapper <- function(data_with_shapes, 
                       index_value_column,
                       name_column = NULL,
                       map_path = NULL,
                       map_name = NULL){
  # Load the required packages
  require(tidyverse)
  require(leaflet)
  require(htmltools)
  require(leaflet.providers)
  
  # Check if map_path is NULL and set it to the current directory
  if (is.null(map_path)) {
    map_path <- getwd()
  }
  
  # Check if map_name is NULL and set it to index_value_column
  if (is.null(map_name)) {
    map_name <- index_value_column
  }
  
  # Create a color palette based on the index value
  pal <- colorNumeric(
    palette = "YlGnBu",
    domain = data_with_shapes[[index_value_column]]
  )
  
  # Create the web index mapper
  index_map <- leaflet(data_with_shapes) %>%
    # addTiles() %>% 
    
    #Add greyscale tiles and roadless tiles 
    addProviderTiles(providers$CartoDB.Positron) %>% 
    addTiles(urlTemplate = "https://tiles.wmflabs.org/hikebike/{z}/{x}/{y}.png") %>%
  
    # Add polygons to the map
    addPolygons(
      fillColor = ~pal(data_with_shapes[[index_value_column]]),
      fillOpacity = 0.7,
      color = "black",
      weight = 1,
      opacity = 1,
      stroke = FALSE, 
      highlight = highlightOptions(
        weight = 5,
        color = "red",
        fillOpacity = 0.7,
        bringToFront = TRUE
      ),
      # Expose the county names and values to the user
      label = ~paste("County: ", str_to_title(data_with_shapes[[name_column]]),
                     "Index Value:", round(data_with_shapes[[index_value_column]], 2))
    ) %>%
    # Add a legend to the map
    addLegend(
      pal = pal,
      values = ~data_with_shapes[[index_value_column]],
      title = "Index Value",
      opacity = 0.7,
      position = "bottomright"
    ) %>% 
    # Zoom the map to mainly focus on the US
    setView(-96, 37.8, zoom = 4)
  
  # Save the map to an html file
  save_html(index_map, 
            file = file.path(map_path, paste0(map_name, ".html")))
  return(index_map)
}
