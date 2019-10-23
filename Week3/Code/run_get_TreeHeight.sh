#!/bin/bash 

#Runs get_TreeHeight.R and get_TreeHeight.py with trees.csv as an example. 
#Shows the results in the screen

echo -e '\nRunning get_TreeHeight.R  with trees.csv as an example...'
Rscript get_TreeHeight.R trees.csv
echo -e 'The results are:\n' && 
	cat ../Results/trees_treeheights.csv | head
echo -e '\nRunning get_TreeHeight.py with trees.csv as an example...'
python3 get_TreeHeight.py trees.csv 
echo -e 'The results are:\n' &&
       	cat ../Results/trees_treeheights.csv | head
