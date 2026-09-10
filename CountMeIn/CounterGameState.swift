//
//  CounterGameState.swift
//  CountMeIn
//
//  Created by Jonathan Strid on 2026-08-21.
//

import Foundation
import SwiftData

@Model
final class CounterGameState {
    var gameType: String // "counter"
    var createdAt: Date
    var isActive: Bool
    
    @Relationship(deleteRule: .cascade, inverse: \CounterPlayer.counterGame)
    var players: [CounterPlayer]
    
    init(gameType: String = "counter", createdAt: Date = Date(), isActive: Bool = true) {
        self.gameType = gameType
        self.createdAt = createdAt
        self.isActive = isActive
        self.players = []
    }
}
