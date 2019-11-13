#!/usr/bin/env python3

'''Discrete time version of LV2.py'''

__appname__ = '[LV3.py]'
__author__ = 'Pablo Lechon (plechon@ucm.es)'
__version__ = '0.0.1'

## IMPORTS ##

import sys
import matplotlib.pylab as p
import scipy as sc

## CONSTANTS ##
if len(sys.argv) ==5:
    r = float(sys.argv[1])
    a = float(sys.argv[2])
    z = float(sys.argv[3])
    e = float(sys.argv[4])
    K = 15

else:
    r = 1.
    a = 0.1
    z = 0.5
    e = 0.7
    K = 19

## FUNCTIONS ##

def discrete_r(R, C):
    '''Calculate next step of the function'''
    return R * (1 + r * (1 - R/K) - a * C) 

def discrete_c(R, C):
    return C * (1 - z + e * a * R)

def main(argv):
    '''Main function'''
    t = sc.linspace(0,15,200) 
    R = [10]
    C = [5]
    #Since the values for R, C depend on the previous value, using lambda 
    #functions or list comprehensions will not imporve velocity, but only
    #make the code less intuitive to read. Therefore, we use a for loop
    i = 1 #The 0 position is set when we set initial parameter values
    #Prealocate variables
    R = R + (len(t)-1)*[0]
    C = C + (len(t)-1)*[0]
    while i < len(t):
        R[i] = discrete_r(R[i-1], C[i-1])
        C[i] = discrete_c(R[i-1], C[i-1])
        i += 1

    #Plot
    f1 = p.figure()
    f1.set_size_inches(8.27, 11.69)
    p.subplot(2,1,1)
    p.plot(t, R, 'g-', label='Resource density')
    p.plot(t, C, 'b-', label='Consumer density')

    p.grid()
    p.legend(loc='best')
    p.xlabel('Time')
    p.ylabel('Population density')
    p.title('Consumer-Resource population dynamics'+
            '\nr = %.1f, a = %.1f, z = %.1f, e = %.1f, K = %i'
             %(r, a, z, e, K))
    p.subplot(2,1,2)
    p.plot(R, C,  'r-', label = 'Cycle') # Plot
    p.grid()
    p.legend(loc='best')
    p.xlabel('Resource density')
    p.ylabel('Consumer density')
    p.title('Consumer-Resource population dynamics')
    f1.savefig('../Results/LV3_model.pdf') #Save figure

    return 0

## CODE ##

if (__name__ == '__main__'):
    status = main(sys.argv)
    sys.exit(status)
     

