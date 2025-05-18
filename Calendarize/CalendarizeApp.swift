//
//  CalendarizeApp.swift
//  Calendarize
//
//  Created by David Wang on 2025/5/13.
//

import SwiftUI

@main
struct CalendarizeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(CalendarRepository())
        }
    }
}
