#include <stdio.h>

int add_integers(int, int); // A function prototipe

// Prototype with optional variable name
int add_four_integers(int a, int b, int c, int d); 

int add_four_integers(int a, int b, int c, int d){return add_integers(a, b) 
                                                  + add_integers(c, d);}

int add_integers(int x, int y){return x + y;}

int a = 5;
int b = 6;
int result = 0;

int main (void)
{
    result = add_integers(a, b);
    printf("Sum of a and b: %i\n", result);
    printf("Sum of result and b: %i\n", add_integers(result, b));

    return 0;
}	
