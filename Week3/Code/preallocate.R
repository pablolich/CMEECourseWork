#!/usr/bin/env R

#Demonstrates how prealocation increases speed.

a <- NA
nonpre<- function(){
	for (i in 1:10){
		a<-c(a,i)
		print(a)
		print(object.size(a))
	}
}

#Preallocating the memory

b <- rep(NA, 10)
	pre <- function(){
	for (i in 1:10) {
		b[i] <- i
		print(b)
		print(object.size(a))
	}
}

print(system.time(nonpre()))
print(system.time(pre()))

