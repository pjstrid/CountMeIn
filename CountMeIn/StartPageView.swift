//
//  StartPageView.swift
//  CountMeIn
//
//  Created by Jonathan Strid on 2026-08-23.
//

import SwiftUI

struct StartPageView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()
                // App Icon and Title
                VStack(spacing: 16) {
                    Image(systemName: "list.number")
                        .font(.system(size: 80))
                        .foregroundStyle(.brown, .tertiary)
                    
                    VStack(spacing: 4) {
                        Text("CountMeIn")
                            .font(.largeTitle)
                            .bold()
                    }
                }
                .padding(.bottom, 20)
                
                Spacer()
                
                // Game options list
                VStack(spacing: 16) {
                    
                    Text("Games")
                        .font(.title2)
                        .foregroundStyle(.gray)
                        .padding(.bottom, 20)
                    
                    NavigationLink(destination: PlayerSetupView()) {
                        GameOptionRow(
                            icon: "scope",
                            title: "Dart Games",
                            color: .green
                        )
                    }
                    
                    NavigationLink(destination: DiceGamesPlaceholder()) {
                        GameOptionRow(
                            icon: "dice",
                            title: "Dice Games",
                            color: .orange
                        )
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                Spacer()
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct GameOptionRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundStyle(color)
                .frame(width: 50)
            
            Text(title)
                .font(.title2)
                .bold()
                .foregroundStyle(.white)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}

struct DiceGamesPlaceholder: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "dice")
                .font(.system(size: 80))
                .foregroundStyle(.orange)
            
            Text("Dice Games")
                .font(.largeTitle)
                .bold()
            
            Text("Coming Soon!")
                .font(.title3)
                .foregroundStyle(.gray)
        }
        .navigationTitle("Dice Games")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    StartPageView()
}
