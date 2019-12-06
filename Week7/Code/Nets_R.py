#!/usr/bin/env python3

'''Reproduction of the R network plot with python'''

__appname__ = '[Nets_R.py]'
__author__ = 'Pablo Lechon (plechon@ucm.es)'
__version__ = '0.0.1'

## IMPORTS ##

import sys
import networkx as nx
import scipy as sc
import pandas as pd
import matplotlib.pylab as p
from matplotlib.patches import Patch
from matplotlib.lines import Line2D
import warnings
warnings.filterwarnings("ignore")

## CONSTANTS ##


## FUNCTIONS ##

def main(argv):
    '''Main function'''
    #load data
    link = pd.read_csv('../Data/QMEE_Net_Mat_edges.csv')
    names_unis = link.columns
    names_unis = sc.arange(0,len(names_unis))
    link = sc.matrix(link)
    nodes = pd.read_csv('../Data/QMEE_Net_Mat_nodes.csv')
    col = []
    for i in nodes['Type']:
        if i == 'University':
            col.append('b')
        elif i == 'Hosting Partner':
            col.append('g')
        else:
            col.append('r')
    names_node_atrib = nodes.columns
    #Geting indeces of interactions in matrix
    ind = sc.nonzero(link)
    ind_tup = sc.array([tuple(i) for i in sc.transpose(ind)])
    weight = sc.array([link[i,j] for i,j in ind_tup])
    ind_tup = ind_tup[weight!=0]
    ind_tup = [tuple(i) for i in ind_tup]
    weight = weight[weight!=0]
    std_weight = 1 + weight/10
    plot = p.figure()
    G = nx.DiGraph()
    pos = nx.spring_layout(sc.array(names_unis).tolist())
    G.add_nodes_from(sc.array(names_unis).tolist())
    G.add_edges_from(ind_tup)
    M = G.number_of_edges()
    edge_colors = sc.log(weight/max(weight))
    nx.draw_networkx(G, pos, width = std_weight, node_color = col, 
            node_size = 2000, with_labels = False, edge_color = edge_colors,
            edge_cmap = p.cm.Blues, arrowstyle = 'fancy')
    nx.draw_networkx_labels(G, pos, labels = nodes['id'])
    legend_elements = [Patch(facecolor='b', 
                         label='University'),
                       Patch(facecolor='g',
                         label='Hosting Partner'),
                   Patch(facecolor='r', 
                         label='Non-Hosting Partners')]
    p.legend(handles=legend_elements, loc='best', framealpha = 0.4)
    p.savefig('../Results/Net.pdf')

    return 0

## CODE ##

if (__name__ == '__main__'):
    status = main(sys.argv)
    sys.exit(status)
     

