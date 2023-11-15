//
//  TaskActionPopover.swift
//  DailySecretary
//
//  Created by Vii on 2023/7/16.
//

import SwiftUI

struct TaskActionView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var showTaskActionPopover : Bool
    
    private var editAction : () -> Void
    
    private var updateAction : () -> Void
    
    private var taskModel : TaskModel
    
    init(showTaskActionPopover: Binding<Bool>, taskModel: TaskModel,
         editAction : @escaping () -> Void,
         updateAction : @escaping () -> Void) {
        self._showTaskActionPopover = showTaskActionPopover
        self.taskModel = taskModel
        self.editAction = editAction
        self.updateAction = updateAction
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(alignment: .leading){
                    Button(action: {
                        print("taskModel : ", taskModel.title ?? "")
                        
                        taskModel.status = TaskStatus.COMPLETED.rawValue
                        updateTask(task: taskModel)
                        updateAction()
                        back()
                    }, label: {
                        HStack{
                            Image("TaskCompleted").frame(width: 24, height: 24)
                            Spacer().frame(width: 13)
                            Text(NSLocalizedString("done", comment: ""))
                                .font(.system(size: 16))
                                .foregroundColor(ColorConstants.Black)
                        }
                    })
                    
                    Button(action: {
                        editAction()
                        updateAction()
                        back()
                    }, label: {
                        HStack{
                            Image("TaskEdit").frame(width: 24, height: 24)
                            Spacer().frame(width: 13)
                            Text(NSLocalizedString("edit", comment: ""))
                                .font(.system(size: 16))
                                .foregroundColor(ColorConstants.Black)
                        }
                    })
                    
                    Button(action: {
                        taskModel.status = TaskStatus.CANCELED.rawValue
                        updateTask(task: taskModel)
                        removeNotification(withIdentifier: String(taskModel.taskId))
                        updateAction()
                        back()
                    }, label: {
                        HStack{
                            Image("TaskDelete").frame(width: 24, height: 24)
                            Spacer().frame(width: 13)
                            Text(NSLocalizedString("cancel", comment: ""))
                                .font(.system(size: 16))
                                .foregroundColor(ColorConstants.Black)
                        }
                    })
                }
                .frame(width: 144, height: 160)
                .background(ColorConstants.White)
                .cornerRadius(14)
                .shadow(radius: 10)
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .center
            )
        }
        .background(ColorConstants.White.opacity(0.6))
        .onTapGesture {
            back()
        }
    }
    
    func back() {
        showTaskActionPopover = false
    }
}
