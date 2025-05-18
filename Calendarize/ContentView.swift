//
//  ContentView.swift
//  Calendarize
//
//  Created by David Wang on 2025/5/13.
//

import SwiftUI

struct ContentView: View {
    @Environment(CalendarRepository.self) var calendarRepository
    
    var body: some View {
        TabView {
            Tab("Calendar", systemImage: "calendar") {
                CalendarTabView(model: CalendarViewModel(calendarRepository: calendarRepository))
            }
            Tab("Reminders", systemImage: "checklist") {
                RemindersTabView()
            }
            Tab("Settings", systemImage: "gear") {
                SettingsTabView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(CalendarRepository())
}
