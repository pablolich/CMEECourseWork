#!/usr/bin/env R 

# This script loads the treeheights file with the heights of trees g
# and calculates the height of each tree based on its distance and inclination degrees
#  using  the trigonometric formula 
#
# height = distance * tan(radians)
#
# ARGUMENTS
# degrees:   The angle of elevation of tree
# distance:  The distance from base of tree (e.g., meters)
#
# OUTPUT
# The heights of the tree, same units as "distance"

#########################################################################################

#Functions

TreeHeight <- function(degrees, distance){
	radians <- degrees * pi / 180
	height <- distance * tan(radians)
	
	return(height)
}

#Code

#load data
trees = read.csv('../Data/trees.csv')

#Vectorized version
height <- TreeHeight(trees$Distance.m, trees$Angle.degrees)

#Create data frame
TreeHts <- data.frame('Species' = trees$Species, 'Distance.m' = trees$Distance.m,
                      'Angle.degrees' = trees$Angle.degrees, 'Tree.Height.m' = height)

#Save to csv
write.csv(TreeHts, '../Results/TreeHts.csv', row.names = F)


