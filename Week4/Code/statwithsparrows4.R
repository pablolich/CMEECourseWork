rm(list=ls())
daphnia <- read.delim("../Data/daphnia.txt")
summary(daphnia)
par(mfrow = c(1, 2))
plot(Growth.rate ~ Detergent, data = daphnia) 
plot(Growth.rate ~ Daphnia, data = daphnia)
require(dplyr)
daphnia %>%
  group_by(Detergent) %>%
  summarise (variance=var(Growth.rate)) 
graphics.off()
hist(daphnia$Growth.rate)
seFun <- function(x) {
  sqrt(var(x)/length(x)) }
detergentMean <- with(daphnia, tapply(Growth.rate, INDEX = Detergent, FUN = mean))
detergentSEM <- with(daphnia, tapply(Growth.rate, INDEX = Detergent, FUN = seFun))
cloneMean <- with(daphnia, tapply(Growth.rate, INDEX = Daphnia, FUN = mean)) 
cloneSEM <- with(daphnia, tapply(Growth.rate, INDEX = Daphnia, FUN = seFun))
par(mfrow=c(2,1),mar=c(4,4,1,1))
barMids <- barplot(detergentMean, xlab = "Detergent type", ylab = "Population growth rate",
                   ylim = c(0, 5))
arrows(barMids, detergentMean - detergentSEM, barMids, detergentMean +
         detergentSEM, code = 3, angle = 90)
barMids <- barplot(cloneMean, xlab = "Daphnia clone", ylab = "Population growth rate",
                   ylim = c(0, 5))
arrows(barMids, cloneMean - cloneSEM, barMids, cloneMean + cloneSEM,
       code = 3, angle = 90)

daphniaMod <- lm(Growth.rate ~ Detergent + Daphnia, data = daphnia)
anova(daphniaMod)
summary(daphniaMod)
detergentMean - detergentMean[1]

daphniaANOVAMod <- aov(Growth.rate ~ Detergent + Daphnia, data = daphnia)
summary(daphniaANOVAMod)
daphniaModHSD <- TukeyHSD(daphniaANOVAMod)
daphniaModHSD
par(mfrow=c(2,1),mar=c(4,4,1,1))
plot(daphniaModHSD)
par(mfrow=c(2,2))
plot(daphniaMod)


#Multiple regression

timber <- read.delim("../Data/timber.txt")
summary(timber)

par(mfrow = c(2, 2))
boxplot(timber$volume) 
boxplot(timber$girth)
boxplot(timber$height)

var(timber$volume)
## [1] 1.416803 
var(timber$girth) 
## [1] 627.0461 
var(timber$height) 
## [1] 3.654

t2<-as.data.frame(subset(timber, timber$volume!="NA"))
t2$z.girth<-scale(timber$girth) 
t2$z.height<-scale(timber$height) 
var(t2$z.girth)
var(t2$z.height)
plot(t2)













