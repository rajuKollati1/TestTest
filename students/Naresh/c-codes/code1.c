//Addtion of Three Numbers
#include <stdio.h>

int main() {
    int a, b, c, sum;

    printf("Enter the first number: ");
    scanf("%d", &a);

    printf("Enter the second number: ");
    scanf("%d" , &b);
    
    printf("Enter the third number: ");
    scanf("%d" , &c);

    sum = a + b + c;

    printf("sum = %d\n", sum);

    return 0;
}