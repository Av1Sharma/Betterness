//
//  DayDetailView.swift
//  Betterness
//
//  Created by Avi Sharma on 11/25/24.
//

import SwiftUICore
import SwiftUI


struct DayDetailView: View {
    @State var day: DayData
    var onUpdate: (DayData) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            // Victory/Setback Buttons
            HStack {
                Button("Victory") {
                    day.isVictory = true
                    saveAndDismiss()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("Setback") {
                    day.isVictory = false
                    saveAndDismiss()
                }
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            // Journal Entry
            TextField("Journal", text: $day.journal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Mood Selector
            HStack {
                ForEach(DayData.Mood.allCases, id: \.self) { mood in
                    Button(action: {
                        day.mood = mood
                        saveAndDismiss()
                    }) {
                        Text(mood.icon)
                            .font(.largeTitle)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Details for \(formattedDate(day.date))")
    }
    
    private func saveAndDismiss() {
        onUpdate(day)
        dismiss()
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
