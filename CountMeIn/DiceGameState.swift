//
//  DiceGameState.swift
//  CountMeIn
//
//  Created by Jonathan Strid on 2026-08-21.
//

import Foundation
import SwiftData

@Model
final class DiceGameState {
    var gameType: String // "10000"
    var createdAt: Date
    var isActive: Bool
    
    @Relationship(deleteRule: .cascade, inverse: \DicePlayer.diceGame)
    var players: [DicePlayer]
    
    init(gameType: String = "10000", createdAt: Date = Date(), isActive: Bool = true) {
        self.gameType = gameType
        self.createdAt = createdAt
        self.isActive = isActive
        self.players = []
    }
}
