#Clean workspace
rm(list=ls())

getwd()
setwd(paste("/Users/pablolechon/Desktop/Imperial/", 
            "CMEECourseWork/Week4/Code", sep = ''))
getwd()

myNumericVector <- c(1.3,2.5,1.9,3.4,5.6,1.4,3.1,2.9)
myCharacterVector <- c("low","low","low","low","high",
                       "high","high","high") 
myLogicalVector <- c(TRUE,TRUE,FALSE,FALSE,TRUE,TRUE,
                     FALSE,FALSE)
myMixedVector <-c(1, TRUE, FALSE, 3, "help", 1.2, 
                  TRUE, "notwhatIplanned")
str(myMixedVector)

install.packages("lme4")
library(lme4) 
require(lme4)

sqrt(4); 4^0.5; log(0); log(1); log(10); log(Inf)

d<-read.table("../Data/SparrowSize.txt", header=TRUE)
str(d)
