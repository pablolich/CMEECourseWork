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

from itertools import compress # To mask lists
import warnings
import sys
from align_seqs import calculate_score

## CONSTANTS ##


## FUNCTIONS ##

def non_valid_character_detector(genome):
    '''Delete empty lines and lines that are not part of the genome'''
    #Delete empty list elements if they exist
    if not all(genome):
        mask = [bool(i) for i in genome]
        genome = list(compress(genome, mask))
    #Remove lines that are not part of the actual genome
    for i in genome:
        if i[0] != 'A' and i[0] != 'G' and i[0] != 'T' and i[0] != 'C':
            genome.remove(i)
    return genome

def main(argv):
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
        seq1 = non_valid_character_detector(f1.read().split('\n'))
        seq2 = non_valid_character_detector(f2.read().split('\n'))

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
        import ipdb; ipdb.set_trace(context = 20)
        for i in range(l1):
            z = calculate_score(s1, s2, l1, l2, i)
            my_best_align.append( "." * i + s2)
            my_best_score.append(z) 

    #Save the output to a txt file
    with open('../Data/out.txt', 'w+') as f:
        print(my_best_align, file = f)
        print(s1, file = f)
        print(my_best_score, file = f)
## CODE ##

if (__name__ == '__main__'): 
    status = main(sys.argv)
    sys.exit(status)

