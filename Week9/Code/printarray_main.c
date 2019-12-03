#include <stdbool.h>
#include "printarray.h"

//Declaration of the functions (equivalent to export in python)
void print_int_array(int array[], int nelems, bool newline);

int main (void)
{
    int array[] = {4,5,6,7,88};

    print_int_array(array, 5, true);

    return 0;
}

