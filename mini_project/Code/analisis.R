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
keeps = c('Species', 'Temp', 'mu_max', 'model', 'best', 'unique_id_T', 'r_square')
d = dat[keeps]

best_model = function(d){
  #Get score for al models for each id
  models = unique(d$model)
  #Preallocation
  score = rep(0,length(models))
  j = 1
  for (i in models){
    #Calculate score
    score[j] = sum(d[d$model == i,]$best)
    j = j + 1
  }
  #Select best model
  best_model = models[which(score == min(score))]
  return(best_model)
}
#Bad plots (by eye)
#Arthrobactersp.88 TGE agar 37
#Arthrobactersp.77 TGE agar 37
#Arthrobactersp.62 TGE agar 30
#Arthrobactersp.62 TGE agar 37
#Arthrobacter simplex TGE agar 0
#Arthrobacter globiformis TGE agar 0


#Get data groups based on each model
for (i in unique(d$unique_id_T)){
  group = d[d$unique_id_T == i,]
  model = best_model(group)[1]
  Temp = group$Temp[which(group$unique_id_T == i & group$model == model)]
  mu = group$mu_max[which(group$unique_id_T == i & group$model == model)]
  plot(Temp, mu, main = i)
}
