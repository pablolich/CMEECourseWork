rm(list = ls())

MyDF <- read.csv("../data/EcolArchives-E089-51-D1.csv")

#Get indexes of positions where units are in mg
ind = which(MyDF$Prey.mass.unit == 'mg')
MyDF$Prey.mass[ind] = MyDF$Prey.mass[ind]/1000

require(plyr)
require(ggplot2)
require(gridExtra)
require(cowplot)

table = ddply(MyDF, .(Type.of.feeding.interaction, Predator.lifestage), summarize, 
              prey.mass = Prey.mass, predator.mass = Predator.mass)

ggplot(MyDF, aes(log(MyDF$Prey.mass), log(MyDF$Predator.mass))) + 
  geom_point() + 
  facet_grid(~ MyDF$Type.of.feeding.interaction)
