import Foundation

let input = try! String(contentsOfFile: CommandLine.arguments[1], encoding: String.Encoding.utf8)
let lines = input.split(separator: "\n", omittingEmptySubsequences: false)

enum Play: UInt {
  case Rock = 1
  case Paper = 2
  case Scissor = 3
  func score() -> UInt {
    return rawValue
  }
}

var totalScore: UInt = 0
for line in lines {
  let plays = line.split(separator: " ")
  if plays.isEmpty { break }
  precondition(plays.count == 2, String(plays.count))

  var theirPlay: Play = .Rock
  switch plays[0] {
  case "A": theirPlay = .Rock
  case "B": theirPlay = .Paper
  case "C": theirPlay = .Scissor
  default:
    precondition(false, "Expected A|B|C, got: \(plays[0])")
  }

  var myPlay: Play = .Rock
  switch plays[1] {
  case "X": myPlay = .Rock
  case "Y": myPlay = .Paper
  case "Z": myPlay = .Scissor
  default:
    precondition(false, "Expected X|Y|Z, got: \(plays[1])")
  }

  var playScore: UInt = 0
  switch (theirPlay, myPlay) {
  case (_, _) where theirPlay == myPlay: playScore = 3  // Draw
  case (.Rock, .Paper), (.Paper, .Scissor), (.Scissor, .Rock): playScore = 6  // Win for me
  default: do {}  // Loss for me
  }
  let roundScore = myPlay.score() + playScore

  totalScore += roundScore
}
print(totalScore)
