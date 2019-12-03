#!/bin/bash

##Compiles and runs a C script
gcc -Wall $1
	
if [$?!=0]
then
	echo 'Fix error to obtain output'
else 
	./a.out
fi
