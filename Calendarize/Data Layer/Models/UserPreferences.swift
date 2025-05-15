//
//  UserPreferences.swift
//  Calendarize
//
//  Created by David Wang on 2025/5/14.
//

import Foundation

struct SchedulingHours: Codable {
    let daysOfWeek: [Int]
    let startHour: Int
    let endHour: Int
}

struct UserPreferences: Codable {
    // MARK: - Core Scheduling Preferences
    
    /// Default estimated duration for new reminders (in minutes, e.g., 30)
    var defaultTaskDuration: Int = 30

    /// How aggressively to fill available time (e.g., 0.8 means try to fill 80%)
    var schedulingDensity: Double = 0.8

    /// Preferred buffer time (in minutes) between scheduled tasks (e.g., 5)
    var bufferTimeBetweenTasks: Int = 5
    
    /// Which calendars should be checked when considering 

    // MARK: - Weekly Scheduling Time Ranges

    /// Array to store preferred scheduling time ranges for each day of the week
    var preferredSchedulingHours: [SchedulingHours] = [
        .init(daysOfWeek: [1, 2, 3, 4, 5], startHour: 9, endHour: 12),
        .init(daysOfWeek: [1, 2, 3, 4, 5], startHour: 14, endHour: 17),
        .init(daysOfWeek: [6, 7], startHour: 10, endHour: 16)
    ];

    // MARK: - Initialization with Default Values
    init() {}
}
