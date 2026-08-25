//
//  DiceGamesMenuView.swift
//  CountMeIn
//
//  Created by Jonathan Strid on 2026-08-21.
//

import SwiftUI
import SwiftData

struct DiceGamesMenuView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<DiceGameState> { $0.isActive == true }) private var activeGames: [DiceGameState]
    
    @State private var navigateToSetup = false
    
    var hasActiveGame: Bool {
        !activeGames.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Icon and Title
            VStack(spacing: 16) {
                Image(systemName: "dice")
                    .font(.system(size: 80))
                    .foregroundStyle(.orange)
                
                Text("Dice Games")
                    .font(.largeTitle)
                    .bold()
            }
            
            Spacer()
            
            // Game options
            VStack(spacing: 16) {
                // 10 000 button
                Button {
                    navigateToSetup = true
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("10 000")
                                .font(.title2)
                                .bold()
                            
                            if hasActiveGame {
                                Text("Active game")
                                    .font(.caption)
                                    .foregroundStyle(.green)
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.gray)
                    }
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            
            Spacer()
            Spacer()
        }
        .navigationTitle("Dice Games")
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(isPresented: $navigateToSetup) {
            DicePlayerSetupView(activeGame: activeGames.first)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    NavigationStack {
        DiceGamesMenuView()
            .modelContainer(for: [DicePlayer.self, DiceGameState.self], inMemory: true)
    }
}
