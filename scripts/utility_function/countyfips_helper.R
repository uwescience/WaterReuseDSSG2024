###
# The goal of this task is to check whether county_fips is the identifier, correct it if not, and construct one from constituent parts.
# 
# This function will do two things.
# For more information, visit https://www.census.gov/programs-surveys/geography/guidance/geo-identifiers.html#:~:text=The%20full%20GEOID%20for%20many,codes%2C%20in%20which%20they%20nest.

# Check if the county fips identifier is in the format we need (five digits in a character form). The first two digits are state codes. The next three are county codes.
# If not, we want to build the county fips identifier that combines state code and county code.
# Input: county_fips | constructor pieces (state id and county id)
# Output: character vector named "cfips" with values all of length 5
# 
# arguments: cfips=NULL, state=NULL, county=NULL
# location: "scripts/utility_functions"

###

countyfips_helper <- function(
    cfips=NULL, state=NULL, county=NULL){
  if (!is.null(cfips) && is.character(cfips) && nchar(cfips) == 5){
    return(cfips)
  }
  
  if (!is.null(state) && !is.null(county)){
    state <- as.character(state)
    county <- as.character(county)
    cfips <- paste0(state, county)
    return(cfips)
  }
  
  if (!is.null(cfips) && nchar(cfips) < 5){
    cfips <- as.character(cfips)
    cfips <- paste0(0, cfips)
  }
}
