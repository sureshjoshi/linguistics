#include <dirent.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <sys/stat.h>

char current_path[256] = {0};

int naive_walk(const char* path, uint32_t* number_of_files, uint64_t* total_size) {
    DIR* dir = opendir(path);
    if (dir == NULL) {
        printf("Failed to open %s\n", path);
        return -1;
    }
    
    int len = strlen(path);
    strncpy(current_path, path, sizeof(current_path));
    current_path[len++] = '/';
    
    struct stat st;
    struct dirent* entry;
    while((entry = readdir(dir)) != NULL) {
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
            continue;
        }

        // TODO: Replace this with a copy - so I can statically allocate current_path
        // snprintf(current_path, sizeof(current_path), "%s/%s", path, entry->d_name);
        strncpy(current_path + len, entry->d_name, sizeof(current_path) - len);
        if (lstat(current_path, &st) != 0) {
            continue;
        }

        if (S_ISLNK(st.st_mode)) {
            continue;
        }

        if (S_ISREG(st.st_mode)) {
            (*number_of_files) += 1;
            (*total_size) += st.st_size;
        }

        if (S_ISDIR(st.st_mode)) {
            naive_walk(current_path, number_of_files, total_size);
        }
    }
    closedir(dir);
    return 0;
}

int main(int argc, char **argv) {
    const char* path = ".";
    uint32_t number_of_files = 0;
    uint64_t total_size = 0;
    if (naive_walk(path, &number_of_files, &total_size) != 0) {
        printf("naive_walk failed\n");
        return 1;
    }
    printf("%d files with a total size of %lld\n", number_of_files, total_size);
    return 0;
}
