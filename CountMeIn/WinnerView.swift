//
//  WinnerView.swift
//  CountMeIn
//
//  Created by Jonathan Strid on 2026-08-21.
//

import SwiftUI

struct WinnerView: View {
    let winnerName: String
    let onNewGame: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            // Winner card
            VStack(spacing: 24) {
                // Trophy icon
                Image(systemName: "trophy.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.yellow)
                
                // Winner announcement
                VStack(spacing: 8) {
                    Text("Winner!")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(.white)
                    
                    Text(winnerName)
                        .font(.title)
                        .foregroundStyle(.green)
                        .bold()
                }
                
                // Buttons
                VStack(spacing: 12) {
                    Button(action: onNewGame) {
                        Text("New Game")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                    }
                    
                    Button(action: onDismiss) {
                        Text("Back to Menu")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                }
                .padding(.top, 8)
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.95))
            )
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    WinnerView(
        winnerName: "Player 1",
        onNewGame: {},
        onDismiss: {}
    )
}
