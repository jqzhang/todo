//
//  DateUtils.swift
//  DailySecretary
//
//  Created by Vii on 2023/6/26.
//

import Foundation

let weekdays: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]


// 比较两个日期是否为同一天
func isSameDay (_ day1 : Date, _ day2 : Date) -> Bool{
    let df = DateFormatter()
    df.dateFormat = "yyyyMMdd"
    
    return df.string(from: day1) == df.string(from: day2)
}

func getDateByFormate(format : String, date : Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    
    let formattedDate = dateFormatter.string(from: date)
    
    return formattedDate
}

func getCurrentDate(_ formate : String) -> String {
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = formate
    
    let formattedDate = dateFormatter.string(from: currentDate)
    
    return formattedDate
}

// 获取指定日期所在周的map
func getWeekDaysDate (dateComponents : DateComponents) -> [String:Date]{
    var weekDaysDate = [String:Date]()
    
    var dateCom = DateComponents()
    dateCom.timeZone = TimeZone.current
    dateCom.year = dateComponents.year
    dateCom.month = dateComponents.month
    dateCom.day = dateComponents.day
    
    let calendar = Calendar.current
    let date = calendar.date(from: dateCom)!
    
    // 获取传入日期当前是周几
    let weekdayIndex = calendar.component(.weekday, from: date)
    
    var weekStartDate = Date()
    
    // 查找指定日期所在周的第一天，1 为周日，2为周一，以此类推
    if (1 == weekdayIndex) {
        weekStartDate = calendar.date(byAdding: .day, value: -6, to: date)!
    } else {
        let addDays = weekdayIndex - 2
        weekStartDate = calendar.date(byAdding: .day, value: -addDays, to: date)!
    }
    
    for (index, weekday) in weekdays.enumerated() {
        let currentDate = calendar.date(byAdding: .day, value: index, to: weekStartDate)!
        weekDaysDate[weekday] = currentDate
    }
    
    return weekDaysDate
}


func date2Components(date: Date) -> DateComponents {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
    
    return components
}


func components2Date(components : DateComponents)-> Date {
    let calendar = Calendar.current
    
    return calendar.date(from: components)!
}
