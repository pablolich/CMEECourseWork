#!/usr/bin/env R 

#Demonstrate the use of next.

for (i in 1:10) {
  if ((i %% 2) == 0) 
    next # pass to next iteration of loop 
  print(i)
}
