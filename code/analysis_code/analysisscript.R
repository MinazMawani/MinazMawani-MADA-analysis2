###############################
# analysis script
#
#this script loads the processed, cleaned data, does a simple analysis
#and saves the results to the results folder

#load needed packages. make sure they are installed.
library(ggplot2) #for plotting
library(broom) #for cleaning up output from lm()
library(here) #for data loading/saving
library(tidyverse)

#path to data
#note the use of the here() package and not absolute paths
data_location <- here::here("data","processed_data","processeddata.rds")

#load data. 
mydata <- readRDS(data_location)

######################################
#Data exploration/description
######################################

#summarize data 
mysummary = summary(mydata)

#look at summary
print(mysummary)

#do the same, but with a bit of trickery to get things into the 
#shape of a data frame (for easier saving/showing in manuscript)
summary_df = data.frame(do.call(cbind, lapply(mydata, summary)))

#save data frame table to file for later use in manuscript
summarytable_file = here("results", "summarytable.rds")
saveRDS(summary_df, file = summarytable_file)

#make a scatterplot of data
#we also add a linear regression line to it
p1 <- mydata %>% 
  filter(State == "Georgia") %>%
  ggplot(aes(x=Year, y=`Smoke everyday`)) + 
  geom_point() + ggtitle("Trend in Smoking Every Day, Georgia") + labs(y = "# of Persons Smoking Every Day") +
  geom_smooth(method='lm') #In Georgia, the number of people who smoke every day looks like it's decreasing over time

#look at figure
plot(p1)

#save figure
figure_file = here("results","resultfigure.png")
ggsave(filename = figure_file, plot=p1) 

######################################
#Data fitting/statistical analysis
######################################

# fit linear model

lmfit <- lm(`Smoke everyday` ~ Year, mydata)  

# place results from fit into a data frame with the tidy function
lmtable <- broom::tidy(lmfit)

#look at fit results
print(lmtable) #The number of people who smoke every day in Georgia decreases by -0.476 persons per additional 1 year. This relationship is statistically significant (p-value = 4.03E-70).

# save fit results table  
table_file = here("results", "resulttable.rds")
saveRDS(lmtable, file = table_file)

  