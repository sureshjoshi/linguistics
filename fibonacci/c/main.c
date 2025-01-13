#include <stdio.h>

int fib(int n) {
    if (n <= 1) {
        return n;
    }
    return fib(n-2) + fib(n-1);
}

int main(int argc, char **argv) {
    int result = fib(42);
    printf("Fib(%d) = %d\n", 42, result);
    return 0;
}
