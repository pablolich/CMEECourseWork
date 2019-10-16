#!/usr/bin/env python3 

'''Takes any two fasta sequences (in separate files) to be aligned as input. 
It outputs the best alignment along with its corresponding score in a text
file and records all the equally best alignments, saving them in 
../Results/out_[i].txt, with i being the ith equally best alignment. If no 
inupts files are given, it uses default files stored in ../Data/'''

__appname__ = '[align_seqs_better.py]'
__author__ = 'Pablo Lechon (plechon@ucm.es)'
__version__ = '0.0.1'

## IMPORTS ##

import warnings
import sys
import os
from align_seqs import calculate_score, mask_list, sort_seq, save_out
from align_seqs_fasta import non_valid_character_detector as nv

## CONSTANTS ##


## FUNCTIONS ##

def main(argv):
    '''Main function'''
    #Distribute variables (if given)
    if len(sys.argv) == 3:
        _FILE1 = sys.argv[1]
        _FILE2 = sys.argv[2]
    else:
        _FILE1 = '../Data/def1.fasta'
        _FILE2 = '../Data/def2.fasta'

    with open(_FILE1) as f1, open(_FILE2) as f2:
        #Separate the files by lines into a lis and getting rid of the first 2
        #lines
        seq1 = nv(f1.read().split('\n'))
        seq2 = nv(f2.read().split('\n'))

        ##Removing \n characters
        seq1 = ''.join(seq1)
        seq2 = ''.join(seq2)

        #Assign the longer sequence to s1 and its length to l1
        s1,s2,l1,l2 = sort_seq(seq1, seq2)
        
        #Create lists of 0 where all the possible alignments and scores well
        #be saved
        my_best_align = [0]*len(s1)#Preallocation to increase speed
        my_best_score = [0]*len(s1)

        #Calculate all the best alignments
        for i in range(l1):
            z = calculate_score(s1, s2, l1, l2, i)
            my_best_align[i] =  ("." * i + s2)
            my_best_score[i] = z 

        #Find the positions of the maximum score in my_best_score
        max_ind = [i for i in range(len(my_best_score)) 
                   if my_best_score[i] == max(my_best_score)]

        #Mask the alignments and scores according to those positions
        best_aligns = mask_list(my_best_align, max_ind)
        best_scores = mask_list(my_best_score, max_ind)


    #Delete out_*.txt files before creating new ones
    try:
        os.system('rm ../Results/out_*.txt')
    except:
        pass
    #Save best aligns to output files
    for i in range(len(best_scores)):
        save_out(i, [best_aligns, s1, best_scores])
    
    return 0

## CODE ##

if (__name__ == '__main__'): 
    status = main(sys.argv)
    sys.exit(status)

