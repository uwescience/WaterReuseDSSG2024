edit_options <- function(website_title, description, menu_options) {
  
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
    #'Overwrites options.json in the website folder to include your custom website options. 
  
  require(rjson)
  
  #fix the relative path
  options <- fromJSON(file= paste0(getwd(), "/geo-ndxr/prototype-dev/learning-checkboxes/learning-dynamic-checkboxes/options.json"))
  
  #replace content with input strings/lists
  options$website_title <- website_title
  options$description <- description 
  options$menu_options <- menu_options
  
  # Specify the file to overwrite (options.json)
  out = file(paste0(getwd(), "/geo-ndxr/prototype-dev/learning-checkboxes/learning-dynamic-checkboxes/options.json"))
  
  # Write the file contents in JSON format
  toJSON(options, pretty = TRUE, auto_unbox = TRUE) %>%
    write(out)
}
