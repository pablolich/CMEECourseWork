#Plot secondary model for all species
rm(list=ls())
#Load packages
library(ggplot2)

#Load growth data and results
d = read.csv('../Results/dat_secondary.csv', stringsAsFactors = F)
fit_evals = read.csv('../Results/fit_eval_secondary.csv', stringsAsFactors = F)

fit_evals = fit_evals[order(fit_evals$Topt),]

#Sort datframe according to values of Topt
d = d[order(d$Topt),]
fit_evals = fit_evals[order(fit_evals$Topt),]

#Remove extra lines for clarity in the plot
d<-d[!(d$Species=="Arthrobacter sp. 62" | d$Species=='Arthrobacter sp. 77'),]
fit_evals<-fit_evals[!(fit_evals$Species=="Arthrobacter sp. 62" | 
                       fit_evals$Species=='Arthrobacter sp. 77'),]

#Delete all arthrobacter form d
labels = c('Sp. 88','Aurescens', 'Citreus', 'Simplex', 'Globiformis')
speciesd = rep(labels, each = 5)
rep = length(subset(fit_evals, fit_evals$Topt == unique(fit_evals$Topt)[1])$Topt)
speciesevals = rep(labels, each = rep)
d$Species = speciesd
fit_evals$Species = speciesevals

#Get rid of elements less than 0
zero = which(fit_evals$mu_max < 0)
fit_evals = fit_evals[-zero,]

#plot

breaks = unique(d$Species)
color_points = rainbow(length(labels))[c(5,1,2,3,4)]
p = ggplot(d, aes(x = Temp, y = mu_max,
                  shape = Species,
                  fill = Species) ) + 
   geom_point(size = 2, color = 'black')+
   scale_shape_manual(values = c(21, 22, 24, 23, 25))+
   scale_color_manual(values = color_points)+
   scale_fill_manual(values = color_points)+
   theme_bw()+
   theme(plot.title = element_text(size=110,face="bold"), #Title
        panel.grid.major = element_blank(), #Get rid of grids
        panel.grid.minor = element_blank(),
        axis.title=element_text(size=9),#Increase size of axis title
        axis.text.x = element_text(size=8), #Increase size of ticks
        axis.text.y = element_text(size=8),
        legend.text=element_text(size=9), #Increase size of legend
        legend.position = 'bottom',
        legend.title = element_blank(),
        legend.box.margin=margin(0,0,-10,0)) +
  
  labs(x = 'T (°C)',
       y = expression(paste(mu[max]," (CFU ", h^-1, ")")))+

  geom_line(data = fit_evals, aes(x = Temp, y = mu_max,
                                  color = Species,
                                  linetype = Species), size = 1) +#Add fitted lines

  ggsave('../Results/TCP.pdf', width = 12.5, height = 8, units = 'cm')
