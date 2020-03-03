#Fitting and evaluating primary models..i!/usr/bin/env python3

__appname__ = '[analysis.py]'
__author__ = 'Pablo Lechon (plechon@ucm.es)'
__version__ = '0.0.1'

## IMPORTS ##

import sys
import numpy as np
import pandas as pd
from lmfit import Minimizer, Parameters
from models import lactin2
from progressbar import ProgressBar 

## CONSTANTS ##
global R
R = 8.31446261815324 #(J K^-1 mol^-1)


## FUNCTIONS ##

def main(argv):
    '''Main function'''
    

    #Load data
    dat = pd.read_csv('../Data/cfu_analysis.csv')
    T = np.array(dat.Temp)
    mu_max = np.array(dat.mu_max)
    


    #FIT LACTIN FOR ALL MODELS#
    ###########################


    species = np.unique(dat.Species)
    #Preallocate a vector for Topt
    Topt = [0]*len(dat.Temp)
    j = 0
    nevals = 500
    ngroups = len(species)
    ntot = nevals*ngroups
    names_out = list(np.repeat(species, nevals))
    fit_results = {'Species':names_out, 'Temp':[0]*ntot, 
                   'mu_max':[0]*ntot, 'Topt':[0]*ntot}
    pbar = ProgressBar() # Implement progress bar
    for i in pbar(species):
        fit_dat = dat[dat.Species == i]
        T = fit_dat.Temp
        mu_max = fit_dat.mu_max
        #Convert temperature to K
        par_name = ['rho', 'Tmax', 'delta', 'lam']
        par_vals = [0.12, 37, 8.2, -0.015]
        params = Parameters()
        for p in range(len(par_name)):
            min_ = -np.inf
            max_ = np.inf
            if par_name[p] == 'Tmax':
                min_ = 0
                max_ = 60

            params.add(par_name[p], value = par_vals[p], 
                       min = min_, max = max_)
        #Perform fit
        minner = Minimizer(lactin2, params, fcn_args = (T, mu_max))
        fit_ = minner.minimize()
        params_dict = fit_.params.valuesdict()
        Tmax = params_dict['Tmax']
        delta = params_dict['delta']
        rho = params_dict['rho']
        To = (Tmax*delta*rho - Tmax + delta*np.log(1/(delta*rho)))/\
              (delta*rho-1)
        Topt[j*len(T):(j+1)*len(T)] = [To]*len(T)
        #Evaluate fit and plot
        T_eval = np.linspace(min(T), params_dict['Tmax'], nevals)
        synthetic = np.ones(nevals)
        pred = lactin2(fit_.params, T_eval, synthetic)
        evaluation = synthetic + pred
        names = list(fit_results.keys())#Get rid of names key
        names.pop(0)
        #Flag unsuccesful fits if topt is unreal (due to lack of t range)
        suc = 1
        if To > 120:
            suc = 0
        values = [list(T_eval), list(evaluation), [suc]*nevals]
        for k in range(len(names)):
            fit_results[names[k]][j*nevals:(j+1)*nevals] = values[k]
        j += 1
    #Adding Topt to the original results
    dat['Topt'] = Topt
    fit_eval = pd.DataFrame(fit_results)
    Toptvec, idx = np.unique(Topt, return_index = True)
    #Sort in the original order of appearance
    Toptvec = Toptvec[np.argsort(idx)]
    Topt_eval = np.repeat(Toptvec, nevals)
    fit_eval['Topt'] = Topt_eval
    dat.to_csv('../Results/dat_secondary.csv')
    fit_eval.to_csv('../Results/fit_eval_secondary.csv')

    return 0

## CODE ##

if (__name__ == '__main__'):
    status = main(sys.argv)
    sys.exit(status)
     

