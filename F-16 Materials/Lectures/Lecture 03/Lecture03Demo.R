#  Lecture 03 Demo

library(MASS)
data(UScereal)
head(UScereal)  #  shows the first few rows of te data.frame
colnames(UScereal)  #  shows the column names of the data.frame
rownames(UScereal)  #  shows the row names of the data.frame

ggplot(data = UScereal, aes(x = mfr)) + geom_bar()
ggplot(data = UScereal, aes(x = vitamins)) + geom_bar()
ggplot(data = UScereal, aes(x = shelf)) + geom_bar()

