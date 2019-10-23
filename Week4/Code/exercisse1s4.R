rm(list = ls())
setwd(paste("/Users/pablolechon/Desktop/Imperial/", 
            "CMEECourseWork/Week4/Code", sep = ''))
d = read.table('../Data/SparrowSize.txt', header = T)

#Complete population sample
s_tarsus = sqrt(sd(d$Tarsus, na.rm = T)/length(d$Tarsus))
s_mass = sqrt(sd(d$Mass, na.rm = T)/length(d$Tarsus))
s_wing = sqrt(sd(d$Wing, na.rm = T)/length(d$Tarsus))


#Subset the dataset
d1 = subset(d,d$Year==2001)
s_tarsu_sub = sqrt(sd(d1$Tarsus, na.rm = T)/length(d1$Tarsus))
s_mass_sub = sqrt(sd(d1$Mass, na.rm = T)/length(d1$Tarsus))
s_wing_sub = sqrt(sd(d1$Wing, na.rm = T)/length(d1$Tarsus))
