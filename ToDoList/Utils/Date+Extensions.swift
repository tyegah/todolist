//
//  Date+Extensions.swift
//  ToDoList
//
//  Created by Ty Septiani on 01/08/23.
//

import Foundation

extension Date {
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        
        if calendar.isDateInToday(self) {
            return "Today"
        } else if calendar.isDateInYesterday(self) {
            return "Yesterday"
        }
        else if calendar.isDateInTomorrow(self) {
            return "Tomorrow"
        }
        else {
            return dateFormatter.string(from: self)
        }
    }
}

