package main

import "core:fmt"

fib :: proc(n: int) -> int {
    if n <= 1 {
        return n
    }
    return fib(n-2) + fib(n-1)
}

main :: proc() {
    result := fib(42)
    fmt.println("Fmt(42) = ", result)
}