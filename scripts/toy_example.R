root_dir <- config::get()
datasets_folder <- "/2022CWNS_NATIONAL_APR2024/"

datasets_dir <- paste0(root_dir, datasets_folder)

join_column <- "CWNS_ID"

flow_name <- "FLOW.csv"
facility_name <- "FACILITY_TYPES.csv"

flow <- read.csv(paste0(datasets_dir, flow_name))

flow <- flow %>% mutate(CWNS_ID = as.character(CWNS_ID))

facility <- read.csv(paste0(datasets_dir, facility_name))

facility <- facility %>% mutate(CWNS_ID = as.character(CWNS_ID))

merged_df <- merge(flow, facility, by = join_column, all = TRUE)

suffix_x <- grep("\\.x$", names(merged_df), value=TRUE)
suffix_y <- grep("\\.y$", names(merged_df), value=TRUE)


resolved_df <- merged_df %>% 
  mutate(across(all_of(suffix_x), ~coalesce(.x, get(gsub("\\.x$", ".y", cur_column()))), .names = "{.col}")) %>% 
  select(-all_of(c(suffix_y))) %>% # remove the columns duplicated in the merge; for cleanup
  rename_with(~gsub("\\.x$", "", .), ends_with(".x")) # remove .x suffix

print(resolved_df)
