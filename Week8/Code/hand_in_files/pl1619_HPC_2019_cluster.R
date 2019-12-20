# CMEE 2019 HPC excercises R code HPC run code proforma

rm(list=ls()) # good practice 
graphics.off() #turn off grafics
source("pl1619_HPC_2019_main.R")

#Read in the job number from the cluster
iter = as.numeric(Sys.getenv('PBS_ARRAY_INDEX'))
set.seed(as.integer(iter))
mod = iter %% 4
if (mod == 1){ 
  size = 500 
  } else if (mod == 2){ 
  size = 1000 
  } else if (mod == 3){ 
  size = 2500
  } else { 
  size = 5000
}
output_file_name = paste(c('result_', iter, '.rda'), collapse = '')
cluster_run(speciation_rate = 0.00403, 
            size = size, 
            wall_time = 11.5*60,
            interval_rich = 1, 
            interval_oct = size/10, 
            burn_in_generations = 8*size, 
            output_file_name = output_file_name)

