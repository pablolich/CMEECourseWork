#include <stdio.h>
#include <stdlib.h>

int main (void)
{
    int integers[] = {1,33,4,10,11};
    int (*aintptr)[] = NULL; // A pointer to an array of integers
    int *aintptr2 = NULL; // A pointer to an integer

    aintptr = &integers;

    printf("The valuea at index 1 in intarray via indirection: %i\n", 
	    (*aintptr)[1]);

    // We can make this a lot more simpler:
    aintptr2 = integers;

    printf("Dereferencing pointer to an array: %i\n", *aintptr2);

    printf("Get second value by pointer arithmetic: %i\n", *(aintptr2 + 1));
    printf("Get second value by array subscripting a pointer: %i\n", 
	    aintptr2[1]);

    int *endofarray = NULL; // Let's point to a specific value in array:

    endofarray = &integers[4]; // Now points to last element of array

    for (aintptr2 = integers; aintptr2 <= endofarray; ++aintptr2){

	printf("%i ", *aintptr2);
    }

    printf("\n");



    
    

    return 0;
    
}
