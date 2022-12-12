import Foundation

let input = try! String(contentsOfFile: CommandLine.arguments[1], encoding: String.Encoding.utf8)
let lines = input.split(separator: "\n")

var countEnclosing: UInt = 0
for line in lines {
  let pair = line.split(separator: ",")
  precondition(pair.count == 2, String(line))

  let left = pair[0]
  let right = pair[1]

  let leftParts = left.split(separator: "-")
  precondition(leftParts.count == 2)
  let left_start = UInt(leftParts[0]) ?? 0
  let leftend = UInt(leftParts[1]) ?? 0
  let leftRange = left_start...leftend

  let rightParts = right.split(separator: "-")
  precondition(rightParts.count == 2)
  let right_start = UInt(rightParts[0]) ?? 0
  let rightend = UInt(rightParts[1]) ?? 0
  let rightRange = right_start...rightend

  if leftRange.overlaps(rightRange) {
    countEnclosing += 1
  }
}
print(countEnclosing)
