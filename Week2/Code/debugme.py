#!/usr/bin/env python3 

'''Learning how to debug a code'''

def makeabug(x):
    y = x**4
    z = 0
    try:
        y = y/z
    except ZeroDivisionError as e:
        print(e)
    return y

makeabug(25)
