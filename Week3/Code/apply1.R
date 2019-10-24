#!/usr/bin/env R 

#Learning how to use apply function

## Build a random matrix
M <- matrix(rnorm(100), 10, 10)

## Take the mean of each row
RowMeans <- apply(M,1,mean) #The 1 indicates that we are applying it to Rows (MARGIN)
print(RowMeans)

##Now the variance
RowVars <- apply(M,1,var)
print(RowVars)

## By column
ColMeans <- apply(M, 2, mean)
print (ColMeans)
