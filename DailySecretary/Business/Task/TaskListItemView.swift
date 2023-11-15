//
//  TaskListItemView.swift
//  DailySecretary
//
//  Created by Vii on 2023/7/20.
//

import SwiftUI

struct TaskListItemView: View {
    
    private var itemClickAction : (TaskModel) -> Void
    
    let task: TaskModel
    
    let backgroundColor : Color
    
    init(task: TaskModel, backgroundColor: Color, itemClickAction: @escaping (TaskModel) -> Void) {
        self.task = task
        self.backgroundColor = backgroundColor
        self.itemClickAction = itemClickAction
    }
    
    var body: some View {
        Button(action: {
            itemClickAction(task)
        }, label: {
            HStack{
                Rectangle()
                    .frame(width: 2,height: 42)
                    .cornerRadius(1)
                    .foregroundColor(backgroundColor)
                
                Spacer().frame(width: 10)
                
                VStack(alignment: .leading){
                    HStack{
                        Text(task.title!)
                            .font(.system(size: 16))
                            .foregroundColor(ColorConstants.C2C406E)
                        
                        Spacer()
                    }
                    
                    Spacer().frame(height: 10)
                    
                    Text(getDateByFormate(format: "yyyy-MM-dd HH:mm", date: task.remindTime!))
                        .font(.system(size: 14))
                        .foregroundColor(ColorConstants.C9AA8C7)
                }
                Spacer()
            }
            .padding(15)
            .background(backgroundColor.opacity(0.3))
            .cornerRadius(15)
        }).buttonStyle(ButtonScaleStyle())
    }
}
