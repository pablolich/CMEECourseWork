#include <stdio.h>
#include <stdbool.h>

//const tells the user that the function is not intending to change the 
//parameters
void print_int_array(const int array[], int nelems, bool newline)
{
    //In case we want to change nelems, we can record the limit in a third
    //variable
    const int limit = nelems;
    int i = 0;
    for (i = 0; i < limit; ++i) {
	printf("%i", array[i]);
	if (i < (nelems - 1)){
	    printf(", ");
	}
    }

    if (!newline) {return;}

    printf("\n");

    return;
}
