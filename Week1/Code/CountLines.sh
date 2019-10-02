!/bin/bash

# Author: Pablo Lechon, pl1619@ic.ac.uk
# Script: CountLines.sh
# Description: Counts the lines of input
# Arguments: 1-> txt file
# Date: Oct 2019

NumLines=`wc -l <  $1`
echo "the file $1 has $NumLines lines"
echo
