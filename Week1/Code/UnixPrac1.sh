#!/bin/bash 

#Author: Pablo Lechon Alonso (plechon@ucm.es)
#Script: UnixPrac1.sh
#Desc: Fasta exercise
#Arguments: None
#Date: Oct 2019

#The following bash script performs several operations on the fasta files 


#########################################################################
###1. Count how many lines there are in each file###
#########################################################################

echo -e '\nNumber of lines of each file:\n' && wc -l ../Data/*.fasta

#########################################################################
##Explanation
#The wc comand counts the lines, words, and characters in the file. The 
#-l option specifies that I only want thel ines to be counted. 
#########################################################################



#########################################################################
###2 Print everything starting from the second line for the E. coli genome
#########################################################################

echo -e '\n\n Printing the whole genome:\n' &&
cat ../Data/E.coli.fasta | tail -78103

#########################################################################
##Explanation
#The cat command prints through the screen whatever file give as an input
#we have piped a tail command to it that only prints the last 78103 lines
#or, in other words, all the file except the first line
#########################################################################



#########################################################################
###3 Count the sequence length of this genome
#########################################################################

echo -e '\n\nThe sequence length of the genome is:\c'&&
cat ../Data/E.coli.fasta | tail -78103 | tr -d "\n" | wc -m

#########################################################################
###Explanation
#The cat command prints the genome. The piped tail command extracts the 
#first line. The tr command with the -d(elete) option on deletes all the
#"\n" characters. Finally, we count the caracters with the -m option on 
#########################################################################



#########################################################################
###4 Count the matches of a particular sequence, "ATGC" in the genome of
#E. coli (hint: Start by removing the first line and removing newline 
#characters)
#########################################################################

echo -e '\n\nNumber of matches of the ATGC sequence in the genome:\c'&&
grep -o 'ATGC' ../Data/E.coli.fasta | wc -l

#########################################################################
###Explanation
#We use grep command to search for a particuar string inside a file. The
#-o option prints only the matching portion in a line. Counting the lines
#would then tell us what is the number of AGTC strings in the genome
#########################################################################



#########################################################################
###5 Compute the AT/GC ratio. That is, the (A+T)/(G+C) ratio. 
#########################################################################

a=$(grep -o 'A' ../Data/E.coli.fasta | wc -l) &&
t=$(grep -o 'T' ../Data/E.coli.fasta | wc -l) &&
g=$(grep -o 'G' ../Data/E.coli.fasta | wc -l) &&
c=$(grep -o 'C' ../Data/E.coli.fasta | wc -l) &&
at=`expr $a + $t` && gc=`expr $g + $c` &&
ratio=$(echo "scale=4 ; $at/$gc" | bc) &&
echo -e "\n\nThe ratio AT/GC is: $ratio\n"

########################################################################
###Explanation
#First, we count the occurrences of each letter separately and we store 
#them in the variables a, t, g, c. Second, we use the command expr to 
#sum variables appropietely in pairs. 
#Third, we divide them and set a number of decimals for the output using
#scale=4 and send the output to bc, a builtin unix calculator, that 
#reads the echo output (sacle=4 ; $at/$gc), and performs those
#instructions.
########################################################################

