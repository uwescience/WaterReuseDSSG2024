acs_cleaned <- readRDS("~/Downloads/acs_cleaned.rds")



# Define the bounding box coordinates
bbox_coords <- c(xmin = -124.7844079, xmax = -66.9513812,
                 ymin = 24.7433195, ymax = 49.3457868)


# Plot the result
plot <- ggplot(data = acs_cleaned) +
  geom_sf(aes(fill = no_DW_access)) +
  scale_fill_viridis_c(option = "D", na.value = "gray") +
  labs(title = "Housing Units Lacking Complete Plumbing Facilities",
       fill = "Number of housing units",
       caption = "number of occupied housing units lacking complete plumbing facilities by service boundaries") +
  theme_minimal(base_family = "Arial") +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    plot.caption = element_text(hjust = 0.5, size = 10),
    panel.background = element_rect(fill = "white", color = NA)
  )+
  coord_sf(xlim = c(bbox_coords["xmin"], bbox_coords["xmax"]),
           ylim = c(bbox_coords["ymin"], bbox_coords["ymax"]))

ggsave(filename = "acs_no_DW_access.png", plot = plot, path = "~/Desktop/WaterReuseDSSG2024/code/data_cleaning",
       device = "png")


# Plot the result
plot2 <- ggplot(data = acs_cleaned) +
  geom_sf(aes(fill = no_DW_access_pct)) +
  scale_fill_viridis_c(option = "D", na.value = "gray") +
  labs(title = "Housing Units Lacking Complete Plumbing Facilities",
       fill = "Percentage of housing units",
       caption = "percentage of occupied housing units lacking complete plumbing facilities by service boundaries") +
  theme_minimal(base_family = "Arial") +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    plot.caption = element_text(hjust = 0.5, size = 10),
    panel.background = element_rect(fill = "white", color = NA)
  )+
  coord_sf(xlim = c(bbox_coords["xmin"], bbox_coords["xmax"]),
           ylim = c(bbox_coords["ymin"], bbox_coords["ymax"]))

ggsave(filename = "acs_no_DW_access_pct.png", plot = plot2, path = "~/Desktop/WaterReuseDSSG2024/code/data_cleaning",
       device = "png")
