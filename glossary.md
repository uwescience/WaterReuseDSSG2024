---
title: "Glossary"
layout: page
---
## User Roles
**Index Creator:** uses R functions provided in this repo to determine which variables are included in an index, pre-process them, calculate the default index, and generate an interactive website.

**Index Explorer:** accesses the website created by the R user & interacts with the graphical user interface. May explore the interactive map and recalculate the index by selecting a subset of the indicators the Index Creator has made available.

## GIS Terminology
**Scale/Scaling:** in the context of the Water Reuse Index project, scale refers to the basic geographical units that organize the different datasets that contribute to the Index. For example, different datasets are organized at the census tract, county, or watershed levels. These are all different geographic _scales_ we need to be able to convert between in order to make an index over common units.

**Crosswalking:** the process of converting between different geographic scales. For example, suppose we have one dataset where each row is a state and another dataset where each row is a county. We want to create an index that include both of them. To do this, we have to map counties to the states they're in and convert one of the datasets so that both are on the same scale. This process is called _crosswalking_.

**Spatial join:** the process of matching rows from one dataset with another based on some overlap in their spatial relationship. For example, if one dataset has rows for every county and another has rows for every ZIP code, spatially joining these datasets may mean checking whether the rows in the county-level dataset overlap with any ZIP codes. If they do, those two rows will be merged.

## Water Reuse Specific Terminology

**Water Reuse:** Defined by the Environmental Protection Agency (EPA) as “the practice of reclaiming water from a variety of sources, treating it, and reusing it for beneficial purposes.” For more detailed information, visit this [Water Reuse Glossary](https://watereuse.org/educate/water-reuse-101/glossary/). 

**NPDES:** [National Pollutant Discharge Elimination System]([url](https://www.epa.gov/npdes/npdes-permit-basics)), a permitting program set up by the US Environmental Protection Agency. **NPDES requires most wastewater facilities to report data about the substances they discharge, a key data source for this project.**

**Watershed:** A watershed is a basin where all flowing surface water drains in a given geographic area. 

**HUC:** hydrologic unit code. "The United States is divided and sub-divided into successively smaller hydrologic units... The hydrologic units are arranged or nested within each other, from the largest geographic area (regions) to the smallest geographic area (cataloging units). Each hydrologic unit is identified by a unique hydrologic unit code (HUC)." -[US Geographic Survey]([url](https://water.usgs.gov/GIS/huc.html))


