//
//  WeekCalendarView.swift
//  DailySecretary
//
//  Created by Vii on 2023/6/21.
//
import SwiftUI

struct WeekCalendarView: View {
    
    @Binding private var selectedDate: Date
    
    let onDateSelected: (Date) -> Void // 回调闭包
    
    init(date: Binding<Date>, onDateSelected : @escaping (Date) -> Void) {
        self._selectedDate = date
        self.onDateSelected = onDateSelected
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 2) {
                ForEach(weekdays, id: \.self) { weekday in
                    let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
                    let weekDaysDate = getWeekDaysDate(dateComponents: dateComponents)
                    
                    let isCurrentDay = isSameDay(weekDaysDate[weekday]!, Date())
                    
                    let isSelectedDay = isSameDay(weekDaysDate[weekday]!, selectedDate)
                    
                    ZStack {
                        VStack {
                            Text(weekday)
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                                .foregroundColor(getTextColor(isSelectedDay))
                            
                            Spacer().frame(height: 10)
                            ZStack {
                                Text("\(dateForWeekday(weekDaysDate[weekday]!))")
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                                    .foregroundColor(getTextColor(isSelectedDay))
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(EdgeInsets(top: 10, leading: 8, bottom: 16, trailing: 8))
                    .background(isSelectedDay ? ColorConstants.C5B67CA : ColorConstants.White)
                    .cornerRadius(12)// 添加圆角
                    .overlay(
                        Group {
                            if isCurrentDay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(ColorConstants.C5B67CA.opacity(0.5), lineWidth: 1)
                            } else {
                                EmptyView() // 不显示边框
                            }
                        }
                    )// 添加边框样式
                    .onTapGesture {
                        let date = weekDaysDate[weekday]!
                        selectedDate = date
                        onDateSelected(date)
                    }
                }
            }
        }
    }
    
    func dateForWeekday(_ date: Date) -> String {
        let day = getDateByFormate(format: "dd", date: date)

        return day
    }
    
    func getTextColor(_ isCurrentDay : Bool)->Color {
        if isCurrentDay {
            return ColorConstants.White
        }
        return ColorConstants.C10275A
    }
}
