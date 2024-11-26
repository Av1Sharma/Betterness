//
//  CalendarView.swift
//  Betterness
//
//  Created by Avi Sharma on 11/25/24.
//

import SwiftUICore
import SwiftUI

struct CalendarView: View {
    @State private var days: [DayData] = []
    @State private var currentMonth: Date = Date()
    @State private var selectedDay: DayData? = nil

    var body: some View {
        NavigationView {
            VStack {
                // Month and Year Heading
                Text(monthYearString(for: currentMonth))
                    .font(.largeTitle)
                    .padding()

                // Calendar Grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                    // Padding for the starting weekday
                    ForEach(0..<paddingDays(for: currentMonth), id: \.self) { _ in
                        Spacer()
                    }
                    
                    // Days of the month
                    ForEach(days) { day in
                        Button(action: {
                            selectedDay = day
                        }) {
                            ZStack {
                                Circle()
                                    .fill(dayColor(for: day))
                                    .frame(width: 40, height: 40)
                                
                                if let mood = day.mood {
                                    Text(mood.icon)
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
                .padding()
                .onAppear(perform: setupCalendar)
                .onChange(of: currentMonth, perform: { _ in setupCalendar() })

                // Navigation Buttons
                HStack {
                    Button("Previous Month") {
                        currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth)!
                    }
                    Spacer()
                    Button("Next Month") {
                        currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth)!
                    }
                }
                .padding()
            }
            .sheet(item: $selectedDay) { day in
                DayDetailView(day: day, onUpdate: updateDay)
            }
        }
    }

    private func setupCalendar() {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentMonth)!
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        
        days = range.map { day in
            DayData(date: calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)!, isVictory: nil, journal: "", mood: nil)
        }
    }

    private func paddingDays(for date: Date) -> Int {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        return calendar.component(.weekday, from: startOfMonth) - 1
    }

    private func monthYearString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }

    private func dayColor(for day: DayData) -> Color {
        guard let isVictory = day.isVictory else { return Color.gray }
        return isVictory ? Color.blue : Color.orange
    }

    private func updateDay(updatedDay: DayData) {
        if let index = days.firstIndex(where: { $0.id == updatedDay.id }) {
            days[index] = updatedDay
        }
    }
}
