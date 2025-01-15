from pathlib import Path
import lib

def main():
    number_of_files, total_size = lib.naive_walk(Path("."))
    print(f"{number_of_files} files with a total size of {total_size}")

if __name__ == "__main__":
    main()
