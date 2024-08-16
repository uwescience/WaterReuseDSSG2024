Crosswalk Helper Functions
================
2024-07-30

# Crosswalk: tools for web creators

Crosswalks align geospatial data that are on different scales. Scales
refer to units of analysis (county, census tracts, blocks, watershed
etc.)

To analyze datasets at different geospatial resolutions, pre-processing
steps should take place to ensure aggregation (low-to-high resolution)
and splitting ( high-to-low) are done smoothly. With the goal of helping
web creators process their data sets, we provide functions and
supporting data sets to allow crosswalks across nested and un-nested
spatial units.

If your needs are not met by this function, we have compiled a list of GIS resources [here](https://github.com/uwescience/WaterReuseDSSG2024/blob/main/docs/tutorial/GIS_Resources.md).

### Installation

Once you [git clone](https://git-scm.com/docs/git-clone) or download the
Github [Repository](https://github.com/uwescience/WaterReuseDSSG2024),
identify where it is located at. Make sure you edit the `config.yml`
file and replace the template with your home directory path. You can
open and edit the `config.yml` file by using text editors of your
choice. Make sure to save the file and be mindful of white spaces.

For example, if you download and unzip the “WaterReuseDSSG2024” Github
Repo in Downloads folder, my config.yml file would look like below.

``` r
config::get()
```

      $home_path
      [1] "/Users/your_name/Downloads"

``` r
config::get()
#> $home_path
#> [1] "/Users/jihyeonbae/Desktop/WaterReuseDSSG2024"
```

``` r
library(dplyr)
library(docstring)
library(readr)
```

### Crosswalk id example: the `crosswalk_id` function

First, we introduce the `crosswalk_id` function that appends a battery
of ID columns that correspond to your data’s level of analysis.

We use the National Drought Index \[dataset\] data which is at county
level as an example. Unique identifier of each row is FIPS county code.
For more details about the FIPS code, refer to the census bureau
[website](https://www.census.gov/library/reference/code-lists/ansi/ansi-codes-for-states.html).

``` r
root_dir <- config::get()
ndi <- read_csv(paste0(root_dir,"/data/drought_risk.csv"))
head(ndi)
#> # A tibble: 6 × 8
#>   FIPS    FID County            State          NDC     NDI NDC2NDI MY_risk
#>   <chr> <dbl> <chr>             <chr>        <dbl>   <dbl>   <dbl> <chr>  
#> 1 27077     0 Lake of the Woods Minnesota  0.00848 0.00848       1 low    
#> 2 53019     1 Ferry             Washington 0.00351 0.00351       1 low    
#> 3 53065     2 Stevens           Washington 0.0243  0.0243        1 low    
#> 4 53047     3 Okanogan          Washington 0.0161  0.0161        1 low    
#> 5 53051     4 Pend Oreille      Washington 0.00465 0.00465       1 low    
#> 6 16021     5 Boundary          Idaho      0.00835 0.00835       1 low
```

The `crosswalk_id` function will append a list of IDs including census
tracts and states, for each county. You have to tell the function what
your data’s geospatial resolution is. For example, by setting
`source_scale = "FIPS"` and `key = "county.census.geoid"`, you are
telling the `crosswalk_id()` function that your column “FIPS” is
referring to the FIPS county code. Geospatial level of your source_scale
and key should match.

If your data contains some of the inconsistent FIPS Codes, use our
`countyfips_helper()` function to pad 4 digits with zero so that all of
your FIPS codes are in right 5-digits shape. For example, some of the
data sets can contain FIPS code as $1234$ instead of $01234$.

``` r
source(paste0(root_dir, "/code/crosswalk/crosswalk_id.R"))
#docstring(crosswalk_id)

processed_data <- crosswalk_id(data=ndi,  
                               data2=NULL, 
                               source_scale = "FIPS",
                               key = "county.census.geoid")

head(processed_data)
#> # A tibble: 6 × 21
#>   FIPS    FID County    State     NDC     NDI NDC2NDI MY_risk tract.census.geoid
#>   <chr> <dbl> <chr>     <chr>   <dbl>   <dbl>   <dbl> <chr>   <chr>             
#> 1 27077     0 Lake of … Minn… 0.00848 0.00848       1 low     27077460300       
#> 2 27077     0 Lake of … Minn… 0.00848 0.00848       1 low     27077460400       
#> 3 53019     1 Ferry     Wash… 0.00351 0.00351       1 low     53019940000       
#> 4 53019     1 Ferry     Wash… 0.00351 0.00351       1 low     53019970100       
#> 5 53019     1 Ferry     Wash… 0.00351 0.00351       1 low     53019970200       
#> 6 53065     2 Stevens   Wash… 0.0243  0.0243        1 low     53065941000       
#> # ℹ 12 more variables: county.census.geoid <chr>, puma.census.geoid <chr>,
#> #   state.census.geoid <chr>, state.census.name <chr>,
#> #   metro.census.cbsa10.geoid <dbl>, metro.census.cbsa10.name <chr>,
#> #   metro.census.csa10.geoid <dbl>, metro.census.csa10.name <chr>,
#> #   region.woodard.nation <chr>, region.woodard.culture <chr>,
#> #   region.census.main <chr>, region.census.division <chr>
```

``` r
names(processed_data) 
#>  [1] "FIPS"                      "FID"                      
#>  [3] "County"                    "State"                    
#>  [5] "NDC"                       "NDI"                      
#>  [7] "NDC2NDI"                   "MY_risk"                  
#>  [9] "tract.census.geoid"        "county.census.geoid"      
#> [11] "puma.census.geoid"         "state.census.geoid"       
#> [13] "state.census.name"         "metro.census.cbsa10.geoid"
#> [15] "metro.census.cbsa10.name"  "metro.census.csa10.geoid" 
#> [17] "metro.census.csa10.name"   "region.woodard.nation"    
#> [19] "region.woodard.culture"    "region.census.main"       
#> [21] "region.census.division"
```

You will see a list of new id columns appended to each county-level
observation. This set of census-related columns will be provided to
users as a *default*. However, you can specify an external reference
table for ID crosswalk by specifying `data2=NULL`. If your data and
data2 contain a lot of columns and hence if it is hard to manually check
a list of variables that exist in both data sets, refer to
`identify_key()` helper function.

### Crosswalk with weights dataset: `apply_weight` function

If you want to crosswalk *not just* the ID columns, but want to reassign
values to your target scale, `apply_weight` function can be useful.
Let’s use [Climate Vulnerabilitly Index (CVI)
data](https://climatevulnerabilityindex.org) as an example for this
function.

``` r
library(readr)
cvi <- read_csv(paste0(root_dir, "/data/CVI Data Excerpts_rename.csv"))
head(cvi)
#> # A tibble: 6 × 39
#>   State County  `FIPS Code` `Geographic Coordinates` CVI_overall CVI_base_all
#>   <chr> <chr>   <chr>       <chr>                          <dbl>        <dbl>
#> 1 AL    Autauga 01001020100 +32.4771112,-086.4903033       0.577        0.513
#> 2 AL    Autauga 01001020200 +32.4757580,-086.4724678       0.597        0.556
#> 3 AL    Autauga 01001020300 +32.4740243,-086.4597033       0.602        0.570
#> 4 AL    Autauga 01001020400 +32.4710782,-086.4446805       0.564        0.486
#> 5 AL    Autauga 01001020500 +32.4589157,-086.4218165       0.567        0.483
#> 6 AL    Autauga 01001020600 +32.4473470,-086.4768023       0.611        0.569
#> # ℹ 33 more variables: CVI_base_health <dbl>, CVI_base_SEC <dbl>,
#> #   CVI_base_inf <dbl>, CVI_base_env <dbl>, CVI_climate_all <dbl>,
#> #   CVI_climate_health <dbl>, CVI_climate_SEC <dbl>,
#> #   CVI_climate_extremes <dbl>, flood_factor2020 <dbl>, proptax_base2020 <dbl>,
#> #   vote_turnout_2020 <dbl>, RSEI_2019 <dbl>, pesticide_crop_acre <dbl>,
#> #   DW_viol_Pb <dbl>, RSEI_stream <dbl>, impervious_area_pct <dbl>,
#> #   flood_factor2050 <dbl>, wildfire_factor2050 <dbl>, …
```

Note that the cvi dataset is on the census tract level. Our goal is to
walk census tract level to county (upward). There are two ways of
assigning values to higher levels.

- Aggregation: We can simply add up the components to fill in the
  information at the higher level. For example, by adding up the number
  of CVI across all of the census tracts, we get the total number for
  county.
- Weighting: given with the data for the components, we can estimate the
  value of the total by weighting. Note that
  [IPUMS](https://www.nhgis.org/geographic-crosswalks) discusses these
  two approaches more extensively.

First, use `crosswalk_id` function to assign county codes for each of
the census tract.

``` r
cvi_appended <- crosswalk_id(cvi, 
                             data2 = NULL,
                             source_scale = "FIPS Code",
                             key = "tract.census.geoid")
head(cvi_appended)
#> # A tibble: 6 × 52
#>   State County  `FIPS Code` `Geographic Coordinates` CVI_overall CVI_base_all
#>   <chr> <chr>   <chr>       <chr>                          <dbl>        <dbl>
#> 1 AL    Autauga 01001020100 +32.4771112,-086.4903033       0.577        0.513
#> 2 AL    Autauga 01001020200 +32.4757580,-086.4724678       0.597        0.556
#> 3 AL    Autauga 01001020300 +32.4740243,-086.4597033       0.602        0.570
#> 4 AL    Autauga 01001020400 +32.4710782,-086.4446805       0.564        0.486
#> 5 AL    Autauga 01001020500 +32.4589157,-086.4218165       0.567        0.483
#> 6 AL    Autauga 01001020600 +32.4473470,-086.4768023       0.611        0.569
#> # ℹ 46 more variables: CVI_base_health <dbl>, CVI_base_SEC <dbl>,
#> #   CVI_base_inf <dbl>, CVI_base_env <dbl>, CVI_climate_all <dbl>,
#> #   CVI_climate_health <dbl>, CVI_climate_SEC <dbl>,
#> #   CVI_climate_extremes <dbl>, flood_factor2020 <dbl>, proptax_base2020 <dbl>,
#> #   vote_turnout_2020 <dbl>, RSEI_2019 <dbl>, pesticide_crop_acre <dbl>,
#> #   DW_viol_Pb <dbl>, RSEI_stream <dbl>, impervious_area_pct <dbl>,
#> #   flood_factor2050 <dbl>, wildfire_factor2050 <dbl>, …
```

Now that we have a dataframe with a bunch of identifiable ID columns, we
can aggregate/split in many different directions. During this process,
we might have to source population/area weighting data.
[MCDC](https://mcdc.missouri.edu/applications/geocorr2022.html) provides
these weights. Select source scale and target scale for states of
interest. This will generate a .csv file that contains crosswalk
weights. Users should find and save their own weight data of interest.
To be compatible with relative paths, make sure to move weight data to
the \[“/code/crosswalk/weights_data”\] directory.

``` r
root_dir <- config::get()
source(paste0(root_dir,"/code/crosswalk/apply_weight.R"))
source(paste0(root_dir, "/code/crosswalk/process_mcdc_data.R"))
#docstring(apply_weight)

weight_data <- read.csv(paste0(root_dir, "/code/crosswalk/weights_data/2020tr_ct_area.csv"), header = TRUE)[-1,] 
weight_data <- process_data(weight_data)
names(weight_data)
#> [1] "county.census.geoid" "tract"               "CountyName"         
#> [4] "LandSQMI"            "afact"               "tract.census.geoid"
```

In the `apply_weight` function, you have to specify key =
“tract.census.geoid” to let the function know that the source_scale =
“FIPS Code” is actually referring to census tract-level identifier code.
Unlike the earlier example, now we get crosswalked *values* for the
variables of interest.

``` r
cvi_aggregated <- cvi %>%
  apply_weight(source_scale = "FIPS Code",
               weight_data = weight_data,
               key = "tract.census.geoid", 
               target_scale = "county.census.geoid",
               variable = c("CVI_overall", "CVI_base_all"),
               method = "mean",
               weight_value = "afact")
```

### Census crosswalks as default: `crosswalk_census` function

For the web creators’ convenience, we provide additional function that
reads in mostly used weight data sets. This function does not require
you to feed in weight_data, because we provide it for you!

#### ⬆️ Upward crosswalk: CVI example

While you can provide your own weight_data by using `apply_weight()`
function, we provide a default dataset to allow easy aggregation and
splitting across three mostly-used resolutions: *census tract, county,
and Public Use Microdata Area (PUMA).*

``` r
source(paste0(root_dir,"/code/crosswalk/crosswalk_census.R"))
#docstring(crosswalk_census)

cvi_county <- cvi %>%
  crosswalk_census(key = "tract.census.geoid",
                   source_scale = "FIPS Code",
                   target_scale = "county.census.geoid",
                   weight_by = "area",
                   method = "weighted_mean",
                   variable = c("CVI_overall", "CVI_base_all"))
head(cvi_county)
#> # A tibble: 6 × 3
#>   county.census.geoid CVI_overall_weighted_mean CVI_base_all_weighted_mean
#>   <chr>                                   <dbl>                      <dbl>
#> 1 01001                                   0.602                      0.557
#> 2 01003                                   0.592                      0.479
#> 3 01005                                   0.640                      0.628
#> 4 01007                                   0.577                      0.527
#> 5 01009                                   0.602                      0.539
#> 6 01011                                   0.639                      0.594
```

``` r
print(dim(cvi_county))
#> [1] 3087    3
```

The function `crosswalk_census` will print out the intermediary
dataframe where `left_join` of data and embedded weight data happens.
The final output dataframe, “cvi_county” has the right number of rows
(3087), where each row corresponds to county.

#### ⬇️ Downward crosswalk: NDI example

In the previous example, we used NDI dataset - at county level. Using
`crosswalk_census()` function, we can aportion county-level value
downwards to the census tract level. If we want this data to talk to the
census-tract level data, we can automatically let all of the
census-tracts to inherit that value from the upstream. (And census
tracts *always* fall under the county.) Assignment borrowing or
inheritance is appropriate in cases where the values at the higher level
are not shared or distributed down to lower levels.

But for the sake of this tutorial, let’s assume that we want to split
county-level value into multiple census tracts. In case of downward
crosswalk, only `method = "weighted_sum"` makes sense since downward
aportioning is relevant to inverse weighting. The other options (mean,
sum, weighted_mean) would simply return higher-resolution values.

``` r
ndi_reduced <- ndi %>%
  crosswalk_census(source_scale = "FIPS",
                   key = "county.census.geoid",
                   target_scale = "tract.census.geoid",
                   weight_by = "area",
                   method = "weighted_sum",
                   variable = c("NDI", "NDC")
                   )

head(ndi_reduced)
#> # A tibble: 6 × 3
#>   tract.census.geoid NDI_weighted_sum NDC_weighted_sum
#>   <chr>                         <dbl>            <dbl>
#> 1 01001020100               0.000110         0.000110 
#> 2 01001020200               0.0000377        0.0000377
#> 3 01001020300               0.0000600        0.0000600
#> 4 01001020400               0.0000703        0.0000703
#> 5 01001020501               0.0000686        0.0000686
#> 6 01001020502               0.0000240        0.0000240
```

### Unnested crosswalk: `crosswalk_spatial`

All of the functions above are useful for handling nested datasets. We
further allow users to crosswalk un-nested datasets by using
spatial_joins.Perform spatial crosswalks on point, shapefile, and raster data 
when a geo-id crosswalk is unavailable. 

Please read the docstrings for the wrapper function crosswalk_spatial
for information on arguments. The function crosswalk_spatial relies on
crosswalk_raster and crosswalk_geom, which deal with spatial conversions
to/from rasters and shapefiles respectively. To look at the underlying
methods of those functions, see crosswalk_raster.R and crosswalk_geom.R.

The function crosswalk_spatial can deal with point, polygon, multipoint,
and raster data. Specify the data of interest and the data containing
target geometries, which can be polygons or rasters.

The output will be a shapefile in all cases except raster/raster
conversions.

Depending on the input data types, the output will take the mean,
areal_weighted mean, or maximum area as an aggregation method. See the
documentation of crosswalk_spatial for more details on this.

This function will automatically detect geometry columns associated with 
shapefiles. 

Please be mindful of NA values prior to performing spatial crosswalks/joins. 
When taking areal-weighted averages and sums, all target geometries will be 
maintained even if the resulting interpolation is NA. Prior to calculating the 
interpolation, NA values in the source data will be removed so as to not cause 
calculations to return NA. You will need to check your NAs and handle them in 
the way you see appropriate before using the crosswalked data output by this 
function.  
 
When assigning points to shapes, all points will be returned with their 
associated shapes (left join where points are maintained). When assigning point 
values to a raster, you will end up with a polygonized raster with appended 
values for points contained by the raster squares.

Notes on using raster data in combination with other data: 
- Point data is set on the raster scale but maintains its original values. NA 
values for polygonized rasters not containing a point. Will double count 
polygons containing multiple points. 
- Raster/shapefile combinations will output a shapefile, not a raster. User must
rasterize polygon data if they want the output to be a raster. 
- Raster/raster combinations stack the two files to be a stacked raster object.
The output is a stacked raster. Users must combine with another shapefile if 
they want a shapefile output. 

#### example

``` r
source(paste0(root_dir, "/code/crosswalk/crosswalk_spatial.R"))
#docstring(crosswalk_spatial)
```

#### Watershed to county: overlapping polygons

Below is an example of a shape/shape conversion using the areal-weighted
mean and preserving the values as spatially intensive (in contrast to
preserving a spatially extensive value, e.g. population).

``` r

aquifers <- st_read(paste0(root_dir,"/data/us_aquifers.shp"))
head(aquifers)

# aquifers <- st_transform(aquifers, crs = st_crs(counties_sf))
# aquifers <- st_make_valid(aquifers)

joined_sfs <- crosswalk_spatial(aquifers, counties_sf, extensive = FALSE, join_method = "areal_weighted")

head(joined_sfs)
```

#### Point to county

This changes point-level data to county-level.

``` r
cwns <- st_read(paste0(root_dir,"/data/CWNS_merged.csv"))
cwns <- cwns %>% 
  dplyr::select(LATITUDE, 
         LONGITUDE, 
         CURRENT_DESIGN_FLOW)

joined_sfs <- crosswalk_spatial(cwns, counties, location_columns = c("LATITUDE", "LONGITUDE"))

head(joined_sfs)
```

#### Point to raster 

#### Stacking rasters

#### Rasters to shapes 

