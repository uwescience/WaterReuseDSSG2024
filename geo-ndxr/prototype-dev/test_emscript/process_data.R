
input_file <- "/mnt/input.txt"
output_file <- "/mnt/output.txt"

# Read input data
input_data <- readLines(input_file)

# Simple processing: reverse the text
output_data <- rev(input_data)

# Write output data
writeLines(output_data, output_file)
