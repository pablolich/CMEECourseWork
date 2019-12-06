#!/usr/bin/env R 

#Extention of PP_Regress.R. This time, the groups are made attending also to the location of the
#species.
options(warn = -1)

MyDF <- read.csv("../Data/EcolArchives-E089-51-D1.csv")
#Get indexes of positions where units are in mg
ind = which(MyDF$Prey.mass.unit == 'mg')
MyDF$Prey.mass[ind] = MyDF$Prey.mass[ind]/1000
MyDF$Prey.mass.unit[ind] = 'g'

new_df = data.frame('lifestage.feeding.location' = paste(MyDF$Predator.lifestage, 
                                                MyDF$Type.of.feeding.interaction,
                                                MyDF$Location,
                                                sep = '_'), 
                    'prey.mass' = MyDF$Prey.mass, 
                    'predator.mass' = MyDF$Predator.mass)

library(plyr)
library(broom)
table = ddply(new_df, .(lifestage.feeding.location), summarize,
              intercept = lm(log10(predator.mass)~log10(prey.mass))$coef[1],
              slope = lm(log10(predator.mass)~log10(prey.mass))$coef[2], 
              r.squared = summary(lm(log10(predator.mass)~log10(prey.mass)))$r.squared,
              f.statistic = as.numeric(glance(lm(log10(predator.mass)~log10(prey.mass)))[4]),
              p.value = summary(lm(log10(predator.mass)~log10(prey.mass)))$coefficients[8])

write.table(table, '../Results/PP_Regres_loc_Results.csv', row.names = F, quote = F) 

#Warnings suggest that in fact this is too complicate to be meaningful

