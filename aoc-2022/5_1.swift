import Foundation

struct Move {
  let count: Int
  let from: Int
  let to: Int
}

var input = try! String(contentsOfFile: CommandLine.arguments[1], encoding: String.Encoding.utf8)
let lines = input.split(separator: "\n")

var stacks: [[Character]] = [[]]
var moves: [Move] = []

for (_, line) in lines.enumerated() {
  if line.isEmpty { break }
  if line == "\n" { continue }

  if line.contains("[") {  // Crates
    var remaining = line

    while true {
      let crateBegin = remaining.firstIndex(of: "[")
      if crateBegin == nil { break }

      let crateEnd = remaining[crateBegin!...].firstIndex(of: "]")!
      let crate = remaining[crateBegin!..<crateEnd]

      let crateName = crate.dropFirst()
      let column = line[...crateBegin!].count / 4

      if stacks.count <= column {
        for _ in 0...column - stacks.count {
          stacks.append([])
        }
      }
      precondition(column < stacks.count, "\(column) \(stacks.count)")
      stacks[column].insert(crateName.first!, at: 0)

      remaining = remaining[crateEnd...].dropFirst()
    }
  } else if line.starts(with: "move") {  // Moves
    let parts = line.split(separator: " ")
    precondition(parts.count == 6, parts.description)

    let cratesCount = Int(parts[1]) ?? 0
    // 1-indexed
    let from = (Int(parts[3]) ?? 0) - 1
    let to = (Int(parts[5]) ?? 0) - 1

    moves.append(Move(count: cratesCount, from: from, to: to))
  }
}

for move in moves {
  for _ in 1...move.count {
    let top = stacks[move.from].last!
    stacks[move.to].append(top)
    stacks[move.from] = stacks[move.from].dropLast()
  }
}

let tops = stacks.map({ st in String(st.last!) }).joined()
print(tops)
