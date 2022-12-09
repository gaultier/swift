import Foundation
import System

struct File {
    let path: FilePath
    let size: Int
}

class FSEntry {
    var size: Int
    let path: FilePath
    var children: [FSEntry]
    let parent: FSEntry?

    init(size: Int, path: FilePath, parent: FSEntry?) {
        self.size = size
        self.path = path
        self.children = []
        self.parent = parent
    }

    func add_file_to_directory(file_path: FilePath, file_size: Int) {
                size += file_size
                children.append(FSEntry(size: file_size, path: file_path, parent: fs_entry))
    }

    func cd(path: FilePath) -> FSEntry  {
        let child = children.first(where: {entry in entry.path == path})
        if let child = child {
            return child
        }

        children.append(FSEntry(size: 0, path: path, parent: self))
        return children.last!
    }

    var debugDescription: String {
        var s = "\(path) \(size)\n"
        for c in children {
            s += c.debugDescription
        }
        return s
    }
}


var input = try! String(contentsOfFile: CommandLine.arguments[1], encoding: String.Encoding.utf8)
let lines = input.split(separator: "\n")


var cwd : FilePath = "/"
var fs_entry = FSEntry(size: 0, path: "/", parent: nil)
let root = fs_entry

for line in lines {
    let parts = line.split(separator: " ")
    if (line.starts(with: "$ ")) { // Command
        let cmd = parts[1]

       if (cmd == "cd") {
           let cmd_arg = parts.last!
           cwd.append(String(cmd_arg))
           cwd.lexicallyNormalize()
           print("cwd=\(cwd)")
       } 
    }  else if (line.starts(with: "dir")) { // Output of `ls`, dir
        let dir : FilePath = FilePath(String(parts.last!))
        print(dir)
        fs_entry = fs_entry.cd(path: dir)
    } else { //  Output of `ls`, file
        let file_size = Int(parts.first!) ?? 0
        let file_name = parts.last!
        print(file_name, file_size)
        
        let file_path = cwd.appending(String(file_name)).lexicallyNormalized()
        print("[D002] \(cwd) \(file_path)")

        fs_entry.add_file_to_directory(file_path: file_path, file_size: file_size)
        //print(file_path, fs_entry)
    }

}
print("----")
print(root.debugDescription)
