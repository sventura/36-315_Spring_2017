
library(tidyverse)
library(reshape2)
library(forcats)

#  Read in data
bike_data <- read_csv("https://raw.githubusercontent.com/sventura/315-code-and-datasets/master/data/nyc-citi-bike-data-subset.csv")
date_time <- colsplit(bike_data$starttime, " ", c("date", "time"))

#  Add start_date variable to big_bike, and a bunch of other variables
bike_data <- mutate(bike_data,
                    time_of_day = as.vector(date_time$time),
                    start_date = as.Date(date_time$date, format = "%m/%d/%Y"),
                    birth_decade = paste0(substr(`birth year`, 1, 3), "0s"),
                    hour_of_day = as.integer(substr(time_of_day, 1, 2)),
                    am_or_pm = ifelse(hour_of_day < 12, "AM", "PM"),
                    day_of_week = weekdays(start_date),
                    less_than_30_mins = ifelse(tripduration < 1800, 
                                               "Short Trip", "Long Trip"),
                    less_than_15_mins = ifelse(tripduration < 1800, 
                                               "Less Than 15 Minutes", 
                                               "15 Minutes Or Longer"),
                    weekend = ifelse(day_of_week %in% c("Saturday", "Sunday"), 
                                     "Weekend", "Weekday"))

day_level <- c("Sunday", "Monday","Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")
bike_data <- bike_data %>%
  mutate(
    day_of_week2 = factor(day_of_week,  day_level)
  )

ggplot(bike_data, aes(x = day_of_week)) + geom_bar()
ggplot(bike_data, aes(x = day_of_week2)) + geom_bar()


f <- factor(c("a", "b", "c", "d"))
fct_relevel(f)
fct_relevel(f, "c")
fct_relevel(f, "b", "a")


f <- (c("M", "Tu", "W", "Th", "F",
        "Sa", "Su"))
day_15 <- bike_data %>%
  mutate(
    day_of_week = factor(day_of_week, f)
  ) 

ggplot(day_15, aes(x=fct_relevel(day_of_week, f), fill = less_than_15_mins)) + 
  geom_bar(position = "fill") + 
  labs(title = "Proportions of Rides Greater than and Less than 15 Minutes")

day_15 <- bike_data %>%
  group_by(day_of_week, less_than_15_mins) %>%
  summarize(count = n())

#Using full bike_data
ggplot(bike_data, aes(x = fct_rev(fct_infreq(day_of_week)), fill = less_than_15_mins)) + 
  geom_bar(position = "dodge")+
  labs(
    title = "Day of the Week and Length of Bike Ride",
    x = "Day of Week",
    y = "Count"
  )



