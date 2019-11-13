#!/usr/bin/env python3

'''
Integrates the Lotka-Volterra model and outputs a time series plot with the 
evolution of both species, as long as a phase diagram
'''

__appname__ = '[LV1.py]'
__author__ = 'Pablo Lechon (plechon@ucm.es)'
__version__ = '0.0.1'

## IMPORTS ##

import sys
import scipy as sc
import scipy.integrate as integrate
import matplotlib.pylab as p

## CONSTANTS ##

r = 1.
a = 0.1
z = 1.5
e = 0.75
t = sc.linspace(0, 15, 1000)
R0 = 10
C0 = 5
RC0 = sc.array([R0, C0])

## FUNCTIONS ##

def dCR_dt(pops, t=0):

    R = pops[0]
    C = pops[1]
    dRdt = r * R - a * R * C
    dCdt = -z * C + e * a * R * C

    return sc.array([dRdt, dCdt])

def main(argv):
    '''Main function'''
    pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output=True)
    f1 = p.figure()
    f1.set_size_inches(8.27, 11.69)#A4 paper
    p.subplot(2,1,1)
    p.plot(t, pops[:,0], 'g-', label='Resource density') # Plot
    p.plot(t, pops[:,1]  , 'b-', label='Consumer density')
    p.grid()
    p.legend(loc='best')
    p.xlabel('Time')
    p.ylabel('Population density')
    p.title('Consumer-Resource population dynamics'+
            '\nr = %.1f, a = %.1f, z = %.1f, e = %.1f' %(r, a, z, e))

    p.subplot(2,1,2)
    p.plot(pops[:,0], pops[:,1], 'r-', label = 'Cycle') 
    p.grid()
    p.legend(loc='best')
    p.xlabel('Resource density')
    p.ylabel('Consumer density')
    p.title('Consumer-Resource population dynamics')
    f1.savefig('../Results/LV1_model.pdf') #Save figure
    return 0

## CODE ##

if (__name__ == '__main__'):
    status = main(sys.argv)
    sys.exit(status)
     

