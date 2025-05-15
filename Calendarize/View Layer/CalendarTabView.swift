//
//  CalendarTabView.swift
//  Calendarize
//
//  Created by David Wang on 2025/5/13.
//

import SwiftUI

struct CalendarTabView: View {
    @State private var model = CalendarViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                CalendarView(selectedDate: $model.selectedDate)
                    .frame(height: 400)
                    .padding(.horizontal)
                ForEach(0..<40) { _ in
                    Text("Test")
                }
            }
            .navigationTitle("\(model.selectedDate.formatted(date: .abbreviated, time: .omitted))")
        }
    }
    
    var calendarView: UICalendarView {
        let calendarView = UICalendarView()
        return calendarView
    }
}

#Preview {
    CalendarTabView()
}
