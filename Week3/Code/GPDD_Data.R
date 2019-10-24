#!/usr/bin/env R 

#Represents on a world map data from location in which we have species information.

#Load the maps package
require(maps)

#Loads the GPDD data
load(file = '../Data/GPDDFiltered.RData', env = globalenv())

#Draw the map
map('world')
map.axes()
points(x = as.numeric(gpdd$long), y  = as.numeric(gpdd$lat),
       pch = 20, cex = 0.1, col ='red')

#A bias coming from the non-uniform distribution of the data points location will probably be present
