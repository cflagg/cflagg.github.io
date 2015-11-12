
# load libraries
library(dplyr)

# read data
plot_df <- read.csv("C:/Users/cflagg/Documents/GitHub/devTOS/spatialData/supportingDocs/applicableModules.csv")

# check number of rows, has it changed?
nrow(plot_df)

# add columns to match L_plotIDs table
plot_df$domainID <- ""

# select columns for output to plotID table for databases
plot_df %>% select(domainID, plotID, plotType, subtype, plotSize, siteID) -> plotID_out

# write csv file for importing 

