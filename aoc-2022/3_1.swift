import Foundation

let input = try! String(contentsOfFile: CommandLine.arguments[1], encoding: String.Encoding.utf8)
let lines = input.split(separator: "\n", omittingEmptySubsequences: false)

for line in lines {
  let middle : Int = line.count / 2
  let left = line.prefix(middle)
  let right = line.suffix(middle)
  
  print(left, right)
}
