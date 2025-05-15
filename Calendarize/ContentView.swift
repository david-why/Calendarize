//
//  ContentView.swift
//  Calendarize
//
//  Created by David Wang on 2025/5/13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Calendar", systemImage: "calendar") {
                CalendarTabView()
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
}
