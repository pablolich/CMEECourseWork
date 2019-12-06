#!/usr/bin/env python3

'''Start by positioning the beginning of the shorter sequence at all positions 
(bases) of the longer one (the start position), and count the number of bases 
matchebv, downstream. Then, for each start position, count the "score" as total 
of number of bases matched. The alignment with the highest score wins. Ties are
possible, in which case, you just take the an arbitrary alignment (e.g., first 
or last) with the highest score.'''

__appname__ = '[align_seqs.py]'
__author__ = 'Pablo Lechon (plechon@ucm.es)'
__version__ = '0.0.1'

## IMPORTS ##

import warnings
import sys

## CONSTANTS ##


## FUNCTIONS ##

def mask_list(l1, l2):
    '''Mask a list using another list of indexes or boolean values.'''
    if type(l2[0]).__name__ == 'bool':
        return [l1[i] for i in range(len(l2)) if l2[i]]
    else: 
        return [l1[i] for i in l2 if i]

def calculate_score(s1, s2, l1, l2, startpoint):
    '''Calculates the number of coincidences of two aligned genomes.


    Keyword arguments:
    s1 (str) -- first genome 
    s2 (str) -- second genome
    l1 (int) -- length of first genome
    l2 (int) -- length of second genome
    startpoint (int) -- starting position in s1 of the comparison
    '''

       
    matched = "" # to hold string displaying alignements
    score = 0
    for i in range(l2):
        if (i + startpoint) < l1:
            if s1[i + startpoint] == s2[i]: # if the bases match
                matched = matched + "*"
                score = score + 1
            else:
                matched = matched + "-"

    return score

def sort_seq(seq1, seq2):
    '''Assigns s1 and l1 to the longer sequence and s2 and l2 to the shorter'''
    l1 = len(seq1)
    l2 = len(seq2)
    if l1 >= l2:
        s1 = seq1
        s2 = seq2
    else:
        s1 = seq2
        s2 = seq1
        l1, l2 = l2, l1 # swap the two lengths
    return s1, s2, l1, l2

def save_out(i, names):
    '''Save the ith output files to a txt file'''
    with open('../Results/out_'+str(i)+'.txt', 'w+') as f:
        print(names[0], file = f)
        print(names[1], file = f)
        print(names[2], file = f)
    return 0

def main(argv):
    '''Main function'''
     #Load data
    _file = 'seq.txt'

    with open('../Data/' + _file) as f:
        #Create an array: each element is one line of the file
        seq = f.read().split('\n') 
        #Removing empty elements in the array due to unexpected \n 
        if not all(seq): 
            mask = [bool(i) for i in seq]
            seq = mask_list(seq, mask)
            print('Empty elements of the array have been removed') 

        seq1 = seq[0]
        seq2 = seq[1]
        #Assign the longer sequence to s1 and its length to l1
        s1, s2, l1, l2 = sort_seq(seq1, seq2)

        # now try to find the best match (highest score) for the two sequences
        my_best_align = None
        my_best_score = -1

        # Note that you just take the last alignment with the highest score
        for i in range(l1):
            z = calculate_score(s1, s2, l1, l2, i)
            if z > my_best_score:
                my_best_align = "." * i + s2 # think about what this is doing!
                my_best_score = z 

    #Save output to txt files
    save_out(0,[my_best_align, s1, my_best_score])
       
## CODE ##

if (__name__ == '__main__'): 
    status = main(sys.argv)
    sys.exit(status)
   
