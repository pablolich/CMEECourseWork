#include <stdio.h>
#include <stdlib.h>

struct listobj {//Listobj is a type of structure

    // The size of an int plus the size of a pointer.
    int data;
    struct listobj* next;

};

void traverse_list(struct listobj* lobj)
{
    /*This function traverses a list recursiveli
     * and calls out the integer stored inside */

    if (lobj != NULL) {
	printf("int data: %i\n", (*lobj).data);
	traverse_list((*lobj).next);
	printf("int data: %i\n", (*lobj).data);
	//Control goes to the last call, so if next is NULL, it will just go 
	//back through the list
    }
}

int main (void)
{

    // 3 instances to listobj
    struct listobj l1; // l1 has space in memory for an integer and a structure
    struct listobj l2;
    struct listobj l3;
    struct listobj l4;

    int intarray[3] = {10, 21, 33};
    
    //l1.next is a pointer to a structure, so it needs to be equal to a pointer
    //to a structure, ie &l2 (Note that l2 is a structure)
    l1.data = 10;
    l2.data = 21;
    l3.data = 33;
    l4.data = 41;

    l1.next = &l2; 
    l2.next = &l3; 
    l3.next = NULL; 

    //Loop through a linked list: (listobj)
    struct listobj* p = NULL;
    p = &l1;
    
    // First, lets look at member selection via a pointer
    int data = 0;
    //The .data selection has a higher priority than the star, so we put 
    //parentheses 
    data = (*p).data;
    //Friendlier:
    data = p -> data;

    //Lets leverage to do some looping:

    while (p != NULL){
	printf("data in p: %i\n", (*p).data);
	p = p->next;
    }

    printf("\n");

    //Insert a new element at position 2
    l4.next = &l2;
    l1.next = &l4;

    p = &l1; 
    while (p != NULL){
	printf("data in p: %i\n", (*p).data);
	p = p->next;
    }

    //Lets traverse the list recursively using a function
    printf("\nTraversing recursively:\n");
    traverse_list(&l1);

    printf("\n");
    return 0;
}

