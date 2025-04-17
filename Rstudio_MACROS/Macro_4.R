#============================
# MACRO IV
# FILE PROCESSING (M and Q)
#
# IMPORTANT: set the working directory to a file where M, Q, C data is located
#
# what nucleus are you starting with? (change the variable below)

starting_nuc <- 0 #(important if you already analysed n number of nuclei)

#------ RUN this code using "control + shift + S" ------

#============================


# Get list of M and Q files
m_files <- list.files(pattern = "^M_\\d+\\.csv$")
q_files <- list.files(pattern = "^Q_\\d+\\.csv$")

# Extract numbers from filenames
m_numbers <- as.numeric(gsub("^M_(\\d+)\\.csv$", "\\1", m_files))
q_numbers <- as.numeric(gsub("^Q_(\\d+)\\.csv$", "\\1", q_files))

# Find common numbers between M and Q files
common_numbers <- intersect(m_numbers, q_numbers)

# Initialize an empty list to store merged data
all_merged_data <- list()

# Process each pair of files
for (i in seq_along(common_numbers)) {
  num <- common_numbers[i]
  
  # Construct filenames
  m_file <- paste0("M_", num, ".csv")
  q_file <- paste0("Q_", num, ".csv")
  
  # Read data
  m_data <- read.csv(m_file)
  q_data <- read.csv(q_file)
  
  # 1) Add nucleus column to M data
  m_data <- cbind(nucleus = num+starting_nuc, m_data)
  
  # 2) Remove specified columns
  m_data <- m_data[, !(names(m_data) %in% c("Name", "Label", "Type", "X"))]
  q_data <- q_data[, !(names(q_data) %in% c("Nb", "Name", "Label", "Type", "X"))]
  
  # 3) Merge horizontally (assuming same number of rows and order matches)
  merged_data <- cbind(m_data, q_data)
  
  # Store merged data in the list
  all_merged_data[[i]] <- merged_data
  
  cat("Processed:", m_file, "and", q_file, "\n")
}

# Combine all merged data vertically (row-wise) and order by nuc value
final_df_MQ <- do.call(rbind, all_merged_data)
final_df_MQ <- final_df_MQ[order(final_df_MQ$nucleus), ]

# Calculate measurements per nucleus group
measurements_count <- as.data.frame(table(final_df_MQ$nucleus))
colnames(measurements_count) <- c("nucleus", "measurements")

# Merge counts back into final_data
final_df_MQ <- merge(final_df_MQ, measurements_count, by = "nucleus", all.x = TRUE)

# Reorder columns to place 'measurements' right after 'nucleus'
final_df_MQ <- final_df_MQ[, c("nucleus", "measurements", 
                             setdiff(names(final_df_MQ), c("nucleus", "measurements")))]

# Sort by nucleus (ascending)
final_df_MQ <- final_df_MQ[order(final_df_MQ$nucleus), ]

# Reset row names (optional)
rownames(final_df_MQ) <- NULL

cat("\nAll files processed and combined into 'final_df_MQ'!\n")

# Optional: Write the combined dataframe to a new CSV file
#write.csv(final_df_MQ, "combined_nuc_data.csv", row.names = FALSE)

#---Next stage---

  


