library(RColorBrewer)

#Analisis
fit_results = read.csv('../Results/fit_results.csv', stringsAsFactors = F)
fit_results$unique_id_T = paste(fit_results$Species, fit_results$Medium)
#Get a subset of my dataframe for the arthrobaccter


model_averaging = function(d, mu_max_averaged){
  #Average between all the models
  id = unique(d$unique_id)
  j = 1
  for (i in id){
    d_av = subset(d, d$unique_id == i)
    mu_max_vec = d_av$mu_max
    w_i_vec = d_av$w_i
    mu_max_averaged[j] = sum(mu_max_vec*w_i_vec)
    j = j+1
  }
  return(mu_max_averaged)
}

dat_analisis = fit_results[grep("Arthrobacter", fit_results$unique_id_T), ]
#Get a subset for my dataframe for the models that yield an r_max
keeps = c('unique_id','Species', 'Temp', 'mu_max', 'model', 'best', 'w_i')
d_tot = dat_analisis[keeps]
#Get only models that provide a value of mu_max
d = subset(d_tot, d_tot$model == 'gompertz' |
                  d_tot$model == 'baranyi' |
                  d_tot$model == 'buchanan')

#Perform model averaging
mu_max_averaged = rep(0, nrow(d)/4)
mu_max_averaged = model_averaging(d, mu_max_averaged)
#Add mu_max_averaged to d
d_av = subset(d, d$model == 'gompertz')
d_av$mu_max = mu_max_averaged

#Get rid of unused information
keeps = c('Species', 'Temp', 'mu_max')
dat_filt_T = d_av[keeps]


#Save this data to fit
write.csv(dat_filt_T, '../Data/cfu_analysis.csv', row.names = F)
