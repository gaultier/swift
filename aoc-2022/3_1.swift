import Foundation

let input = try! String(contentsOfFile: CommandLine.arguments[1], encoding: String.Encoding.utf8)
let lines = input.split(separator: "\n", omittingEmptySubsequences: false)

func char_to_priority(c: Character) -> UInt8 {
    switch (c) {
    case "a"..."z": return (c.asciiValue ?? 0) - 96
    case "A"..."Z": return (c.asciiValue ?? 0) - 64 + 26
    default: 
        assert(false)
    }
}

var sum : UInt = 0
for line in lines {
  if line == "\n" || line.isEmpty { break }

  let middle : Int = line.count / 2
  let left = Set(line.prefix(middle).sorted())
  let right = Set(line.suffix(middle).sorted())
  
  let inter =  left.intersection(right)
  precondition(inter.count >= 1, "\(inter) \(line) \(left) \(right)")

  let c = inter.first!
  let priority = char_to_priority(c: c)

  //print(line, left, right, inter, priority)

  sum += UInt(priority)
}

print(sum)
