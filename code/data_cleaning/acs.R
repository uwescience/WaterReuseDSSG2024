library(dplyr)
library(sf)
library(ggplot2)
library(readr)
acs <- read_csv("~/Downloads/ACS_extracts.csv")
library(tigris)

source("~/Desktop/WaterReuseDSSG2024/code/crosswalk/crosswalk_spatial.R")
source("~/Desktop/WaterReuseDSSG2024/code/crosswalk/crosswalk_geom.R")
source("~/Desktop/WaterReuseDSSG2024/code/crosswalk/crosswalk_raster.R")


census_tracts <- tracts(cb = TRUE, year = 2020, filter_by = c(-124.7844079, -66.9513812, 24.7433195, 49.3457868))

service <- st_read("~/Desktop/WaterReuseDSSG2024/data/EPA PWS boundaries/EPA_CWS_V1.shp")

acs <- acs %>%
  rename(GEOID = TL_GEO_ID)

acs_sf <- census_tracts %>%
  left_join(acs, by = "GEOID")

service <- st_transform(service, crs = st_crs(acs_sf))
service <- service %>%
  st_make_valid()

joined_data <- st_join(service, acs_sf, join = st_intersects)

acs_cleaned <- joined_data %>%
  st_drop_geometry() %>%  
  group_by(PWSID) %>%
  summarize(gini=mean(gini, na.rm=TRUE))

acs_sf <- acs_cleaned %>%
  left_join(service, by = "PWSID")

acs_sf<-st_as_sf(acs_sf)

# Define the bounding box coordinates
bbox_coords <- c(xmin = -124.7844079, xmax = -66.9513812,
                 ymin = 24.7433195, ymax = 49.3457868)

xwalked <- crosswalk_geom(acs_sf, service, join_method ="areal_weighted" )

# Plot the result
plot <- ggplot(data = acs_sf) +
  geom_sf(aes(fill = gini)) +
  scale_fill_viridis_c(option = "D", na.value = "gray") +
  labs(title = "Average Gini Coefficient by Service Boundary",
       fill = "Gini Coefficient",
       caption = "") +
  theme_minimal(base_family = "Arial") +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    plot.caption = element_text(hjust = 0.5, size = 10),
    panel.background = element_rect(fill = "white", color = NA)
  )+
  coord_sf(xlim = c(bbox_coords["xmin"], bbox_coords["xmax"]),
           ylim = c(bbox_coords["ymin"], bbox_coords["ymax"]))

ggsave(filename = "acs_tract_plot_dw.png", plot = plot, path = "~/Desktop/WaterReuseDSSG2024/code/data_cleaning",
       device = "png")
