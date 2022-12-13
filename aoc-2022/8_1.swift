import Foundation

let data = NSData(contentsOfFile: CommandLine.arguments[1])!
var input = [UInt8](repeating: 0, count: data.length)
data.getBytes(&input, length: data.length)

let lines = [[UInt8]](input.split(separator: 0x0a).map({ l in [UInt8](l) }))
let width = lines.first!.count
let height = lines.count

var visible = [[UInt8]](repeating: [UInt8](repeating: 0, count: width), count: height)

// Raytrace each row from the left
for y in 0..<height {
  var maxRow = UInt8(0)
  for x in 0..<width {
    let cell = lines[y][x]
    if cell > maxRow {
      visible[y][x] |= 1
      maxRow = cell
    }
  }
}

// Raytrace each row from the right
for i in 0..<height {
  var maxRow = UInt8(0)
  for j in 0..<width {
    let x = width - 1 - j
    let y = i
    let cell = lines[y][x]
    if cell > maxRow {
      visible[y][x] |= 1
      maxRow = cell
    }
  }
}

// Raytrace each column from the top
for x in 0..<width {
  var maxCol = UInt8(0)
  for y in 0..<height {
    let cell = lines[y][x]
    if cell > maxCol {
      visible[y][x] |= 1

      maxCol = cell
    }
  }
}

// Raytrace each column from the bottom
for i in 0..<width {
  var maxCol = UInt8(0)
  for j in 0..<height {
    let x = i
    let y = height - 1 - j
    let cell = lines[y][x]
    if cell > maxCol {
      visible[y][x] |= 1

      maxCol = cell
    }
  }
}

var sum = 0
for y in 0..<height {
  for x in 0..<width {
    sum += Int(visible[y][x])
  }
}
print(sum)
