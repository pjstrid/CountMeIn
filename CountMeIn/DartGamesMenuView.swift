//
//  DartGamesMenuView.swift
//  CountMeIn
//
//  Created by Jonathan Strid on 2026-08-21.
//

import SwiftUI
import SwiftData

struct DartGamesMenuView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<GameState> { $0.isActive == true }) private var activeGames: [GameState]
    
    @State private var navigateToSetup = false
    
    var hasActiveGame: Bool {
        !activeGames.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Icon and Title
            VStack(spacing: 16) {
                Image(systemName: "scope")
                    .font(.system(size: 80))
                    .foregroundStyle(.green)
                
                Text("Dart Games")
                    .font(.largeTitle)
                    .bold()
            }
            
            Spacer()
            
            // Game options
            VStack(spacing: 16) {
                // Killer Dart button
                Button {
                    navigateToSetup = true
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Killer")
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
        .navigationTitle("Dart Games")
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(isPresented: $navigateToSetup) {
            PlayerSetupView(activeGame: activeGames.first)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    NavigationStack {
        DartGamesMenuView()
            .modelContainer(for: [Player.self, GameState.self], inMemory: true)
    }
}
