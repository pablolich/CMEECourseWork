#include <stdio.h>

int main (void)
{
	// Interpretation: reserve memory with a read/write size of an int
	int i = 0;
	int j = 0;
	// Reserve memory with a read/write size of a char
	char c = 'c'; 	
	// Reserve memory with a read/write size of double
	double pi = 3.14;

	int intarray[4]; //Explicitly sized declaration
	int intarray2[] = {0, 0, 1, 4};
	int matrix[2][4]; //Matrixes can be specified
	int nmatrix[2][4][3]; //Matrices can be n-dimensional

	//Reading and writing form/to arrays:
	
	//Example: read from an uninitialised array:
	//Reading/writing in C is zero-based:

	//Takes the value into the zero position and asigns it to j
	j = intarray[0]; 

	printf("intarray at position 0: %i\n", j);
	printf("intarray at position 1: %i\n", intarray[1]);
	printf("intarray at position 2: %i\n", intarray[2]);
	printf("intarray at position 3: %i\n", intarray[3]);

	printf("intarray2 at position 0: %i\n", intarray2[0]);
	printf("intarray2 at position 1: %i\n", intarray2[1]);
	printf("intarray2 at position 2: %i\n", intarray2[2]);
	printf("intarray2 at position 3: %i\n", intarray2[3]);

	//Initialize positions of intarray2
	intarray2[0] = 3;
	intarray2[1] = 2;

	printf("after assignment:\n");
	printf("intarray2 at position 0: %i\n", intarray2[0]);
	printf("intarray2 at position 1: %i\n", intarray2[1]);
	printf("intarray2 at position 2: %i\n", intarray2[2]);
	printf("intarray2 at position 3: %i\n", intarray2[3]);

	printf("Reading out of intarray bounds: %i\n", intarray[4]);
	return 0;
}
