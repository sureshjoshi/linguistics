func fib(_ n: Int) -> Int {
    if n <= 1 {
        return n
    }
    return fib(n-2) + fib(n-1)
}

let result = fib(42)
print("Fib(42) = \(result)")
