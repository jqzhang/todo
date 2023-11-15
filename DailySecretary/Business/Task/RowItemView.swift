//
//  RowItemView.swift
//  ToDo
//
//  Created by Vii on 2023/7/30.
//

import SwiftUI

struct TimeTask {
    var hour : Int
    var tasks : [TaskModel]
}

struct RowItemView: View {
    @State var timeTask : TimeTask
    
    var body: some View {
        ScrollView {
            VStack{
                Divider().background(ColorConstants.CEBF9FF)
                
                Spacer().frame(height: 10)
                
                HStack {
                    Text(String(format: "%02d", timeTask.hour))
                        .foregroundColor(ColorConstants.C2C406E)
                        .font(.system(size: 14))
                    
                    ForEach (timeTask.tasks) { item in
                        TaskItemView(task: item, itemClickAction: { task in
                        }, moreIconClickAction: {  task in
                        })
                    }
                }
            }
        }
    }
}

