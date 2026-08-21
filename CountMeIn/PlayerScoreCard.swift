//
//  PlayerScoreCard.swift
//  CountMeIn
//
//  Created by Jonathan Strid on 2026-08-21.
//

import SwiftUI

struct PlayerScoreCard: View {
    let playerName: String
    let score: Int
    let selectedNumber: Int?
    let onNumberSelect: () -> Void
    let onScoreChange: (Int) -> Void
    
    var isEliminated: Bool {
        score == 0
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 8) {
                
                // Player name
                Text(playerName)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.top, 8)
                
                Spacer()
                
                // Score display with +/- buttons
                HStack(spacing: 24) {
                    // Minus button
                    Button(action: {
                        onScoreChange(score - 1)
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.red)
                    }
                    .disabled(isEliminated)
                    
                    // Score
                    Text("\(score)")
                        .font(.system(size: 56, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(minWidth: 80)
                    
                    // Plus button
                    Button(action: {
                        onScoreChange(score + 1)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.green)
                    }
                    .disabled(isEliminated)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.vertical, 8)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
            .opacity(isEliminated ? 0.4 : 1.0)
            .blur(radius: isEliminated ? 2 : 0)
            
            // Number selection button (top-left corner)
            Button(action: onNumberSelect) {
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 50, height: 50)
                    
                    if let number = selectedNumber {
                        Text("\(number)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.white)
                    } else {
                        Text("-")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                }
            }
            .padding(12)
            .disabled(isEliminated)
            .opacity(isEliminated ? 0.4 : 1.0)
            
            // Killer badge (top-right corner, only show if score is 5)
            if score == 5 {
                VStack {
                    HStack {
                        Spacer()
                        
                        Text("Killer")
                            .font(.headline)
                            .foregroundStyle(.red)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(
                                Color.black
                                    .cornerRadius(8)
                            )
                    }
                    
                    Spacer()
                }
                .padding(12)
            }
            
            // Eliminated overlay
            if isEliminated {
                VStack {
                    
                    Spacer()
                    
                    HStack {
                        
                        Spacer()
                        
                        Text("ELIMINATED")
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.red)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Color.black.opacity(0.7)
                                    .cornerRadius(8)
                            )
                        
                        Spacer()
                        
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 6) {
        PlayerScoreCard(
            playerName: "Player 1", 
            score: 5,
            selectedNumber: 7,
            onNumberSelect: {},
            onScoreChange: { _ in }
        )
        .frame(height: 200)
        
        PlayerScoreCard(
            playerName: "Player 2", 
            score: 0,
            selectedNumber: 10,
            onNumberSelect: {},
            onScoreChange: { _ in }
        )
        .frame(height: 200)
    }
    .preferredColorScheme(.dark)
}
