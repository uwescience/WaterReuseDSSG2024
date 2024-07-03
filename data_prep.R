library(tidyverse)
library(readxl)
# This package is used to wrangle raster datasets
library(terra)
library(sf)
library(urbnmapr)


# fertilizer_data <-  read_csv("Data Sets/Found_dataset/fert-farm-1987-2017.txt")
# 
# fertilizer_np <- read_xlsx("Data Sets/Found_dataset/N-P_from_fertilizer_1950-2017-july23-2020.xlsx")
# 
# global_waster_percent <- read.table("Data Sets/Found_dataset/Wastewater_production/Country_WWctr_Percentage.txt", sep = '\t',header = TRUE)
# 
# global_waster_flow_rate <- read.table("Data Sets/Found_dataset/Wastewater_production/Country_WWpctr_FlowRate.txt", sep = '\t',header = TRUE)

# Learning to use terra ####
# The package can read lots of terra file formats
# Reading raster data (Global waste water production, collection, treatment and re-use)
global_ww_raster <- rast("Data Sets/Found_dataset/Wastewater_production/WWpctr_5arc.nc")
# NetCDF (nc)is a format commonly used for storing multi-dimensional scientific data 
# such as temperature, humidity, pressure, wind speed, and direction.
global_ww_raster

# Get the summary of the raster
summary(global_ww_raster)

# Get the name of the variable names
names(global_ww_raster)
varnames(global_ww_raster)

# global_ww_raster is a SpatRaster of 4 layers
# Get a single layer by subset the global_ww_raster
gww_raster_layer2 <- global_ww_raster[[2]]
gww_raster_layer2
# Datum is a model that is used to estimate the angle of longitude and latitudes
# That are used as a reference point

# Inspect the coordinsate reference system
crs(global_ww_raster)

# This dataset uses the WGS 84 crs
# WGS 84: The World Geodetic System (WGS) is a standard used in cartography, geodesy, 
# and satellite navigation including GPS. The current version, WGS 84, defines an 
# Earth-centered, Earth-fixed coordinate system and a geodetic datum, and also 
# describes the associated Earth Gravitational Model (EGM) and World Magnetic Model (WMM). 
# The standard is published and maintained by the United States National 
# Geospatial-Intelligence Agency.[1]


# Check if the cells have numbers
hasValues(global_ww_raster)
hasValues(gww_raster_layer2)
# We can get the cell values of the Spatraster dataset
gww_raster_values <- values(global_ww_raster)
head(gww_raster_values)
gww_raster_layer2_values <- values(gww_raster_layer2)
head(gww_raster_layer2_values)

# Get the sources of the raster data
sources(global_ww_raster)
sources(gww_raster_layer2)

# Get the values of the dataset
summary(values(gww_raster_layer2))
summary(values(global_ww_raster))

# Plot the data using thr values function
plot(gww_raster_layer2)

# We can use global to get summary statistics of the entire SpatRaster
# It is used with functions like mean", "min", "max", "su", "prod", "range" (min and max)
# "rms" (root mean square), "sd" (sample standard deviation), "std" (population standard deviation), "isNA" (number of cells that are NA), "notNA" (number of cells that are not NA)

# Get only the value of row 1000 to 1005
gww_raster_layer2_values[1000:1005]


# # The rasterVis package provides a lot of very nice plotting options as well
# plot(gww_raster_layer2)
# plot(global_ww_raster)

# Read a specific variable from the global_wastewater
wwp <- rast("Data Sets/Found_dataset/Wastewater_production/WWpctr_5arc.nc", "WWp")
print(wwp)
summary(wwp)
# Taking one variable is the same as taken one layer
wwp1 <- global_ww_raster[[1]]
wwp1
wwp_values <- values(wwp)
head(wwp_values)
plot(wwp1)

# Use the bounding box coordinates for the continental United States to crop the data
# Top: 49.3457868 north latitude
# Left: -124.7844079 west longitude
# Right: -66.9513812 east longitude
# Bottom: 24.7433195 south latitud

# Define the extent of the US (xmin, xmax, ymin, ymax)
us_extent <- ext(-124.7844079, -66.9513812, 24.7433195, 49.3457868)
# crop the raster data to get only for the US
# This can also be done like this

# Create an empty list to store the cropped rasters
cropped_rasters <- list()

# Loop through each layer in the global raster and crop each layet to US extent
for (i in 1:nlyr(global_ww_raster)) {
  cropped_raster = crop(global_ww_raster[[i]], us_extent)

  cropped_rasters[[i]] = cropped_raster

}

# I need shapefile to to be able to get county data
# I can get this shape file from the US census bureau
# I can use urbanmapr to get the shapefile

plot(cropped_rasters[[1]])

# Get the county level dataset
# read th shapefile
counties_shapefile <- vect("Data Sets/Found_dataset/cb_2023_us_county_5m/cb_2023_us_county_5m.shp")
head(counties_shapefile)
summary(counties_shapefile)

plot(counties_shapefile)
# Check the crs of the shapefile
crs(counties_shapefile)

## reproject the shapefile to match the raster
counties_shapefile <-  project(counties_shapefile, global_ww_raster)
counties_shapefile
# # what if I project  global_ww_raster
# global_ww_raster <- project(global_ww_raster, counties_shapefile)
# global_ww_raster

# Loop through each county and extract the raster data
county_ww_data <- data.frame()
for (i in 1:length(counties_shapefile)){
  # get the current county
  county = counties_shapefile[i]
  
  # make a vector to store the sum values of each layer
  sum_values = c()
  
  # Loop through each cropped raster layer
  for (j in 1:length(cropped_rasters)){
    # extract data for the current county
    extracted_values = extract(cropped_rasters[[j]], county, fun = sum, na.rm = TRUE)
    # extracted values is a dataframe of an ID and a value
    
    # Get the sum value
    sum_value = extracted_values[1, 2]
    # Append the sum value to the vector
    sum_values <- c(sum_values, sum_value)
  }
  # create a dataframe for the current county
  county_df = data.frame(
    NAME = county$NAME,
    wwp_sum = ifelse(length(sum_values) >= 1, sum_values[1], NA),
    wwc_sum = ifelse(length(sum_values) >= 2, sum_values[2], NA),
    wwt_sum = ifelse(length(sum_values) >= 3, sum_values[3], NA),
    wwr_sum = ifelse(length(sum_values) >= 4, sum_values[4], NA)
  )
  # append the county data to the main datafrma
  county_ww_data = rbind(county_ww_data, county_df)
}


write_csv(county_ww_data, "Data Sets/county_ww.csv")


# Convert counties_shapefile to sf format
# it provides simple feature access
counties_sf <- st_as_sf(counties_shapefile)

# Merge the spatial data with the extracted data
counties_sf <- counties_sf %>% left_join(county_ww_data, by = "NAME")

# Plot the data for layer1_sum
ggplot(data = counties_sf) +
  geom_sf(mapping = aes(fill = wwp_sum)) +
  scale_fill_viridis_c(option = "plasma", na.value = "grey50") +
  labs(title = "Waste Water Production by County",
       fill = "Total Values") +
  theme_minimal()


# Plot the data for layer1_sum
ggplot(counties_sf) +
  geom_sf(mapping = aes(fill = wwp_sum)) +
  scale_fill_gradient(name = "Cubic Meter Per Year",
                      label = scales::comma_format()) +
  labs(title = "Waste Water Production by County")

counties = get_urbn_map(sf = TRUE, map = "counties")

test <- vect("Data Sets/Found_dataset/tl_2019_us_county/tl_2019_us_county.shp")
head(test)





for (i in counties_sf$GEOID){
  print(i)
}






