#!/bin/bash

#Glue all the components together
#Run the dataWrangling algorithm to prepare data for fitting
echo -e "\nPRIMARY MODELS"
echo "	1. Data preparation"
Rscript datawrang_logisticgrowth.R 
#First run the nlls python fitting algorithm
echo "	2. Fitting and evaluating primary models..."
python3 fit_model.py
#Now run the plotting script to plot results and fittin performance
echo "	3. Plotting results"
Rscript plot_results.R 2>../Sandbox/warnings.txt
#Run the file to plot one example of each model
Rscript plot_all_models.R 2>../Sandbox/warnings.txt
#Run the script that performs the biological question data preparation
echo -e "\nSECONDARY MODELS"
echo "	1. Data preparation"
Rscript analisis.R 2>../Sandbox/warnings.txt
#Run the python algorithm to fit the secondary models
echo "	2. Fitting and evaluating secondary models..."
python3 analysis.py
#Run the Rscript to plot analysis results
echo "	3. Plotting results"
Rscript analysis_secondary.R &>../Sandbox/warnings.txt
echo -e "\nGENERATING LaTeX REPORT"
bash ~/Desktop/Imperial/CMEECourseWork/Week1/Code/CompileLaTeX.sh mini_project_report 1>../Sandbox/warnings.txt
#Delete warnings
rm ../Sandbox/warnings.txt
echo "Done!"
