---
title: "Website Generation"
layout: page
---

## Website Generation
**Overview of the Web Map Creation:**
Web Assembly with webr:
- We used webr, a web assembly framework for R, to build the website that hosts the map. Web assembly allows us to run R code directly in the browser, which eliminates the need for a server to host the map. This setup is particularly efficient because it enables the map to be displayed and interacted with entirely on the client side.

Serverless Map Display:
- Thanks to webr, the map is rendered and displayed in the browser without requiring a backend server. This is achieved by compiling the R code into web assembly, allowing the map and its functionalities to run smoothly in the user's browser. As a result, users can interact with the map instantly without the latency or complexity of server-side processing.

**User Interaction and Customization:**
Index Map Display:
- The primary feature of the website is the display of an index map, which visualizes the calculated index values across different geographic regions. Users can explore these indices directly on the map, gaining insights into the spatial distribution of the underlying data.

Exploring Specific Drivers and Indicators: 
- We also provide users with the ability to explore specific drivers or indicators that contribute to the overall index. Through an interactive interface, users can select and prioritize certain drivers or indicators over others, allowing for a customized view of the data. This flexibility enables users to focus on the aspects of the data that are most relevant to their needs or interests.
