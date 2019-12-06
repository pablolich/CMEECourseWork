#!/usr/bin/env R 

#Example of vectorization

M <- matrix(runif(1000000),1000,1000)

SumAllElements <- function(M){
  Dimensions <- dim(M)
  Tot <- 0
  for (i in 1:Dimensions[1]){
    for (j in 1:Dimensions[2]){
      Tot <- Tot + M[i,j]
    }
  }
  return (Tot)
}
 
time1 = as.numeric(system.time(res2<-SumAllElements(M))[3])
time1_f = format(round(time1, 4), nsmall = 4)
time2 = as.numeric(system.time(res2<-sum(M))[3])
time2_f = format(round(time2, 4), nsmall = 4)
cat(' -------------  -----------|------------', '\n')
cat(" Vectorize1.R  |", time1, '\t\t', time2, ' |\n')

