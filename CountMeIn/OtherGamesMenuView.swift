//
//  OtherGamesMenuView.swift
//  CountMeIn
//
//  Created by Jonathan Strid on 2026-08-21.
//

import SwiftUI
import SwiftData

struct OtherGamesMenuView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<CounterGameState> { $0.isActive == true }) private var activeCounterGames: [CounterGameState]
    
    @State private var navigateToCounter = false
    
    var hasActiveCounterGame: Bool {
        !activeCounterGames.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Icon and Title
            VStack(spacing: 16) {
                Image(systemName: "gamecontroller")
                    .font(.system(size: 80))
                    .foregroundStyle(.blue)
                
                Text("Other Games")
                    .font(.largeTitle)
                    .bold()
            }
            
            Spacer()
            
            // Game options
            VStack(spacing: 16) {
                // Counter button
                Button {
                    navigateToCounter = true
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Counter")
                                .font(.title2)
                                .bold()
                            
                            if hasActiveCounterGame {
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
        .navigationTitle("Other Games")
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(isPresented: $navigateToCounter) {
            CounterPlayerSetupView(activeGame: activeCounterGames.first)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    NavigationStack {
        OtherGamesMenuView()
            .modelContainer(for: [CounterPlayer.self, CounterGameState.self], inMemory: true)
    }
}
