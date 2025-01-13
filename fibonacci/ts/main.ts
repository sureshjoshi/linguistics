function fib(n: number): number {
  if (n <= 1) {
    return n;
  }
  return fib(n - 2) + fib(n - 1);
}

const result = fib(42);
console.log(`Fib(42) = ${result}`);
