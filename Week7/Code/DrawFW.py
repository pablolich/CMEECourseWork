#!/usr/bin/env python3

__appname__ = '[DrawFW.py]'
__author__ = 'Pablo Lechon (plechon@ucm.es)'
__version__ = '0.0.1'

## IMPORTS ##

import sys
import networkx as nx
import scipy as sc
import matplotlib.pyplot as p

## CONSTANTS ##


## FUNCTIONS ##
def GenRdmAdjList(N = 2, C = 0.5):
    """
    Generate a syntetic foodweb
    """
    Ids = range(N)
    ALst = []
    for i in Ids:
        if sc.random.uniform(0,1,1) < C:
            Lnk = sc.random.choice(Ids,2).tolist()
            if Lnk[0] != Lnk[1]: #avoid self (e.g., cannibalistic) loops
                ALst.append(Lnk)
    return ALst

def main(argv):
    '''Main function'''
    MaxN = 30
    C = 0.75
    AdjL = sc.array(GenRdmAdjList(MaxN, C))
    Sps = sc.unique(AdjL)
    pos = nx.circular_layout(Sps)
    G = nx.Graph()
    G.add_nodes_from(Sps)
    G.add_edges_from(tuple(AdjL))
    SizRan = ([-10,10]) #use log10 scale
    Sizs = sc.random.uniform(SizRan[0],SizRan[1],MaxN)
    NodSizs= 1000 * (Sizs-min(Sizs))/(max(Sizs)-min(Sizs))
    nx.draw_networkx(G, pos, node_size = NodSizs)
    #save file
    p.savefig('../Results/network.pdf')
    return 0

## CODE ##

if (__name__ == '__main__'):
    status = main(sys.argv)
    sys.exit(status)
     

