#  Lecture 03 Demo

library(MASS)  #  Load the MASS library
data(UScereal)  #  Load the "UScereal" dataset into your workspace (as a data.frame in R)
help(UScereal)  #  Read the help documentation for this dataset
head(UScereal)  #  shows the first few rows of the data.frame
colnames(UScereal)  #  shows the column names of the data.frame
rownames(UScereal)  #  shows the row names of the data.frame


#  Manufacturer graphs:

#  Bar chart
#  On the x-axis, I am using the mfr categorical variable
#  With bar charts, it's pretty easy to compare the heights of the bars
ggplot(data = UScereal) + geom_bar(stat = "count") + 
  aes(x = mfr) + coord_cartesian()

#  Notice that you don't actually need stat = "count" or stat = "bin" 
#    in the geom_bar() function, since this is the default
#  Also notice that you don't need to include coord_cartesian(),
#    since, again, this is the default
ggplot(data = UScereal) + geom_bar() + 
  aes(x = vitamins)


#  Spine Chart:  
#  On the x-axis, I created a one-category variable with "factor(1)"
#  Then, I colored the single bar according to the mfr variable
#  With spine charts, it's difficult to compare the heights of the stacked bars,
#    much less determine the specific count or proportion
ggplot(data = UScereal) + geom_bar() + 
  aes(x = factor(1), fill = mfr) + coord_cartesian()


#  Let's take the same spine chart and change it to polar coordinates.  What happens?
ggplot(data = UScereal) + geom_bar() + 
  aes(x = factor(1), fill = mfr) + coord_polar()


#  What happened?  It mapped the mfr variable to the fill command -- no good.
#  Remember, we're in polar coordinates, so we have two parameters -- radius and angle
#  Let's change the graph so that the angle is mapped to 
#    the equivalent of "y" in a bar chart, which is the count/proportion
#  As a result, we should get a pie chart
ggplot(data = UScereal) + geom_bar() + 
  aes(x = factor(1), fill = mfr) + coord_polar(theta = "y")


#  In the above pie chart, the angles are proportional to the counts.
#  What is the area proportional to?  Hint:  What's the formula for the area
#    of a "pie slice" of a circle with angle theta?


#  Moving along now.  
#  What if we took our bar chart command and put it in polar coordinates?
ggplot(data = UScereal) + geom_bar() + 
  aes(x = mfr) + coord_polar()


#  We get a rose diagram, where the radii are proportional to the counts/proportions,
#    and the angles are equal.  You can color this with the fill argument, e.g.:
ggplot(data = UScereal) + geom_bar() + 
  aes(x = mfr, fill = mfr) + coord_polar()


#  Okay, one more graph:  Let's start with the rose diagram above.
#  By default, coord_polar() maps the angle, theta, to the "x" argument, 
#    which is specified in aes(x = mfr).
#  In other words, the angles are equal because each one represents a category
#    of the categorical variable mfr
#  See?  Nothing changes if we specify theta = "x" below:
ggplot(data = UScereal) + geom_bar() + 
  aes(x = mfr, fill = mfr) + coord_polar(theta = "x")


#  What will happen if we take the same code, 
#    but now specify theta = "y"?
#  The angle of each category should now be 
#    proportional to the count of that category,
#    so we should get something that looks like a bar chart, but in polar coordinates
#  The resulting graph is called a "target chart", and it has a lot of issues:
#  For example, what are the areas of the concentric circles proportional to?
#  Remember, categories G and K are the most frequent, 
#    but it sure doesn't look like this from this graph!
#  I do not recommend ever using this type of plot
#  This is more to demonstrate that ggplot is very flexible 
#    and will do what you tell it to do...
#    ...even if what you tell it to do makes no sense
ggplot(data = UScereal) + geom_bar() + 
  aes(x = mfr, fill = mfr) + coord_polar(theta = "y")


#  Print out the manufacturer vector
UScereal$mfr

#  Get the category counts for the manufacturer variable
table(UScereal$mfr)

#  Basic Chi-Square Test for equality in proportions for the manufacturer variable
chisq.test(table(UScereal$mfr))
chisq.test(table(UScereal$mfr), p = table(UScereal$mfr) / nrow(UScereal))


#  2-D Categorical bar chart:
ggplot(data = UScereal) + geom_bar() + 
  aes(x = shelf, fill = vitamins)





