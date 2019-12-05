#include <stdio.h>
#include <stdlib.h>

int main (void)
{
    int numsites = 30;
    int *spcounts = NULL;

    //cast the pointer to void from mawloc to a pointer to integers.
    //size_t datatype is a long long undefined type of data.
    spcounts = (int*)malloc(numsites * sizeof(int));
    //Check that malloc succeeded and returned a valid pointer
    if (spcounts == NULL){
	printf("Insufficient memory for operation!\n");
	return 1;
    }

    spcounts[20] = 44;

    int i = 0;
    for (i = 0; i < numsites; ++i){
	printf("data in site %i is: %i\n", i, *(spcounts + i)); //spcounts[i] 
    }
    
    //To avoid memory leaks we call free memory. return it to the system before
    //overwriting the pointer to that memory:
    free(spcounts);
    sppcounts = NULL;

    spcounts = (int*)calloc(numsites, sizeof(int));

    spcounts[20] = 44;

    for (i = 0; i < numsites; ++i){
	printf("data in site %i is: %i\n", i, *(spcounts + i)); //spcounts[i] 
    }
    free(sppcounts);
    spcounts = NULL;

    return 0;
}

