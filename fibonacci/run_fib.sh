#! /usr/bin/env bash

set -e

function main() {
    echo "Cleaning out previous files"
    rm -rf .mypy_cache build/ c/fib.bin cpp/fib.bin odin/fib.bin py/__pycache__ py/*.so rs/target swift/.build ts/fib.bin 

    echo "Running mypyc so it can pre-compile"
    mypyc --help > /dev/null

    echo "Compiling binaries"
    hyperfine \
        --runs 1 \
        --sort "command" \
        --export-markdown "./compile-time.md" \
        --show-output \
        "clang -std=c17 -O3 c/main.c -o c/fib-c.bin" \
        "clang++ -std=c++23 -O3 cpp/main.cpp -o cpp/fib-cpp.bin" \
        "odin build odin -o:aggressive -out:odin/fib-odin.bin" \
        "mypyc py/fib.py && mv *.so py/" \
        "cargo build --release --manifest-path=rs/Cargo.toml" \
        "swift build --configuration=release --package-path=swift" \
        "deno compile --output=ts/fib-ts.bin ts/main.ts"

    echo "Running binaries"
    hyperfine \
        --warmup 3 \
        --runs 10 \
        --sort "command" \
        --export-markdown "./run-time.md" \
        "c/fib-c.bin" \
        "cpp/fib-cpp.bin" \
        "odin/fib-odin.bin" \
        "python3.13 py/main.py" \
        "rs/target/release/fib-rs" \
        "swift/.build/release/fib-swift" \
        "ts/fib-ts.bin"
}

main "$@"; exit
