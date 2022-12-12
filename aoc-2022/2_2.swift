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

enum Outcome: UInt {
  case I_Lose = 0
  case Draw = 3
  case I_Win = 6
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

  var outcome: Outcome = .I_Lose
  switch plays[1] {
  case "X": outcome = .I_Lose
  case "Y": outcome = .Draw
  case "Z": outcome = .I_Win
  default:
    precondition(false, "Expected X|Y|Z, got: \(plays[1])")
  }

  var myPlay: Play = .Rock
  switch (theirPlay, outcome) {
  case (_, .Draw): myPlay = theirPlay
  case (.Rock, .I_Win): myPlay = .Paper
  case (.Paper, .I_Win): myPlay = .Scissor
  case (.Scissor, .I_Win): myPlay = .Rock
  case (.Rock, .I_Lose): myPlay = .Scissor
  case (.Paper, .I_Lose): myPlay = .Rock
  case (.Scissor, .I_Lose): myPlay = .Paper
  }

  let playScore: UInt = outcome.rawValue

  let roundScore = myPlay.score() + playScore

  totalScore += roundScore
}
print(totalScore)
