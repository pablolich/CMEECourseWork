# CMEE 2019 HPC excercises R code HPC run code proforma
setwd("~/Desktop/Imperial/CMEECourseWork/Week8/Code")
library(ggplot2)
library(ggpubr)
rm(list=ls()) # good practice 
source("pl1619_HPC_2019_main.R")
# it should take a faction of a second to source your file
# if it takes longer you're using the main file to do actual simulations
# it should be used only for defining functions that will be useful for your cluster run and which will be marked automatically

# do what you like here to test your functions (this won't be marked)
# for example
# should return 4 when you've written the function correctly for question 1

# you may also like to use this file for playing around and debugging
# but please make sure it's all tidied up by the time it's made its way into the main.R file or other files.
#neutral_step_speciation(c(1,2,3,4), 0.8)

#neutral_generation_speciation(community = c(1,2,3,4), speciation_rate = 0.8)

#question_12()

#species_abundance(c(1,2,3,4,3,4,5,5))

#octaves(c(100, 64, 63, 5, 4, 3, 2, 2, 1, 1, 1, 1))

#question_16()

#cluster_run(speciation_rate = 0.1, size = 100, wall_time = 0.1, interval_rich = 1, interval_oct = 10, 
 #           burn_in_generations = 200, output_file_name = 'my_test_file_1.rda')


chaos_game()

#Turtle

plot.new()
plot.new()
plot.window(xlim=c(-10,20), ylim=c(-10,20))
axis(1)
axis(2)
#turtle(start_position = c(0,0), direction = pi/4, length = 1)
#elbow(start_position = c(0,0), direction = pi/5, length = 1)
text = spiral(start_position = c(0,15), direction = 0, length = 10)











