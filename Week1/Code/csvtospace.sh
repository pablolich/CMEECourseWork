#!/bin/bash
#Author: Pablo Lechon Alonso: plechon@ucm.es
#Script: csvtospace.sh
#Desc: transform csv files to space separated files
#Arguments: csv file
#Date: Oct 2019

echo -e "\nConverting $1 from csv to space separated file ($2)"
cat $1 | tr -s "," " " > $2 
echo -e '\nDone!\n'
head $2
echo	

#We use print the input file and pipe the output to a tr command, that
#erases and shrinks all the comas, and substitutes them for spaces. 
#The output is sent to a second file which name needs to be specified 
#when calling the bash script
