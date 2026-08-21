//
//  NumberPickerView.swift
//  CountMeIn
//
//  Created by Jonathan Strid on 2026-08-21.
//

import SwiftUI

struct NumberPickerView: View {
    let playerName: String
    @Binding var selectedNumber: Int?
    @Environment(\.dismiss) private var dismiss
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text("Select Number")
                        .font(.title2)
                        .bold()
                    
                    Text(playerName)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                .padding(.top, 20)
                .padding(.bottom, 24)
                
                // Number grid
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(1...20, id: \.self) { number in
                            Button(action: {
                                selectedNumber = number
                                dismiss()
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(selectedNumber == number ? Color.blue : Color.gray.opacity(0.3))
                                        .frame(width: 60, height: 60)
                                    
                                    Text("\(number)")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundStyle(.white)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .background(Color.black)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
                
                if selectedNumber != nil {
                    ToolbarItem(placement: .destructiveAction) {
                        Button("Clear") {
                            selectedNumber = nil
                            dismiss()
                        }
                        .foregroundStyle(.red)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    NumberPickerView(playerName: "Player 1", selectedNumber: .constant(7))
}
