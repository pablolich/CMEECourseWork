#!/usr/bin/env R 

#Plots lattice plots regarding different types of magnitudes grouping them by feeding.interaction.
#Creates a table with mean, and median corresponding to the different groups.

rm(list = ls())
MyDF <- read.csv("../Data/EcolArchives-E089-51-D1.csv")

#Get indexes of positions where units are in mg
ind = which(MyDF$Prey.mass.unit == 'mg')
MyDF$Prey.mass[ind] = MyDF$Prey.mass[ind]/1000
MyDF$Prey.mass.unit[ind] = 'g'
library(lattice)
library(plyr)
pdf('../Results/Pred_Lattice.pdf', 11.7, 8.3)
densityplot(~log(MyDF$Predator.mass) | MyDF$Type.of.feeding.interaction, data=MyDF)
graphics.off()
pdf('../Results/Prey_Lattice.pdf', 11.7, 8.3)
densityplot(~log(MyDF$Prey.mass) | MyDF$Type.of.feeding.interaction, data=MyDF)
graphics.off()
pdf('../Results/SizeRatio_Lattice.pdf', 11.7, 8.3)
densityplot(~log(MyDF$Prey.mass/MyDF$Predator.mass) | MyDF$Type.of.feeding.interaction, data=MyDF)
graphics.off()

#the command ddply groups MyDF into .(group) if you specify the option summarize.
#to this groups, it applies the operations you want, in this case mean and median. 
#make sure to not call the different columns using the $ notation, or othrewise ddply won't work
#correctly
table = ddply(MyDF, .(Type.of.feeding.interaction), summarize,
              mean_pred = mean(log(Predator.mass)),
              median_pred = median(log(Predator.mass)),
              mean_prey = mean(log(Prey.mass)),
              median_prey = median(log(Prey.mass)),
              mean_ratio = mean(log(Prey.mass/Predator.mass)),
              median_ratio = median(log(Prey.mass/Predator.mass)))

#quote = F avoids writing the strings enclosed by ""
write.table(table, '../Results/PP_Results.csv', row.names = F, quote = F) 
