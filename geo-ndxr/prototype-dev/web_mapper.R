library(tidyverse)
library(leaflet)
library(htmlwidgets)
library(geojson) # This package enables reading geojson data



web_mapper <- function(data_with_shapes, index_value_column, name_column){
  # Create a color palette based on the index value
  pal <- colorNumeric(
    palette = "YlGnBu",
    domain = data_with_shapes[[index_value_column]]
  )

  # Create the web index mapper
  index_map <- leaflet(data_with_shapes) %>%
    addTiles() %>%
    # Add polygons to the map
    addPolygons(
      fillColor = ~pal(data_with_shapes[[index_value_column]]),
      fillOpacity = 0.7,
      color = "black",
      weight = 1,
      opacity = 1,
      highlight = highlightOptions(
        weight = 5,
        color = "red",
        fillOpacity = 0.7,
        bringToFront = TRUE
      ),
      # Expose the name and values to the user
      label = ~paste("County: ", str_to_title(data_with_shapes[[name_column]]),
                     "Index Value:", round(data_with_shapes[[index_value_column]], 2))
    ) %>%
    addLegend(
      pal = pal,
      values = ~data_with_shapes[[index_value_column]],
      title = "Index Value",
      opacity = 0.7,
      position = "bottomright"
    ) %>% setView(-96, 37.8, zoom = 4)

  return(index_map)
}

web_mapper(data_with_shapes = counties_sf,
           index_value_column = "index_value",
           name_column = "NAME")


