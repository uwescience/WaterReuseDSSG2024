# Load necessary packages
library(dplyr)

root_dir <- config::get()
datasets_folder <- "/2022CWNS_NATIONAL_APR2024/"

datasets_dir <- paste0(root_dir, datasets_folder)

files_in_dir <- list.files(path = datasets_dir)

files_for_merge <- grep("\\.csv$", files_in_dir, value = TRUE)

join_column <- "CWNS_ID"

first_table_path <- paste0(datasets_dir, "FACILITIES.csv")

first_table <- read.csv(first_table_path)

df <- first_table %>% mutate(CWNS_ID = as.character(CWNS_ID))

# Initialize a counter for the number of tables merged
tables_merged <- 1

# Create or clear the log file
log_file <- "merge_log.txt"
cat("", file = log_file)

for (tablename in files_for_merge) {
  
  print(paste("Processing table", tablename))
  
  table_path <- paste0(datasets_dir, tablename)
  table <- read.csv(table_path)
  
  # CWNS id is numeric natively
  table <- table %>% mutate(CWNS_ID = as.character(CWNS_ID))
  
  merged_df <- merge(df, table, by = join_column, all = TRUE)
  
  suffix_x <- grep("\\.x$", names(merged_df), value = TRUE)
  suffix_y <- grep("\\.y$", names(merged_df), value = TRUE)
  
  resolved_df <- merged_df %>% 
    mutate(across(all_of(suffix_x), ~coalesce(.x, get(
      gsub("\\.x$", ".y", cur_column()))), .names = "{.col}")) %>% 
    select(-all_of(c(suffix_y))) %>% 
    rename_with(~gsub("\\.x$", "", .), ends_with(".x"))
  
  df <- resolved_df
  
  print(nrow(df))
  print(ncol(df))
  
  tables_merged <- tables_merged + 1
  print(paste("Tables merged:", tables_merged))
  
  new_columns <- setdiff(names(table), join_column)
  log_message <- paste("Table:", tablename, "\nColumns added:", paste(new_columns, collapse = ", "), "Shape after addition:(", nrow(df), ",", ncol(df), ")")
  cat(log_message, "\n", file = log_file, append = TRUE)
}

print(df)
