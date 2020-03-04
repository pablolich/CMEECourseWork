#Plot results from fits

#LOAD PACKAGES#
###############


require(ggplot2)
require(dplyr)
library(RColorBrewer)
library(grid)
library(gridExtra)


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


#MAKE FIT PLOTS#
################
#Get rid of fits that are not in the top 3
fit_evals = fit_evals[!(fit_evals$best!=0 & fit_evals$best!=1 
                        & fit_evals$best!=2 & fit_evals$best!=3),]

#Erase previous plots
graphics.off()
#Create iterator
id = unique(fit_evals$unique_id)
#Set progress bar
pb = txtProgressBar(1, length(id), style=3)
j = 1
#Save pdf with all plots
pdf('../Results/fits.pdf')
for (i in id){
  #Scatter plot experimental points
  exp_dat = d[which(d$unique_id == i),]
  #Get data for all the models
  fit_dat = fit_evals[which(fit_evals$unique_id == i),]
  #Get number of evaluations and models
  #Create values for scale color manual
  colors = rev(brewer.pal(n = 5, name = "YlOrRd")[2:5])
  models = unique(fit_dat$model)[unique(fit_dat$best)+1]
  labels = rep(NA, length(unique(fit_dat$model)))
  names(labels) = models
  for (k in seq(length(labels))){
    labels[k] = colors[k]
  }
  p = ggplot(exp_dat, aes(x = exp_dat$Time, y = exp_dat$y_t)) + 
    geom_point()+ 
    theme_bw()+
    theme(aspect.ratio=1, #Square plot frame
          plot.title = element_text(size=16,face="bold"), #Title
          plot.subtitle = element_text(size = 15), #Increase size of subtitle
          panel.grid.major = element_blank(), #Get rid of grids
          panel.grid.minor = element_blank(),
          axis.title=element_text(size=15),#Increase size of axis title
          axis.text.x = element_text(size=14), #Increase size of ticks
          axis.text.y = element_text(size=14),
          legend.text=element_text(size=14), #Increase size of legend
          legend.position = 'bottom') +
    labs(title = unique(exp_dat$Species),#Title of plot and axis
         subtitle = paste("T: ", unique(exp_dat$Temp), "°C",
                          ", Medium: ",unique(exp_dat$Medium), sep = ""),
         x = 'Time (h)',
         y = expression(paste(log[10],"[N(t)]")),
         fill = "")+
    geom_line(data = fit_dat, aes(x = fit_dat$t, y = fit_dat$fit_eval,
                  color = fit_dat$model))+ #Add fitted lines
    #sum 1 because of python
    scale_color_manual('', values=labels, breaks=models)
  #Save plots
  print(p)
  #Print progress...
  setTxtProgressBar(pb, j)
  j = j+1
}
garbage <- dev.off()

#ANALIZE SUCCESS OF THE FITTING FOR EACH MODEL#
###############################################
#Get number of total data, fitted models, and evaluations
ndat = length(id)
nmodel = length(unique(fit_results$model))
#Get succes per model
success = fit_results$fit_success
#Create dataframe to plot
succes_df = data.frame(x = rep(seq(nmodel), ndat), 
                       y = rep(seq(ndat), each = nmodel),
                       z = rep(success, nmodel))
#Get a table with percent of best model for each model
best = round(100*table(fit_results[which(fit_results$fit_success == -2),]$model)/ndat)
#Create labels for x-axis plot
models = as.vector(unique(fit_results$model))
labels = rep(NA, length(models))
for (i in seq(length(models))){
  labels[i] = c(paste(models[i], 
                      paste(as.numeric(best[models[i]]),'%', sep = ''), 
                      sep = '\n'))
}

#Plot it
ggplot(succes_df, aes(x, y)) +  
  geom_tile(aes(fill = factor(z)), color = NA)+ #Bar code type of plot
  theme_bw()+
  theme(axis.title.x=element_blank(),
        axis.text.x = element_text(size=15,
                                   vjust = 0.5, 
                                   colour = rev(brewer.pal(n = 4, name = 'RdBu'))[1]),
        axis.text.y = element_text(size = 10),
        axis.title.y = element_text(size = 16),
        panel.grid.major = element_blank(), #Get rid of grids
        panel.grid.minor = element_blank(),
        legend.title = element_blank(), 
        legend.position = 'bottom',
        legend.text = element_text(size = 15, color = 'black'),
        plot.title = element_text(hjust = 0.5, size = 20)) + #No legend
  scale_x_discrete(labels = labels,
                   limits = seq(from = min(succes_df$x), 
                                to = max(succes_df$x)),
                   expand = c(0,0))+ #Eliminate white margins
  scale_y_continuous(name='Growth curve',
                    limits=c(1, 285),
                    breaks = seq(1, 285, by = 284/4),
                    expand = c(0,0))+
  scale_fill_manual(name = "", 
                    limits=c("-2", "1", "-1", "0"),
                    labels = c("best", "success", "poor", "fail"),
                    values = rev(brewer.pal(n = 4, name = 'RdBu')))+
  
ggsave(filename = '../Results/success_report.pdf', height = 9.46, width = 8)


##Create a plot with all models fitting each of them their best data set###

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
  geom_text(x = 35, y = 0.5, label = 'Gompertz', size = size_text)


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
  geom_text(x = 225, y = 0.5, label = 'Buchanan', size = size_text)

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
  geom_text(x = 350, y = 0.75, label = 'Baranyi', size = size_text)

#pdf('../Results/all_models.pdf')
lay <- rbind(c(NA, 1,1, 2,2, 3,3, NA),
             c(4,4, 5,5, 6,6, 7,7))
tot = grid.arrange(linear, quadratic, cubic, logistic, 
                   gompertz, Buchanan, baranyi, 
                   layout_matrix = lay,
                   left = textGrob(expression(paste(log[10],"(Population)")), gp=gpar(fontsize=40), rot = 90),
                   bottom = textGrob("Time", gp=gpar(fontsize=40)))

ggsave('../Results/all_models.pdf', plot = tot, height = 10, width = 20)

