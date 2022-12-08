import Foundation

struct Move {
    let count: Int
    let from: Int
    let to: Int
}

var input = try! String(contentsOfFile: CommandLine.arguments[1], encoding: String.Encoding.utf8)
let lines = input.split(separator: "\n")

var stacks : Array<Array<Character>> = [[]]
var moves : Array<Move> = []

for (_, line) in lines.enumerated() {
    if (line.isEmpty) { break }
    if (line == "\n") { continue }

    if (line.contains("[")) { // Crates
        var remaining = line

        while (true) {
            let crate_begin = remaining.firstIndex(of: "[")
            if (crate_begin == nil) { break }

            let crate_end = remaining[crate_begin!...].firstIndex(of: "]")!
            let crate = remaining[crate_begin!..<crate_end]

            let crate_name = crate.dropFirst()
            let column = line[...crate_begin!].count / 4

            if (stacks.count <= column) {
                for _ in 0...column - stacks.count {
                    stacks.append([])
                }
            }
            precondition(column < stacks.count, "\(column) \(stacks.count)")
            stacks[column].insert(crate_name.first!, at: 0)

            remaining = remaining[crate_end...].dropFirst()
        }
    } else if (line.starts(with: "move")) { // Moves
        let parts = line.split(separator: " ")
        precondition(parts.count == 6, parts.description)

        let crates_count = Int(parts[1]) ?? 0
        // 1-indexed
        let from = (Int(parts[3]) ?? 0) - 1
        let to = (Int(parts[5]) ?? 0) - 1

        moves.append(Move(count: crates_count, from: from, to: to))
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
