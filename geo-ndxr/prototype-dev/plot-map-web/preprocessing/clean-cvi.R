library(tidyverse)
library(tigris)
library(sf)

source("../../../code/create_index/get_pca_weights.R")
source("../../../code/create_index/weighted_average.R")

path <- "/Users/danielvogler/Documents/DSSG/water_reuse/datasets/Drivers/cvi_data/cvi-data.csv"
cvi <- read.csv(path)

# HELPER FUNCTION IMPUTES MEDIAN
impute_median <- function(df) {
  df <- df %>% mutate(across(everything(), ~ ifelse(is.na(.), median(., na.rm = TRUE), .)))
  return(df)
}

clean_cvi <- impute_median(cvi) %>% mutate(FIPS.Code = as.character(FIPS.Code))

tracts_df <- tracts(cb=TRUE, year=2020)

clean_cvi_geom <- right_join(tracts_df, clean_cvi, by = c("GEOID"="FIPS.Code"))

clean_cvi_geom <- clean_cvi_geom %>% select(-c("STATEFP", "COUNTYFP", 
                             "TRACTCE","AFFGEOID", 
                             "NAME","NAMELSAD",
                             "STUSPS","NAMELSADCO",
                             "STATE_NAME", "LSAD", 
                             "ALAND", "AWATER", "State", 
                             "County", "Geographic.Coordinates"))

sf <- st_as_sf(clean_cvi_geom)

# rename columns so that write_sf doesn't fail

columns_to_rename <- setdiff(names(sf), c("GEOID", "geometry"))

new_column_names <- paste0("x", seq_along(columns_to_rename))

names(sf)[names(sf) %in% columns_to_rename] <- new_column_names

sf <- sf %>% select(c(geometry, x1, x2, x3)) %>% slice(51:100)

gj_path <- "./geo-ndxr/prototype-dev/plot-map-web/data/test_2.geojson"

st_write(sf, gj_path, driver = "GEOJSON")

 #web_mapper(sf, index_value_column = "x1")

#sf_ser <- serialize(sf, NULL, ascii=TRUE)

#cat(sf_ser, file = "./geo-ndxr/prototype-dev/plot-map-web/data/test.obj")

#save(sf, file = "./geo-ndxr/prototype-dev/plot-map-web/data/test.obj", ascii=TRUE)
