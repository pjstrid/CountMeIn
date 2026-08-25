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
    @Environment(\.dismiss) private var dismiss

    let playerNames: [String]
    let existingGame: DiceGameState?

    /// First player to reach (or pass) this score wins.
    private static let winningScore = 10000

    @State private var hasInitialized = false
    @State private var currentGame: DiceGameState?
    @State private var selectedPlayerIndex: Int?
    @State private var showEditScore = false
    @State private var editingPlayerIndex: Int?
    @State private var showWinner = false
    @State private var winnerName = ""

    private var players: [DicePlayer] {
        if let game = currentGame {
            return game.players.sorted { $0.order < $1.order }
        }
        return []
    }

    var body: some View {
        ZStack {
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

                    HStack {
                        // Save button
                        Button(action: saveRoundScore) {
                            Text("Save")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(selectedPlayerIndex != nil && players.indices.contains(selectedPlayerIndex!) && players[selectedPlayerIndex!].roundScore > 0 ? Color.blue.opacity(0.8) : Color.gray.opacity(0.5))
                                .cornerRadius(12)
                        }
                        .disabled(selectedPlayerIndex == nil || !players.indices.contains(selectedPlayerIndex!) || players[selectedPlayerIndex!].roundScore == 0)
                        .padding(.horizontal)

                        // Clear button
                        Button(action: clearRoundScore) {
                            Text("Clear")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(selectedPlayerIndex != nil && players.indices.contains(selectedPlayerIndex!) && players[selectedPlayerIndex!].roundScore > 0 ? Color.red.opacity(0.8) : Color.gray.opacity(0.5))
                                .cornerRadius(12)
                        }
                        .disabled(selectedPlayerIndex == nil || !players.indices.contains(selectedPlayerIndex!) || players[selectedPlayerIndex!].roundScore == 0)
                        .padding(.horizontal)
                    }
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
            .sheet(isPresented: $showEditScore) {
                if let index = editingPlayerIndex, players.indices.contains(index) {
                    EditScoreView(
                        playerName: players[index].name,
                        score: Binding(
                            get: { players[index].savedScore },
                            set: { players[index].savedScore = $0 }
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
                        finishGame()
                        dismiss()
                    }
                )
            }
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
                },
                onEditScore: {
                    editingPlayerIndex = index
                    showEditScore = true
                },
                onUndoLastSave: {
                    undoLastSave(for: index)
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
                .background(Color.green.opacity(0.5))
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
        let amountToSave = player.roundScore
        
        // Save the amount for potential undo
        player.lastSavedAmount = amountToSave
        
        // Add to saved score and clear round score
        player.savedScore += amountToSave
        player.roundScore = 0
        
        // Deselect player after saving
        selectedPlayerIndex = nil

        try? modelContext.save()

        checkForWinner(player)
    }

    private func clearRoundScore() {
        guard let index = selectedPlayerIndex, players.indices.contains(index) else { return }
        
        let player = players[index]
    
        // Clears the round score
        player.roundScore = 0
        
        // Deselect player after saving
        selectedPlayerIndex = nil
    }
    
    private func undoLastSave(for index: Int) {
        guard players.indices.contains(index) else { return }
        
        let player = players[index]
        
        // Only undo if there was a previous save
        guard player.lastSavedAmount > 0 else { return }
        
        // Subtract the last saved amount from the saved score
        player.savedScore = max(0, player.savedScore - player.lastSavedAmount)
        
        // Add it back to the round score
        player.roundScore += player.lastSavedAmount
        
        // Clear the last saved amount
        player.lastSavedAmount = 0
        
        try? modelContext.save()
    }
    
    private func checkForWinner(_ player: DicePlayer) {
        guard player.savedScore >= Self.winningScore else { return }
        winnerName = player.name
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showWinner = true
        }
    }

    private func startNewGame() {
        // Reset all players back to a fresh start
        players.forEach { player in
            player.savedScore = 0
            player.roundScore = 0
            player.lastSavedAmount = 0
        }

        showWinner = false
        selectedPlayerIndex = nil
        try? modelContext.save()
    }

    /// Called when the winner screen is dismissed back to the menu. A finished
    /// game is never resumable, so remove it (and its players, via cascade
    /// delete) instead of leaving it marked active forever.
    private func finishGame() {
        guard let game = currentGame else { return }
        modelContext.delete(game)
        currentGame = nil
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
            // First, remove any leftover active dice games (e.g. abandoned
            // mid-game) so old players don't pile up in the store forever.
            let descriptor = FetchDescriptor<DiceGameState>(
                predicate: #Predicate { $0.isActive == true }
            )
            if let existingGames = try? modelContext.fetch(descriptor) {
                existingGames.forEach { modelContext.delete($0) }
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
