package main

import "core:fmt"
import "core:path/filepath"
import "core:os"

Foo :: struct {
    number_of_files: u32,
    total_size: i64,
}

callback :: proc(info: os.File_Info, in_err: os.Errno, user_data: rawptr) -> (err: os.Errno, skip_dir: bool) {
    foo := cast(^Foo)user_data
    foo.number_of_files += 1
    foo.total_size += info.size
    return
}

main :: proc() {
    foo: Foo
    filepath.walk(".", callback, &foo)
    fmt.println(foo.number_of_files, "files with a total size of", foo.total_size)
}