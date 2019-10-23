rm(list = ls())
setwd(paste("/Users/pablolechon/Desktop/Imperial/", 
            "CMEECourseWork/Week4/Code", sep = ''))
d = read.table('../Data/SparrowSize.txt', header = T)

#Complete population sample
s_tarsus = sd(d$Tarsus, na.rm = T)/sqrt(length(d$Tarsus))
s_mass = sd(d$Mass, na.rm = T)/sqrt(length(d$Tarsus))
s_wing = sd(d$Wing, na.rm = T)/sqrt(length(d$Tarsus))
CI_tarsus = 1.96*s_tarsus
CI_tarsus = 1.96*s_mass
CI_tarsus = 1.96*s_wing

#Subset the dataset
d1 = subset(d,d$Year==2001)
s_tarsu_sub = sd(d1$Tarsus, na.rm = T)/sqrt(length(d1$Tarsus))
s_mass_sub = sd(d1$Mass, na.rm = T)/sqrt(length(d1$Tarsus))
s_wing_sub = sd(d1$Wing, na.rm = T)/sqrt(length(d1$Tarsus))
CI_tarsus = 1.96*s_tarsu_sub
CI_mass = 1.96*s_mass_sub
CI_wing = 1.96*s_wing_sub

#Hipothesis testing
t.test(d1$Tarsus, mu = 18.5, na.rm = T)

t.test(d1$Wing, mu = mean(d$Wing, na.rm = T), na.rm = T)
#We can aslso use t to test for differences in meant
boxplot(d$Wing~d$Sex.1, col = c("red", "blue"), ylab="Body mass (g)")
t.test2 = t.test(d$Wing~d$Sex)

#Lets test it for the subset of 2001
boxplot(d1$Wing~d1$Sex.1, col = c("red", "blue"), ylab="Body mass (g)")
t.test1 = t.test(d1$Wing~d1$Sex)

#Even a smaller sample of the pop
dsmal = as.data.frame(head(d,50))
t.test2small <- t.test(d1$Mass~d1$Sex) 
t.test2small

#Power detection
library(pwr)

pwr.t.test(d = 5/sd(d$Wing, na.rm = T), power = .8,
           sig.level = .05, type = 'one.sample', 
           alternative = 'two.sided')


