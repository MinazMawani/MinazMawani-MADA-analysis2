###############################
# processing script
#
#this script loads the raw data, processes and cleans it 
#and saves it as Rds file in the processed_data folder

#load needed packages. make sure they are installed.

library(readr) #for loading Excel files
library(dplyr) #for data processing
library(here) #to set paths
library(tidyverse)


#path to data
#note the use of the here() package and not absolute paths

data_location <- here::here("data","raw_data","BRFSSdata.csv")

#load data. 

rawdata <- read_csv(data_location)

#take a look at the data
dplyr::glimpse(rawdata)

#Printing the data and checking summary

print(rawdata)
summary(rawdata)


#subsetting for only one state to see changes in current smoking over time
BRFSSnew <- subset(rawdata, State =="Ohio") 

#checking trend of smoking over time
ggplot(data = BRFSSnew) + 
    geom_point(mapping = aes(x = Year, y = 'Smoke some days'))#The trend of smoking remained similar over years
ggplot(data = BRFSSnew) + 
  geom_point(mapping = aes(x = Year, y = 'Smoke everyday'))
ggplot(data = BRFSSnew) + 
  geom_point(mapping = aes(x = Year, y = 'Former smoker'))
ggplot(data = BRFSSnew) + 
  geom_point(mapping = aes(x = Year, y = 'Never smoked'))


# The data is clean and could not see any errors, except i would like to remove the exact location column

processeddata <- select(rawdata, c('Year', 'State', 'Smoke everyday', 'Smoke some days', 
                                    'Former smoker', 'Never smoked'))

                        
# save data as RDS
# location to save file

save_data_location <- here::here("data","processed_data","processeddata.rds")

saveRDS(processeddata, file = save_data_location)


