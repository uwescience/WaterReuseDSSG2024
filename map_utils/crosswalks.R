library(readxl)
library(tidycensus)
library(tigris)
library(crsuggest)
options(tigris_use_cache = TRUE)
library(urbnmapr)
library(ggplot2)
library(tidyverse)
library(raster)
library(sf)

# read in datasets
drought <- read_excel("~/Desktop/WaterReuseDSSG2024/data/final_results_dissemination_NDINDC.xlsx")
drought$county_fips <- as.character(drought$FIPS)

cvi <- read_csv("~/Downloads/CVI Data Excerpts_rename.csv")
  

cwns <- read_csv("~/Downloads/CWNS_merged.csv")

str_name <- "~/Downloads/CONUS_ww_raster.tif" 
raster <- raster(str_name)


# get 51 unique state fips codes (including dc)
unique_states <- fips_codes %>% 
  filter(state_code < 60) %>%
  pull(state_code) %>% 
  unique()

tracts_url <- "https://nccsdata.s3.us-east-1.amazonaws.com/geo/xwalk/TRACTX.csv"
crosswalk_file <- readr::read_csv(tracts_url)

# assume data is nested (from county to census tracts)
# args: 
# output:library(dplyr)


crosswalk_data <- function(data, 
                           source_scale, 
                           key, 
                           target_scale) {
  
  if (!is.character(data[(source_scale)])) {
    data <- data %>%
      dplyr::mutate({{ source_scale }} := as.character({{ source_scale }}))
  }
  
  print(paste0("Maximum number of digits for the identifier is ", max(nchar(source_scale))))
  print(paste0("Minimum number of digits for the identifier is ", min(nchar(source_scale))))
  
  appendix <- crosswalk_file %>%
    dplyr::select({{ key }}, {{ target_scale }}) 
  
  target_data <- data %>%
    dplyr::left_join(appendix, 
                     by = setNames(key, source_scale))
  
  return(target_data)
}

# Usage example:
# county to census tract
sample1 <- crosswalk_data(drought, 
                          source_scale = "county_fips", 
                          key = "county.census.geoid", 
                          target_scale = "tract.census.geoid")
# census tract to county
sample2 <- crosswalk_data(cvi,
                          source_scale = "FIPS Code",
                          key = "tract.census.geoid",
                          target_scale = "county.census.geoid")
# census tract to county
sample3 <- crosswalk_data(cwns,
                          source_scale = "CWNS_ID",
                          key = "tract.census.geoid",
                          target_scale = "county.census.geoid")


