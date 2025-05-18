//
//  CalendarViewModel.swift
//  Calendarize
//
//  Created by David Wang on 2025/5/13.
//

import Foundation

@Observable
class CalendarViewModel {
    let calendarRepository: CalendarRepository
    
    var selectedDate: Date = .now {
        didSet {
            Task {
                try? await self.updateEvents(forDate: selectedDate)
            }
        }
    }
    
    private(set) var loadingEvents: Bool = false
    private(set) var events: [CalendarEventModel] = []
    
    init(calendarRepository: CalendarRepository) {
        self.calendarRepository = calendarRepository
    }
    
    private func updateEvents(forDate selectedDate: Date) async throws {
        loadingEvents = true
        try? await Task.sleep(for: .seconds(1))
        let startDate = Calendar.current.startOfDay(for: selectedDate)
        let endDate = startDate.addingTimeInterval(60 * 60 * 24)
        events = try await calendarRepository.fetchScheduledEvents(from: startDate, to: endDate)
        loadingEvents = false
    }
}
