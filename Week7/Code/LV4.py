#!/usr/bin/env python3

'''
Discrete version of LV2.py with random gaussian fluctuation in the resource
growth
'''

__appname__ = '[LV4.py]'
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
    z = 1.5
    e = 0.75
    K = 35

## FUNCTIONS ##

def discrete_r(R, C, eps):
    '''Calculate next step of the R function'''
    return R * (1 + (r + eps) * (1 - R/K) - a * C) 

def discrete_c(R, C):
    '''Calculate next step of the C function'''
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
    #Calculate values for the prealocated lists
    while i < len(t):
        eps = sc.random.normal(scale = 0.1)
        R[i] = discrete_r(R[i-1], C[i-1], eps)
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
    f1.savefig('../Results/LV4_model.pdf') #Save figure

    return 0

## CODE ##

if (__name__ == '__main__'):
    status = main(sys.argv)
    sys.exit(status)
     

