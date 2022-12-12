import Foundation
import System

let availableSpace = 70_000_000
let targetFreeSpace = 30_000_000

struct file {
  let path: FilePath
  let size: Int
}

enum FSEntryKind {
  case file(Int)
  case directory
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

  func addfileTodirectory(filePath: FilePath, fileSize: Int) {
    children.append(FSEntry(kind: FSEntryKind.file(fileSize), path: filePath, parent: self))
  }

  func cdAndMaybeMkdir(path: FilePath) -> FSEntry {
    if path == "/" && self.path == "/" {
      return self
    }

    let child = children.first(where: { entry in entry.path == path })
    if let child = child {
      return child
    }

    // mkdir
    children.append(FSEntry(kind: FSEntryKind.directory, path: path, parent: self))
    return children.last!
  }

  func computeSize() -> Int {
    switch self.kind {
    case .file(let fileSize):
      return fileSize
    case .directory:
      var size = 0
      for c in self.children {
        size += c.computeSize()
      }
      return size
    }
  }

  func collectdirectorySize(directorySizes: inout [Int]) {
    switch self.kind {
    case .directory:
      directorySizes.append(self.computeSize())
      for c in self.children {
        c.collectdirectorySize(directorySizes: &directorySizes)
      }
    default: do {}
    }
  }

  func isDirectory() -> Bool {
    switch self.kind {
    case .directory:
      return true
    default:
      return false
    }
  }

}

var input = try! String(contentsOfFile: CommandLine.arguments[1], encoding: String.Encoding.utf8)
let lines = input.split(separator: "\n")

var cwd = FSEntry(kind: FSEntryKind.directory, path: "/", parent: nil)
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
        let dir: FilePath = cwd.path.appending(String(arg))
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

    cwd.addfileTodirectory(filePath: filePath, fileSize: fileSize)
  }

}
var directorySizes: [Int] = []
root.collectdirectorySize(directorySizes: &directorySizes)
let occupiedSpace = directorySizes[0]  // root
directorySizes.sort()

let freeSpace = availableSpace - occupiedSpace
let index = directorySizes.firstIndex(where: { size in freeSpace + size >= targetFreeSpace }) ?? 0
print(index, directorySizes[index])
