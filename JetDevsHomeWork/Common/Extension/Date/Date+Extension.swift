//
//  Date+Extension.swift
//  JetDevsHomeWork
//
//  Created by syndromme on 09/01/24.
//

import Foundation

extension Calendar {
    
    func numberOfDaysBetweenMidnight(_ from: Date, toTarget: Date) -> Int {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: toTarget)
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
        return (numberOfDays.day ?? 0)
    }
    
    func numberOfDaysBetween(_ from: Date, toTarget: Date) -> Int {
        let numberOfDays = dateComponents([.day], from: from, to: toTarget)
        return (numberOfDays.day ?? 0)
    }
    
}

extension String {
    
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: self) ?? Date()
    }
    
}

extension Date {
    
    func timeAgoDisplay() -> String {
        if #available(iOS 13.0, *) {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            return formatter.localizedString(for: self, relativeTo: Date())
        } else {
            let calendar = Calendar.current
            let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date()) ?? Date()
            let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date()) ?? Date()
            let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date()
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()

            if (minuteAgo < self) {
                let diff = (Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0)
                return "\(diff) sec ago"
            } else if (hourAgo < self) {
                let diff = (Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0)
                return "\(diff) min ago"
            } else if (dayAgo < self) {
                let diff = (Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0)
                return "\(diff) hrs ago"
            } else if (weekAgo < self) {
                let diff = (Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0)
                return "\(diff) days ago"
            }
            let diff = (Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0)
            return "\(diff) weeks ago"
        }
        
    }
    
}
