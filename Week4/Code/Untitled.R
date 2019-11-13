rm(list = ls())
setwd('~/Desktop/Imperial/CMEECourseWork/Week4/Code/')

d = read.table('../Data/SparrowSize.txt', header = T)
d1 = subset(d, d$Wing != 'NA')
summary(d1$Wing)
hist(d1$Wing)
model1 = lm(Wing~Sex.1, data = d1)
summary(model1)
boxplot(d1$Wing~d1$Sex.1, ylab = 'Wing length (mm)')
anova(model1)

t.test(d1$Wing~d1$Sex.1, vaar.equal = T)

boxplot(d1$Wing~d1$BirdID, ylab = 'Wing lenght (mm)')

require(dplyr)
tbl_df(d1)

#Piping with dplyr

d$Mass %>% cor.test(d$Tarsus, na.rm = T)
#same as cor.test(d$Mass, d$Tarsus, na.rm = T)

d1 %>%
  group_by(BirdID) %>%
  summarise(count = length(BirdID)) %>%
  count(count)

model13 = lm(Wing~as.factor(BirdID), data = d1)
anova(model13)

boxplot(d$Mass~d$Year)
m2 = lm(d$Mass~as.factor(d$Year))
anova(m2)
summary(m2)
t(model.matrix(m2))
