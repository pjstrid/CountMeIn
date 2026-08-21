//
//  GameView.swift
//  CountMeIn
//
//  Created by Jonathan Strid on 2026-08-21.
//

import SwiftUI
import SwiftData

struct GameView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Player.order) private var allPlayers: [Player]
    
    let playerNames: [String]
    let existingGame: GameState?
    
    @State private var hasInitialized = false
    @State private var showingNumberPicker = false
    @State private var selectedPlayerIndex: Int?
    @State private var currentGame: GameState?
    @State private var showWinner = false
    @State private var winnerName = ""
    
    private var players: [Player] {
        if let game = currentGame {
            return game.players.sorted { $0.order < $1.order }
        }
        return []
    }
    
    private var activePlayers: [Player] {
        players.filter { $0.score > 0 }
    }
    
    private var hasWinner: Bool {
        activePlayers.count == 1 && players.count > 1
    }
    
    var body: some View {
        ZStack {
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
            .navigationTitle("Killer Dart")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
            .onAppear {
                initializeGame()
            }
            .sheet(isPresented: $showingNumberPicker) {
                if let index = selectedPlayerIndex, index < players.count {
                    NumberPickerView(
                        playerName: players[index].name,
                        selectedNumber: Binding(
                            get: { players[index].selectedNumber },
                            set: { players[index].selectedNumber = $0 }
                        )
                    )
                }
            }
            
            // Winner overlay
            if showWinner {
                WinnerView(
                    winnerName: winnerName,
                    onNewGame: {
                        startNewGame()
                    },
                    onDismiss: {
                        dismiss()
                    }
                )
            }
        }
    }
    
    @ViewBuilder
    private func playerCard(at index: Int) -> some View {
        if index < players.count {
            PlayerScoreCard(
                playerName: players[index].name,
                score: players[index].score,
                selectedNumber: players[index].selectedNumber,
                onNumberSelect: {
                    selectedPlayerIndex = index
                    showingNumberPicker = true
                },
                onScoreChange: { newScore in
                    // Limit score between 0 and 5
                    let clampedScore = max(0, min(5, newScore))
                    players[index].score = clampedScore
                    
                    // Check for winner
                    checkForWinner()
                }
            )
        }
    }
    
    private func checkForWinner() {
        if hasWinner, let winner = activePlayers.first {
            winnerName = winner.name
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showWinner = true
            }
        }
    }
    
    private func startNewGame() {
        // Reset all players to score 1
        players.forEach { player in
            player.score = 1
            player.selectedNumber = nil
        }
        
        showWinner = false
        try? modelContext.save()
    }
    
    private func initializeGame() {
        guard !hasInitialized else { return }
        hasInitialized = true
        
        if let existing = existingGame {
            // Continue existing game
            currentGame = existing
        } else {
            // Create new game
            // First, deactivate any existing active games
            let descriptor = FetchDescriptor<GameState>(
                predicate: #Predicate { $0.isActive == true }
            )
            if let existingGames = try? modelContext.fetch(descriptor) {
                existingGames.forEach { $0.isActive = false }
            }
            
            // Create new game state
            let newGame = GameState()
            modelContext.insert(newGame)
            
            // Create players for the new game
            for (index, name) in playerNames.enumerated() {
                let player = Player(name: name, score: 1, order: index)
                player.game = newGame
                modelContext.insert(player)
            }
            
            currentGame = newGame
            try? modelContext.save()
        }
    }
}

#Preview {
    GameView(playerNames: ["Berit", "Bertil"], existingGame: nil)
        .modelContainer(for: [Player.self, GameState.self], inMemory: true)
}
