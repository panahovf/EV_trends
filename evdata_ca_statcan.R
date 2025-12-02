#date: Dec 2025
#author: Farhad Panahov
#project: Retreive EV data from Statistics Canada


####################################################################################
#install library
if (!require("cansim")) {
  install.packages("cansim")
  library(cansim)
}

if (!require("tidyverse")) {
  install.packages("tidyverse")
  library(tidyverse)
}

####################################################################################
# Download Table ID: 20-10-0025-01
# https://www150.statcan.gc.ca/t1/tbl1/en/cv.action?pid=2010002501
table_id <- "20-10-0025-01"

# full dataset with following filters to minimize data size
vehicle_registrations <- get_cansim_connection(table_id) %>%
  filter(
    `Vehicle type` == "Total, vehicle type",
    `Fuel type` %in% c("All fuel types", "Battery electric", "Plug-in hybrid electric")
  )%>%
    collect_and_normalize()

# total for Canada
vehicle_registrations_ca <- get_cansim_connection(table_id) %>% 
  filter(GEO == "Canada") %>% 
  collect_and_normalize()


####################################################################################
# export data
write.csv(vehicle_registrations, "2 - output/ev_regist_canada_total.csv", row.names = TRUE)
write.csv(vehicle_registrations_ca, "2 - output/ev_regist_canada.csv", row.names = TRUE)

