//
//  CalendarEventModel.swift
//  Calendarize
//
//  Created by David Wang on 2025/5/14.
//

import Foundation

struct CalendarEventModel: Identifiable {
    let id: String
    var title: String
    var startDate: Date
    var endDate: Date
    let isScheduledTask: Bool
    let originalReminderIdentifier: String? // Optional, to link back to your reminder
}
