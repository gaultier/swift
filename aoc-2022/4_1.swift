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
  let leftend = UInt(left_parts[1]) ?? 0

  let right_parts = right.split(separator: "-")
  precondition(right_parts.count == 2)
  let right_start = UInt(right_parts[0]) ?? 0
  let rightend = UInt(right_parts[1]) ?? 0

  if (left_start <= right_start && rightend <= leftend)
    || (right_start <= left_start && leftend <= rightend)
  {
    count_enclosing += 1
  }
}
print(count_enclosing)
