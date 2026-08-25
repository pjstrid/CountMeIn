//
//  EditScoreView.swift
//  CountMeIn
//
//  Created by Jonathan Strid on 2026-08-21.
//

import SwiftUI

struct EditScoreView: View {
    let playerName: String
    @Binding var score: Int
    @Environment(\.dismiss) private var dismiss
    
    @State private var scoreText: String
    @FocusState private var isTextFieldFocused: Bool
    
    init(playerName: String, score: Binding<Int>) {
        self.playerName = playerName
        self._score = score
        self._scoreText = State(initialValue: "\(score.wrappedValue)")
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Edit Score")
                    .font(.title2)
                    .bold()
                    .padding(.top, 20)
                
                Text(playerName)
                    .font(.headline)
                    .foregroundStyle(.gray)
                
                Spacer()
                
                // Score input
                VStack(spacing: 12) {
                    Text("Saved Score")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    TextField("Score", text: $scoreText)
                        .font(.system(size: 48, weight: .bold))
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .focused($isTextFieldFocused)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
                
                // Save button
                Button(action: saveScore) {
                    Text("Save")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                isTextFieldFocused = true
            }
        }
        .preferredColorScheme(.dark)
        .presentationDetents([.medium])
    }
    
    private func saveScore() {
        if let newScore = Int(scoreText) {
            score = max(0, newScore) // Ensure score is not negative
        }
        dismiss()
    }
}

#Preview {
    EditScoreView(playerName: "Player 1", score: .constant(2500))
}
