import Foundation

let data = NSData(contentsOfFile: CommandLine.arguments[1])!
var input = [UInt8](repeating: 0, count: data.length)
data.getBytes(&input, length: data.length)

let lines = [[UInt8]](input.split(separator: 0x0a).map({ l in [UInt8](l) }))
let width = lines.first!.count
let height = lines.count

var scores = [[Int]](repeating: [Int](repeating: 1, count: width), count: height)

for y in 0..<height {
  for x in 0..<width {
    let mainCell = lines[y][x]

    var score = 0
    // To the right
    for j in (x + 1)..<width {
      let otherCell = lines[y][j]
      score += 1
      if otherCell >= mainCell {
        break
      }
    }
    scores[y][x] *= score
    score = 0

    // To the left
    for j in 0..<x {
      let otherX = x - 1 - j
      let otherCell = lines[y][otherX]
      score += 1
      if otherCell >= mainCell {
        break
      }

    }
    scores[y][x] *= score
    score = 0

    // Downwards
    for i in (y + 1)..<height {
      let otherCell = lines[i][x]
      score += 1
      if otherCell >= mainCell {
        break
      }

    }
    scores[y][x] *= score
    score = 0

    // Upwards
    for i in 0..<y {
      let otherY = y - 1 - i
      let otherCell = lines[otherY][x]
      score += 1
      if otherCell >= mainCell {
        break
      }
    }
    scores[y][x] *= score
  }
}

print(scores)

var max = 0
for row in scores {
  for score in row {
    if max < score {
      max = score
    }
  }
}
print(max)
