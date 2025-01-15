#! /usr/bin/env bash

set -e

function main() {
    echo "Cleaning out previous files"
    rm -rf .mypy_cache build/ c/*.bin cpp/*.bin odin/*.bin py/__pycache__ py/*.so rs/target swift/.build ts/*.bin 

    echo "Running mypyc so it can pre-compile"
    mypyc --help > /dev/null

    echo "Compiling binaries"
    hyperfine \
        --runs 1 \
        --sort "command" \
        --export-markdown "./compile-time.md" \
        --show-output \
        "clang -std=c17 -O3 c/main.c -o c/naive-walk-c.bin" \
        "clang++ -std=c++23 -O3 cpp/main.cpp -o cpp/naive-walk-cpp.bin" \
        "odin build odin -o:aggressive -out:odin/naive-walk-odin.bin" \
        "mypyc py/lib.py && mv *.so py/" \
        "cargo build --release --manifest-path=rs/Cargo.toml" \
        "swift build --configuration=release --package-path=swift" \
        "deno compile --allow-read --output=ts/naive-walk-ts.bin ts/main.ts"

    echo "Running binaries"
    hyperfine \
        --warmup 3 \
        --runs 5 \
        --sort "command" \
        --export-markdown "./run-time.md" \
        "c/naive-walk-c.bin" \
        "cpp/naive-walk-cpp.bin" \
        "odin/naive-walk-odin.bin" \
        "python3.13 py/main.py" \
        "rs/target/release/naive-walk-rs" \
        "swift/.build/release/naive-walk-swift" \
        "ts/naive-walk-ts.bin"
}

main "$@"; exit
