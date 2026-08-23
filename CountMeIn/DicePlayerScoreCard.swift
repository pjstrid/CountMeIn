//
//  DicePlayerScoreCard.swift
//  CountMeIn
//
//  Created by Jonathan Strid on 2026-08-21.
//

import SwiftUI

struct DicePlayerScoreCard: View {
    let playerName: String
    let savedScore: Int
    let roundScore: Int
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            
            VStack(spacing: 12) {
                // Player name
                Text(playerName)
                    .font(.headline)
                    .foregroundStyle(.white)
                    
                    
                HStack {
                    
                    Spacer()
                    
                    // Saved score
                    VStack(spacing: 4) {
                        Text("Saved")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                        Text("\(savedScore)")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    
                    Spacer()
                    
                    // Round score
                    VStack(spacing: 4) {
                        Text("Round")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                        Text("\(roundScore)")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(roundScore > 0 ? .green : .white.opacity(0.5))
                    }
                    
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 3)
            )
            .padding(8)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 6) {
        DicePlayerScoreCard(
            playerName: "Player 1",
            savedScore: 2500,
            roundScore: 350,
            isSelected: true,
            onSelect: {}
        )
        .frame(height: 150)
        
        DicePlayerScoreCard(
            playerName: "Player 2",
            savedScore: 1800,
            roundScore: 0,
            isSelected: false,
            onSelect: {}
        )
        .frame(height: 150)
    }
    .preferredColorScheme(.dark)
}
