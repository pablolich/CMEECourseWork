# CMEE 2019 HPC excercises R code HPC run code proforma
setwd("~/Desktop/Imperial/CMEECourseWork/Week8/Code")
rm(list=ls()) # good practice 
source("pl1619_HPC_2019_main.R")
community = seq(10)
species_richness(community)

init_community_max(10)

init_community_min(10)

choose_two(10) 

neutral_step(community)

neutral_generation(community)

duration = 5
neutral_time_series(community, duration)

question_8()

speciation_rate = 0.1
neutral_step_speciation(community,speciation_rate)

neutral_generation_speciation(community,speciation_rate)

question_12()

species_abundance(community)

abundance_vect = species_abundance(community)
octaves(abundance_vect)

sum_vect(c(1,2,3), c(1,2,3,4))

question_16()

cluster_run(speciation_rate = 0.1, size=100, 
            wall_time=0.1, interval_rich=1, interval_oct=10,
            burn_in_generations=200, 
            output_file_name = 'my_test_file_1.rda')
load('my_test_file_1.rda')

process_cluster_results()

question_21()

question_22()

chaos_game()

draw_spiral()

draw_tree()

draw_fern()

draw_fern2()

Challenge_A()

Challenge_B()

Challenge_B_alternative()

Challenge_C()

Challenge_D()

Challenge_E()

Challenge_F()
