#ifndef _NODE_H
#define _NODE_H

//A typedef to save us keystrokes
//typedef <known type> <new alias>
typedef struct _node node_t;
typedef struct _node {
    //Every node_t has pionters to other structures.
    node_t *left;
    node_t *right;
    node_t *anc;
    int    tip;//Indicate if the node is a tip, and if it is, what unique label it has
    int    mem_index;//So that we can find it in the trees array
    char   *label;//A label for, say, the species

} node_t;

//node_t* new_node(void)'
//void    delete_node;


#endif

