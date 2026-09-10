//
//  CounterPlayerCard.swift
//  CountMeIn
//
//  Created by Jonathan Strid on 2026-08-21.
//

import SwiftUI

struct CounterPlayerCard: View {
    let playerName: String
    let score: Int
    let onScoreChange: (Int) -> Void
    
    var body: some View {
        VStack(spacing: 16) {
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
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}

#Preview {
    VStack(spacing: 6) {
        CounterPlayerCard(
            playerName: "Player 1", 
            score: 15,
            onScoreChange: { _ in }
        )
        .frame(height: 200)
        
        CounterPlayerCard(
            playerName: "Player 2", 
            score: 23,
            onScoreChange: { _ in }
        )
        .frame(height: 200)
    }
    .preferredColorScheme(.dark)
}
