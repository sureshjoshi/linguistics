#! /usr/bin/env bash

set -e

# readonly COMMANDS=(
#     "c;clang -std=c17 -O3 main.c -o fib.bin;./fib.bin"
#     "cpp;clang++ -std=c++23 -O3 main.cpp -o fib.bin;./fib.bin"
#     "odin;odin build . -o:aggressive -out:fib.bin;./fib.bin"
#     "py;odin build . -o:speed -out:fib.bin;python3 "
#     "rs;cargo build --release;./target/release/fib"
#     "swift;swift build -c release ;./.build/release/fib"
#     "ts;deno compile main.ts;deno run main.ts"
# )

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
        "clang -std=c17 -O3 c/main.c -o c/fib.bin" \
        "clang++ -std=c++23 -O3 cpp/main.cpp -o cpp/fib.bin" \
        "odin build odin -o:aggressive -out:odin/fib.bin" \
        "mypyc py/fib.py && mv *.so py/" \
        "cargo build --release --manifest-path=rs/Cargo.toml" \
        "swift build --configuration=release --package-path=swift" \
        "deno compile --output=ts/fib.bin ts/main.ts"

    echo "Running binaries"
    hyperfine \
        --warmup 3 \
        --runs 10 \
        --sort "command" \
        --export-markdown "./run-time.md" \
        "c/fib.bin" \
        "cpp/fib.bin" \
        "odin/fib.bin" \
        "python3.13 py/main.py" \
        "rs/target/release/fib" \
        "swift/.build/release/fib" \
        "ts/fib.bin"
}

main "$@"; exit
