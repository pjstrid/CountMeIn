//
//  GameState.swift
//  CountMeIn
//
//  Created by Jonathan Strid on 2026-08-21.
//

import Foundation
import SwiftData

@Model
final class GameState {
    var gameType: String // "killer" for now
    var createdAt: Date
    var isActive: Bool
    
    @Relationship(deleteRule: .cascade, inverse: \Player.game)
    var players: [Player]
    
    init(gameType: String = "killer", createdAt: Date = Date(), isActive: Bool = true) {
        self.gameType = gameType
        self.createdAt = createdAt
        self.isActive = isActive
        self.players = []
    }
}
