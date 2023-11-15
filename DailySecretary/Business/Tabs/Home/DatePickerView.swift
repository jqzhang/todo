//
//  DatePickerView.swift
//  DailySecretary
//
//  Created by Vii on 2023/7/1.
//

import SwiftUI

struct DatePickerView: View {
    
    @Binding var selectedDateCom: DateComponents
    @Binding var showDatePicker: Bool
    @State private var selectedDate: Date
    
    init(dateComponents: Binding<DateComponents>, isShow : Binding<Bool>) {
        self._selectedDateCom = dateComponents
        self._showDatePicker = isShow
        self._selectedDate = State(initialValue: Date())
    }
    
    var body: some View {
        VStack {
            DatePicker(selection: $selectedDate, displayedComponents: [.date, .hourAndMinute]) {
            }
            .datePickerStyle(CompactDatePickerStyle())
            .labelsHidden()
            .background(ColorConstants.White)
            
            Button(action: {
                // 确认选择并关闭选择框
                dismiss()
            }) {
                Text(NSLocalizedString("confirm", comment: ""))
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
        .onAppear {
            selectedDate = components2Date(components: selectedDateCom)
        }
        .onDisappear {
            selectedDateCom = date2Components(date: selectedDate)
        }
    }
    
    private func dismiss() {
        // 关闭选择框
        withAnimation {
            showDatePicker = false
        }
    }
}

//struct CustomDatePickerStyle: DatePickerStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        DatePicker("", selection: configuration.$wrappedValue, displayedComponents: configuration.datePickerComponents)
//            .labelsHidden()
//            .background(Color.white)
//    }
//}


struct CustomDatePickerStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Arial", size: 16)) // 设置时间字体
            .background(Color.yellow) // 设置背景色
    }
}


struct TestDatePickerView: View {
    @Binding var dc: DateComponents
    @Binding var show : Bool
    
    var date: Date {
        Date()
    }
    
    init(dc: Binding<DateComponents>, show : Binding<Bool>) {
        self._dc = dc
        self._show = show
    }
    
    var body: some View {
        DatePickerView(dateComponents: $dc, isShow: $show)
    }
}


struct DatePickerView_Previews: PreviewProvider {
    @State static var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    @State static var show = true
    
    static var previews: some View {
        TestDatePickerView(dc: $dateComponents,show: $show)
    }
}
