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
    @Query(sort: \Player.order) private var players: [Player]
    
    let playerNames: [String]
    @State private var hasInitialized = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Killer Dart")
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                }
                .padding()
                .background(Color.black.opacity(0.3))
                
                // Player score cards
                if playerNames.count == 2 {
                    // 50/50 layout
                    VStack(spacing: 2) {
                        playerCard(at: 0)
                        playerCard(at: 1)
                    }
                } else if playerNames.count == 3 {
                    // 33/33/33 layout
                    VStack(spacing: 2) {
                        playerCard(at: 0)
                        playerCard(at: 1)
                        playerCard(at: 2)
                    }
                } else if playerNames.count == 4 {
                    // 25/25/25/25 layout
                    VStack(spacing: 2) {
                        playerCard(at: 0)
                        playerCard(at: 1)
                        playerCard(at: 2)
                        playerCard(at: 3)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .onAppear {
            initializePlayers()
        }
    }
    
    @ViewBuilder
    private func playerCard(at index: Int) -> some View {
        if index < players.count {
            PlayerScoreCard(
                playerName: players[index].name,
                score: players[index].score
            )
        }
    }
    
    private func initializePlayers() {
        guard !hasInitialized else { return }
        hasInitialized = true
        
        // Clear existing players
        players.forEach { modelContext.delete($0) }
        
        // Add new players
        for (index, name) in playerNames.enumerated() {
            let player = Player(name: name, score: 0, order: index)
            modelContext.insert(player)
        }
        
        try? modelContext.save()
    }
}

#Preview {
    GameView(playerNames: ["Berit", "Bertil"])
        .modelContainer(for: Player.self, inMemory: true)
}
