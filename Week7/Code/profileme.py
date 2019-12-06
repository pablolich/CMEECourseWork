#!/usr/bin/env python3

'''Auxiliary function to be profiled'''

def my_squares(iters):
    '''Calculate squares with for loop'''
    out = []
    for i in range(iters):
        out.append(i ** 2)
    return out

def my_join(iters, string):
    '''Join strings'''
    out = ''
    for i in range(iters):
        out += string.join(", ")
    return out

def run_my_funcs(x,y):
    '''Run all functions'''
    print(x,y)
    my_squares(x)
    my_join(x,y)
    return 0


run_my_funcs(10000000,"My string")
