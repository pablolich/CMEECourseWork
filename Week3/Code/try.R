#!/usr/bin/env R 


#Demonstrates how the try command works


doit <- function(x){
	temp_x <- sample(x, replace = TRUE)
	if(length(unique(temp_x)) > 30) {#only take mean if sample was sufficient
		 print(paste("Mean of this sample was:", as.character(mean(popn))))
		} 
	else {
		stop("Couldn't calculate mean: too few unique values!")
		}
	}

popn <- rnorm(50)

#Try doing the same thing using try
result <- lapply(1:15, function(i) try(doit(popn), F))

#This is a list that stores the result of each of the 15 runs, including the ones that ran into an error.
class(result)
result

result <- vector("list", 15) #Preallocate/Initialize
for(i in 1:15) {
	result[[i]] <- try(doit(popn), FALSE)
}


