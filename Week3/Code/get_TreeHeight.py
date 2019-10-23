#!/usr/bin/env python3

'''Calculate height of trees from an csv input file with the name of the tree, 
its degrees of inclination, and the distance to it'''

__appname__ = '[App_name_here]'
__author__ = 'Pablo Lechon (plechon@ucm.es)'
__version__ = '0.0.1'

## IMPORTS ##

import sys
import csv
from math import pi, tan

## CONSTANTS ##


## FUNCTIONS ##

def tree_height(degrees, distance):
    '''Calculate tree height based on the degrees and the distance to tree

    Keyword arguments:
    degrees (list) -- .
    distance (list) -- .
    '''
    
    #multiply lists element by element
    radians = [i * pi / 180 for i in degrees]
    height = [i * tan(j) for i,j in zip(distance, radians)]

    return height

def remove_header(_list):
    '''Remove first row of a list of lists if all the elements in the first row
    are strings'''
    list_0 = [0]*len(_list[0])
    header = None
    for i in range(len(_list[0])):
        try:
            float(_list[0][i])
        except ValueError as e:
            if str(e).startswith('could not convert string to float:'):
                list_0[i] = 1
    if all(list_0):
        header = _list[0]
        _list = _list[1:]
    else: pass

    return _list, header

def str2float(_list, column):
    '''Transform the nth column of a list of lists from string to float

    Keyword arguments:
    _list (list) -- list of lists from which to pick a column to transform
    column (list) -- indexes of columns to transform
    '''
    for j in column:
       for i in range(len(_list)):
            _list[i][j] = float(_list[i][j])

    return _list

def main(argv):
    '''Main function'''
    #load data and massage it a little
    with open(sys.argv[1]) as trees_csv:
        trees = trees_csv.readlines()
        #delete '\n' at the end of lines
        trees_rm = [i.replace('\n', '').replace('"', '') for i in trees]
        #split rows to have different columns, using the ',' character
        trees_rm_sp = [i.split(',') for i in trees_rm]
        #remove header if it exists (if all the elements of the first row
        #are strings)
        trees_rmh_sp, header = remove_header(trees_rm_sp)
        #Transform columns 1,2 to floats
        trees_rmh_sp_float = str2float(trees_rmh_sp, [1, 2])
        #Calculate heights after transforming some elements to floats
        distances = [i[1] for i in trees_rmh_sp_float]
        angles = [i[2] for i in trees_rmh_sp_float]
        height = tree_height(distances, angles)
        #Append this column to the trees_rm_sp list
        _auxlist_ = [trees_rmh_sp_float[i].append(j) 
                     for i,j in zip(range(len(trees_rmh_sp_float)), height)]
        #Add header once we are ready to save the file
        #Also, add to the header the new column with tree heights
        save_trees_rmh_sp_float = [header + ['Height']] + trees_rmh_sp_float
        #Save to a csv file
        #Get the name of the input file without the csv extension
        name = sys.argv[1].split('/')[-1].split('.')[0]
        #create a file with the desired name and save our file to there
        with open('../Results/' + name + '_treeheights.csv', 'w') as csvfile:
            writer = csv.writer(csvfile)
            writer.writerows(save_trees_rmh_sp_float)

    return 0

## CODE ##

if (__name__ == '__main__'):
    status = main(sys.argv)
    sys.exit(status)
