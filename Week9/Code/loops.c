#include <stdio.h>

int main (void)
{

    int i = 0;
    int intarray[] = {4, 8, 5, 44};
    char hello[]  = "Hello!";

    //While loop	
    while ( i < 4 ) { //while condition is non-zero
        // Execute code in here
        printf("%i ", intarray[i]);
        ++i; 
  }
    printf("\n");
  
    i = 0;
    do {
        printf("%i ", intarray[i]);
	++i;
    } while ( i < 4 );
    printf("\n");

    printf("Using a for-loop:\n");
    for (i = 0; i < 4; i++) {
	printf("%i ", intarray[i]);
    }
    printf("\n");

    printf("Read an array backwards:\n");
    for (i = 3; i >=0; --i) {
	printf("%i ", intarray[i]);
    }
    printf("\n");

    for (i = 4; i-- ;) {
	printf("%i ", intarray[i]);
    }
    printf("\n");

    //Three ways to pring a string:
    // Char hello[] = "Hello!";

    for (i = 0; i < 6; ++i) { 
	putchar(hello[i]);
    }
    printf("\n");

    for (i = 0; hello[i]; ++i) {
	putchar(hello[i]);
    }
    printf("\n");

    printf("%s",hello);

    return 0;

}
