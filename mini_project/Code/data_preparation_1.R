#Clean variables
rm(list = ls())

#Set working directory
setwd('~/Desktop/Imperial/CMEECourseWork/mini_project/Code/')

#Require packages
library('plyr')
library('RColorBrewer')
library('wesanderson')

#Turn warnings off
options(warn=-1)

d = dplyr::tbl_df(read.csv('../Data/LogisticGrowthData.csv',
                           stringsAsFactors = F))
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

#Create a color legend for each medium
#Choose the palette
pal <-wes_palette("FantasticFox1", type = "continuous")
jColors = with(d, 
               data.frame(Medium = unique(Medium), 
                          color = grDevices::colorRampPalette(pal)(length(unique(Medium))),
                          stringsAsFactors = F))

#Shuffle the colors so we get a clearer difference for each medium
jColors$color = jColors[sample(1:length(jColors$color)), 'color']

#Group by species
d_species = ddply(d, .(Species, Temp, Medium), summarize, 
                  Time = Time, PopBio = PopBio, 
                  matchRetVal = match(Medium, jColors$Medium))

write.csv(d_species, file = '../Data/growth_data.csv', row.names = F)

#Plot all species
list_species = unique(d_species$Species)
k = 0
#pdf(file = paste('../Sandbox/all_plots.pdf', sep = ''), height = 11, width = 8)
for (i in list_species){
  ind = which(d_species$Species == i)
  d_species_plot = d_species[ind,]
  #Multipanel plot for each temperature
  list_temperatures = unique(d_species$Temp[ind])
  #Detremine the number of plots in the multipanel plot
  pdf(file = paste('../Sandbox/',i,'.pdf', sep = ''), height = 11, width = 8)
  par(mfrow = c(3,2))
  #Draw one plot per temperature in the same panel
  for (j in list_temperatures){
    plot(d_species_plot$Time[which(d_species_plot$Temp == j)],
         d_species_plot$PopBio[which(d_species_plot$Temp == j)], 
         main = paste(i,j, sep = '_'),
         xlab = 'Time (h)', 
         ylab = 'Pop', 
         pch = 20, cex = 2.5, 
         col = jColors$color[d_species_plot$matchRetVal])
    #Generate a list of the mediums in ploted in the (i,j) plot
    list_mediums = unique(d_species_plot$Medium)
    legend('topleft', legend = list_mediums, 
           col = jColors$color[match(list_mediums, jColors$Medium)],
           lty=1:2, cex=0.8,box.lty=0)
    k = k+1
    
  }
  graphics.off()
}

keeps <- c('Time', 'y_t', 'Species', 'Temp', 'Medium', 'unique_id', 
           'PopBio_units')
d = d[keeps]
#Save new dataframe
write.csv(d, file = '../Data/LogisticGrowthData_mod.csv', row.names = F)

