//
//  Player.swift
//  CountMeIn
//
//  Created by Jonathan Strid on 2026-08-21.
//

import Foundation
import SwiftData

@Model
final class Player {
    var name: String
    var score: Int
    var order: Int
    var selectedNumber: Int? // 1-20, nil if not selected
    
    var game: GameState?
    
    init(name: String, score: Int = 1, order: Int = 0, selectedNumber: Int? = nil) {
        self.name = name
        self.score = score
        self.order = order
        self.selectedNumber = selectedNumber
    }
}
