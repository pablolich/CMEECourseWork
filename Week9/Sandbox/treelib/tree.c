#include <stdlib.h>
#include "tree.h"

tree_t* new_treeee(int num_taxa)
{
    int i = 0;
    tree_t *newt = NULL;

    //Create the structure of the tree
    newt = (tree_t*)calloc(1, sizeof(tree_t));
    if (newt != NULL) {
	newt->num_taxa  = num_taxa;
	newt->num_nodes = 2 * num_taxa - 1;
	newt->nodes     = (node_t*)calloc(newt->num_nodes, sizeof(node_t));
	if (newt->nodes == NULL) {
	    // Allocation failed; clean up and return NULL
	    free(newt);
	    return NULL; 
	}

        for (i = 0; i < newt->num_nodes; ++i) {
	    // Assign memory indices to the nodes
	    newt->nodes[i].mem_index = i;
	    // Label the tips with non-zero
	    if (i < newt->num_taxa) {
		newt->nodes[i].tip = i + 1;
	    }
	    else {
		//Label the internalnodes with 0 tip
		newt->nodes[i].tip = 0;
	    }
	}

    }

    return newt;
}

void delete_tree(tree_t* tree)
{
    //Implement me!
}

void tree_read_anc_table(int *anctable, tree_t* t)
{
    int i = 0;
    int j = 0;

    //Loop over all elements of anctable
    //at each postioion link that node to its ancestor
    for (i = 0; i < t->num_nodes; ++i) {
	j = anctable[i]; // this is index of the ancestor of ith node
	
	t->nodes[i].anc = &t->nodes[anctable[j]]; //Setting the ancestor
	//Check if the position on theleft of the ancestor is NULL
	if (t->nodes[anctable[i]].left == NULL) { 
	    t->nodes[anctable[i]].left = &t->nodes[i];//The adress on that elemetn
	}
	else {
	    t->nodes[anctable[i]].right = &t->nodes[i];//Otherwise, to the right

	}
    }
}
