//
//  CounterGameView.swift
//  CountMeIn
//
//  Created by Jonathan Strid on 2026-08-21.
//

import SwiftUI
import SwiftData

struct CounterGameView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CounterPlayer.order) private var allPlayers: [CounterPlayer]
    
    let playerNames: [String]
    let existingGame: CounterGameState?
    
    @State private var hasInitialized = false
    @State private var currentGame: CounterGameState?
    
    private var players: [CounterPlayer] {
        if let game = currentGame {
            return game.players.sorted { $0.order < $1.order }
        }
        return []
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Player score cards
            if players.count == 2 {
                // 50/50 layout
                VStack(spacing: 2) {
                    playerCard(at: 0)
                    playerCard(at: 1)
                }
            } else if players.count == 3 {
                // 33/33/33 layout
                VStack(spacing: 2) {
                    playerCard(at: 0)
                    playerCard(at: 1)
                    playerCard(at: 2)
                }
            } else if players.count == 4 {
                // 25/25/25/25 layout
                VStack(spacing: 2) {
                    playerCard(at: 0)
                    playerCard(at: 1)
                    playerCard(at: 2)
                    playerCard(at: 3)
                }
            }
            
            Spacer()
                .frame(height: 20)
        }
        .navigationTitle("Counter")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .onAppear {
            initializeGame()
        }
    }
    
    @ViewBuilder
    private func playerCard(at index: Int) -> some View {
        if index < players.count {
            CounterPlayerCard(
                playerName: players[index].name,
                score: players[index].score,
                onScoreChange: { newScore in
                    players[index].score = newScore
                }
            )
        }
    }
    
    private func initializeGame() {
        guard !hasInitialized else { return }
        hasInitialized = true
        
        if let existing = existingGame {
            // Continue existing game
            currentGame = existing
        } else {
            // Create new game
            // First, deactivate any existing active counter games
            let descriptor = FetchDescriptor<CounterGameState>(
                predicate: #Predicate { $0.isActive == true }
            )
            if let existingGames = try? modelContext.fetch(descriptor) {
                existingGames.forEach { $0.isActive = false }
            }
            
            // Create new game state
            let newGame = CounterGameState()
            modelContext.insert(newGame)
            
            // Create players for the new game
            for (index, name) in playerNames.enumerated() {
                let player = CounterPlayer(name: name, score: 0, order: index)
                player.counterGame = newGame
                modelContext.insert(player)
            }
            
            currentGame = newGame
            try? modelContext.save()
        }
    }
}

#Preview {
    CounterGameView(playerNames: ["Alice", "Bob"], existingGame: nil)
        .modelContainer(for: [CounterPlayer.self, CounterGameState.self], inMemory: true)
}
