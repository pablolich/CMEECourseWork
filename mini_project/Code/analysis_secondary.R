library(ggplot2)
library(dplyr)
library(viridis)

#Load growth data and results
d = dplyr::tbl_df(read.csv('../Results/dat_secondary.csv',
                           stringsAsFactors = F))

fit_evals = dplyr::tbl_df(read.csv('../Results/fit_eval_secondary.csv', 
                                   stringsAsFactors = F))
d = d[order(d$Topt),] 
fit_evals = fit_evals[order(fit_evals$Topt),]

#Sort datframe according to values of Topt
#Get rid of elements less than 0
zero = which(fit_evals$mu_max < 0)
fit_evals = fit_evals[-zero,]

#plot
values = rep(rev(rainbow(7)),2)
breaks = rep(unique(fit_evals$Topt), 2)
labels = rep(c('Sp. 62', 'Sp. 77', 'Sp. 88','Aurescens',
               'Citreus', 'Simplex', 'Globiformis'), 2)
pdf('../Results/TCP.pdf')
p = ggplot(d, aes(x = d$Temp, y = d$mu_max, 
                  color = factor(d$Topt))) + 
  scale_color_manual(values = values, 
                     breaks = breaks, 
                     labels = labels)+
  geom_point()+
  
  theme_bw()+
  theme(aspect.ratio=0.5, #Square plot frame
        plot.title = element_text(size=16,face="bold"), #Title
        plot.subtitle = element_text(size = 15), #Increase size of subtitle
        panel.grid.major = element_blank(), #Get rid of grids
        panel.grid.minor = element_blank(),
        axis.title=element_text(size=15),#Increase size of axis title
        axis.text.x = element_text(size=14), #Increase size of ticks
        axis.text.y = element_text(size=14),
        legend.text=element_text(size=14), #Increase size of legend
        legend.position = 'bottom',
        legend.title = element_blank()) +
  labs(x = 'T (°C)',
       y = expression(paste(mu[max]," (CFU ", h^-1, ")")),
       fill = "")+
  
  geom_line(data = fit_evals, aes(x = fit_evals$Temp, y = fit_evals$mu_max,
                                  color = factor(fit_evals$Topt)) )#Add fitted lines
  
print(p)
dev.off()




