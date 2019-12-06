#!/usr/bin/env python3

'''Python version of Vectorize2.R'''

import numpy as np
import time

def stochrick(p0 = np.random.uniform(0.5,1.5,(1,1000))[0], r = 1.2, K = 1,
    sigma = 0.2, numyears = 100):
    '''Implementation with preallocation and witout vectorization'''
    #Initialize
    N = np.zeros([numyears, len(p0)])
    N[1,:] = p0

    for pop in np.arange(len(p0)): #Loop through the populations
        for yr in np.arange(numyears - 1): #For each population loop years
            N[yr, pop] = N [ yr - 1, pop] * np.exp(r * (1 - N[yr - 1, pop] / K)
                    + np.random.normal(loc = 0, scale = sigma, size = 1))

    return N

# Now write another function called stochrickvect that vectorizes the above to
# the extent possibl, with improved perrformance:

def stochrickvect(p0 = np.random.uniform(0.5,1.5,(1,1000))[0], r = 1.2, K = 1,
    sigma = 0.2, numyears = 100):
    '''Implementation with preallocation and vectorization'''

    #Initialize
    #Empty matrix of 1000 by 1000 by default. Every row corresponds to a 
    #population, and every column corresponds to one year.
    N  = np.zeros([numyears, len(p0)])
    N[1,:] = p0

    for yr in np.arange(numyears):#for each population loop through years
        N[yr,:] = N[yr-1,:] * np.exp(r * (1 - N[yr - 1,:] / K) + 
                  np.random.normal(loc = 0, scale = sigma, size = len(p0)))

    return N

start = time.time()
N = stochrick()
end = time.time()
tot1 = end - start
start = time.time()
N = stochrickvect()
end = time.time()
tot2 = end - start
print(" Vectorize2.py | {:.{}f}\t\t".format(tot1,4), "{:.{}f}".format(tot2,4), 
        '|') 


















