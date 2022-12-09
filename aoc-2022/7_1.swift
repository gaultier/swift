import Foundation
import System

struct File {
    let path: FilePath
    let size: Int
}

enum FSEntryKind {
    case File(Int), Directory
}

class FSEntry {
    let kind: FSEntryKind
    let path: FilePath
    var children: [FSEntry]
    let parent: FSEntry?

    init(kind: FSEntryKind, path: FilePath, parent: FSEntry?) {
        self.kind = kind
        self.path = path
        self.children = []
        self.parent = parent
    }

    func addFileToDirectory(file_path: FilePath, file_size: Int) {
                children.append(FSEntry(kind: FSEntryKind.File(file_size), path: file_path, parent: self))
    }

    func cdAndMaybeMkdir(path: FilePath) -> FSEntry  {
        if (path == "/" && self.path == "/") {
            return self
        } 

        let child = children.first(where: {entry in entry.path == path})
        if let child = child {
            return child
        }

        // mkdir
        children.append(FSEntry(kind: FSEntryKind.Directory, path: path, parent: self))
        return children.last!
    }

    var debugDescription: String {
        var s = "\(kind) \(path)\n"
        for c in children {
            s += c.debugDescription
        }
        return s
    }

    func computeSize() -> Int {
        switch(self.kind) {
            case .File(let file_size):
                return file_size
            case .Directory:
                var size = 0
                for c in self.children {
                    size += c.computeSize()
                }
                return size
        }
    }

    func collectDirectorySize(directorySizes: inout [FilePath : Int]) {
       switch (self.kind) {
           case .Directory:
               directorySizes[self.path] = self.computeSize() 
               for c in self.children {
                   c.collectDirectorySize(directorySizes: &directorySizes)
               }
            default: do{}
       }
    }

    func isDirectory() -> Bool {
       switch (self.kind) {
           case .Directory:
               return true
           default: 
               return false
        }
    }

    func printDebug(spaces: Int) {
        print(String(repeating: " ", count: spaces) + "- \(kind) \(path)")
        for c in children {
            c.printDebug(spaces: spaces + 2)
        }
    }
}


var input = try! String(contentsOfFile: CommandLine.arguments[1], encoding: String.Encoding.utf8)
let lines = input.split(separator: "\n")


var cwd = FSEntry(kind: FSEntryKind.Directory, path: "/", parent: nil)
let root = cwd


for line in lines {
    precondition(cwd.isDirectory(), cwd.debugDescription)

    let parts = line.split(separator: " ")
    if (line.starts(with: "$ ")) { // Command
        let cmd = parts[1]

       if (cmd == "cd") {
           let arg = parts.last!
           if (arg == "..") {
               cwd = cwd.parent!
           } else {
            let dir : FilePath = cwd.path.appending(String(arg))
            cwd = cwd.cdAndMaybeMkdir(path: dir)
            precondition(cwd.isDirectory(), cwd.debugDescription)
           }
       } 
    }  else if (line.starts(with: "dir")) { // Output of `ls`, dir
        // No-op
    } else { //  Output of `ls`, file
        let file_size = Int(parts.first!) ?? 0
        let file_name = parts.last!
        
        let file_path = cwd.path.appending(String(file_name))

        cwd.addFileToDirectory(file_path: file_path, file_size: file_size)
    }

}
print("----")
root.printDebug(spaces: 0)


var directorySizes: [FilePath : Int] = [:]
root.collectDirectorySize(directorySizes: &directorySizes)
print(directorySizes)

let top_sizes = directorySizes.values.filter({s in s <= 100000})
var sum = 0
for s in top_sizes {
    sum += s
}
print(top_sizes, sum)
