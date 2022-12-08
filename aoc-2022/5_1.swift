import Foundation

var input = try! String(contentsOfFile: CommandLine.arguments[1], encoding: String.Encoding.utf8)
let lines = input.split(separator: "\n", omittingEmptySubsequences: false)

for (i, line) in lines.enumerated() {
    if (line == "\n" || line.isEmpty) { break }

    var remaining = line

    while (true) {
        let crate_begin = remaining.firstIndex(of: "[")
        if (crate_begin == nil) { break }

        let crate_end = remaining[crate_begin.unsafelyUnwrapped...].firstIndex(of: "]").unsafelyUnwrapped
        let crate = remaining[crate_begin.unsafelyUnwrapped..<crate_end]

        print(i, crate.dropFirst())

        remaining = remaining[crate_end...].dropFirst()
    }
}
