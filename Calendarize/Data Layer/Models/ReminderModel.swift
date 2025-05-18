//
//  ReminderModel.swift
//  Calendarize
//
//  Created by David Wang on 2025/5/15.
//

import Foundation

struct ReminderModel: Identifiable {
    let id: String
    var title: String
    var dueDate: Date?
    var priority: Int = 0
    var isCompleted: Bool
    var notes: String?
    
    var estimatedDuration: Int? // minutes
    
    enum SchedulingStatus: String, Codable {
        case notScheduled
        case partiallyScheduled
        case fullyScheduled
        case issues
    }
}
