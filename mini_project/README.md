# Continuity of the thermal optimum in mesophilic and psichrophilic Arthrobacter species. A multimodel inference approach

This folder contains the components necessary to run the perform the nlls fitting of bacterial growth curves, and analyze the results, producint a pdf output with the compiled final mini-project report. It contains 4 subfolders: Code, Data, Results and Sandbox. Their respective contents are detailed next.

## Prequisites

Before you continue, ensure you have the following requirements:

### Libraries
1. Python libraries: NumPy/Scipy (numerical computing), Pandas (data analyisis), os (myscellaneous operating system interfaces and ProgressBar (impelments a progres bar during the execution of the code.
2. R libraries: ggplot2 (for regular plotting), grid and gridExtra (for multipanel plotting)
3. LaTex packages: graphicx, lineno (to count lines), texcount (to count words), setspace (to change inline spacing), cite, amsmath and geometry (to change margns)

## Content

The important content is stored in the Code directory.
### List of files in Code directory

1. Data preparation (R):
  - `data_preparation_1.R` --> Prepares the data for the primary models fitting
  - `data_preparation_2.R` --> Prepares the data for the secondary model fitting
  - `data_preparation_functions.R` --> some functions used in data_preparation_* scripts
2. Model fitting scripts (Python):
  - `fit_store_models_1.py` --> Performs primary model fitting and stores results
  - `fit_store_models_2.py` --> Performs secondary model fitting and stores results
3. Plotting scripts (R):
  - `plotting_1.R` --> Plots all the fits of primary models
  - `plotting_2.R` --> Plots the fits to the secondary model
4. LaTeX (tex): 
  - `mini_project_report.tex` --> Generates the pdf report
5. Bibliography (bib):
  - `library.bib` --> Generates the references in the latex report
6. Run everything (bash):
  - `run_MiniProject.sh` --> Runs all the above scripts to produce the final results
  
The data to fit and some example figures taken from the literature are store in the Data directory.

Finally, a project_log.md file is kept in the Sandbox directory.
