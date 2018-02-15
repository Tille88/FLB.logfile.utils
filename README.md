# FLB.logfile.utils
Reads in logs to processable format from mavlogdump.py

## Installation
```r
devtools::install_github("Tille88/FLB.logfile.utils/FLB.logfile.utils")
```

## Example code of usage
```r
# Example of usage
library(FLB.logfile.utils)
library(readr)
library(stringr)
library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)
library(corrplot)
library(RColorBrewer)


path = "~/Desktop/reading_in_logs/x5_1_log_flight_15_09_to_15_15_from_16_39_file.txt"
# Read in log
log_df = read_in_log(path)

# Extract full variable lookup table by category and view
extract_variable_lookup(log_df) %>% View()

# Split log df into list of dfs
separate_dfs = split_separate_dfs(log_df)

# Extract single category df in wide format
attitude_df = extract_variables_wide(separate_dfs$ATTITUDE)

# Get summary statistics
attitude_df %>% summary()
# If also want e.g. standard deviation
attitude_df %>% summarise(sd = sd(pitchspeed))

# Extract all in wide format
log_df_wide_list = extract_all_in_wide(separate_dfs)
# Get specific one from list
attitude_df = log_df_wide_list$ATTITUDE
# Quick plot example
# All vars
plot(attitude_df)
#Single variable against time
plot(attitude_df$posix_time, attitude_df$yaw)

# Convert single dataframe to long format
#(e.g. for plotting and not having to interpolate between values)
attitude_long = attitude_df %>% gather(key = variables, value = values, -1) %>% head()

# Combine two dfs in long format and pick specific variables
df_1 = log_df_wide_list$ATTITUDE %>%
  gather(key = variables, value = values, -1)
df_2 = log_df_wide_list$GLOBAL_POSITION_INT %>%
  gather(key = variables, value = values, -1)
combined = rbind(df_1, df_2)  

#Selecting variables at this stage
# Inefficient, but for different plots, you may want to plot different subsets easy
combined_subset = combined %>% filter(variables %in%  c("roll", "rollspeed", "alt"))

# Plots over time
ggplot(combined_subset, aes(posix_time, values)) +
        geom_point(size=0.2) +
        geom_line() +
        facet_grid(variables ~ ., scales = "free_y")

# Connected scatterplot
# Need data in wide format
# If combining categories
#frequency differ, so must deal with that through e.g. interpolation  
global_pos_df = log_df_wide_list$GLOBAL_POSITION_INT

ggplot(global_pos_df, aes(lat,
                          lon,
                          colour=relative_alt)) +
  geom_path()

# Get correlation plot between variables (wide form)
corr_mat=cor(global_pos_df %>% select(-c(1,2)),method="s")
# From http://rpubs.com/melike/corrplot
corrplot(corr_mat, method = "color", outline = T,
         addgrid.col = "darkgray", order="hclust",
         addrect = 4, rect.col = "black",
         rect.lwd = 5,cl.pos = "b", tl.col = "indianred4",
         tl.cex = 1.5, cl.cex = 1.5, addCoef.col = "white",
         number.digits = 2, number.cex = 0.75,
         col = colorRampPalette(c("darkred","white","midnightblue"))(100))

```
