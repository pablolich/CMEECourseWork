#include <stdio.h>

int main (void)
{
  char charray[]  = {'a', ' ', 's', 't', 'r', 'i', 'n', 'g', '!', '\0'};
  char string1[] = "A string!";

  printf("The 9th element of charray: %c\n", charray[9]);
  printf("The 9th element of charray: %c\n", string1[9]);


}


