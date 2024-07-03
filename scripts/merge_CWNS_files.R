library(dplyr)

root_dir <- config::get()
datasets_folder <- "/2022CWNS_NATIONAL_APR2024/"

datasets_dir <- paste0(root_dir, datasets_folder)

files_in_dir <- list.files(path = datasets_dir)

files_for_merge <- grep("\\.csv$", files_in_dir, value = TRUE)

join_column <- "CWNS_ID"

first_table_path <- paste0(datasets_dir, files_for_merge[1])

first_table <- read.csv(first_table_path)

df <- first_table %>% mutate(CWNS_ID = as.character(CWNS_ID))

for (tablename in files_for_merge[-1]) {
  
  table_path <- paste0(datasets_dir, tablename)
  table <- read.csv(table_path)
  
  table <- table %>% mutate(CWNS_ID = as.character(CWNS_ID))
  
  merged_df <- merge(df, table, by = join_column, all = TRUE)
  
  suffix_x <- grep("\\.x$", names(merged_df), value = TRUE)
  suffix_y <- grep("\\.y$", names(merged_df), value = TRUE)
  
  
  resolved_df <- merged_df %>% 
    mutate(across(all_of(suffix_x), ~coalesce(.x, get(gsub("\\.x$", ".y", cur_column()))), .names = "{.col}")) %>% 
    select(-all_of(c(suffix_y))) %>% # remove the columns duplicated in the merge; for cleanup
    rename_with(~gsub("\\.x$", "", .), ends_with(".x")) # remove .x suffix
  
  df <- resolved_df
  
}

print(df)

