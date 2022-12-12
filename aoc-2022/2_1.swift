import Foundation

let input = try! String(contentsOffile: CommandLine.arguments[1], encoding: String.Encoding.utf8)
let lines = input.split(separator: "\n", omittingEmptySubsequences: false)

enum Play: UInt {
  case rock = 1
  case paper = 2
  case scissor = 3
  func score() -> UInt {
    return rawValue
  }
}

var totalScore: UInt = 0
for line in lines {
  let plays = line.split(separator: " ")
  if plays.isEmpty { break }
  precondition(plays.count == 2, String(plays.count))

  var theirPlay: Play = .rock
  switch plays[0] {
  case "A": theirPlay = .rock
  case "B": theirPlay = .paper
  case "C": theirPlay = .scissor
  default:
    precondition(false, "Expected A|B|C, got: \(plays[0])")
  }

  var myPlay: Play = .rock
  switch plays[1] {
  case "X": myPlay = .rock
  case "Y": myPlay = .paper
  case "Z": myPlay = .scissor
  default:
    precondition(false, "Expected X|Y|Z, got: \(plays[1])")
  }

  var playScore: UInt = 0
  switch (theirPlay, myPlay) {
  case (_, _) where theirPlay == myPlay: playScore = 3  // Draw
  case (.rock, .paper), (.paper, .scissor), (.scissor, .rock): playScore = 6  // Win for me
  default: do {}  // Loss for me
  }
  let roundScore = myPlay.score() + playScore

  totalScore += roundScore
}
print(totalScore)
