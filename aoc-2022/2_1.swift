import Foundation

let input = try! String(contentsOfFile: CommandLine.arguments[1], encoding: String.Encoding.utf8)
let lines = input.split(separator: "\n", omittingEmptySubsequences: false)

enum Play: UInt {
    case Rock = 0, Paper = 1, Scissor = 2
    func score() -> UInt {
        return 1 + rawValue
    }
}

var total_score: UInt = 0
for line in lines {
    let plays = line.split(separator: " ")
    if (plays.isEmpty) { break }
    
    let left = UInt((plays[0].first?.asciiValue ?? 0) - (Character("A").asciiValue ?? 0))
    let their_play = Play(rawValue: left)!

    let right = UInt((plays[1].first?.asciiValue ?? 0) - (Character("X").asciiValue ?? 0))
    let my_play = Play(rawValue: right)!

    var play_score: UInt = 0 
    switch ((their_play, my_play)) {
        case (_, _) where their_play == my_play: play_score = 3 
        case (_, _) where my_play.rawValue > their_play.rawValue: play_score = 6
        case (_, _):  do{}
    }
    let round_score = my_play.score() + play_score
    print(their_play, my_play, "\(my_play.score()) + \(play_score) = \(round_score) => total before = \(total_score), after = \(total_score+round_score)")

    total_score += round_score
}
print(total_score)
