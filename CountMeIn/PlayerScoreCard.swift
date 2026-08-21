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
    
    var body: some View {
        VStack(spacing: 12) {
            Text(playerName)
                .font(.headline)
                .foregroundStyle(.white)
            
            Text("\(score)")
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(.white)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}

#Preview {
    PlayerScoreCard(playerName: "Player 1", score: 0)
        .frame(height: 200)
        .preferredColorScheme(.dark)
}
