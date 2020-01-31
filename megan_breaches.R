setwd("C:/Users/mcaruso/Desktop/Notebook/Data_breaches")

# load libraries
library(tidyverse)
options("scipen" = 10)

# check the file names. This is for a mac. Windows may be different
# learn more at: https://stat.ethz.ch/R-manual/R-devel/library/base/html/list.files.html
files <- list.files("csv/") 
for (file in files) {
  print(paste(file),quote=FALSE) # this should print the filenames that are in the csv dir
}

# Reading these dates in requires a special format: %m/%d/%Y
# Note the capitol Y for years as 0000
dfopen <- read_csv("csv/breach_report2.csv", col_types = cols("Breach Submission Date" = col_date(format = "%m/%d/%Y")), na = "")
dfclosed <- read_csv("csv/breach_report.csv", col_types = cols("Breach Submission Date" = col_date(format = "%m/%d/%Y")), na = "")
# add in the status just in case
dfopen$status <- "open"
dfclosed$status <- "closed"

# now append the two together
df <- rbind(dfopen, dfclosed)

# create columns of year, month to prep for grouping
df$breachd <- format(as.Date(df$`Breach Submission Date`), "%Y-%m") # need this to sort
df$breachdate <- format(as.Date(df$`Breach Submission Date`), "%b-%Y") # need this for presentation


# filter for the month we want, sort by top number of indv affected and slice the top ten
dflist <- filter(df, (`Breach Submission Date` >= '2019-01-01') & (`Breach Submission Date` <= '2019-12-31') ) %>% arrange(desc(`Individuals Affected`)) %>% slice(1:100)

summary(df)

# save to csv 
write_csv(dflist,'csv/top100.csv')

