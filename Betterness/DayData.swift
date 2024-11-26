//
//  DayData.swift
//  Betterness
//
//  Created by Avi Sharma on 11/25/24.
//


import SwiftUI

struct DayData: Identifiable {
    let id = UUID()
    let date: Date
    var isVictory: Bool? // nil = no selection, true = victory, false = setback
    var journal: String
    var mood: Mood?

    enum Mood: String, CaseIterable {
        case happy, neutral, sad, excited
        
        var icon: String {
            switch self {
            case .happy: return "😊"
            case .neutral: return "😐"
            case .sad: return "😢"
            case .excited: return "😃"
            }
        }
    }
}
