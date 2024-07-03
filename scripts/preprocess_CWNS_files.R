setwd("/Users/danielvogler/Documents/DSSG/WaterReuseDSSG2024") # remove before PR

# Load necessary packages
library(dplyr)

root_dir <- config::get()
datasets_folder <- "/2022CWNS_NATIONAL_APR2024/"

datasets_dir <- paste0(root_dir, datasets_folder)

index_dir <- paste0(datasets_dir, "CWNS-Database-Dictionary-April2024-Tables.csv")

index <- read.csv(index_dir, header = TRUE)

# want to add a column to index telling us if CWNS_ID is repeated in the table with that name

duplicated_status <- vector("logical", length = nrow(index))

for (i in seq_along(index$Table)) {
  
  table_name <- index$Table[i]
  table_path <- paste0(datasets_dir, table_name, ".csv")
  
  print(paste("Opened table", table_name))
  
  table <- read.csv(table_path)
  
  is_duplicated <- any(duplicated(table$CWNS_ID))
  
  duplicated_status[i] <- is_duplicated
  
}

index$is_duplicated <- duplicated_status
