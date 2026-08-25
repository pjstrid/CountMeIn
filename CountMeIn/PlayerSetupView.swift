//
//  PlayerSetupView.swift
//  CountMeIn
//
//  Created by Jonathan Strid on 2026-08-21.
//

import SwiftUI
import SwiftData

struct PlayerSetupView: View {
    @Environment(\.modelContext) private var modelContext

    /// Passed down from DartGamesMenuView, which already holds the live
    /// query for this. Deliberately NOT re-queried here: two simultaneous
    /// `@Query`s with the identical predicate — one on this view, one on its
    /// still-mounted parent — send SwiftData's change observation into an
    /// infinite invalidation loop that pegs the CPU and freezes the app the
    /// moment this screen is pushed. One source of truth, passed down.
    let activeGame: GameState?

    @State private var playerCount: Int = 2
    @State private var playerNames: [String] = ["Player 1", "Player 2"]

    var hasActiveGame: Bool {
        activeGame != nil
    }

    var body: some View {
        VStack(spacing: 24) {
            VStack {
                Image(systemName: "scope")
                    .font(.system(size: 40))
                    .foregroundStyle(.green)

                Text("Killer Dart")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 40)
            }

            Spacer()

            // Continue game button (if there's an active game)
            if let activeGame {
                NavigationLink {
                    GameView(playerNames: [], existingGame: activeGame)
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
                GameView(playerNames: playerNames.prefix(playerCount).map { String($0) }, existingGame: nil)
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
        .navigationTitle("Killer")
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
        PlayerSetupView(activeGame: nil)
            .modelContainer(for: [Player.self, GameState.self], inMemory: true)
    }
}
