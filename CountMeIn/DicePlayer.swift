//
//  DicePlayer.swift
//  CountMeIn
//
//  Created by Jonathan Strid on 2026-08-21.
//

import Foundation
import SwiftData

@Model
final class DicePlayer {
    var name: String
    var savedScore: Int
    var roundScore: Int
    var order: Int
    
    var diceGame: DiceGameState?
    
    init(name: String, savedScore: Int = 0, roundScore: Int = 0, order: Int = 0) {
        self.name = name
        self.savedScore = savedScore
        self.roundScore = roundScore
        self.order = order
    }
}
