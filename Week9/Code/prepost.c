#include <stdio.h>

int main (void)
{
	int x = 6;
	int y = 0;

	//Postfix incrementation
	y = ++x;
	printf("y after postfix assignment: %i\n", y);
	printf("x after postfix assignment: %i\n", x);

	y = x++;
	printf("y after prefix assignent: %i\n", y);
	printf("x after prefix assignment: %i\n", x);

	// Deincrement x
	int z = x--;
	printf("x after deincrementeation: %i\n", x);
	printf("x from postfix deincrement: %i\n", z);

	return 0;
}

