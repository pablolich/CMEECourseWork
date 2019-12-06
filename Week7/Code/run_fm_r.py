#!/usr/bin/env python3

'''Run an .R file from python and print in screen the R console output, as well
as wether the run was succesful or not'''

__appname__ = '[run_fm_r.py]'
__author__ = 'Pablo Lechon (plechon@ucm.es)'
__version__ = '0.0.1'

## IMPORTS ##

import sys
import subprocess

## CONSTANTS ##


## FUNCTIONS ##

def main(argv):
    '''Main function'''
    subprocess.Popen("Rscript --verbose fmr.R > ../Results/TestR.Rout 2> \
                 ../Results/TestR_errFile.Rout", shell=True).wait()
    f = open('../Results/TestR.Rout').readlines()    
    if f[0].startswith('Reading') and f[-1].startswith('Finished'):
        print('Succesful run!:')
        print(open('../Results/TestR.Rout').read())
    else:
        print('Unsuccesful run:')
        print(open('../Results/TestR.Rout').read())

    return 0

## CODE ##

if (__name__ == '__main__'):
    status = main(sys.argv)
    sys.exit(status)
     

