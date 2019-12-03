#include <stdio.h>

int calculate_factorial(int n)
{
    if (n) {
        return n * calculate_factorial(n-1);
    }
    return 1;
}

int count_n(int n)
{
    if (n <= 10){
	printf("%i ", n);
	return count_n(n+1);
    }
return 1;
}

int main (void)
{
    int n = 4;
    printf("The factorial of %i is %i", n, calculate_factorial(n));
    printf("\nCounting to 10 with a recursive function\n");
    count_n(0);

    return 0;
}

