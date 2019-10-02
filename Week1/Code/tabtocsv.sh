!/bin/bash
# Author: Your name pl1619@ic.ac.uk
# Script: tabtocsv.sh
# Desc: substitute the tabs in the files wiht commas
# and saves the output to a .csv file

# Arguments: 1 -> tab delimited file
# Date: Oct 2019

echo 'Creating a comma delimited version of $1...'
cat $1 | tr -s '\t' ',' >> $1.csv
echo 'Done!'
exit
