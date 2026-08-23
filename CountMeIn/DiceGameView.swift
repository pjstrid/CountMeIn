//
//  DiceGameView.swift
//  CountMeIn
//
//  Created by Jonathan Strid on 2026-08-21.
//

import SwiftUI
import SwiftData

struct DiceGameView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DicePlayer.order) private var allPlayers: [DicePlayer]
    
    let playerNames: [String]
    let existingGame: DiceGameState?
    
    @State private var hasInitialized = false
    @State private var currentGame: DiceGameState?
    @State private var selectedPlayerIndex: Int?
    
    private var players: [DicePlayer] {
        if let game = currentGame {
            return game.players.sorted { $0.order < $1.order }
        }
        return []
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Player score cards
            ScrollView {
                VStack {
                    ForEach(0..<players.count, id: \.self) { index in
                        playerCard(at: index)
                    }
                }
            }
            
            // Bottom control panel
            VStack(spacing: 12) {
                // Point buttons
                HStack(spacing: 12) {
                    pointButton(value: 50)
                    pointButton(value: 100)
                    pointButton(value: 500)
                }
                .padding(.horizontal)
                
                // Save button
                Button(action: saveRoundScore) {
                    Text("Save")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedPlayerIndex != nil && players.indices.contains(selectedPlayerIndex!) && players[selectedPlayerIndex!].roundScore > 0 ? Color.green : Color.gray.opacity(0.5))
                        .cornerRadius(12)
                }
                .disabled(selectedPlayerIndex == nil || !players.indices.contains(selectedPlayerIndex!) || players[selectedPlayerIndex!].roundScore == 0)
                .padding(.horizontal)
            }
            .padding(.vertical, 16)
            .background(Color.black.opacity(0.5))
        }
        .navigationTitle("10 000")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .onAppear {
            initializeGame()
        }
    }
    
    @ViewBuilder
    private func playerCard(at index: Int) -> some View {
        if index < players.count {
            DicePlayerScoreCard(
                playerName: players[index].name,
                savedScore: players[index].savedScore,
                roundScore: players[index].roundScore,
                isSelected: selectedPlayerIndex == index,
                onSelect: {
                    selectedPlayerIndex = index
                }
            )
            .frame(height: 150)
        }
    }
    
    @ViewBuilder
    private func pointButton(value: Int) -> some View {
        Button(action: {
            addPoints(value)
        }) {
            Text("+\(value)")
                .font(.title2)
                .bold()
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
        }
        .disabled(selectedPlayerIndex == nil)
    }
    
    private func addPoints(_ points: Int) {
        guard let index = selectedPlayerIndex, players.indices.contains(index) else { return }
        players[index].roundScore += points
    }
    
    private func saveRoundScore() {
        guard let index = selectedPlayerIndex, players.indices.contains(index) else { return }
        
        let player = players[index]
        player.savedScore += player.roundScore
        player.roundScore = 0
        
        // Deselect player after saving
        selectedPlayerIndex = nil
        
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
            // First, deactivate any existing active dice games
            let descriptor = FetchDescriptor<DiceGameState>(
                predicate: #Predicate { $0.isActive == true }
            )
            if let existingGames = try? modelContext.fetch(descriptor) {
                existingGames.forEach { $0.isActive = false }
            }
            
            // Create new game state
            let newGame = DiceGameState()
            modelContext.insert(newGame)
            
            // Create players for the new game
            for (index, name) in playerNames.enumerated() {
                let player = DicePlayer(name: name, savedScore: 0, roundScore: 0, order: index)
                player.diceGame = newGame
                modelContext.insert(player)
            }
            
            currentGame = newGame
            try? modelContext.save()
        }
    }
}

#Preview {
    DiceGameView(playerNames: ["Berit", "Bertil", "Birger", "Börje"], existingGame: nil)
        .modelContainer(for: [DicePlayer.self, DiceGameState.self], inMemory: true)
}
