#!/usr/bin/env Rscript

# This script loads the a file with the heights of trees g
# and calculates the height of each tree based on its distance and inclination 
#degrees  using  the trigonometric formula 
#
# height = distance * tan(radians)
#
# ARGUMENTS
# degrees:   The angle of elevation of tree
# distance:  The distance from base of tree (e.g., meters)
#
# OUTPUT
# The heights of the tree, same units as "distance"

###############################################################################

args = commandArgs(trailingOnly=TRUE)

if (length(args) == 0){
	stop("One argument must be supplied (input file)")
}

#Functions

TreeHeight <- function(degrees, distance){
  radians <- degrees * pi / 180
  height <- distance * tan(radians)
  
  return(height)
}

loaddata = function(name){
  return(read.csv(paste('../Data/', name, sep = '')))
}

#Code

#load dataT
name = args[1]
trees = loaddata(name)

#Vectorized version
height <- TreeHeight(trees$Distance.m, trees$Angle.degrees)

#Create data frame
TreeHts <- data.frame('Species' = trees$Species, 
		      'Distance.m' = trees$Distance.m,
                      'Angle.degrees' = trees$Angle.degrees, 
		      'Tree.Height.m' = height)

#Save to csv
#strsplit is getting rid of the .csv extension
write.csv(TreeHts, 
          paste('../Results/', strsplit(name, '.csv')[[1]], 
		'_treeheights.csv', sep = ''),
          row.names = F, quote = F) #To write strings without quotes
