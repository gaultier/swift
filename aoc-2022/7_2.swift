import Foundation
import System

let availableSpace = 70_000_000
let targetFreeSpace = 30_000_000

struct file {
  let path: filePath
  let size: Int
}

enum FSEntryKind {
  case file(Int)
  case Directory
}

class FSEntry {
  let kind: FSEntryKind
  let path: filePath
  var children: [FSEntry]
  let parent: FSEntry?

  init(kind: FSEntryKind, path: filePath, parent: FSEntry?) {
    self.kind = kind
    self.path = path
    self.children = []
    self.parent = parent
  }

  func addfileToDirectory(filePath: filePath, fileSize: Int) {
    children.append(FSEntry(kind: FSEntryKind.file(fileSize), path: filePath, parent: self))
  }

  func cdAndMaybeMkdir(path: filePath) -> FSEntry {
    if path == "/" && self.path == "/" {
      return self
    }

    let child = children.first(where: { entry in entry.path == path })
    if let child = child {
      return child
    }

    // mkdir
    children.append(FSEntry(kind: FSEntryKind.Directory, path: path, parent: self))
    return children.last!
  }

  func computeSize() -> Int {
    switch self.kind {
    case .file(let fileSize):
      return fileSize
    case .Directory:
      var size = 0
      for c in self.children {
        size += c.computeSize()
      }
      return size
    }
  }

  func collectDirectorySize(directorySizes: inout [Int]) {
    switch self.kind {
    case .Directory:
      directorySizes.append(self.computeSize())
      for c in self.children {
        c.collectDirectorySize(directorySizes: &directorySizes)
      }
    default: do {}
    }
  }

  func isDirectory() -> Bool {
    switch self.kind {
    case .Directory:
      return true
    default:
      return false
    }
  }

}

var input = try! String(contentsOffile: CommandLine.arguments[1], encoding: String.Encoding.utf8)
let lines = input.split(separator: "\n")

var cwd = FSEntry(kind: FSEntryKind.Directory, path: "/", parent: nil)
let root = cwd

for line in lines {
  precondition(cwd.isDirectory(), cwd.path.debugDescription)

  let parts = line.split(separator: " ")
  if line.starts(with: "$ ") {  // Command
    let cmd = parts[1]

    if cmd == "cd" {
      let arg = parts.last!
      if arg == ".." {
        cwd = cwd.parent!
      } else {
        let dir: filePath = cwd.path.appending(String(arg))
        cwd = cwd.cdAndMaybeMkdir(path: dir)
        precondition(cwd.isDirectory(), cwd.path.debugDescription)
      }
    }
  } else if line.starts(with: "dir") {  // Output of `ls`, dir
    // No-op
  } else {  //  Output of `ls`, file
    let fileSize = Int(parts.first!) ?? 0
    let fileName = parts.last!

    let filePath = cwd.path.appending(String(fileName))

    cwd.addfileToDirectory(filePath: filePath, fileSize: fileSize)
  }

}
var directorySizes: [Int] = []
root.collectDirectorySize(directorySizes: &directorySizes)
let occupiedSpace = directorySizes[0]  // root
directorySizes.sort()

let freeSpace = availableSpace - occupiedSpace
let index = directorySizes.firstIndex(where: { size in freeSpace + size >= targetFreeSpace }) ?? 0
print(index, directorySizes[index])
