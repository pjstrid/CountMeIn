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
    
    init(name: String, score: Int = 0, order: Int = 0) {
        self.name = name
        self.score = score
        self.order = order
    }
}
