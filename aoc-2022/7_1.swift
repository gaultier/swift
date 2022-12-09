import Foundation
import System

var input = try! String(contentsOfFile: CommandLine.arguments[1], encoding: String.Encoding.utf8)
let lines = input.split(separator: "\n")


var cwd : FilePath = "/"
var paths : [FilePath] = []
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
    } else { //  Output of `ls`, file
        let file_size = Int(parts.first!) ?? 0
        let file_name = parts.last!
        print(file_name, file_size)
        
        let file_path = cwd.appending(String(file_name)).lexicallyNormalized()
        paths.append(file_path)
    }

}
print(paths)
