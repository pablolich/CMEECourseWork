#include <stdio.h>
#include <stdlib.h>

struct intvec{
    size_t nelems; // size_t is a type of int that helps with optimization
    int*   data;
};

typedef struct intvec intvec_t;

intvec_t *new_intvec(size_t nelems)
{
    intvec_t* newvec = NULL;

    newvec = (intvec_t*)calloc(1, sizeof(intvec_t));

    if (newvec != NULL) {
	//set the 'array' bounds:
	newvec->nelems = nelems;
	//Allocate the memory for the 'array':
	newvec->data = (int*)calloc(nelems, sizeof(intvec_t));
	//Checks that the data was fully allocated
	if (newvec->data == NULL){
	    // If it failed, clean up the resources and exit the function
	    // returning NULL
	    free(newvec);
	    return NULL;
	}
    }

    return newvec;
}

void delete_intvec(intvec_t* ints)
{
    //Always check that the pointer to meomory being freed is non-NULL.
    if (ints != NULL) {
	if (ints->data != NULL){
	    free(ints->data);
	    ints->data = NULL;
	}
	free(ints);
    }
}

/*This function sets data in the intvec at a particular position; returns 0 if 
 * success; and returns -1 if failed (i.e. out of bounds)
 */
int set_data(int data, int index, intvec_t* ints)
{
    if (index >= ints->nelems) {
	return -1;
    }

    ints->data[index] = data;
    return 0;
}
/* This function gets data from a particular index in the intvec; returns 0 if
 * success; returns -1 if failed (i.e. out of bounds).
 */
int get_data(int* res, int index, intvec_t* ints){
    if (index < ints->nelems){
	*res = ints->data[index];
	return 0;
    }

    return -1;
}

int main (void)
{
    intvec_t *spcounts = new_intvec(30);

    int i = 0;
    int val = 0;

    for (i = 0; i < spcounts->nelems; ++i) {
	
	set_data(i + 3, i, spcounts);
    }

    printf("All of the elements of spcounts:\n");
    for (i = 0; i < spcounts->nelems; ++i) {
	get_data(&val, i, spcounts);
	printf("%i ", val);
    }
    printf("\n");

    int error = 0;

    error = get_data(&val, 50, spcounts);

    if (error != 0) {
	printf("Error! Tried to read out of bounds, you muppet!\n");
    }

    return 0;
}

