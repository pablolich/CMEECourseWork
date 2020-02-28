#Plot results from fits
#To run this script in the terminal, and avoid warnings, type:
#Rscript plot_results.R 2> warnings.txt
#You can later on removee warnings file in the bash script

#LOAD PACKAGES#
###############

options(warn=-1) #Supress warnings from overwriting packages
require(ggplot2)
require(dplyr)
require(viridis)
library(RColorBrewer)

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
print(unname(as.data.frame("Plotting results...")),
      quote = FALSE, row.names = FALSE)
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
dev.off()

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
  geom_tile(aes(fill = factor(z)), color = 'grey0')+ #Bar code type of plot
  scale_fill_manual(values= c('#25CED1', '#9DA3A4', '#0C0F0A', '#FFFFFF'),
                    labels = c('best', 'doubious', 'fail', 'success'))+
  theme_bw()+
  theme(axis.title.y=element_blank(),
        axis.title.x=element_blank(),
        axis.text.x = element_text(size=15, 
                                   angle=0,
                                   vjust = 0.6),
        panel.grid.major = element_blank(), #Get rid of grids
        panel.grid.minor = element_blank(),
        legend.title = element_blank(), 
        legend.position = 'bottom',
        plot.title = element_text(hjust = 0.5, size = 20)) + #No legend
  scale_x_discrete(labels = labels,
                   limits = seq(from = min(succes_df$x), 
                                to = max(succes_df$x)),
                   expand = c(0,0))+ #Eliminate white margins
  scale_y_discrete(expand = c(0,0))+
  labs(title = 'Fitting performance')
ggsave(filename = '../Results/success_report.pdf', height = 14, width = 10, 
       units = 'cm')
#Histograming goodnes results
hist(fit_evals$bic)
hist(fit_evals$aic)
#plot only those greater than 0
hist(fit_evals$r_square[which(fit_evals$r_square>-0)])

