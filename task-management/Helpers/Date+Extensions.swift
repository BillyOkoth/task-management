//
//  Date+Extensions.swift
//  task-management
//
//  Created by Billy Okoth on 14/05/2024.
//

import SwiftUI

extension Date {
    //custom formatter for the date
    func format(_ format :String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from:self)
    }
    
    //check if the current date is today
    var isToday:Bool {
        return Calendar.current.isDateInToday(self)
    }
    //check if the date is same hours
    var isSameHour:Bool {
        return Calendar.current.compare(self, to: .init(), toGranularity: .hour) == .orderedSame
    }
    //check if the date is past hours
    var isPastHour:Bool {
        return Calendar.current.compare(self, to: .init(), toGranularity: .hour) == .orderedAscending
    }
    //fetch the week based on a given date
    func fetchWeek(_ date:Date = .init()) -> [WeekDay] {
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: date)
        
        var week:[WeekDay] = []
        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)
        guard let startOfWeek = weekForDate?.start else {
            return []
        } 
        //iterating through the whole week.
        (0..<7).forEach { index in
            if let weekDay = calendar.date(byAdding: .day, value: index, to: startOfWeek){
                week.append(.init(date: weekDay))
            }
        }
       return week
    }
    
    //function create next week based on last current weeks date
    
    func createNextWeek() -> [WeekDay]{
        let calendar = Calendar.current
        let startOfLastDate = calendar.startOfDay(for: self)
        guard let nextDate = calendar.date(byAdding: .day,value:1  ,to: startOfLastDate ) else {
            return []
        }
        return fetchWeek(nextDate)
    }
    
    //function Previos  week based on First  current weeks date
    
    func createPreviousWeek() -> [WeekDay]{
        let calendar = Calendar.current
        let startOfLastDate = calendar.startOfDay(for: self)
        guard let previousDate = calendar.date(byAdding: .day,value:-1  ,to: startOfLastDate ) else {
            return []
        }
        return fetchWeek(previousDate)
    }
    
    
    
    
    
    struct WeekDay:Identifiable {
        var id:UUID = .init()
        var date: Date
    }
    
    
}

