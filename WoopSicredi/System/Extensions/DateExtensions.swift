//
//  DateExtensions.swift
//  WoopSicredi
//
//  Created by Alexandre Scheer Bing on 12/11/20.
//

import Foundation

extension Date {
    // MARK: Date functions
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func getFullDateString() -> String {
        let day = get(.day)
        let month = get(.month)
        let year = get(.year)
        
        return "\(day).\(month).\(year)"
    }

    func adding(seconds: Int) -> Date {
        return Calendar.current.date(byAdding: .second, value: seconds, to: self)!
    }
    
    // MARK: Static functions
    
    static func dateFromString(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm"
        return dateFormatter.date(from: date) ?? nil
    }
}
