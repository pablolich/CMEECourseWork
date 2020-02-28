#!/usr/bin/env python3

__appname__ = '[analysis.py]'
__author__ = 'Pablo Lechon (plechon@ucm.es)'
__version__ = '0.0.1'

## IMPORTS ##

import sys
import numpy as np
import pandas as pd
from lmfit import Minimizer, Parameters
from models import lactin2, ratkowsky, hinshelwood
from matplotlib.pylab import plt

## CONSTANTS ##


## FUNCTIONS ##
def select_best():
    return()

def get_points():
    return()

def main(argv):
    '''Main function'''
    

    #Vector of possible parameters

    #Load data
    dat = pd.read_csv('../Data/analysis.csv')
    T = np.array(dat.Temp)
    mu_max = np.array(dat.mu_max)
    

    #LACTIN#
    ########
    #Initialize parameters
    par_name = ['rho', 'Tmax', 'delta', 'lam']
    par_vals = [0.12, 37, 8.2, -0.015]
    params = Parameters()
    for p in range(len(par_name)):
        params.add(par_name[p], value = par_vals[p])
    #Perform fit
    minner = Minimizer(lactin2, params, fcn_args = (T, mu_max))
    fit_ = minner.minimize()
    #Evaluate fit and plot
    evals = 100
    T_eval = np.linspace(0, 39, 100)
    synthetic = np.ones(evals)
    pred = lactin2(fit_.params, T_eval, synthetic)
    evaluation = synthetic + pred
    plt.scatter(T, mu_max)
    plt.plot(T_eval, evaluation)


    #SQUARE ROOT#
    #############
    #Initialize parameters
    par_name = ['b', 'Tmax', 'Tmin', 'c']
    par_vals = [0.03, 37, 2, 0.02]
    params = Parameters()
    for p in range(len(par_name)):
        params.add(par_name[p], value = par_vals[p])
    #Perform fit
    minner = Minimizer(ratkowsky, params, fcn_args = (T, mu_max))
    fit_ = minner.minimize()
    #Evaluate fit and plot
    evals = 100
    T_eval = np.linspace(0, 39, 100)
    synthetic = np.ones(evals)
    pred = ratkowsky(fit_.params, T_eval, synthetic)
    evaluation = synthetic + pred
    plt.plot(T_eval, evaluation)


    #HINSHELWOOD#
    #############
    #Initialize parameters
    par_name = ['k1', 'E1', 'k2', 'E2']
    par_vals = [1e3, 20*8, 1e4, 30*8]
    params = Parameters()
    for p in range(len(par_name)):
        params.add(par_name[p], value = par_vals[p])
    #Perform fit
    minner = Minimizer(hinshelwood, params, fcn_args = (T, mu_max))
    import ipdb; ipdb.set_trace(context = 20)
    fit_ = minner.minimize()
    #Evaluate fit and plot
    evals = 100
    T_eval = np.linspace(0, 39, 100)
    synthetic = np.ones(evals)
    pred = hinshelwood(fit_.params, T_eval, synthetic)
    evaluation = synthetic + pred
    plt.plot(T_eval, evaluation)
    plt.show()
    plt.close()



    return 0

## CODE ##

if (__name__ == '__main__'):
    status = main(sys.argv)
    sys.exit(status)
     

