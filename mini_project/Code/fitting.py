#!/usr/bin/env python3

__appname__ = '[fitting.py]'
__author__ = 'Pablo Lechon (plechon@ucm.es)'
__version__ = '0.0.1'

## IMPORTS ##

import sys
import pandas as pd
from scipy.optimize import least_squares
from numpy import exp

## CONSTANTS ##


## FUNCTIONS ##
def logistic_equation(t, N_0 = 1, r = 1, K = 1):
    return (N_0 * K * exp(r * t))/(K + N_0 * (exp(r * t)-1))

def first_approach(time, population):
    'First fit to very good data'
#    good_dat = 

    return
    

def main(argv):
    '''Main function'''
    #load data
    import ipdb; ipdb.set_trace(context = 20)
    dat = pd.read_csv('../Data/growth_data.csv')
    print(logistic_equation(2))

    return 0 

## CODE ##

if (__name__ == '__main__'):
    status = main(sys.argv)
    sys.exit(status)
     



