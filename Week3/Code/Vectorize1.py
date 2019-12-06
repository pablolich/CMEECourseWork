#!/usr/bin/env python3

'''Python version of Vectorize1.R'''

import numpy as np
import time

M = np.random.uniform(0,1,(1000,1000))

def SumAllElements(M):
    Dimensions = M.shape
    Tot = 0
    for i in np.arange(Dimensions[0]):
        for j in np.arange(Dimensions[1]):
            Tot = Tot + M[i,j]

    return Tot

print("                  Non-vect   Vectorized")
start = time.time()
SumAllElements(M)
end = time.time()
tot1 = end - start
start = time.time()
np.sum(M)
end = time.time()
tot2 = end - start
print('                -----------|------------')
print(" Vectorize1.py | {:.{}f}\t\t".format(tot1,4), "{:.{}f}".format(tot2,4),
        '|')


