//
//  CalendarTabView.swift
//  Calendarize
//
//  Created by David Wang on 2025/5/13.
//

import SwiftUI

struct CalendarTabView: View {
    @State var model: CalendarViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                CalendarView(selectedDate: $model.selectedDate)
                    .frame(height: 400)
                    .padding(.horizontal)
                
                if model.loadingEvents {
                    ProgressView()
                } else {
                    ForEach(0..<40) { _ in
                        Text("Test")
                    }
                }
            }
            .navigationTitle("\(model.selectedDate.formatted(date: .abbreviated, time: .omitted))")
        }
    }
}

#Preview {
    let repository = CalendarRepository()
    let viewModel = CalendarViewModel(calendarRepository: repository)
    CalendarTabView(model: viewModel)
}
