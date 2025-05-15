//
//  CalendarView.swift
//  Calendarize
//
//  Created by David Wang on 2025/5/13.
//

import SwiftUI

struct CalendarView: UIViewRepresentable {
    @Binding var selectedDate: Date
    var decorationForDate: ((DateComponents) -> AnyView?)? = nil
    
    private let selectable: Bool
    
    init() {
        self._selectedDate = .constant(.now)
        self.decorationForDate = nil
        self.selectable = false
    }
    
    init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
        self.decorationForDate = nil
        self.selectable = true
    }
    
    init<Decoration: View>(@ViewBuilder decorationForDate: @escaping (DateComponents) -> Decoration) {
        self._selectedDate = .constant(.now)
        self.decorationForDate = { components in
            AnyView(decorationForDate(components))
        }
        self.selectable = false
    }
    
    init<Decoration: View>(selectedDate: Binding<Date>, @ViewBuilder decorationForDate: @escaping (DateComponents) -> Decoration) {
        self._selectedDate = selectedDate
        self.decorationForDate = { components in
            AnyView(decorationForDate(components))
        }
        self.selectable = true
    }
    
    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView(frame: .zero)
        calendarView.delegate = context.coordinator
        calendarView.wantsDateDecorations = self.decorationForDate != nil
        calendarView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        calendarView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        if selectable {
            calendarView.selectionBehavior = UICalendarSelectionSingleDate(delegate: context.coordinator)
        }
        return calendarView
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        if let selection = uiView.selectionBehavior as? UICalendarSelectionSingleDate {
            let components = Calendar.current.dateComponents(in: .current, from: selectedDate)
            selection.setSelected(components, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        var parent: CalendarView
        
        init(_ parent: CalendarView) {
            self.parent = parent
        }
        
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            guard let decorationForDate = parent.decorationForDate,
                  let view = decorationForDate(dateComponents) else {
                return nil
            }
            return .customView {
                return UIHostingController(rootView: view).view
            }
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            if let date = dateComponents?.date {
                parent.selectedDate = date
            }
        }
    }
}

#Preview {
    @Previewable @State var date = Date.now
    
    ScrollView {
        CalendarView(selectedDate: $date) { components in
            if let date = Calendar.current.date(from: components) {
                if (abs(date.timeIntervalSince(Calendar.current.startOfDay(for: Date.now))) <= 86400 * 3) {
                    Circle().fill(Color.red).frame(width: 12, height: 12)
                }
            }
        }
        .frame(width: 220, height: 330)
        .border(.red)
        .onChange(of: date) {
            print("selected date", date)
        }
    }
}
