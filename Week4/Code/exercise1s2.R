#Load data

rm(list = ls())
setwd(paste("/Users/pablolechon/Desktop/Imperial/", 
            "CMEECourseWork/Week4/Code", sep = ''))
d_raw = read.table('../Data/SparrowSize.txt', header = T)
#Eliminate NA from our dataset, so all variables have the
#same data

d = subset(d_raw, d_raw$Tarsus!='NA' & d_raw$Mass != 'NA' & d_raw$Bill != 'NA')
d = d_raw[which(d_raw$Tarsus !='NA' & d_raw$Mass != 'NA' & d_raw$Bill != 'NA'),]

#Calculate mean, variance and sdv of 

#Bill length

bill_mean = mean(d$Bill)
bill_std = sd(d$Bill)
bill_var = bill_std^2

#Body mass

mass_mean = mean(d$Bill)
mass_std = sd(d$Bill)
mass_var = bill_std^2

#Wing lengt

wlength_mean = mean(d$Bill)
wlength_std = sd(d$Bill)
wlength_var = bill_std^2

#Multipanel plot

par(mfrow = c(2,2))
hist(d$Bill, col= 'grey')
hist(d$Wing, col= 'grey')
hist(d$Mass, col= 'grey')
hist(d$Tarsus, col = 'grey')

