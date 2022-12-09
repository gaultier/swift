import Foundation
import System

struct File {
    let path: FilePath
    let size: Int
}

enum FSEntryKind {
    case File, Directory
}

class FSEntry {
    let kind: FSEntryKind
    var size: Int
    let path: FilePath
    var children: [FSEntry]
    let parent: FSEntry?

    init(kind: FSEntryKind, size: Int, path: FilePath, parent: FSEntry?) {
        self.kind = kind
        self.size = size
        self.path = path
        self.children = []
        self.parent = parent
    }

    func addFileToDirectory(file_path: FilePath, file_size: Int) {
                size += file_size
                children.append(FSEntry(kind: FSEntryKind.File, size: file_size, path: file_path, parent: fs_entry))
    }

    func cdAndMaybeMkdir(path: FilePath) -> FSEntry  {
        let child = children.first(where: {entry in entry.path == path})
        if let child = child {
            return child
        }

        // mkdir
        children.append(FSEntry(kind: FSEntryKind.Directory, size: 0, path: path, parent: self))
        return children.last!
    }

    var debugDescription: String {
        var s = "\(path) \(size)\n"
        for c in children {
            s += c.debugDescription
        }
        return s
    }

    func computeSize() -> Int {
        var size = self.size
        for c in self.children {
            size += c.size
        }
        return size
    }

    func collectDirectorySize(directorySizes: inout [FilePath : Int]) {
       if (self.kind != FSEntryKind.Directory) { return }

       directorySizes[self.path] = self.computeSize() 
       for c in self.children {
           c.collectDirectorySize(directorySizes: &directorySizes)
       }
    }
}


var input = try! String(contentsOfFile: CommandLine.arguments[1], encoding: String.Encoding.utf8)
let lines = input.split(separator: "\n")


var cwd : FilePath = "/"
var fs_entry = FSEntry(kind: FSEntryKind.Directory, size: 0, path: "/", parent: nil)
let root = fs_entry


for line in lines {
    let parts = line.split(separator: " ")
    if (line.starts(with: "$ ")) { // Command
        let cmd = parts[1]

       if (cmd == "cd") {
           let cmd_arg = parts.last!
           cwd.append(String(cmd_arg))
           cwd.lexicallyNormalize()
           print("[D002] cwd=\(cwd)")
       } 
    }  else if (line.starts(with: "dir")) { // Output of `ls`, dir
        let dir : FilePath = cwd.appending(String(parts.last!))
        print("[D003] \(dir)")
        fs_entry = fs_entry.cdAndMaybeMkdir(path: dir)
    } else { //  Output of `ls`, file
        let file_size = Int(parts.first!) ?? 0
        let file_name = parts.last!
        print("[D004] \(file_name) \(file_size)")
        
        let file_path = cwd.appending(String(file_name)).lexicallyNormalized()
        print("[D005] \(cwd) \(file_path)")

        fs_entry.addFileToDirectory(file_path: file_path, file_size: file_size)
        //print(file_path, fs_entry)
    }

}
print("----")
print(root.debugDescription)


var directorySizes: [FilePath : Int] = [:]
root.collectDirectorySize(directorySizes: &directorySizes)
print(directorySizes)
