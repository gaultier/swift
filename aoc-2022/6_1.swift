import Foundation


var input = try! String(contentsOfFile: CommandLine.arguments[1], encoding: String.Encoding.utf8)

for i in 1...(input.count - 4) {
    let a = input.prefix(i + 0).last!
    let b = input.prefix(i + 1).last!
    let c = input.prefix(i + 2).last!
    let d = input.prefix(i + 3).last!
    if (a == b || a == c || a == d || b == c || b == d || c == d) { continue }
    print(i+3, a, b, c, d)
    break
}
