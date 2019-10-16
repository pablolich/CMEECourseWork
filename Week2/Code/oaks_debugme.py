#!/usr/bin/env python3 

'''Given a file with species, the script detects which one of them is an oak
given the genus and the species. It admits certain typos to the genus'''

__appname__ = '[oaks_debugme.py]'
__author__ = 'Pablo Lechon (plechon@ucm.es)'
__version__ = '0.0.1'

## IMPORTS ##

import csv
import sys
import doctest
from itertools import permutations
import warnings

## CONSTANTS ##


## FUNCTIONS ##

def is_an_oak(name):
    """ Returns True if name is starts with 'quercus'
    
    >>> is_an_oak('quercus robur')
    True

    >>> is_an_oak('Quercus robur')
    True

    >>> is_an_oak('Quercuss robur')
    True

    >>> is_an_oak('Fagus sylvatica')
    False

    """

    #Generate a list of possible typos by permuting every character and 
    #doubling it
    _str = 'qquercuss'
    _str2 = 'quercus'
    perm_str = permutations(list(_str))
    perm_str2 = permutations(list(_str2))
    list1 = [i for i in perm_str]
    list2 = [i for i in perm_str2]
    listone = [''.join(i) for i in list1]
    listtwo = [''.join(i) for i in list2]
    #List of possible typos (pretty long)
    listtot = listone + listtwo
    for i in listtot:
        if name.lower().startswith(i):
            name = 'quercus'
    _bool = name.lower().startswith('quercus')
    if name.lower().startswith('quercus'):
        return True
    else:
        return False

def select_range(_list, ind, _range):
    import ipdb; ipdb.set_trace(context = 20)
    '''Select a range of elements in a list around a center value

    Keyword arguments:
    _list (list): list from which to extract the range of elements 
    ind (int): index of the central element 
    _range (int): number of elements to both sides of value to extract
    index (int): specifies which coincidence will be the central value
    '''

    #Get the index of an element in _list if it equals to value
    #to get the functionality of enumerate() do:
    #[i, x for i, x in enumerate(_list)]
    #inds = [i for i, x in enumerate(_list) if x == value)] 
    #Select which inds we want to have as a central value
    #Create list with the central value and the range selection
    #try:
    _out = _list[ind-_range:ind] + [_list[ind]] + _list[ind+1:ind+_range+1]
    #except 
    return _out

def auto_corretor(actual, attempt, tol):
    '''Rewrite 'attempt' string as 'actual' string if they are similar

    Keyword argument:
    actual (str): correct version of the word
    attempt (str): typo
    tol (float): percent indicating similarity between actual and attempt
    '''

    #Separate each character into a list
    l_attempt = list(attempt)
    l_actual = list(actual)
    intersect = []
    subtract_switch = 0
    k = 0#An index for l_attempt, that we will fiddle around with 
    #Compare how much do they have in common
    for i in range(len(l_actual)):
        #Select a range of words in which to search for the considered
        #character.
        #If the character is repeated, specify which one will be the central
        #inds = [i for i, x in enumerate(l_attempt) if x == i]
        sub_list = select_range(l_attempt, k, 1, )
        #the [0] at the end of the comprehension list makes sure that only one 
        #element is added to the intersect list each time. The correspondance
        #between the characters in l_actual and l_attempt is biunivoc.
        #try and except because the comprehension list might be empty, in
        #which case selecting the first element would yield an error
        try: intersect += [j for j in sub_list if j == l_actual[i]][0] 
        except: 
            del l_attempt[k]
            k += 1
            pass #Since there is nothing to add, we keep running the code
        #eliminate the found intersecting element in order to iterate through
        #the whole l_attempt word, which might me longer than l_actual
        
        #similarity = 100*len(intersect)/len(l_actual)
    return intersect


def main(argv): 
    '''Main function'''
    auto_corretor('quercus', 'queinircus', 90)
    f = open('../data/TestOaksData.csv','r')
    g = open('../data/JustOaksData.csv','w')
    taxa = csv.reader(f)
    csvwrite = csv.writer(g)
    next(taxa, None) #Skip the headers
    oaks = set()
    csvwrite.writerow(['Genus', 'species'])
    for row in taxa:
        print(row)
        print ("The genus is: ") 
        print(row[0] + '\n')
        if is_an_oak(row[0]):
            print('FOUND AN OAK!\n')
            csvwrite.writerow([row[0], row[1]])    

    return 0
    
doctest.testmod()

## CODE ##

if (__name__ == "__main__"):
    status = main(sys.argv)
