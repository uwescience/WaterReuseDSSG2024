---
layout: page
title: Data Processing
---
---

<img src="{{ site.url }}{{ site.baseurl }}/assets/img/gis_graphic.png" alt="GIS img" class="gis-photo">

## Gathering Geospatial Datasets
In order to create an impactful index, we gathered data from a variety of sources (detailed in the citations below). The data we used captures the indicators that were specified in the driver-indicator structure for drivers of water reuse described on the [Motivation](https://uwescience.github.io/WaterReuseDSSG2024/motivation/) page. 

The data we used was meant to represent the United States on a national level as much as possible, though of course certain variables were more sparse in certain areas. We acknowledge the bias and the impact that a lack of data availability creates in our calculated index and mapped representation. 

Most of the data we used was publically available, and anything that was not publically available was provided by other researchers to use with permission. 

<img src="{{ site.url }}{{ site.baseurl }}/assets/img/Crosswalk.png" alt="crosswalk img" class="crosswalk-photo">
## Process and Merge ("crosswalk") Data to a Target Scale (e.g. Water Service Area). 
Because we used data on various geographic scales, for example census data on county or census tract level in combination with environmental data on a watershed level, we had to scale values up and down based on area or population weighting, depending on the variables and if they were best represented by a mean (e.g. population density) or a sum (e.g. total population) value, respectively. We also had to match boundary lines of overlapping areas by calculating the intersecting areas, bounded by their coordinate geometries. These types of procesesses are common in GIS tasks. Our final dataframe for the Water Reuse Index is on the drinking water service area level. 

We decided to create functions that allow for "crosswalking" data between different geospatial units, sometimes based on a common ID column (for nested geometries) and sometimes based on more complicated area calculations. We allowed for point (longitude, latitude), raster, polygon, and tabular (with an ID column) data in these functions. The functions are detailed in [this tutorial](https://github.com/uwescience/WaterReuseDSSG2024/blob/main/docs/tutorial/crosswalk.md) and the associated R scripts (complete with doc strings) are located in [this folder](https://github.com/uwescience/WaterReuseDSSG2024/tree/main/code/crosswalk). If you are looking for examples of how we used these functions in our data cleaning and crosswalking process, you can take a look at our [cleaning files](https://github.com/uwescience/WaterReuseDSSG2024/tree/main/code/data_cleaning) here. 

Additional resources and tips for GIS processing have been [compiled here](https://github.com/uwescience/WaterReuseDSSG2024/blob/main/docs/tutorial/GIS_Resources.md). 

[Notes and examples](https://github.com/uwescience/WaterReuseDSSG2024/blob/main/code/data_cleaning/final_merge.Rmd): For the Provisional Water Reuse Index, we imputed null values to 0. We converted all values to percentiles prior to performing a Principal Component Analysis. We dropped any water service areas with no associated geometry that could be mapped. 

## Assign Variables ("indicators") to Categories ("drivers")
We knew that it was important to maintain the conceptual indicator/driver structure shown on the [Motivation](https://uwescience.github.io/WaterReuseDSSG2024/motivation/). We did this by creating a list mapping the drivers to the indicator values (columns) they are measured by. This impacts both how the index is calculated and the menu options that appear on the final website. This is detailed in following pages and in the [create_website.Rmd](https://github.com/uwescience/WaterReuseDSSG2024/blob/main/geo-ndxr/create_index.Rmd).


## Data Citations 

| **Dataset Name**                                    | **Citation** |
|-----------------------------------------------------|--------------|
| **2000-2020, Public supply water use reanalysis**    | Luukkonen, C.L., Alzraiee, A.H., Larsen, J.D., Martin, D.J., Herbert, D.M., Buchwald, C.A., Houston, N.A., Valseth, K.J., Paulinski, S., Miller, L.D., Niswonger, R.G., Stewart, J.S., and Dieter, C.A., 2023, Public supply water use reanalysis for the 2000-2020 period by HUC12, month, and year for the conterminous United States: U.S. Geological Survey data release, [https://doi.org/10.5066/P9FUL880](https://doi.org/10.5066/P9FUL880). |
| **WaSSI**                                           | USDA/UFS      |
| **2015 Water Use Survey**                           | USGS          |
| **2024 EJScreen Data - Census Tracts**              | U.S. Environmental Protection Agency. Risk-Screening Environmental Indicators (RSEI) [https://www.epa.gov/rsei](https://www.epa.gov/rsei) (2019). |
| **ACS 2018-2022**                                   | Steven Manson, Jonathan Schroeder, David Van Riper, Katherine Knowles, Tracy Kugler, Finn Roberts, and Steven Ruggles. IPUMS National Historical Geographic Information System: Version 18.0 [dataset]. Minneapolis, MN: IPUMS. 2023. [http://doi.org/10.18128/D050.V18.0](http://doi.org/10.18128/D050.V18.0) |
| **ATTAINS Dataset** - Data only                     | US EPA        |
| **ATTAINS Dataset** - Geopackage                    | US EPA        |
| **Bureau of Labor Statistics**                      | Bureau of Labor Statistics |
| **CDC Waterborne Disease Outbreaks**                | CDC           |
| **Clean Watersheds Needs Survey (CWNS)**            | US EPA        |
| **Climate Vulnerability Index (CVI)**               |               |
| **Coastal Submarine Flows**                         | Sawyer, David, and Famiglietti 2016 |
| **County-Scale Rainwater Harvesting Potential**     | Ennenbach, M.W., Concha Larrauri, P. and Lall, U., 2018. County‐scale rainwater harvesting feasibility in the United States: Climate, collection area, density, and reuse considerations. JAWRA Journal of the American Water Resources Association, 54(1), pp.255-274. |
| **CSO Inventory**                                   | US Environmental Protection Agency |
| **CVI -->  2018 Highway Performance Monitoring System (HPMS)** | U.S. Department of Transportation - Federal Highway Administration. Highway Performance Monitoring System (HPMS) Functional System 1 - 4 , [https://www.fhwa.dot.gov/policyinformation/hpms.cfm](https://www.fhwa.dot.gov/policyinformation/hpms.cfm) (2018). |
| **CVI --> 2020 Presidential Voter Turnout**         | MIT Election Data and Science Lab. Voter Turnout (2020 Presidential), [https://electionlab.mit.edu/research/voter-registration](https://electionlab.mit.edu/research/voter-registration) (2020). |
| **CVI --> 2050 Wildfire Factor**                    | First Street Foundation. Flood Factor Risk Statistics V 2.0, [https://firststreet.org/press/press-release-flood-factor-v2-0-launch/](https://firststreet.org/press/press-release-flood-factor-v2-0-launch/) (2022). |
| **CVI --> Agricultural pesticides**                 | Wieben, C. M. Estimated Annual Agricultural Pesticide Use for Counties of the Conterminous United States, 2013-17 (ver. 2.0, May 2020). U.S. Geological Survey data release (2019). [https://doi.org/10.5066/P9F2SRYH](https://doi.org/10.5066/P9F2SRYH). |
| **CVI --> Change in Flood Factor, 2020-2050**       | First Street Foundation. Flood Factor Risk Statistics V 2.0, [https://firststreet.org/press/press-release-flood-factor-v2-0-launch/](https://firststreet.org/press/press-release-flood-factor-v2-0-launch/) (2022) |
| **CVI --> CHAS**                                    | U.S. Department of Housing and Urban Development. Office of Policy Development and Research Consolidated Planning/CHAS Data. Database [https://www.huduser.gov/portal/datasets/cp.html#2006-2018_query](https://www.huduser.gov/portal/datasets/cp.html#2006-2018_query) (2014-2018). |
| **CVI --> Consecutive Dry Days**                    | Iturbide M. et al. Repository supporting the implementation of FAIR principles in the IPCC-WG1 Atlas. (2021). |
| **CVI --> County Health Rankings & Roadmaps (CHR&R)** | University of Wisconsin Population Health Institute and the Robert Wood Johnson Foundation. County Health Rankings & Roadmaps (CHR&R), [https://www.countyhealthrankings.org/2022-measures](https://www.countyhealthrankings.org/2022-measures) (2022). |
| **CVI --> Flood Factor**                            | First Street Foundation. Flood Factor Risk Statistics V 2.0, [https://firststreet.org/press/press-release-flood-factor-v2-0-launch/](https://firststreet.org/press/press-release-flood-factor-v2-0-launch/) (2022). |
| **CVI --> Medically Underserved Areas**             | Health Resources and Services Administration (HRSA). Locations of US Dept of Health and Human Services Health Resources and Services Administration Nursing Facilities; Locations of hospitals and critical access hospitals; Medically Underserved Areas; Counts and rates of health resources; and Health Professional Shortage Areas, [https://data.hrsa.gov/tools/data-explorer](https://data.hrsa.gov/tools/data-explorer) (2022). |
| **CVI --> National Environmental Public Health Tracking Network** | Centers for Disease Control and Prevention. National Environmental Public Health Tracking Network, [https://ephtracking.cdc.gov/](https://ephtracking.cdc.gov/) (2022). |
| **CVI --> National Neighborhood Data Archive (NaNDA)** | Finlay, J. L., M. Esposito, M. Gomez-Lopez, I. Khan, A. Clarke, P. and Chenoweth, M. National Neighborhood Data Archive (NaNDA): Religious, Civic, and Social Organizations by Census Tract, United States, 2003-2017. Ann Arbor, MI: Inter-university Consortium for Political and Social Research [distributor]. (2020-10-20). [https://doi.org/10.3886/E115967V2](https://doi.org/10.3886/E115967V2) |
| **CVI --> Yields (% change)**                       | Hsiang, S. et al. Estimating economic damage from climate change in the United States. Science 356, 1362-1369 (2017). [https://doi.org/10.1126/science.aal4369](https://doi.org/10.1126/science.aal4369) |
| **Drinking Water Service Area Boundaries**          | SimpleLab, Environmental Policy Innovation Center (EPIC), 2022 |
| **Drinking Water Service Area Boundaries**          | US EPA        |
| **Drought Risk to Water Supply**                    | Devineni et al |
| **Global Land Subsidence Probability**              | Hasan, M. F., R. Smith, S. Vajedian, R. Pommerenke, S. Majumdar (2023). Global Land Subsidence Mapping Reveals Widespread Loss of Aquifer Storage Capacity Datasets, HydroShare, [https://doi.org/10.4211/hs.dc7c5bfb3a86479b889d3b30ab0e4ef7](https://doi.org/10.4211/hs.dc7c5bfb3a86479b889d3b30ab0e4ef7) |
| **Global Wastewater Dataset**                       | Jones et. al. |
| **GRACE/GLDAS**                                     | USGS          |
| **Hurricane/Wind Factor**                           | The First Street Foundation |
| **National Land Cover Database (NLCD)**             |               |
| **NPDES Discharge Monitoring Report (DMR) Loading Tool Summaries** | US EPA        |
| **NPDES Discharge Monitoring Reports**              | US EPA        |
| **NPDES Violations**                                | US EPA        |
| **Plumbing Poverty**                                | Meehan        |
| **Principal Aquifers of the US**                    | U.S. Geological Survey, 2003, Principal Aquifers of the 48 Conterminous United States, Hawaii, Puerto Rico, and the U.S. Virgin Islands: U.S. Geological Survey data release, [https://doi.org/10.5066/P9Y2HOUJ](https://doi.org/10.5066/P9Y2HOUJ). |
|

<style>
.gis-photo {
  float: left;
  width: 200px;
  height: 200px;
  object-fit: cover;
  margin-right: 20px;
}