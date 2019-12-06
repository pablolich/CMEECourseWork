#!/bin/bash 

#Runs get_TreeHeight.R and get_TreeHeight.py with trees.csv as an example. 
#Shows the results in the screen

echo -e '\nRunning get_TreeHeight.R  with trees.csv as an example...'
Rscript get_TreeHeight.R ../Data/trees.csv
echo -e 'The results are:\n' && 
	cat ../Results/trees_treeheights.csv | head -3
echo -e '\nRunning get_TreeHeight.py with trees.csv as an example...'
python3 get_TreeHeight.py ../Data/trees.csv 
echo -e 'The results are:\n' &&
       	cat ../Results/trees_treeheights_py.csv | head -3
