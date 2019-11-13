#!/usr/bin/env python3

__appname__ = '[App_name_here]'
__author__ = 'Pablo Lechon (plechon@ucm.es)'
__version__ = '0.0.1'

## IMPORTS ##

import sys
import pandas as pd
import numpy as np

## CONSTANTS ##

MU = 1e-8

## FUNCTIONS ##

def segregation_sites(data):
    '''Identify columns with SNPs (segregating sites)'''
    return [data.columns.get_loc(i) for i in range(len(data.columns))
                                    if len(set(data[i]))==2]

def snp_freq(data):
    '''Calculate frequencies of snps'''
    return [sum(data[i]) for i in range(len(data.columns))]

def waterson_estimator(n, s):
    '''Calculate Waterson's estimator'''
    #no need for n-1 bc python indexes things from 0 to n-1
    return s/sum([1/i for i in range(1,n)])         

def compare_sequences(data):
    '''Calculate the number of different bases in seq1 and seq2'''
    #get i,j pairs with the condition i<j
    ind = np.triu_indices(len(data))
    pairwise_diff = []
    for i in range(len(ind[1])):
        #compare these indices to see how many pairwaise differences there are
        comp = np.equal(data.iloc[ind[0][i]],data.iloc[ind[1][i]])
        pairwise_diff.append(len(comp)-sum(comp))
    return sum(pairwise_diff)

def tajima_estimator(diff, n):
    '''Calculate Tajima's estimator'''
    return diff/(n*(n-1)/2)
                        
def main(argv):
    '''Main function'''
    '''Estimate the effective population size for each population, using both 
    the Watterson's and Tajima's estimator of "theta" assuming a mutation rate 
    of 1x10^{-8}. Discuss the difference between values of "theta" using 
    different estimators.'''

    #load data
    #this is a dataframe of dimensions 10x50000 with 0 and 1
    north = pd.read_csv('../Data/killer_whale_North.csv', header = None)
    south = pd.read_csv('../Data/killer_whale_South.csv', header = None)

    #Watterson's estimator
    #calculate segregating sites for both populations
    ind_north = segregation_sites(north)
    ind_south = segregation_sites(south)
    #calculate the estimator
    theta_w_north = waterson_estimator(len(north), len(ind_north))
    theta_w_south = waterson_estimator(len(south), len(ind_south))

    #Effective population size
    Ne_w_north = theta_w_north/(4*MU*len(north.columns))
    Ne_w_south = theta_w_south/(4*MU*len(south.columns))
    
    #Tajima's estimator
    #calculate pairwise differences
    diff_north = compare_sequences(north)
    diff_south = compare_sequences(south)
    #calculate estimator
    pi_north = tajima_estimator(diff_north, len(north))
    pi_south = tajima_estimator(diff_south, len(south))
    
    #Effective population size
    Ne_pi_north = pi_north/(4*MU*len(north.columns))
    Ne_pi_south = pi_south/(4*MU*len(south.columns))

    #Calculate the unfolded site frequency spectrum
    #Por columnas! Primero calculaar el numero de snips en cada columna 
    #(numero de unos!) Despues calcular la frecuencia de la frecuencia de snips
    #calcula la absoluta! es decir, desde 0 hasta 10. 
    #Cuantas veceas tengo 0 snips?, cuantas 1, cuantas 2...
    snp_f_n = snp_freq(north)
    freqsnp_f_n = np.bincount(snp_f_n)[1:]
    snp_f_s = snp_freq(south)
    freqsnp_f_s = np.bincount(snp_f_s)[1:]
    
    #Format output
    d = {'North': [theta_w_north,Ne_w_north, pi_north, Ne_pi_north, 
                   [freqsnp_f_n]], 
         'South': [theta_w_north,Ne_w_north, pi_north, Ne_pi_north, 
                   [freqsnp_f_s]]}

    df = pd.DataFrame(d, index = ['Theta', 'Ne_theta', 'Pi','Ne_pi', 'Spec'])
    df.to_csv('../Results/results_table.csv')

    return 0
          

## CODE ##

if (__name__ == '__main__'):
    status = main(sys.argv)
    sys.exit(status)
      

