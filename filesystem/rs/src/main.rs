use std::fs;
use std::path::Path;

fn naive_walk(dir: &Path, mut number_of_files: u32, mut total_size: u64) -> (u32, u64) {
    let entries = fs::read_dir(dir).unwrap();
    for entry in entries {
        let entry = entry.unwrap();
        let path = entry.path();
        if path.is_dir() {
            (number_of_files, total_size) = naive_walk(&path, number_of_files, total_size);
        } else {
            number_of_files += 1;
            total_size += path.metadata().unwrap().len();
        }
    }
    (number_of_files, total_size)
}

fn main() {
    let (number_of_files, total_size) = naive_walk(&Path::new("."), 0, 0);
    println!(
        "{} files with a total size of {}",
        number_of_files, total_size
    );
}
