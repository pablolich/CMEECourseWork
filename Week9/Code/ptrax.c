#include <stdio.h>
#include <stdlib.h>

int main (void)
{
    int i  = 0;
    int j = 1;
    int *p = NULL; //The value of the pointer is NULL
    int *q = NULL;

    p = &i; //The value of the pointer changes to i (0).
    q = &j;

    printf("Value of i before indirection : %i\n", i);
    printf("Value of i via indirection : %i\n", *p);
    
    i = 4;
    *p = 5;


    printf("Value of i after indirection : %i\n", i);

    printf("Adress of i using & operator: %p\n", &i);
    printf("Adress of i reading p: %p\n", p); 

    printf("Another way to read apointer %i\n", *(&i));

    // Arithmetic operrations with pointers
    printf("Arithmetic via pointer: %i\n", *p + *q);

    return 0;
}

