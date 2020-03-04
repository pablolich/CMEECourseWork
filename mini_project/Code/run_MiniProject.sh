#!/bin/bash

#Glue all the components together
#Run the dataWrangling algorithm to prepare data for fitting
echo -e "\nMODULE 1"
echo "	1. Data preparation"
Rscript data_preparation_1.R
#First run the nlls python fitting algorithm
echo "	2. Fitting and evaluating primary models..."
python3 fit_store_models_1.py
#Now run the plotting script to plot results and fittin performance
echo "	3. Plotting results"
Rscript plotting_1.R 2>../Sandbox/warnings.txt
#Run the script that performs the biological question data preparation
echo -e "\n\nMODULE 2"
echo "	1. Data preparation"
Rscript data_preparation_2.R 2>../Sandbox/warnings.txt
#Run the python algorithm to fit the secondary models
echo "	2. Fitting and evaluating secondary models..."
python3 fit_store_models_2.py
#Run the Rscript to plot analysis results
echo "	3. Plotting results"
Rscript plotting_2.R &>../Sandbox/warnings.txt
echo -e "\nGENERATING LaTeX REPORT"
bash ~/Desktop/Imperial/CMEECourseWork/Week1/Code/CompileLaTeX.sh mini_project_report 1>../Sandbox/warnings.txt
#Delete warnings
rm ../Sandbox/warnings.txt
echo "Done!"
