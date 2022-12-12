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

  var their_play: Play = .Rock
  switch plays[0] {
  case "A": their_play = .Rock
  case "B": their_play = .Paper
  case "C": their_play = .Scissor
  default:
    precondition(false, "Expected A|B|C, got: \(plays[0])")
  }

  var my_play: Play = .Rock
  switch plays[1] {
  case "X": my_play = .Rock
  case "Y": my_play = .Paper
  case "Z": my_play = .Scissor
  default:
    precondition(false, "Expected X|Y|Z, got: \(plays[1])")
  }

  var playScore: UInt = 0
  switch (their_play, my_play) {
  case (_, _) where their_play == my_play: playScore = 3  // Draw
  case (.Rock, .Paper), (.Paper, .Scissor), (.Scissor, .Rock): playScore = 6  // Win for me
  default: do {}  // Loss for me
  }
  let roundScore = my_play.score() + playScore

  totalScore += roundScore
}
print(totalScore)
