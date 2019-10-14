#!/usr/bin/env python3 

'''This program is the first one we do in the CMEE course.'''

__appname__ = '[cfexercise1.py]'
__author__ = 'Pablo Lechon (plechon@ucm.es)'
__version__ = '0.0.1'

## IMPORTS ##
import sys

## CONSTANTS ##


## FUNCTIONS ##

def foo_1(x):
    '''Taking the sqare root of x'''
    sq = x ** 0.5
    return '\nfoo_1: The square root of %d is %d' % (x, sq)

def foo_2(x, y):
    '''Returnss the higher number between x and y'''
    if x > y:
        return '\n%d is higher than %d' % (x, y)
    return '\nfoo_2: %d is higher than %d' % (y, x)

def foo_3(x, y, z):
    '''Sorts x, y, z increasingly'''
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return '\nfoo_3: %d > %d > %d' % (x, y, z)

def foo_4(x):
    '''Calculates the factorial of x'''
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return '\nfoo_4: The factorial of %d is %d' % (x, result)

def foo_5(x): 
    '''A recursive function that calculates the factorial of x'''
    if x == 1:
        return 1
    return x * foo_5(x - 1)

def foo_6(x): 
    '''Calculate the factorial of x in a different way'''
    _print = x
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return '\nfoo_6: The factorial of %d is %d' % (_print, facto)

def main(argv):
    '''This function calls the rest of them, with variables the user wants'''
    print(foo_1(4))
    print(foo_2(4, 5))
    print(foo_3(10, 30, 20))
    print(foo_4(6))
    print('\nfoo_5: The factiorial of %d is %d' % (6, foo_5(6)))
    print(foo_6(6))
    
    return 0

if (__name__ == '__main__'): 
    status = main(sys.argv)
    sys.exit(status)
