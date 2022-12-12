import Foundation

let input = try! String(contentsOffile: CommandLine.arguments[1], encoding: String.Encoding.utf8)
let lines = input.split(separator: "\n", omittingEmptySubsequences: false)

func charToPriority(c: Character) -> UInt8 {
  switch c {
  case "a"..."z": return (c.asciiValue ?? 0) - 96
  case "A"..."Z": return (c.asciiValue ?? 0) - 64 + 26
  default:
    assert(false)
  }
  return 0
}

var sum: UInt = 0
for i in stride(from: 0, to: lines.count, by: 3) {
  if lines[i] == "\n" || lines[i].isEmpty { break }

  let x = Set(lines[i])
  let y = Set(lines[i + 1])
  let z = Set(lines[i + 2])

  let inter = x.intersection(y).intersection(z)
  precondition(inter.count >= 1, "\(inter) \(x) \(y) \(z)")

  let c = inter.first!
  let priority = charToPriority(c: c)

  //print(line, left, right, inter, priority)

  sum += UInt(priority)
}

print(sum)
