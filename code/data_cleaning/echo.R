library(dplyr)
library(sf)
library(ggplot2)
library(readr)
library(viridis)  

echo <- read_csv("~/Downloads/Drinking Water ECHO facility search.csv")
shape <- read_sf("~/Downloads/EPA PWS boundaries/EPA_CWS_V1.shp")

echo_cleaned <- echo %>%
  dplyr::rename(violation_points = Viopaccr)

# Verify that there is only one line per PWSID
length(unique(echo_cleaned$PWSId))
nrow(echo_cleaned)

joined_data <- shape %>%
  left_join(echo_cleaned, by = c("PWSID" = "PWSId"))

# Create the plot
echo_plot <- ggplot(data = joined_data) +
  geom_sf(aes(fill = violation_points)) +
  scale_fill_viridis_c(option = "D", na.value = "gray") +
  labs(title = "ECHO Facility",
       fill = "Violation Points",
       caption = "") +
  theme_minimal(base_family = "Arial") +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    plot.caption = element_text(hjust = 0.5, size = 10),
    panel.background = element_rect(fill = "white", color = NA),
    plot.background = element_rect(fill = "white", color = NA),
    panel.grid.major = element_line(color = "gray90"),
    panel.grid.minor = element_line(color = "gray95")
  )+
  coord_sf(xlim = c(bbox_coords["xmin"], bbox_coords["xmax"]),
           ylim = c(bbox_coords["ymin"], bbox_coords["ymax"]))

# Display the plot
print(echo_plot)


# Save the plot
ggsave(filename = "echo_plot.png", plot = echo_plot, path = "~/Desktop/WaterReuseDSSG2024/code/data_cleaning", device = "png")
