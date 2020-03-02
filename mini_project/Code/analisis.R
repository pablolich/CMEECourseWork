library(tidyverse)
library(RColorBrewer)

#Analisis
fit_results = dplyr::tbl_df(read.csv('../Results/fit_results.csv',
                                     stringsAsFactors = F))
fit_results$unique_id_T = paste(fit_results$Species, fit_results$Medium)
#Get a subset of my dataframe for the arthrobaccter
dat_analisis = fit_results[grep("Arthrobacter", fit_results$unique_id_T), ]
#Get a subset for my dataframe for the models that yield an r_max
dat = dat_analisis[!(dat_analisis$model=='quadratic' |
                       dat_analisis$model=='cubic' | 
                       dat_analisis$model=='exponential'),]
keeps = c('Species', 'Temp', 'mu_max', 'model', 'best', 'unique_id_T', 'r_square', 
          'Medium')
d = dat[keeps]

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


#Get data groups based on each model
for (i in unique(d$unique_id_T)){
  group = d[d$unique_id_T == i,]
  model = best_model(group)[1]
  Temp = group$Temp[which(group$unique_id_T == i & group$model == model)]
  mu = group$mu_max[which(group$unique_id_T == i & group$model == model)]
  plot(Temp, mu, main = i)
}

#After visual inspection, we choose "Arthrobacter aurescens TGE agar" to be the one we fit
sel_dat = d[which(d$unique_id_T == "Arthrobacter aurescens TGE agar"),]
bestmodel = best_model(sel_dat)
sel_dat = sel_dat[which(sel_dat$model == bestmodel),]
keeps = c('Species', 'Temp', 'mu_max', 'model', 'Medium')
sel_dat = sel_dat[keeps]
#write.csv(sel_dat, '../Data/analysis.csv', row.names = F)

#Now lets plot all the mu_max when units are CFU
dat_cfu = fit_results %>% filter(PopBio_units == 'CFU')
bestmodel = best_model(dat_cfu)
#Filter data by best model
dat_filt = dat_cfu %>% filter(model == bestmodel)
#Plot to get a feeling of data
plot(dat_filt$Temp, dat_filt$mu_max)

#Remove under-sampled temperatures and outliers
tab = table(dat_filt$Temp)
bad_T = as.numeric(names(which(tab<5)))
dat_filt_T = dat_filt[-which(dat_filt$Temp == bad_T),]
dat_filt_T = dat_filt_T %>% filter(mu_max<0.3)
#Check outliers...
plot(dat_filt_T$Temp, dat_filt_T$mu_max)
#Get rid of Pseudomonas sp. because we only have 2 data points
dat_filt_T = dat_filt_T[startsWith(dat_filt_T$Species, 'Arthro'),]
#Get rid of unused information
keeps = c('Species', 'Temp', 'mu_max')
dat_filt_T = dat_filt_T[keeps]
#Separate points by species
species = unique(dat_filt_T$Species)
plot.new()
plot.window(xlim = c(0, 40), ylim = c(0, 0.4))
axis(1)
axis(2)
colors = rainbow(length(species))
j = 1
for (i in species){
  dat = dat_filt_T %>% filter(Species == i)
  points(dat$Temp, dat$mu_max, col = colors[j], pch = 20)
  j = j+1
}

#We are good, save this data to fit
write.csv(dat_filt_T, '../Data/cfu_analysis.csv', row.names = F)
