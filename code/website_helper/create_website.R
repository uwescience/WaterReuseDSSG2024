
source(paste0(getwd(), "/geo-ndxr/prototype-dev/web_mapper.R"))

create_website <- function(data, filepath, funcs, control_list = NULL) {
  
  web_mapper(data, filepath)
  
  for (func in funcs) {
    split_html(filepath, func)
  }
  
  #output updated html 
}