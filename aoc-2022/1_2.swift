import Foundation

let input = try! String(contentsOfFile: CommandLine.arguments[1], encoding: String.Encoding.utf8)
let lines = input.split(separator: "\n", omittingEmptySubsequences: false)

var elves: [UInt] = [0]  // Start with one elf
elves.reserveCapacity(10_000)

for line in lines {
  if line.isEmpty {
    elves.append(0)
  } else {
    let num = UInt(line) ?? 0
    elves[elves.count - 1] += num
  }
}

elves.sort(by: >)
print(elves[0] + elves[1] + elves[2])
