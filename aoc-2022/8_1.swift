import Foundation

let data = NSData(contentsOfFile: CommandLine.arguments[1])!
var input = [UInt8](repeating: 0, count: data.length)
data.getBytes(&input, length: data.length)

let lines = [[UInt8]](input.split(separator: 0x0a).map({ l in [UInt8](l) }))
let width = lines.first!.count
let height = lines.count
print(width, height, lines, lines[3][2])

var visible = [[UInt8]](repeating: [UInt8](repeating: 0, count: width), count: height)

let visibleLeft = UInt8(0x1)
let visibleRight = UInt8(0x2)
let visibleTop = UInt8(0x4)
let visibleBottom = UInt8(0x8)

func rayTrace() {
  for y in 0..<height {
    var maxRow = UInt8(0)
    for x in 0..<width {
      let cell = lines[y][x]
      if cell > maxRow {
        visible[y][x] |= visibleLeft
      }

      maxRow = cell
    }
  }

  for y in 0..<height {
    var maxRow = UInt8(0)
    for x in 0..<width {
      let cell = lines[y][width - 1 - x]
      if cell > maxRow {
        visible[y][x] |= visibleRight
      }

      maxRow = cell
    }
  }

  for x in 0..<width {
    var maxCol = UInt8(0)
    for y in 0..<height {
      let cell = lines[y][x]
      if cell > maxCol {
        visible[y][x] |= visibleTop
      }

      maxCol = cell
    }
  }

  for x in 0..<width {
    var maxCol = UInt8(0)
    for y in 0..<height {
      let cell = lines[height - 1 - y][x]
      if cell > maxCol {
        visible[y][x] |= visibleBottom
      }

      maxCol = cell
    }
  }
}
rayTrace()

print(visible)
