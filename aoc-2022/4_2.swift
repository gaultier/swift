import Foundation

let input = try! String(contentsOfFile: CommandLine.arguments[1], encoding: String.Encoding.utf8)
let lines = input.split(separator: "\n")

var count_enclosing: UInt = 0
for line in lines {
  let pair = line.split(separator: ",")
  precondition(pair.count == 2, String(line))

  let left = pair[0]
  let right = pair[1]

  let left_parts = left.split(separator: "-")
  precondition(left_parts.count == 2)
  let left_start = UInt(left_parts[0]) ?? 0
  let left_end = UInt(left_parts[1]) ?? 0
  let left_range = left_start...left_end

  let right_parts = right.split(separator: "-")
  precondition(right_parts.count == 2)
  let right_start = UInt(right_parts[0]) ?? 0
  let right_end = UInt(right_parts[1]) ?? 0
  let right_range = right_start...right_end

  if left_range.overlaps(right_range) {
    count_enclosing += 1
  }
}
print(count_enclosing)
