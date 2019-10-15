#!/usr/bin/env python3 

'''Takes any two fasta sequences (in separate files) to be aligned as input. 
It outputs the best alignment along with its corresponding score in a text
file and records all the equally best alignments, saving them in ../Results/
directory. If no inupts files are given, it uses default files stored in 
../Data/'''

__appname__ = '[align_seqs_better.py]'
__author__ = 'Pablo Lechon (plechon@ucm.es)'
__version__ = '0.0.1'

## IMPORTS ##

import warnings
import sys
from align_seqs import calculate_score, mask_list
from align_seqs_fasta import non_valid_character_detector as nv

## CONSTANTS ##


## FUNCTIONS ##

def main(argv):
    '''Main function'''
    #Distribute variables (if given)
    if len(sys.argv) == 3:
        _file1 = sys.argv[1]
        _file2 = sys.argv[2]

    elif len(sys.argv) == 1:
        _file1 = '../Data/def1.fasta'
        _file2 = '../Data/def2.fasta'

    else:
        raise('Invalid number of input arguments')

    with open(_file1) as f1, open(_file2) as f2:
        #Separate the files by lines into a lis and getting rid of the first 2
        #lines
        seq1 = nv(f1.read().split('\n'))
        seq2 = nv(f2.read().split('\n'))

        ##Removing \n characters
        seq1 = ''.join(seq1)
        seq2 = ''.join(seq2)

        #Assign the longer sequence to s1 and its length to l1
        l1 = len(seq1)
        l2 = len(seq2)
        if l1 >= l2:
            s1 = seq1
            s2 = seq2
        else:
            s1 = seq2
            s2 = seq1
            l1, l2 = l2, l1 # swap the two lengths

        #Now try to find the best match (highest score) for the two sequences
        #Create empty lists where all the possible alignments and scores well
        #be saved
        my_best_align = []#[0]*len(s1)
        my_best_score = []#[0]*len(s1)

        # Note that you just take the last alignment with the highest score
        for i in range(l1):
            z = calculate_score(s1, s2, l1, l2, i)
            my_best_align.append( "." * i + s2)
            my_best_score.append(z) 
        #Find the positions of the maximum score
        max_ind = [i for i in range(len(my_best_score)) 
                   if my_best_score[i] == max(my_best_score)]
        #Mask the alignments and scores according to those positions
        best_aligns = mask_list(my_best_align, max_ind)
        best_scores = mask_list(my_best_score, max_ind)
        import ipdb; ipdb.set_trace(context = 20)

    #Save best aligns to output files
    for i in range(len(best_scores)):
        with open('../Results/out_'+str(i)+'.txt', 'w+') as f:
            print(best_aligns[i], file = f)
            print(s1, file = f)
            print(best_scores[i], file = f)

## CODE ##

if (__name__ == '__main__'): 
    status = main(sys.argv)
    sys.exit(status)

