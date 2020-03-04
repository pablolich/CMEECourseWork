#Clean variables
rm(list = ls())

#Set working directory
setwd('~/Desktop/Imperial/CMEECourseWork/mini_project/Code/')

#Turn warnings off
options(warn=-1)

d = read.csv('../Data/LogisticGrowthData.csv', stringsAsFactors = F)
#Removing outliers
outlier = which(d$PopBio == min(d$PopBio))
d = d[-outlier,]
#Make all population values positive
min_pop = min(d$PopBio)
d$PopBio = d$PopBio - min_pop
#Remove 0
zero = which(d$PopBio == 0)
d = d[-zero,]
#Create a unique id
d$unique_id  = paste(d$Species, d$Temp, d$Medium)

#Fix data from species Tetraselmis tetrahele
ind = which(d$Species == 'Tetraselmis tetrahele')
#Get a separate data set for treatement
d_Tetra = d[ind,]
#Subtract this from initial dataset
d = d[-ind,]
#Only time>0
d_Tetra = d_Tetra[which(d_Tetra$Time>0),]
#Get a vector of temperatures
temp = d_Tetra$Temp
#Into the data fixing
source('data_preparation_functions.R')
#Prepare initial variables to store results
temp_factors = unique(temp)
graphics.off()
t_mod = c()
pop_mod = c()
temp_mod = c()
for (j in temp_factors){
  #Get t indices of equivalent measurements
  t = d_Tetra$Time[which(d_Tetra$Temp == j)]
  pop = d_Tetra$PopBio[which(d_Tetra$Temp == j)]
  ind_sets = binning(t, 0.25)
  t_av_t = rep(0, length(ind_sets))
  pop_av_t = rep(0, length(ind_sets))
  for (i in seq(length(ind_sets))){
    #Average equivalent measurements by temperature
    ind_vect = ind_sets[[i]]
    t_av_t[i] = median(t[ind_vect])
    pop_av_t[i] = median(pop[ind_vect])
  }
  #Store results
  t_mod = c(t_mod, t_av_t) 
  pop_mod = c(pop_mod, pop_av_t)
  temp_mod = c(temp_mod, rep(j, length(t_av_t)))
}

#Create single dataframe with modified data
d_mod = data.frame('X' = seq(length(t_mod)) , 
                   'Time' = t_mod, 
                   'PopBio' = pop_mod, 
                   'Temp' = temp_mod, 
                   'Time_units' = rep('Hours', length(t_mod)), 
                   'PopBio_units' = rep('N', length(t_mod)), 
                   'Species' = rep('Tetraselmis tetrahele', length(t_mod)),
                   'Medium' = rep('ESAW', length(t_mod)),
                   'Rep' = rep(NA, length(t_mod)), 
                   'Citation' = rep('Bernhardt, J.R., Sunday, J.M. and O’Connor, M.I., 2018. Metabolic theory and the temperature-size rule explain the temperature dependence of population carrying capacity. The American naturalist, 192(6), pp.687-697.', length(t_mod)),
                   'unique_id' = paste('Tetraselmis tetrahele',temp_mod, 'ESAW'))
#Add dataframe to original data
d = rbind(d, d_mod)
#Eliminate rows with negative time
ind = which(d$Time<0)
d = d[-ind,]
#Create a column with log10 data
d$y_t = log10(d$PopBio)

keeps <- c('Time', 'y_t', 'Species', 'Temp', 'Medium', 'unique_id', 'PopBio_units')
d = d[keeps]
#Save new dataframe
write.csv(d, file = '../Data/LogisticGrowthData_mod.csv', row.names = F)

