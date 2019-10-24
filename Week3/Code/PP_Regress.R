rm(list = ls())

MyDF <- read.csv("../data/EcolArchives-E089-51-D1.csv")
#attach(MyDF)
#Get indexes of positions where units are in mg
ind = which(MyDF$Prey.mass.unit == 'mg')
MyDF$Prey.mass[ind] = MyDF$Prey.mass[ind]/1000
MyDF$Prey.mass.unit[ind] = 'g'

require(ggplot2)

ggplot(MyDF, aes(MyDF$Prey.mass, MyDF$Predator.mass)) + 
  geom_point(shape = I(3), aes(colour = MyDF$Predator.lifestage)) + 
  geom_smooth(method = 'lm', aes(colour = MyDF$Predator.lifestage), fullrange = T, size = 0.5) +
  xlab("Prey mass in grams") + ylab("Predator mass in grams") +
  facet_grid(MyDF$Type.of.feeding.interaction ~ .) + #To arrange them by rows, put the ~ . at the right
  theme_bw()+
  theme(legend.position="bottom", legend.title = element_text(size = 8.4, face = 'bold',), 
        legend.text = element_text(size = 8.4, margin = margin(t = 0.5)), panel.grid.minor = element_line(colour = 'gray96'),
        legend.key.size = unit(1,'line'), plot.margin = unit(c(1, 3, 1, 3), 'cm'), 
        legend.spacing.x = unit(0.05, 'cm'),
        legend.title.align = 0.5, legend.text.align = 0.5)+
  guides(col = guide_legend(nrow = 1))+
  scale_x_continuous(trans='log10')+
  scale_y_continuous(trans = 'log10')


ggsave('../Results/ggplot_graph.pdf', plot = last_plot(), width = 6, height = 9, 
       dpi = 300)

#Linear Regressions

#Convine Predator.lifestage with Type.of.feeding.interaction to make pairs
new_df = data.frame('lifestage.feeding' = 
                      paste(MyDF$Predator.lifestage, MyDF$Type.of.feeding.interaction,sep = '_'), 
                    'prey.mass' = MyDF$Prey.mass, 
                    'predator.mass' = MyDF$Predator.mass)

require(plyr)
require(broom)
table = ddply(new_df, .(lifestage.feeding), summarize,
              intercept = lm(log10(predator.mass)~log10(prey.mass))$coef[1],
              slope = lm(log10(predator.mass)~log10(prey.mass))$coef[2], 
              r.squared = summary(lm(log10(predator.mass)~log10(prey.mass)))$r.squared,
              f.statistic = as.numeric(glance(lm(log10(predator.mass)~log10(prey.mass)))[4]),
              p.value = summary(lm(log10(predator.mass)~log10(prey.mass)))$coefficients[8])

write.table(table, '../Results/PP_Regres_Results.csv', row.names = F, quote = F) 
