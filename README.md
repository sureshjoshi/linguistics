# linguistics

This repo is intended to be for me, by me. I'm looking for a new language that I will use for a handful of upcoming projects. Some of those projects might be open-source, some might just live on my computer - I don't know. What I do know is that I'll be the primary/only code writer. My decision criteria are (in alphabetical order): c/c++ interop, compile time, enjoyment, metaprogramming, performance, standard library.

## THIS IS NOT A BENCHMARK REPO

I have `hyperfine`d some experiments, but most of the low-level languages should have the same-ish performance. If not, then I've probably screwed something up in the code and/or didn't line up compiler flags correctly. My mistakes should not be taken to mean "X is faster than Y because Z". 

There are enough shitty micro-benchmarks out there and I'm not looking to add to that discussion.

And if that isn't enough - I was literally watching YouTube and using XCode while running these on my computer - this is not anything close to a reasonable benchmark environment.

## For me, by me

The experiments here reflect some common workflows I have and I want to test out the ergonomics of a few languages under those use cases. Not just ergonomics while writing the code itself, but also as part of compiling, code quality, etc. Here are examples of a few upcoming projects that I want to pick a language for:
- A backup tool to replace the series of Bash scripts and terminal commands I use today
- A "smart-ish" task runner for cases with specific gotchas (A "smart and dumb" task runner is more accurate)
- Some educational games with raylib

As a result, my experiments focus on features I would need often: read access to lots of files, hashing, forking processes, interop with C and/or C++, and a handful of other items. I also generally prefer to not import libraries for everything - batteries included is great.

If these projects were intended to be written as part of a larger team, with a mixture of developers of different programming experience/skills - I'd change my criteria accordingly... And honestly, I would just pick Rust, Swift, Python, or Typescript depending on the use case and environment.

## Fibonacci

This is my "hello world". A basic recursive fibonacci implementation of the form `fib(n - 2) + fib(n - 1)`. Yes, that's intentional, I'm intentionally not trying to optimize that call - just trying to hammer the CPU with calculations for when `n=42`.

### Compile speeds

This runs only once. I added it to `hyperfine` just to track the numbers somewhere. I don't care about the exact numbers, just looking at "really fast" (C) vs "really slow" (Swift, Rust). I recently applied to the Jai closed beta. If I get accepted, I'm excited to maybe add another language to (really fast). 

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `clang -std=c17 -O3 c/main.c -o c/fib.bin` | 41.0 | 41.0 | 41.0 | 1.00 |
| `clang++ -std=c++23 -O3 cpp/main.cpp -o cpp/fib.bin` | 737.1 | 737.1 | 737.1 | 17.97 |
| `odin build odin -o:aggressive -out:odin/fib.bin` | 728.2 | 728.2 | 728.2 | 17.75 |
| `mypyc py/fib.py && mv *.so py/` | 1241.4 | 1241.4 | 1241.4 | 30.27 |
| `cargo build --release --manifest-path=rs/Cargo.toml` | 1793.0 | 1793.0 | 1793.0 | 43.71 |
| `swift build --configuration=release --package-path=swift` | 1657.7 | 1657.7 | 1657.7 | 40.41 |
| `deno compile --output=ts/fib.bin ts/main.ts` | 600.4 | 600.4 | 600.4 | 14.64 |

### Runtime

In addition to runtime, I added file size of the binary. That doesn't matter too much - other than being a quick check to see if I was running in debug without realizing it. Each of the non-C filesizes could probably be reduced, but I don't care - this isn't like back in the day when a Rust hello world came out to like 4 megs out of the box.

For results, it's as I would expect. All of the low-level languages perform similarly enough within the error built into the test system (e.g. my computer while working and watching YouTube). Typescript running in the Deno runtime was clearly much slower, as is expected. Python's results might seem surprising - except this was compiled down using `mypyc`. Without that step, vanilla Python takes 20-30 seconds to perform the same fib sequence.

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative | Size (kB) |
|:---|---:|---:|---:|---:|---:|
| `c/fib.bin` | 723.1 ± 1.6 | 720.3 | 726.3 | 1.00 ± 0.00 | 33 |
| `cpp/fib.bin` | 743.9 ± 54.8 | 717.1 | 891.0 | 1.03 ± 0.08 | 121 |
| `odin/fib.bin` | 730.0 ± 24.6 | 720.4 | 799.9 | 1.01 ± 0.03 | 151 |
| `python3.13 py/main.py` | 1395.5 ± 11.5 | 1386.4 | 1415.9 | 1.93 ± 0.02 | 148* |
| `rs/target/release/fib` | 722.4 ± 1.0 | 721.5 | 724.9 | 1.00 | 338 |
| `swift/.build/release/fib` | 927.6 ± 1.3 | 925.1 | 929.2 | 1.28 ± 0.00 | 55 |
| `ts/fib.bin` | 1912.7 ± 44.3 | 1895.3 | 2038.6 | 2.65 ± 0.06 | 66,158** |

*: The python size is the compiled object + the python source files. Excludes the Python interpreter (which would be another 25-50MB).

**: `deno compile` includes a stripped Deno runtime, the TS file itself is 338 bytes.

## Filesystem - Naive Walk

This experiment was a basic directory walk (300k files, 28GB total size) - recursive, iterative, whatever felt the most natural in the language. On many of my projects and scripts, at some point, I’ll be walking the filesystem. It might not be at runtime, but at least during build time, or when writing scripts or performing transformations/analyses. This is typically over 100 to 1000 files, so almost negligible performance hit in any language.

As a result, it’s not super important that the directory walk is fast. I’ve only had 2 instances in the past (and one upcoming) where I’ve needed to continually walk through, and operate on, more than 1M files at a time. In those cases, the cost of performing the operations/transformations outweighed the actual directory walking by a factor of 10-50x.

In that light, bonus points to C++, Odin, and Python for providing `walk` built-ins to the language. And dammit Rust, add `jwalk` or `walkdir` to the stdlib. And a big WTF with Swift... I've created a ticket to review why the performance is so bad, I must be completely blundering something about the API usage. Maybe there are more Swift-y APIs to use, and I'm getting caught in the ObjC translation layer or something. I also need to take a quick look at Rust, as I recall looking into this a year ago - and there was an easy win to get it closer to C++ speeds, but I don't recall what it was.

### Compile speeds

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `clang -std=c17 -O3 c/main.c -o c/naive-walk-c.bin` | 331.2 | 331.2 | 331.2 | 1.00 |
| `clang++ -std=c++23 -O3 cpp/main.cpp -o cpp/naive-walk-cpp.bin` | 906.1 | 906.1 | 906.1 | 2.74 |
| `odin build odin -o:aggressive -out:odin/naive-walk-odin.bin` | 1458.9 | 1458.9 | 1458.9 | 4.40 |
| `mypyc py/lib.py && mv *.so py/` | 1363.4 | 1363.4 | 1363.4 | 4.12 |
| `cargo build --release --manifest-path=rs/Cargo.toml` | 2375.7 | 2375.7 | 2375.7 | 7.17 |
| `swift build --configuration=release --package-path=swift` | 3121.3 | 3121.3 | 3121.3 | 9.42 |
| `deno compile --allow-read --output=ts/naive-walk-ts.bin ts/main.ts` | 663.6 | 663.6 | 663.6 | 2.00 |

### Runtime

| Command | Mean [s] | Min [s] | Max [s] | Relative | Size (kB) |
|:---|---:|---:|---:|---:|---:|
| `c/naive-walk-c.bin` | 7.764 ± 0.233 | 7.489 | 8.055 | 1.00 | 33 |
| `cpp/naive-walk-cpp.bin` | 7.783 ± 0.239 | 7.571 | 8.161 | 1.00 ± 0.04 | 125 |
| `odin/naive-walk-odin.bin` | 7.991 ± 0.296 | 7.702 | 8.477 | 1.03 ± 0.05 | 168 |
| `python3.13 py/main.py` | 9.358 ± 0.226 | 9.138 | 9.615 | 1.21 ± 0.05 | 148* |
| `rs/target/release/naive-walk-rs` | 8.799 ± 0.384 | 8.500 | 9.235 | 1.13 ± 0.06 | 339 |
| `swift/.build/release/naive-walk-swift` | 25.605 ± 0.120 | 25.459 | 25.748 | 3.30 ± 0.10 | 69 |
| `ts/naive-walk-ts.bin` | 9.072 ± 0.124 | 8.951 | 9.238 | 1.17 ± 0.04 | 66,222** |

*: The python size is the compiled object + the python source files. Excludes the Python interpreter (which would be another 25-50MB).

**: `deno compile` includes a stripped Deno runtime, the TS file itself is 336 bytes.

## System Information

TODO

## Compiler Information

TODO