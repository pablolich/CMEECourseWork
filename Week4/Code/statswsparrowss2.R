rm(list = ls())
setwd(paste("/Users/pablolechon/Desktop/Imperial/", 
            "CMEECourseWork/Week4/Code", sep = ''))
d = read.table('../Data/SparrowSize.txt', header = T)
str(d);names(d);head(d);length(d$Tarsus)
hsit(d$Tarsus)
mean(d$Tarsus, na.rm = T)
median(d$Tarsus, na.rm = T)

par(mfrow = c(2,2))
hist(d$Tarsus, breaks = 3, col= 'grey')
hist(d$Tarsus, breaks = 10, col= 'grey')
hist(d$Tarsus, breaks = 30, col= 'grey')
hist(d$Tarsus, breaks = 100, col= 'grey')

install.packages('modeest')
library(modeest)

d2 = subset(d, d$Tarsus!='NA')
length(d2$Tarsus)
