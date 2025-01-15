from pathlib import Path

def naive_walk(path: Path) -> tuple[int, int]:
    """
    Using Path.walk in lieu of os.walk or os.scandir incurs a 10% perf hit on my machine
    Without doing any research, my guess is that this is due to:
    - Additional Path objects created during walk and (root/file)
    - scandir caching DirEntry objects
    """
    number_of_files = 0
    total_size = 0
    for root, dirs, files in path.walk():
        number_of_files += len(files)
        total_size += sum((root / file).stat(follow_symlinks=False).st_size for file in files)
    return number_of_files, total_size

# def os_walk_over(path: Path) -> tuple[int, int]:
#     number_of_files = 0
#     total_size = 0
#     for root, dirs, files in os.walk(path):
#         number_of_files += len(files)
#         total_size += sum((os.stat(os.path.join(root,file), follow_symlinks=False)).st_size for file in files)
#     return number_of_files, total_size

# Code from: https://peps.python.org/pep-0471/
# def get_tree_size(path):
#     total = 0
#     for entry in os.scandir(path):
#         if entry.is_dir(follow_symlinks=False):
#             total += get_tree_size(entry.path)
#         else:
#             total += entry.stat(follow_symlinks=False).st_size
#     return total
