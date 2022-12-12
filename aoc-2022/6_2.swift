import Foundation

var input = try! String(contentsOfFile: CommandLine.arguments[1], encoding: String.Encoding.utf8)

for i in 1...(input.count - 14) {
  let index = input.index(input.startIndex, offsetBy: i)
  let msg = input[index...].prefix(14)
  let chars: Set<UInt8> = Set(msg.utf8)

  if msg.count == chars.count {
    print(i + 14)
    break
  }
}
