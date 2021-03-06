#!/usr/bin/env R 


# Runs the stochastic Ricker equation with gaussian fluctuations. 

#remove all objects (ls returns a vector of strings with the names of all objects
rm(list=ls()) 

stochrick<-function(p0=runif(1000,.5,1.5),r=1.2,K=1,sigma=0.2,numyears=100)
{
  #initialize
  N<-matrix(NA,numyears,length(p0))
  N[1,]<-p0
  
  for (pop in 1:length(p0)){#loop through the populations
    
    for (yr in 2:numyears){ #for each pop, loop through the years
      
      N[yr,pop] <- N[yr-1,pop] * exp(r * (1 - N[yr - 1,pop] / K) + rnorm(1,0,sigma))
      
    }
    
  }
  return(N)
  
}

# Now write another function called stochrickvect that vectorizes the above 
# to the extent possible, with improved performance: 

stochrickvect<-function(p0=runif(1000,.5,1.5),r=1.2,K=1,sigma=0.2,numyears=100) { 
  
  #initialize
  #Empty Matrix of 1000 by 100 by default. Every row corresponds to a population, 
  #and every column corresponds to one year.
  N<-matrix(NA,numyears,length(p0))
  #Assign the first population to the first row of the matrix.
  N[1,]<-p0
  
  
  for (yr in 2:numyears){#for each pop, loop through the years
    N[yr,]<-N[yr-1,]*exp(r*(1-N[yr-1,]/K)+rnorm(length(p0),0,sigma))
  }
  
  return(N)
  
}


#Check times

time1 = as.numeric(system.time(res2<-stochrick())[3])
time1_f = format(round(time1, 4), nsmall = 4)
time2 = as.numeric(system.time(res2<-stochrickvect())[3])
time2_f = format(round(time2, 4), nsmall = 4)
cat(" Vectorize2.R  |", time1, '\t\t', time2, ' |\n')
cat('                -----------|------------', '\n')
