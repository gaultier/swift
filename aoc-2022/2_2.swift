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

enum Outcome: UInt {
  case iLose = 0
  case draw = 3
  case iWin = 6
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

  var outcome: Outcome = .iLose
  switch plays[1] {
  case "X": outcome = .iLose
  case "Y": outcome = .draw
  case "Z": outcome = .iWin
  default:
    precondition(false, "Expected X|Y|Z, got: \(plays[1])")
  }

  var myPlay: Play = .rock
  switch (theirPlay, outcome) {
  case (_, .draw): myPlay = theirPlay
  case (.rock, .iWin): myPlay = .paper
  case (.paper, .iWin): myPlay = .scissor
  case (.scissor, .iWin): myPlay = .rock
  case (.rock, .iLose): myPlay = .scissor
  case (.paper, .iLose): myPlay = .rock
  case (.scissor, .iLose): myPlay = .paper
  }

  let playScore: UInt = outcome.rawValue

  let roundScore = myPlay.score() + playScore

  totalScore += roundScore
}
print(totalScore)
