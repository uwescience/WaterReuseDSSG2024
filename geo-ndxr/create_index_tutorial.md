GeoNdxR for Index Creators
================
2024-08-15

``` r
knitr::opts_chunk$set(eval = FALSE, echo = TRUE)
```

# Index and Website Creation Pipeline

Creator pipeline for calculating a default index and setting up an
interactive website displaying an index map. This is a working template
for index creation. DO NOT PUSH to the GitHub repository.

## Required Packages and source GeoNdxR crosswalk functions

## Set working directory

Set your working directory to the location that the cloned GitHub repo
lives on your computer. Start the path with a ‘/’ and DO NOT include a
‘/’ at the end.

``` r
home_path <- "~/Downloads/WaterReuseDSSG2024"
setwd(home_path)
root_dir <- home_path
```

Load required packages. Note it may take a few mins to load them.

``` r
pacman::p_load(tigris, tidyverse, dplyr, sf, usmap, ggplot2, naniar, raster, terra, stars, nngeo, exactextractr, naniar, geojsonsf, rmapshaper, geojsonio, jsonlite)


#Source GeoNdxR crosswalk functions. Find documentation for these functions linked in the GitHub README. 
source(paste0(home_path, "/code/crosswalk/crosswalk_geom.R"))
source(paste0(home_path,"/code/crosswalk/crosswalk_raster.R"))
source(paste0(home_path,"/code/crosswalk/crosswalk_spatial.R"))
source(paste0(home_path,"/code/crosswalk/crosswalk_census.R"))
source(paste0(home_path,"/code/crosswalk/crosswalk_id.R"))
source(paste0(home_path,"/code/crosswalk/apply_weight.R"))
source(paste0(home_path,"/code/website_helper/edit_website.R"))
source(paste0(home_path,"/code/create_index/driver_weighted_pca.R"))
source(paste0(home_path,"/code/website_helper/update_metadata.R"))
```

## Load, explore, and transform data

``` r
data_path <- paste0(home_path,"/geo-ndxr/prototype-dev/connecting-pieces/")

file_name <- "output.geojson"
```

## Calculate default/initial index

Fill in your categories and indicators and how they are structured.
These will become your sidebar menu options (categories and indicators
to calculate the index). An example structure is below. Keep in mind
that categories are creator-chosen and specified, they do not exist in
the data itself. This will decide the order of indicators that show up
on the website. Please change the object `data_structure_for_index`
accordingly.

``` r
data_structure_for_index <- list(Cat1 = list(gini = "gini",
                                             eco_imp_land_mean = "eco mean"),
                                 Category2 = list(NRI_score = "NRI",
                                                  runoff_max = "runoff max"))
```

Run below R code. This step will run weighted PCA. You do not need to
change the below.

``` r
file.exists(paste(data_path, file_name,sep="/"))
percentile_data <- geojsonsf::geojson_sf(paste(data_path, file_name,sep="/"))

input_json <- data_structure_for_index

test_structure <- data.frame(
  Driver = character(),
  Indicator = character(),
  stringsAsFactors = FALSE
)

for (category in names(input_json)) {
  for (key in names(input_json[[category]])) {
    test_structure <- rbind(test_structure, data.frame(
      Driver = category,
      Indicator = key,
      stringsAsFactors = FALSE
    ))
  }
}

numeric_df <- st_drop_geometry(percentile_data[, sapply(percentile_data, is.numeric)])
  
initial_index <- multidriver_pca(data = numeric_df,
                 user_selection = names(numeric_df),
                 index_structure = test_structure)

data_with_index <- cbind(percentile_data, initial_index)
```

Save the dataframe with weighted PCA values.

``` r
pca_result_path <- "specify_path"
write_csv(data_with_index, pca_result_path)
```

## Export data

Fill in the commented sections of this code chunk in order to export a
valid .geojson version of your final data. This file will be located in
the `geo-ndxr/website_materials` folder of the downloaded GitHub
repository on your computer. You will not need to interact directly with
this file. DO NOT CHANGE THE NAME OF THE GEOJSON FILE being exported or
the website creation functions will not work.

``` r
# Export data as a .geojson file in the website template folder of the repo. DO NOT EDIT. 
save_path <- paste(home_path,"geo-ndxr/website_materials",sep="/")

# Store the final version of your data in a final sf object. 
final_sf <- data_with_index

# Confirm and correct the CRS (Coordinate Reference System) of your final dataframe.
final_sf <- st_transform(final_sf, crs = 4326)

# Simplify your geometries to save file space (ensures fast web performance for mapping the index). 
final_json <- geojson_json(final_sf, geometry = "polygon")
final_json_simplified <- ms_simplify(final_json)

#Save the geojson. DO NOT EDIT filepath. 
geojson_write(final_json_simplified, 
              file = paste0(home_path, "/geo-ndxr/website_materials/output.data"))
```

Open output.js.metadata in your `geo-ndxr/website_materials` folder. You
can use any text editor of your choice. Replace the two placeholders
after running the following lines of code.

Replace `%chars` part in the output.js.metadata with the value below. Do
not put quotes around the number.

``` r
nchar(final_json_simplified)
```

Replace `%bytes` part in the output.js.metadata with the value below. Do
not put quotes around the number.

``` r
nchar(final_json_simplified, type = "bytes")
```

## Customizing the website

Set the *website title*, *description*, and *geo_unit* by editing below.
Description will be at the bottom of the website.

``` r
website_title <- "TITLE OF YOUR CHOICE"
  
description <- "TEST Fill in your description. Data is sourced from __organization/website__. Data was published __date__. This data describes ____ conditions across the United States." 

geo_unit <- "PWSID" 

#Do not change the below two lines. 
menu_options <- data_structure_for_index
initial_index <- "initial_index"

edit_website(website_title = website_title, 
             description = description, 
             menu_options = menu_options, 
             initial_index = initial_index, 
             geo_unit = geo_unit, 
             home_path = home_path)
```

## Follow instructions to host the web

You will now have a customized HTML file called `index.html` in the
`website_materials` folder along with your geo-spatial data (including a
calculated default index).

You can test to see if the website looks as expected by following the
following steps: 1. Navigate to the website_materials folder in your
terminal. 2. Type this command: python -m http.server On Windows
machines, type python3 http.server and get it from the Windows Store. 3.
Open your browser and type localhost:8000/index.html 4. Interact with
the website and check all functionality works as expected. 5. If you
encounter any issues that our documentation in the GitHub repo doesn’t
solve, feel free to create an issue on our
[`repository`](https://github.com/uwescience/WaterReuseDSSG2024/issues)
describing your problem, your process, and any relevant screenshots. We
are still in development and working out bugs and your feedback is
highly valued.

If you are satisfied with the finished webpage, you will need to take
the necessary steps to host your html page on a free or hosted web
service. We recommend following the tutorial linked on our GitHub README
to host your website on GitHub pages.

Happy indexing!

-GeoNdxR team
