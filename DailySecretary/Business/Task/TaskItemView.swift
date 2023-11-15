//
//  TaskItem.swift
//  DailySecretary
//
//  Created by Vii on 2023/6/30.
//

import SwiftUI

struct TaskItemView: View {
    private var itemClickAction : (TaskModel) -> Void
    
    private var moreIconClickAction : (TaskModel) -> Void
    
    let task: TaskModel
    
    init(task: TaskModel, itemClickAction: @escaping (TaskModel) -> Void, moreIconClickAction : @escaping (TaskModel) -> Void) {
        self.task = task
        self.itemClickAction = itemClickAction
        self.moreIconClickAction = moreIconClickAction
    }
    
    
    var body: some View {
        Button(action: {
            itemClickAction(task)
        }, label: {
            HStack{
                Rectangle()
                    .frame(width: 2,height: 42)
                    .cornerRadius(1)
                    .foregroundColor(ColorConstants.C8F99EB)
                
                Spacer().frame(width: 10)
                
                VStack(alignment: .leading){
                    HStack{
                        Text(task.title!)
                            .font(.system(size: 16))
                            .foregroundColor(ColorConstants.C2C406E)
                        
                        Spacer()
                        
                        Button(action: {
                            moreIconClickAction(task)
                        }, label: {
                            Image("More")
                        })
                    }
                    
                    Spacer().frame(height: 10)
                    
                    Text(getDateByFormate(format: "HH:mm", date: task.remindTime!))
                        .font(.system(size: 14))
                        .foregroundColor(ColorConstants.C9AA8C7)
                }
                Spacer()
            }
            .padding(15)
            .background(ColorConstants.CEEF0FF)
            .cornerRadius(15)
        }).buttonStyle(ButtonScaleStyle())
    }
}

