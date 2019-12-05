#!/usr/bin/env python3

"""Comparing run time for using loops vs list comprehensions 
and loops vs the join method utilizing the timeit module"""

__appname__ = 'timeitme.py'
__author__ = 'Pablo Lechon (plechon@ucm.es)'
__version__ = '0.0.1'
__license__ = 'None'

##############################################################################
# loops vs. list comprehensions: which is faster?
##############################################################################

iters = 1000000

import timeit

from profileme import my_squares as my_squares_loops

from profileme2 import my_squares as my_squares_lc

##############################################################################
# loops vs. the join method for strings: which is faster?
##############################################################################

mystring = "my string"

from profileme import my_join as my_join_join

from profileme2 import my_join as my_join
