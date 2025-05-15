//
//  CalendarEventModel.swift
//  Calendarize
//
//  Created by David Wang on 2025/5/14.
//

import Foundation

struct CalendarEventModel {
    let identifier: String
    let title: String
    let startDate: Date
    let endDate: Date
    let isScheduledTask: Bool
    let originalReminderIdentifier: String? // Optional, to link back to your reminder
}
