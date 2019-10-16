#!/usr/bin/env python3 

'''Takes any two fasta sequences (in separate files) to be aligned as input. 
Gets rid of a header if there is one.
It outputs the best alignment along with its corresponding score in a text file
If no inupts files are given, it uses default files stored in ../Data/'''

__appname__ = '[align_seqs_fasta.py]'
__author__ = 'Pablo Lechon (plechon@ucm.es)'
__version__ = '0.0.1'

## IMPORTS ##

import warnings
import sys
from align_seqs import calculate_score, mask_list, sort_seq, save_out

## CONSTANTS ##


## FUNCTIONS ##

def non_valid_character_detector(genome):
    import ipdb; ipdb.set_trace(context = 20)
    '''Delete empty lines and lines that are not part of the genome'''
    #Delete empty list elements if they exist
    if not all(genome):
        mask = [bool(i) for i in genome]
        genome = mask_list(genome, mask)
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
        s1, s2, l1, l2 = sort_seq(seq1, seq2)

        #Now try to find the best match (highest score) for the two sequences
        my_best_align = None
        my_best_score = -1

        # Note that you just take the last alignment with the highest score
        for i in range(l1):
            z = calculate_score(s1, s2, l1, l2, i)
            if z > my_best_score:
                my_best_align = "." * i + s2 # think about what this is doing!
                my_best_score = z 

    #Save the output to a txt file
    save_out(0, [my_best_align, s1, my_best_score])

## CODE ##

if (__name__ == '__main__'): 
    status = main(sys.argv)
    sys.exit(status)

