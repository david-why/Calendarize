//
//  ReminderRepository.swift
//  Calendarize
//
//  Created by David Wang on 2025/5/15.
//

import Foundation
import EventKit
import RegexBuilder

protocol ReminderRepositoryProtocol {
    func fetchReminders() async throws -> [ReminderModel]
}

class ReminderRepository : ReminderRepositoryProtocol {
    private let eventStore = EKEventStore()
    let reminderListTitle = "Calendarize" // FIXME: UNUSED
    
    func fetchReminders() async throws -> [ReminderModel] {
        try await requestAccessIfRequired()
        
        guard let calendar = getReminderList() else {
            return []
        }
        let predicate = eventStore.predicateForIncompleteReminders(withDueDateStarting: nil, ending: nil, calendars: [calendar])
        
        return try await withCheckedThrowingContinuation { continuation in
            eventStore.fetchReminders(matching: predicate) { reminders in
                guard let reminders else {
                    continuation.resume(throwing: ReminderError.fetchFailed)
                    return
                }
                let models = reminders.map { ekReminder in
                    var estimatedDuration: Int? = nil
                    if let notes = ekReminder.notes {
                        estimatedDuration = self.parseEstimatedDuration(from: notes)
                    }

                    return ReminderModel(
                        id: ekReminder.calendarItemIdentifier,
                        title: ekReminder.title,
                        dueDate: ekReminder.dueDateComponents?.date,
                        priority: ekReminder.priority,
                        isCompleted: ekReminder.isCompleted,
                        notes: ekReminder.notes,
                        estimatedDuration: estimatedDuration
                    )
                }
            }
        }
    }
    
    private func parseEstimatedDuration(from notes: String) -> Int? {
        // Regular expression to find #duration:XXmin or #duration:YYh
        let minuteRegex = Regex {
            "#duration:"
            Capture {
                OneOrMore(.digit)
            } transform: { Int($0) }
            "min"
        }
        let hourRegex = Regex {
            "#duration:"
            Capture {
                OneOrMore(.digit)
            } transform: { Int($0) }
            "h"
        }

        // Search for minutes
        if let match = try? minuteRegex.firstMatch(in: notes) {
            if let minutes = match.output.1 {
                return minutes
            }
        }

        // Search for hours if no minutes found
        if let match = try? hourRegex.firstMatch(in: notes) {
            if let hours = match.output.1 {
                return hours * 60
            }
        }

        return nil // No duration tag found
    }

    private func requestAccessIfRequired() async throws {
        try await eventStore.requestFullAccessToReminders()
    }
    
    private func getReminderList() -> EKCalendar? {
        eventStore.defaultCalendarForNewReminders()
    }
}

enum ReminderError: Error {
    case fetchFailed
}
