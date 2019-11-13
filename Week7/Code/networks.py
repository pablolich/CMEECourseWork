import networkx as nx
import scipy as sc
import matplotlib.pyplot as p

def GenRdmAdjList(N = 2, C = 0.5):
    """
    Generating a random adjacent list of interactions between species with 
    a connectance probability of 0.5
    """
    Ids = range(N)
    ALst = []
    for i in Ids:
        #We don't have information from this foodweb, so we choose an unbiased
        #connectance.
        if sc.random.uniform(0,1,1) < C:
            Lnk = sc.random.choice(Ids,2).tolist()
            if Lnk[0] != Lnk[1]: #avoid self (e.g., cannibalistic) loops
                ALst.append(Lnk)
    return ALst


