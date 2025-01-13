fn fib(n: i32) -> i32 {
    if n <= 1 {
        return n;
    }
    return fib(n-2) + fib(n-1);
}

fn main() {
    let result = fib(42);
    println!("Fib(42) = {}", result);
}
