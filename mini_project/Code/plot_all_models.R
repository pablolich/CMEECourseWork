 #Supress warnings from overwriting packages
require(ggplot2)
library(RColorBrewer)
library(tidyverse)
library(grid)


#LOAD DATA#
###########
#Housekeeping
rm(list=ls())
#Load growth data and results
d = dplyr::tbl_df(read.csv('../Data/LogisticGrowthData_mod.csv',
                           stringsAsFactors = F))
fit_evals = dplyr::tbl_df(read.csv('../Results/fit_evals.csv', 
                                   stringsAsFactors = F))
fit_results = dplyr::tbl_df(read.csv('../Results/fit_results.csv',
                                     stringsAsFactors = F))

#Cubic
graphics.off()
dat_exp_cubic = d %>% filter(Species == 'Acinetobacter.clacoaceticus.2',
                                        Temp == 25, Medium == 'TSB')
dat_fit_cubic = fit_evals %>% filter(Species == 'Acinetobacter.clacoaceticus.2',
                                   Temp == 25, Medium == 'TSB', model == 'cubic')

#Set parameters for sizes
size_text = 8
size_points = 0.5
size_line = 0.5

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


#Quadratic
dat_exp_quadratic = d %>% filter(Species == 'Spoilage',
                             Temp == 10, Medium == 'Vacuum Beef Striploins')
dat_fit_quadratic = fit_evals %>% filter(Species == 'Spoilage',
                                     Temp == 10, Medium == 'Vacuum Beef Striploins', 
                                     model == 'quadratic')

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


#Exponential
dat_exp_exponential = d %>% filter(Species == 'Escherichia coli',
                                 Temp == 8, Medium == 'Vacuum Beef Striploins')
dat_fit_exponential = fit_evals %>% filter(Species == 'Escherichia coli',
                                         Temp == 8, Medium == 'Vacuum Beef Striploins', 
                                         model == 'exponential')

exponential = ggplot(data = dat_exp_exponential, aes(x = Time, y = y_t))+
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
  geom_line(data = dat_fit_exponential, aes(x = t, y = fit_eval), colour = 'red', 
            size = size_line)+
  geom_text(x = 3.5, y = 1.7, label = 'linear', size = size_text)

#Logistic
dat_exp_logistic = d %>% filter(Species == 'Lactobacillus sakei',
                                   Temp == 12, Medium == 'MRS broth')
dat_fit_logistic = fit_evals %>% filter(Species == 'Lactobacillus sakei',
                                           Temp == 12, Medium == 'MRS broth', 
                                           model == 'logistic')

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
dat_exp_gompertz = d %>% filter(Species == 'Aerobic Mesophilic.',
                                Temp == 20, Medium == 'Salted Chicken Breast')
dat_fit_gompertz = fit_evals %>% filter(Species == 'Aerobic Mesophilic.',
                                        Temp == 20, Medium == 'Salted Chicken Breast', 
                                        model == 'gompertz')
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
print(gompertz)

#Buchanan
dat_exp_Buchanan = d %>% filter(Species == 'Pseudomonas spp.',
                                Temp == 7, Medium == 'Salted Chicken Breast')
dat_fit_Buchanan = fit_evals %>% filter(Species == 'Pseudomonas spp.',
                                        Temp == 7, Medium == 'Salted Chicken Breast', 
                                        model == 'buchanan')
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
dat_exp_baranyi = d %>% filter(Species == 'Arthrobacter simplex',
                                Temp == 7, Medium == 'TGE agar')
dat_fit_baranyi = fit_evals %>% filter(Species == 'Arthrobacter simplex',
                                        Temp == 7, Medium == 'TGE agar', 
                                        model == 'baranyi')
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
lay <- rbind(c(1,2,3),
             c(4,5,6),
             c(NA,7,NA))
tot = grid.arrange(exponential, quadratic, cubic, logistic, 
             gompertz, Buchanan, baranyi, 
             layout_matrix = lay,
             left = textGrob("Population", gp=gpar(fontsize=30), rot = 90),
             bottom = textGrob("Time", gp=gpar(fontsize=30)))

ggsave('../Results/all_models.pdf', plot = tot, height = 10, width = 10)
# grid.newpage()
# grid.draw(cbind(rbind(ggplotGrob(exponential), ggplotGrob(quadratic)),
#                 rbind(ggplotGrob(cubic), ggplotGrob(logistic)),
#                 rbind(ggplotGrob(gompertz), ggplotGrob(Buchanan)),
#                 rbind(ggplotGrob(baranyi), ggplotGrob(exponential))))
# dev.off()
