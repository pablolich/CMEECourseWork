#include <stdio.h>
#include <stdlib.h>

// Function that takes an array of integers as a parameter that returns a 
// pointer to an integer
int *pos_first_odd(const int*, const unsigned long);

int *pos_first_odd(const int *integers, const unsigned long size)
{
    unsigned long int c = 0;
    int *ret = NULL;
    // Cast integers to int so that we don't get the warning of 'assingning to 
    // 'int' from 'const int'
    ret = (int*)integers; 

    while ((*ret % 2) ==0 && c < size) {
	// Incrementing the adress number, we are moving the frame of view in 
	// the memorysame as ret = ret + 1
	++ret; 
	++c;
    }
    
    if ((c == size) && (*ret % 2 == 0)) {return NULL;}
    
    return ret;
}
int main (void)
{
    int *res = NULL;
    int intarray[] = {2,4,10,21,30, 31};

    res = pos_first_odd(intarray, 6);

    printf("res now points to %i\n", *res);

    *res = *res - 1; //Returning the value minus 1

    res = pos_first_odd(intarray, 6);
    if (res != NULL) {
	printf("res now points to %i\n", *res);
    } 

    return 0;
}
// int (* (*x)()) (double) is a pointer to a function that takes nothing and 
// returns a pointer to a function that takes double and returns an integer.

