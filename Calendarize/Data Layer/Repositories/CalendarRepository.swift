//
//  CalendarRepository.swift
//  Calendarize
//
//  Created by David Wang on 2025/5/14.
//

import Foundation
import EventKit

protocol CalendarRepositoryProtocol {
    func fetchScheduledEvents(from startDate: Date, to endDate: Date) async throws -> [CalendarEventModel]
}

@Observable
class CalendarRepository: CalendarRepositoryProtocol {
    private let eventStore = EKEventStore()
    private let calendarTitle = "Calendarize"
    
    func fetchScheduledEvents(from startDate: Date, to endDate: Date) async throws -> [CalendarEventModel] {
        guard let taskCalendar = getTaskCalendar() else { return [] }
        return try await fetchEvents(from: startDate, to: endDate, in: [taskCalendar])
    }
    
    private func fetchEvents(from startDate: Date, to endDate: Date, in calendars: [EKCalendar]) async throws -> [CalendarEventModel] {
        try await requestAccessIfRequired()
        
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
        let ekEvents = eventStore.events(matching: predicate)
        return ekEvents.map { ekEvent in
            let reminderIdentifier = try? CoreDataManager.shared.fetchMapping(forCalendarEventIdentifier: ekEvent.eventIdentifier)?.reminderIdentifier
            return CalendarEventModel(
                id: ekEvent.eventIdentifier,
                title: ekEvent.title,
                startDate: ekEvent.startDate,
                endDate: ekEvent.endDate,
                isScheduledTask: ekEvent.calendar.title == calendarTitle,
                originalReminderIdentifier: reminderIdentifier
            )
        }
    }
    
    private func requestAccessIfRequired() async throws {
        try await eventStore.requestFullAccessToEvents()
    }
    
    private func getTaskCalendar() -> EKCalendar? {
        let calendars = eventStore.calendars(for: .event)
        return calendars.first { $0.title == calendarTitle }
    }
}
