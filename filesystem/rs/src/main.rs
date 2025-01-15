use std::fs;
use std::path::Path;

fn naive_walk(dir: &Path) -> (u32, u64) {
    let mut number_of_files: u32 = 0;
    let mut total_size: u64 = 0;
    let entries = fs::read_dir(dir).unwrap();
    for entry in entries {
        let entry = entry.unwrap();
        let path = entry.path();
        if path.is_dir() {
            let (inner_number_of_files, inner_total_size) = naive_walk(&path);
            number_of_files += inner_number_of_files;
            total_size += inner_total_size;
        } else {
            number_of_files += 1;
            total_size += path.metadata().unwrap().len();
        }
    }
    (number_of_files, total_size)
}

fn main() {
    let (number_of_files, total_size) = naive_walk(&Path::new("."));
    println!(
        "{} files with a total size of {}",
        number_of_files, total_size
    );
}
