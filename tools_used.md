---
title: "Tools we Used"
layout: page
---

## Tools we Used

**1. R Programming Language:**

Generalized Crosswalk Function:
- We used R to develop generalized crosswalk functions that enable web creators to transform data across different geographic scales, such as from state level to county level, census tract level, water service areas, or watershed boundaries. These functions ensures consistent alignment and comparability of data, regardless of its original scale, which is essential for accurate mapping and analysis.

Generalized Index Calculation Function:
- We also employed R to write the generalized function that calculates the index. This function takes the standardized and weighted data, applies necessary transformations (such as PCA), and computes the final index values. This index calculation function is a core component of the web map, allowing for the dynamic creation of indices based on user-selected criteria and weights.

Web Assembly (webr Library):
- Using the webr library in R, we wrote web assembly code to deploy the map and related functionalities directly in the browser. Web assembly enables us to compile R code into a format that can be executed client-side, making the application serverless, efficient, and responsive.

**2. HTML (HyperText Markup Language):**

Website Structure:
- We used HTML to structure the website that hosts the interactive map. It defines the layout, elements, and organization of the content, providing the foundation for the web application. HTML ensures that the map and its controls are accessible and user-friendly.

**3. Leaflet JavaScript Library:**

Interactive Map Display:
- We use the Leaflet JavaScript library to display the interactive map. Leaflet is an open-source library that provides tools for creating mobile-friendly, interactive maps. It supports features like map tiles, layers, markers, popups, and controls, enabling users to zoom, pan, and interact with various map elements. Leaflet’s flexibility and ease of use make it an ideal choice for web-based mapping.
