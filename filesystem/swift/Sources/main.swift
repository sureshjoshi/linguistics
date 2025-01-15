import Foundation

// TODO: There is no chance this is the correct way to write this
// It looks like crap, feels like crap, and is substantially slower than other languages
// !!!Review this!!!
func naive_walk() -> (Int, UInt64) {
    var number_of_files: Int = 0
    var total_size: UInt64 = 0
    var isDir: ObjCBool = false

    let fileManager = FileManager.default 
    let enumerator = fileManager.enumerator(atPath: ".")!
    for path in enumerator  {
        // There should be a better way to do it than this - I recall an API that had file info built in
        guard fileManager.fileExists(atPath: path as! String, isDirectory: &isDir), isDir.boolValue == false else {
            continue
        }
        number_of_files += 1        
        total_size += enumerator.fileAttributes![.size] as! UInt64
    }
    return (number_of_files, total_size)
}

let (number_of_files, total_size) = naive_walk()
print("\(number_of_files) files with a total size of \(total_size / 1024)")
