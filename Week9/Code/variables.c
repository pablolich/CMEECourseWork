#include <stdio.h>

void double_int(int i)
{
    i = 2 * i;
    
    return;
}

void add_one_to_all(int array[], int nelems)
{
    int i = 0;

    for (i = 0; i < nelems; ++i) {
	array[i] += 1;
    }
    return;
}

int main (void)
{
    int i = 4;
    int array[] = {44, 77, 88, 101, 22};
    double_int(i);
    printf("Value of i after function call: %i\n", i);
    printf("Array after add_one_to_all: \n");
    add_one_to_all(array, 5);
    for (i = 0; i < 5; ++i) {
	printf("%i ", array[i]);
    }
    printf("\n");

    return 0;
}

