
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


#  Fourth Down Data from Greg
fourthDowns.train = playData.train[which(playData.train$down == "4"),]    
dim(fourthDowns.train) # = 19889   19 
fourthDowns.train = fourthDowns.train[, c("down", "ydstogo", "yrdline100", "TimeSecs", "ScoreDiff", 
                                          "OffensiveTimeouts", "DefensiveTimeouts", "PlayType", "WPA.train", "posteam")]

fourthDowns.test = playData.test[which(playData.test$down== "4"),]
# [1] 4193   19
fourthDowns.test = fourthDowns.test[, c("down", "ydstogo", "yrdline100", "TimeSecs", "ScoreDiff", 
                                        "OffensiveTimeouts", "DefensiveTimeouts", "PlayType", "WPA.test", "posteam")]


#  Create is_pass, is_rush, etc variables for training and testing data
fourthDowns.train <- fourthDowns.train %>%
  filter(PlayType %in% c("Pass", "Run", "Field Goal", "Punt")) %>%
  mutate(is_pass = 1 * (PlayType == "Pass"),
         is_run = 1 * (PlayType == "Run"),
         is_fg = 1 * (PlayType == "Field Goal"),
         is_punt = 1 * (PlayType == "Punt")) %>%
  rename(WPA = WPA.train)

fourthDowns.test <- fourthDowns.test %>%
  filter(PlayType %in% c("Pass", "Run", "Field Goal", "Punt")) %>%
  mutate(is_pass = 1 * (PlayType == "Pass"),
         is_run = 1 * (PlayType == "Run"),
         is_fg = 1 * (PlayType == "Field Goal"),
         is_punt = 1 * (PlayType == "Punt")) %>%
  rename(WPA = WPA.test)


#  Plots
library(gridExtra)
yards_to_go <- ggplot(fourthDowns.train, aes(x = ydstogo, y = WPA, color = PlayType)) + 
  geom_point(alpha = 0.25) + geom_smooth(size = 2) + ylim(-0.25, 0.25) + 
  theme_bw() + labs(title = "WPA vs. Yards to Go, by Play Type",
                    subtitle = "Fourth Down Plays, 2011-2015")

yard_line <- ggplot(fourthDowns.train, aes(x = yrdline100, y = WPA, color = PlayType)) + 
  geom_point(alpha = 0.25) + geom_smooth(size = 2) + ylim(-0.25, 0.25) + 
  theme_bw() + labs(title = "WPA vs. Yard Line, by Play Type",
                    subtitle = "Fourth Down Plays, 2011-2015")

x <- grid.arrange(yards_to_go, yard_line)
ggsave(x, filename = "/Users/sam/Dropbox/Football/armchair analysis data/Archive/ExploratoryGraphs.pdf", 
       height = 10, width = 10)


#  Build series of models for each place on the field
fourth_lm <- lm(WPA ~ is_pass + is_run + is_fg + is_punt,
                data = filter(fourthDowns.train, yrdline100 > 60))
summary(fourth_lm)

fourth_lm <- lm(WPA ~ is_pass + is_run + is_fg + is_punt,
                data = filter(fourthDowns.train, 
                              yrdline100 <= 60, yrdline100 > 50))
summary(fourth_lm)

fourth_lm <- lm(WPA ~ is_pass + is_run + is_fg + is_punt,
                data = filter(fourthDowns.train, 
                              yrdline100 <= 50, yrdline100 > 40))
summary(fourth_lm)

fourth_lm <- lm(WPA ~ is_pass + is_run + is_fg + is_punt,
                data = filter(fourthDowns.train, 
                              yrdline100 <= 40, yrdline100 > 30))
summary(fourth_lm)

fourth_lm <- lm(WPA ~ is_pass + is_run + is_fg + is_punt,
                data = filter(fourthDowns.train, 
                              yrdline100 <= 30, yrdline100 > 20))
summary(fourth_lm)

fourth_lm <- lm(WPA ~ is_pass + is_run + is_fg + is_punt,
                data = filter(fourthDowns.train, 
                              yrdline100 <= 20, yrdline100 > 10))
summary(fourth_lm)

fourth_lm <- lm(WPA ~ is_pass + is_run + is_fg + is_punt,
                data = filter(fourthDowns.train, 
                              yrdline100 <= 10))
summary(fourth_lm)




set.seed(3951824)
# Table of counts (contingency)
X <- sample(letters[1:3], 100, 1)
Y <- sample(letters[4:5], 100, 1)
t  <- table(X,Y)
tp  <- t/100 # proportions
tn  <- tp/sum(tp)     # normalized, joints
p_x <- rowSums(tn)    # marginals
p_y <- colSums(tn)

P <- tn 
Q <- p_x %o% p_y 

# P(X, Y)   : bin frequency: P_i
# P(X) P(Y) : bin frequency, Q_i 
mi <- sum(P*log(P/Q))
library(entropy)
mi.empirical(t) == mi

freqs1 <- table(sample(letters, 10000, prob = 1:26, replace = T))
freqs2 <- table(sample(letters, 10000, prob = 26:1, replace = T))

KL.plugin(freqs1, freqs2)
chi2.plugin(freqs1, freqs2)
pchisq(2.05, df = 10)



library(MASS)
data(Cars93)
var <- bike_data$day_of_week  # the categorical data 

## Prep data (nothing to change here)
nrows <- 20
df <- expand.grid(y = 1:nrows, x = 1:nrows)
categ_table <- floor(table(var) / length(var) * (nrows*nrows))
categ_table
#>   2seater    compact    midsize    minivan     pickup subcompact        suv 
#>         2         20         18          5         14         15         26 

temp <- rep(names(categ_table), categ_table)
df$category <- sort(c(temp, sample(names(categ_table), nrows^2 - length(temp), prob = categ_table)))
# NOTE: if sum(categ_table) is not 100 (i.e. nrows^2), it will need adjustment to make the sum to 100.

## Plot
ggplot(df, aes(x = x, y = y, fill = category)) + 
  geom_tile(color = "black", size = 0.5) +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL) +
  scale_fill_brewer(palette = "Set3") +
  labs(title="Waffle Chart of Day of Week",
       caption="Source:  NYC Citi Bike Dataset", 
       x = NULL, y = NULL) + 
  theme_bw()





devtools::install_github("yeukyul/lindia", force = TRUE)
library(lindia)
library(MASS)
data(Cars93)

model <- lm(Price ~ Passengers + Fuel.tank.capacity, data = Cars93)
gg_diagnose(model)
?gg_diagnose




