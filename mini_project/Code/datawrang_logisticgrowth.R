#Set working directory
setwd('~/Desktop/Imperial/CMEECourseWork/mini_project/Code/')
#Clean variables
rm(list = ls())
#require packages
require('plyr')
require('RColorBrewer')
library('wesanderson')

set.seed(44434862)

d = dplyr::tbl_df(read.csv('../Data/LogisticGrowthData.csv',
                           stringsAsFactors = F))

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
         col = jColors$color[d_species_plot$matchRetVal],
         log = 'xy')
    #Generate a list of the mediums in ploted in the (i,j) plot
    list_mediums = unique(d_species_plot$Medium)
    legend('topleft', legend = list_mediums, 
           col = jColors$color[match(list_mediums, jColors$Medium)],
           lty=1:2, cex=0.8,box.lty=0)
  }
  graphics.off()
}


