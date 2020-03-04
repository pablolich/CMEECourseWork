library(tidyverse)
library(RColorBrewer)

#Analisis
fit_results = dplyr::tbl_df(read.csv('../Results/fit_results.csv',
                                     stringsAsFactors = F))
fit_results$unique_id_T = paste(fit_results$Species, fit_results$Medium)
#Get a subset of my dataframe for the arthrobaccter


best_model = function(d){
  #Get score for al models for each id
  models = unique(d$model)
  #Preallocation
  score = rep(0,length(models))
  j = 1
  for (i in models){
    #Get data from the ith model
    d_mod = d[which(d$model == i),]
    #Calculate score
    score[j] = sum(d_mod[which(d_mod$best == 1),]$best)
    j = j + 1
  }
  #Select best model
  best_model = models[which(score == max(score))]
  return(best_model)
}

dat_analisis = fit_results[grep("Arthrobacter", fit_results$unique_id_T), ]
#Get a subset for my dataframe for the models that yield an r_max
keeps = c('Species', 'Temp', 'mu_max', 'model', 'best')
d = dat_analisis[keeps]

#Now lets plot all the mu_max when units are CFU
bestmodel = best_model(d)
#Filter data by best model
dat_filt = subset(d, d$model == bestmodel)


#Get rid of unused information
keeps = c('Species', 'Temp', 'mu_max')
dat_filt_T = dat_filt[keeps]


#Save this data to fit
write.csv(dat_filt_T, '../Data/cfu_analysis.csv', row.names = F)
