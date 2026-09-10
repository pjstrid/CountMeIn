//
//  CounterPlayerSetupView.swift
//  CountMeIn
//
//  Created by Jonathan Strid on 2026-08-21.
//

import SwiftUI
import SwiftData

struct CounterPlayerSetupView: View {
    @Environment(\.modelContext) private var modelContext
    
    // Passed down from menu to avoid duplicate queries
    let activeGame: CounterGameState?
    
    @State private var playerCount: Int = 2
    @State private var playerNames: [String] = ["Player 1", "Player 2"]
    
    var body: some View {
        VStack(spacing: 24) {
            VStack {
                Image(systemName: "number")
                    .font(.system(size: 40))
                    .foregroundStyle(.blue)
                
                Text("Counter")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 40)
            }
            
            Spacer()
            
            // Continue game button (if there's an active game)
            if let activeGame {
                NavigationLink {
                    CounterGameView(playerNames: [], existingGame: activeGame)
                } label: {
                    Text("Continue Game")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Text("or start a new game")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            
            // Player count selector
            VStack(spacing: 16) {
                Text("Number of Players")
                    .font(.headline)
                
                Picker("Players", selection: $playerCount) {
                    ForEach(2...4, id: \.self) { count in
                        Text("\(count) Players").tag(count)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: playerCount) { oldValue, newValue in
                    updatePlayerNames(newValue)
                }
            }
            .padding(.horizontal)
            
            // Player name inputs
            VStack(spacing: 12) {
                ForEach(Array(playerNames.prefix(playerCount).enumerated()), id: \.offset) { index, _ in
                    TextField("Player \(index + 1)", text: Binding(
                        get: { playerNames.indices.contains(index) ? playerNames[index] : "" },
                        set: { 
                            if playerNames.indices.contains(index) {
                                playerNames[index] = $0
                            }
                        }
                    ))
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                }
            }
            
            Spacer()
            
            // Start new game button
            NavigationLink {
                CounterGameView(playerNames: playerNames.prefix(playerCount).map { String($0) }, existingGame: nil)
            } label: {
                Text("Start New Game")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .navigationTitle("Counter")
        .navigationBarTitleDisplayMode(.large)
        .preferredColorScheme(.dark)
    }
    
    private func updatePlayerNames(_ count: Int) {
        // Ensure array is always the right size
        while playerNames.count < count {
            playerNames.append("Player \(playerNames.count + 1)")
        }
        while playerNames.count > count {
            playerNames.removeLast()
        }
    }
}

#Preview {
    NavigationStack {
        CounterPlayerSetupView(activeGame: nil)
            .modelContainer(for: [CounterPlayer.self, CounterGameState.self], inMemory: true)
    }
}
