 #Supress warnings from overwriting packages
library(ggplot2)
library(RColorBrewer)
library(tidyverse)
library(grid)
library(gridExtra)


#LOAD DATA#
###########
#Housekeeping
rm(list=ls())
#Load growth data and results
d = read.csv('../Data/LogisticGrowthData_mod.csv', stringsAsFactors = F)
fit_evals = read.csv('../Results/fit_evals.csv', stringsAsFactors = F)
fit_results = read.csv('../Results/fit_results.csv', stringsAsFactors = F)

#Set parameters for sizes
size_text = 13
size_points = 1.5
size_line = 1



#linear
dat_exp_linear = subset(d, d$Species == 'Escherichia coli' &
                          d$Temp == 8 &
                          d$Medium == 'Vacuum Beef Striploins')
dat_fit_linear = subset(fit_evals, fit_evals$Species == 'Escherichia coli' &
                          fit_evals$Temp == 8 & 
                          fit_evals$Medium == 'Vacuum Beef Striploins' &
                          fit_evals$model == 'linear')

linear = ggplot(data = dat_exp_linear, aes(x = Time, y = y_t))+
  geom_point(size = size_points)+
  theme_bw()+
  theme(aspect.ratio=1, #Square plot frame
        plot.title = element_text(size=16,face="bold"), #Title
        plot.subtitle = element_text(size = 15), #Increase size of subtitle
        panel.grid.major = element_blank(), #Get rid of grids
        panel.grid.minor = element_blank(),
        axis.title=element_blank(),#Increase size of axis title
        axis.text.x = element_blank(), #Increase size of ticks
        axis.text.y = element_blank(),
        legend.text=element_blank(),
        axis.ticks = element_blank()) +
  geom_line(data = dat_fit_linear, aes(x = t, y = fit_eval), colour = 'red', 
            size = size_line)+
  geom_text(x = 3.5, y = 1.7, label = 'linear', size = size_text)


#Quadratic
dat_exp_quadratic = subset(d, d$Species == 'Spoilage' &
                             d$Temp == 10 &
                             d$Medium == 'Vacuum Beef Striploins')
dat_fit_quadratic = subset(fit_evals, fit_evals$Species == 'Spoilage' &
                             fit_evals$Temp == 10 & 
                             fit_evals$Medium == 'Vacuum Beef Striploins' & 
                             fit_evals$model == 'quadratic')

quadratic = ggplot(data = dat_exp_quadratic, aes(x = Time, y = y_t))+
  geom_point(size = size_points)+
  theme_bw()+
  theme(aspect.ratio=1, #Square plot frame
        plot.title = element_text(size=16,face="bold"), #Title
        plot.subtitle = element_text(size = 15), #Increase size of subtitle
        panel.grid.major = element_blank(), #Get rid of grids
        panel.grid.minor = element_blank(),
        axis.title=element_blank(),#Increase size of axis title
        axis.text.x = element_blank(), #Increase size of ticks
        axis.text.y = element_blank(),
        legend.text=element_blank(),
        axis.ticks = element_blank()) +
  geom_line(data = dat_fit_quadratic, aes(x = t, y = fit_eval), colour = 'red', 
            size = size_line)+
  geom_text(x = 2.6, y = 2.5, label = 'quadratic', size = size_text)




#Cubic
graphics.off()
dat_exp_cubic = subset(d, d$Species == 'Acinetobacter.clacoaceticus.2' &
                       d$Temp == 25 & 
                       d$Medium == 'TSB')
dat_fit_cubic = subset(fit_evals, fit_evals$Species == 'Acinetobacter.clacoaceticus.2' &
                        fit_evals$Temp == 25 & 
                        fit_evals$Medium == 'TSB' &
                        fit_evals$model == 'cubic')



cubic = ggplot(data = dat_exp_cubic, aes(x = Time, y = y_t))+
  geom_point(size = size_points)+
  theme_bw()+
  theme(aspect.ratio=1, #Square plot frame
        plot.title = element_text(size=16,face="bold"), #Title
        plot.subtitle = element_text(size = 15), #Increase size of subtitle
        panel.grid.major = element_blank(), #Get rid of grids
        panel.grid.minor = element_blank(),
        axis.title=element_blank(),#Increase size of axis title
        axis.text.x = element_blank(), #Increase size of ticks
        axis.text.y = element_blank(),
        legend.text=element_blank(),
        axis.ticks = element_blank()) +
  geom_line(data = dat_fit_cubic, aes(x = t, y = fit_eval), colour = 'red',
            size = size_line)+
  geom_text(x = 75, y = -1.5, label = 'cubic', size = size_text)


#Logistic
dat_exp_logistic = subset(d, d$Species == 'Lactobacillus sakei' &
                          d$Temp == 12 &
                          d$Medium == 'MRS broth')
dat_fit_logistic = subset(fit_evals, fit_evals$Species == 'Lactobacillus sakei' &
                          fit_evals$Temp == 12 & 
                          fit_evals$Medium == 'MRS broth' & 
                          fit_evals$ model == 'logistic')

logistic = ggplot(data = dat_exp_logistic, aes(x = Time, y = y_t))+
  geom_point(size = size_points)+
  theme_bw()+
  theme(aspect.ratio=1, #Square plot frame
        plot.title = element_text(size=16,face="bold"), #Title
        plot.subtitle = element_text(size = 15), #Increase size of subtitle
        panel.grid.major = element_blank(), #Get rid of grids
        panel.grid.minor = element_blank(),
        axis.title=element_blank(),#Increase size of axis title
        axis.text.x = element_blank(), #Increase size of ticks
        axis.text.y = element_blank(),
        legend.text=element_blank(),
        axis.ticks = element_blank()) +
  geom_line(data = dat_fit_logistic, aes(x = t, y = fit_eval), colour = 'red', 
            size = size_line)+
  geom_text(x = 75, y = 2.7, label = 'logistic', size = size_text)


#Gompertz
dat_exp_gompertz = subset(d, d$Species == 'Aerobic Mesophilic.' &
                          d$Temp == 20 &
                          d$Medium == 'Salted Chicken Breast')
dat_fit_gompertz = subset(fit_evals, fit_evals$Species == 'Aerobic Mesophilic.' &
                          fit_evals$Temp == 20 &
                          fit_evals$Medium == 'Salted Chicken Breast' &
                          fit_evals$model == 'gompertz')

gompertz = ggplot(data = dat_exp_gompertz, aes(x = Time, y = y_t))+
  geom_point(size = size_points)+
  theme_bw()+
  theme(aspect.ratio=1, #Square plot frame
        plot.title = element_text(size=16,face="bold"), #Title
        plot.subtitle = element_text(size = 15), #Increase size of subtitle
        panel.grid.major = element_blank(), #Get rid of grids
        panel.grid.minor = element_blank(),
        axis.title=element_blank(),#Increase size of axis title
        axis.text.x = element_blank(), #Increase size of ticks
        axis.text.y = element_blank(),
        legend.text=element_blank(),
        axis.ticks = element_blank()) +
  geom_line(data = dat_fit_gompertz, aes(x = t, y = fit_eval), colour = 'red', 
            size = size_line)+
  geom_text(x = 35, y = 0.5, label = 'gompertz', size = size_text)


#Buchanan
dat_exp_Buchanan = subset(d, d$Species == 'Pseudomonas spp.' &
                          d$Temp == 7 &
                          d$Medium == 'Salted Chicken Breast')
dat_fit_Buchanan = subset(fit_evals, fit_evals$Species == 'Pseudomonas spp.' &
                          fit_evals$Temp == 7 &
                          fit_evals$Medium == 'Salted Chicken Breast' &
                          fit_evals$model == 'buchanan')
Buchanan = ggplot(data = dat_exp_Buchanan, aes(x = Time, y = y_t))+
  geom_point(size = size_points)+
  theme_bw()+
  theme(aspect.ratio=1, #Square plot frame
        plot.title = element_text(size=16,face="bold"), #Title
        plot.subtitle = element_text(size = 15), #Increase size of subtitle
        panel.grid.major = element_blank(), #Get rid of grids
        panel.grid.minor = element_blank(),
        axis.title=element_blank(),#Increase size of axis title
        axis.text.x = element_blank(), #Increase size of ticks
        axis.text.y = element_blank(),
        legend.text=element_blank(),
        axis.ticks = element_blank()) +
  geom_line(data = dat_fit_Buchanan, aes(x = t, y = fit_eval), colour = 'red', 
            size = size_line)+
  geom_text(x = 225, y = 0.5, label = 'buchanan', size = size_text)

#baranyi
dat_exp_baranyi = subset(d, d$Species == 'Arthrobacter simplex' &
                         d$Temp == 7 &
                         d$Medium == 'TGE agar')
dat_fit_baranyi = subset(fit_evals, fit_evals$Species == 'Arthrobacter simplex' &
                         fit_evals$Temp == 7 &
                         fit_evals$Medium == 'TGE agar' &
                         fit_evals$model == 'baranyi')
baranyi = ggplot(data = dat_exp_baranyi, aes(x = Time, y = y_t))+
  geom_point(size = size_points)+
  theme_bw()+
  theme(aspect.ratio=1, #Square plot frame
        plot.title = element_text(size=16,face="bold"), #Title
        plot.subtitle = element_text(size = 15), #Increase size of subtitle
        panel.grid.major = element_blank(), #Get rid of grids
        panel.grid.minor = element_blank(),
        axis.title=element_blank(),#Increase size of axis title
        axis.text.x = element_blank(), #Increase size of ticks
        axis.text.y = element_blank(),
        legend.text=element_blank(),
        axis.ticks = element_blank()) +
  
  geom_line(data = dat_fit_baranyi, aes(x = t, y = fit_eval), colour = 'red', 
            size = size_line)+
  geom_text(x = 350, y = 0.75, label = 'baranyi', size = size_text)

#pdf('../Results/all_models.pdf')
lay <- rbind(c(NA, 1,1, 2,2, 3,3, NA),
             c(4,4, 5,5, 6,6, 7,7))
tot = grid.arrange(linear, quadratic, cubic, logistic, 
             gompertz, Buchanan, baranyi, 
             layout_matrix = lay,
             left = textGrob(expression(paste(log[10],"(Population)")), gp=gpar(fontsize=40), rot = 90),
             bottom = textGrob("Time", gp=gpar(fontsize=40)))

  ggsave('../Results/all_models.pdf', plot = tot, height = 10, width = 20)
