import Foundation

let input = try! String(contentsOfFile: CommandLine.arguments[1], encoding: String.Encoding.utf8)
let lines = input.split(separator: "\n", omittingEmptySubsequences: false)

enum Play: UInt {
    case Rock = 1, Paper = 2, Scissor = 3
    func score() -> UInt {
        return rawValue
    }
}

enum Outcome: UInt {
    case I_Lose = 0, Draw = 3, I_Win = 6
}

var total_score: UInt = 0
for line in lines {
    let plays = line.split(separator: " ")
    if (plays.isEmpty) { break }
    precondition(plays.count == 2, String(plays.count))
    
    var their_play : Play = .Rock
    switch(plays[0]) {
        case "A": their_play = .Rock
        case "B": their_play = .Paper
        case "C": their_play = .Scissor
        default:
            precondition(false, "Expected A|B|C, got: \(plays[0])")
    }

    var outcome: Outcome = .I_Lose
    switch(plays[1]) {
        case "X": outcome = .I_Lose
        case "Y": outcome = .Draw
        case "Z": outcome = .I_Win
        default:
            precondition(false, "Expected X|Y|Z, got: \(plays[1])")
    }

    var my_play: Play = .Rock
    switch ((their_play, outcome)) {
        case (_, .Draw): my_play = their_play
        case (.Rock, .I_Win): my_play = .Scissor
        case (.Paper, .I_Win): my_play = .Rock
        case (.Scissor, .I_Win): my_play = .Rock
        case (.Rock, .I_Lose): my_play = .Scissor
        case (.Paper, .I_Lose): my_play = .Rock
        case (.Scissor, .I_Lose): my_play = .Paper
    }

    let play_score: UInt = outcome.rawValue

    let round_score = my_play.score() + play_score

    total_score += round_score
}
print(total_score)
