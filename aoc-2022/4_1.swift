import Foundation

let input = try! String(contentsOffile: CommandLine.arguments[1], encoding: String.Encoding.utf8)
let lines = input.split(separator: "\n")

var countEnclosing: UInt = 0
for line in lines {
  let pair = line.split(separator: ",")
  precondition(pair.count == 2, String(line))

  let left = pair[0]
  let right = pair[1]

  let leftParts = left.split(separator: "-")
  precondition(leftParts.count == 2)
  let leftStart = UInt(leftParts[0]) ?? 0
  let leftend = UInt(leftParts[1]) ?? 0

  let rightParts = right.split(separator: "-")
  precondition(rightParts.count == 2)
  let rightStart = UInt(rightParts[0]) ?? 0
  let rightend = UInt(rightParts[1]) ?? 0

  if (leftStart <= rightStart && rightend <= leftend)
    || (rightStart <= leftStart && leftend <= rightend)
  {
    countEnclosing += 1
  }
}
print(countEnclosing)
