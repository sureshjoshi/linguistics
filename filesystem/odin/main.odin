package main

import "core:fmt"
import "core:path/filepath"
import "core:os"

Foo :: struct {
    number_of_files: u32,
    total_size: i64,
}

callback :: proc(info: os.File_Info, in_err: os.Errno, user_data: rawptr) -> (err: os.Errno, skip_dir: bool) {
    // TODO: Is this the correct way to cast the rawptr back?
    foo := cast(^Foo)user_data
    foo.number_of_files += 1
    foo.total_size += info.size
    return
}

main :: proc() {
    // TODO: Does this automatically init default 0? Seems to work, but should I use Foo{}?
    foo: Foo
    filepath.walk(".", callback, &foo)
    fmt.println(foo.number_of_files, "files with a total size of", foo.total_size)
}