edit_website <- function(website_title, description, menu_options, initial_index, geo_unit, home_path) {
  
  # Edits website design options
  #' @description
    #' Input menu options to automatically update the template HTML file  
    #' 
    #' @param website_title A string containing the website title for your index.
    #' @param description A string containing the description of your index and maps. Please provide basic 
    #' information on how you chose to calculate the index, weighted the variables, and selected the geographic scale. 
    #' Describe what a high index value vs. a low index value means. Describe the purpose of the web tool and what you
    #'  hope users can learn. 
    #' @param menu_options menu options are a list in a dictionary format from a  with a specific format. If you would like to group indicators (columns) 
    #' by a category (e.g "Environmental Stressors" or "Social Vulnerability"), you need to construct your string like this: 
    #' list(
    #'    Environmental_Stressors = list(column1 = "Column 1", column2 = "Column 2"), 
    #'    Social_Vulnerability = list(column3 = "Column 3", column4 = "Column 4"))
    #'OR a simple list with the columns of interest:
    #'list(column1 = "Column 1", column2 = "Column 2", column3 = "Column3", column4 = "Column4")
    #'
    #' @output
    #'Overwrites options.json and menu_options.json in the website folder to include your custom website options. 
  
  require(rjson)
  
  #fix the relative path
  #options <- fromJSON(file = paste0(home_path, "/geo-ndxr/website_materials/options.json"))
  #menu_options <- fromJSON(file = paste0(home_path, "/geo-ndxr/website_materials/menu_options.json"))
  
  options <- list()
  
  #replace content with input strings/lists
  options$website_title <- website_title
  options$description <- description
  options$initial_index <- initial_index
  options$geo_unit <- geo_unit
  
  # Specify the file to overwrite (options.json)
  options_file = file(paste0(home_path, "/geo-ndxr/website_materials/options.json"))
  
  # Write the file contents in JSON format
  jsonlite::toJSON(options, pretty = TRUE, auto_unbox = TRUE) %>%
    write(options_file)
 
  # Specify the file to overwrite (menu_options.json)
  menu_options_file = file(paste0(home_path, "/geo-ndxr/website_materials/menu_options.json"))
  
  # Write the file contents in JSON format
  jsonlite::toJSON(menu_options, pretty = TRUE, auto_unbox = TRUE) %>%
    write(menu_options_file)
}
