import Foundation

var input = try! String(contentsOfFile: CommandLine.arguments[1], encoding: String.Encoding.utf8)
let lines = input.split(separator: "\n")

for (row, line) in lines.enumerated() {
    if (line.isEmpty) { break }
    if (line == "\n") { continue }

    if (line.contains("[")) { // Crates
        var remaining = line

        for column in  0... {
            let crate_begin = remaining.firstIndex(of: "[")
            if (crate_begin == nil) { break }

            let crate_end = remaining[crate_begin.unsafelyUnwrapped...].firstIndex(of: "]").unsafelyUnwrapped
            let crate = remaining[crate_begin.unsafelyUnwrapped..<crate_end]

            print(row, column, crate.dropFirst())

            remaining = remaining[crate_end...].dropFirst()
        }
    } else if (line.starts(with: "move")) { // Moves
        let parts = line.split(separator: " ")
        precondition(parts.count == 6, parts.description)

        let crates_count = UInt(parts[1]) ?? 0
        let from = UInt(parts[3]) ?? 0
        let to = UInt(parts[5]) ?? 0
        print(row, crates_count, from, to)
    }
}
