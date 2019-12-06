#!/bin/bash
# Author: Your name pl1619@ic.ac.uk
# Script: tabtocsv.sh
# Desc: substitute the tabs in the files wiht commas
# and saves the output to a .csv file

# Arguments: 1 -> tab delimited file
# Date: Oct 2019

if [ -z $1 ]
then echo "Provide an argument"
     exit
fi

if [[ $1 == *".txt"* ]] || [[ $1 == *".csv"* ]];
then echo -e "\nProvide the name of the file without the extension"
    exit
fi

echo -e "\nCreating a comma delimited version of $1.txt..."
cat $1.txt | tr -s '\t' ',' >> $1.csv
echo -e '\nDone!\n'
head $1.csv
echo

exit
