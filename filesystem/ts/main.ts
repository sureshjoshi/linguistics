import { walkSync } from "jsr:@std/fs/walk";

let numberOfFiles = 0;
let totalSize = 0;
for (const dirEntry of walkSync(".", { includeSymlinks: false})) {
  if (dirEntry.isFile) {
    numberOfFiles += 1;
    totalSize += Deno.statSync(dirEntry.path).size;
  }
}

console.log(`${numberOfFiles} files with a total size of ${totalSize}`);
