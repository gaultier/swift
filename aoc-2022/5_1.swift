import Foundation

var input = try! String(contentsOfFile: CommandLine.arguments[1], encoding: String.Encoding.utf8)
let lines = input.split(separator: "\n", omittingEmptySubsequences: false)

for (row, line) in lines.enumerated() {
    if (line == "\n" || line.isEmpty) { break }

    var remaining = line

    for column in  0... {
        let crate_begin = remaining.firstIndex(of: "[")
        if (crate_begin == nil) { break }

        let crate_end = remaining[crate_begin.unsafelyUnwrapped...].firstIndex(of: "]").unsafelyUnwrapped
        let crate = remaining[crate_begin.unsafelyUnwrapped..<crate_end]

        print(row, column, crate.dropFirst())

        remaining = remaining[crate_end...].dropFirst()
    }
}
