#!/bin/bash

# Author: Pablo Lechon, pl1619@ic.ac.uk
# Script: CountLines.sh
# Description: Counts the lines of input
# Arguments: 1-> txt file
# Date: Oct 2019

if [ -z $1 ]
then echo "Provide an argument. Bye"
     exit
fi

NumLines=`wc -l <  $1`
NumLines=`echo ${NumLines}`
A=`basename $1`
echo -e "\nThe file ${A} has $NumLines lines\n"
