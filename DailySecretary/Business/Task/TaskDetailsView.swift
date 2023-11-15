//
//  TaskDetails.swift
//  DailySecretary
//
//  Created by Vii on 2023/6/27.
//

import SwiftUI

enum TaskAction {
    case create
    case edit
    case view
}

struct TaskDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var toastManager: ToastManager
    
    @State private var selectedDate: Date = Date()
    @State private var tfTitle: String = ""
    @State private var tfDescription: String = ""
    @State private var dateComponents: DateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute ], from: Date())
    
    @State var taskAction : TaskAction = TaskAction.create
    
    @State var taskModel : TaskModel?
    
    var defaultDate : Date?
    
    var body: some View {
        ScrollView {
            VStack {
                // Title bar
                ZStack{
                    HStack(){
                        Spacer()
                        
                        Text(getTitleText())
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(ColorConstants.C10275A)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Spacer()
                    }
                    
                    HStack(){
                        Button(action: {
                            // 处理按钮点击事件
                            back()
                        }) {
                            Image("Back").frame(width: 48, height:48, alignment: .center)
                        }
                        Spacer()
                    }.padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                }
                
                // 内容
                ScrollView{
                    // Title
                    Group{
                        HStack{
                            Text(NSLocalizedString("title", comment: ""))
                                .font(.system(size: 14))
                                .foregroundColor(ColorConstants.C8A8BB3)
                                .frame(alignment: .leading)
                            
                            Spacer()
                        }
                        
                        TextField(NSLocalizedString("enterTitle", comment: ""), text: $tfTitle)
                            .foregroundColor(ColorConstants.C10275A)
                            .font(.system(size: tfTitle.isEmpty ? 14 : 16))
                            .disabled(taskAction == TaskAction.view)
                        
                        Spacer().frame(height: 10)
                        Divider().background(ColorConstants.CE8E9F3)
                        Spacer().frame(height: 21)
                    }
                    
                    // Description
                    Group{
                        HStack{
                            Text(NSLocalizedString("description", comment: ""))
                                .font(.system(size: 14))
                                .foregroundColor(ColorConstants.C8A8BB3)
                                .frame(alignment: .leading)
                            
                            Spacer()
                        }
                        
                        TextField(NSLocalizedString("enterDescription", comment: ""), text: $tfDescription)
                            .foregroundColor(ColorConstants.C10275A)
                            .font(.system(size: tfDescription.isEmpty ? 14 : 16))
                            .disabled(taskAction == TaskAction.view)
                        
                        Spacer().frame(height: 10)
                        Divider().background(ColorConstants.CE8E9F3)
                        Spacer().frame(height: 21)
                    }
                    
                    
                    // Date Time
                    Group {
                        HStack{
                            Text(NSLocalizedString("dateTime", comment: ""))
                                .font(.system(size: 14))
                                .foregroundColor(ColorConstants.C8A8BB3)
                            
                            Spacer()
                        }
                        //
                        HStack(alignment: .center){
                            ZStack(alignment: .center) {
                                DatePicker(selection: $selectedDate, displayedComponents: [.date, .hourAndMinute]) {
                                }
                                .disabled(taskAction == TaskAction.view)
                                .datePickerStyle(CompactDatePickerStyle())
                                .labelsHidden()
                                .accentColor(ColorConstants.C10275A)
                                .font(.system(size: 16))
                                .background(ColorConstants.White)
                                .modifier(CustomDatePickerStyle())
                            }
                            
                            Spacer()
                        }
                        
                        Spacer().frame(height: 10)
                        Divider().background(ColorConstants.CE8E9F3)
                        Spacer().frame(height: 21)
                    }
                    
                    if taskAction != TaskAction.view {
                        Group{
                            Spacer().frame(height: 50)
                            Button(action: {
                                addTask()
                            }, label: {
                                HStack{
                                    Spacer()
                                    Text(getButtonText())
                                        .font(.system(size: 16))
                                        .foregroundColor(ColorConstants.White)
                                    Spacer()
                                }
                                .padding(15)
                                .background(ColorConstants.C5B67CA)
                                .cornerRadius(14)
                            })
                            .buttonStyle(ButtonScaleStyle())
                            
                            Spacer().frame(height: 50)
                        }
                    }
                    
                }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
            .modifier(ToastModifier())
            .environmentObject(toastManager)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 20, trailing: 10))
            .navigationBarHidden(true)
            .onAppear(){
                if taskModel != nil {
                    tfTitle = taskModel?.title ?? ""
                    tfDescription = taskModel?.desc ?? ""
                    selectedDate = taskModel?.remindTime ?? (defaultDate ?? Date())
                } else {
                    selectedDate = defaultDate ?? selectedDate
                }
            }
        }
    }
    
    func getButtonText() -> String {
        if taskAction == TaskAction.create {
            return NSLocalizedString("create", comment: "")
        }
        
        if taskAction == TaskAction.edit {
            return NSLocalizedString("update", comment: "")
        }
        
        return ""
    }
    
    func getTitleText() -> String {
        if taskAction == TaskAction.create {
            return NSLocalizedString("addTask", comment: "")
        }
        
        if taskAction == TaskAction.edit {
            return NSLocalizedString("updateTask", comment: "")
        }
        
        return NSLocalizedString("viewTask", comment: "")
    }
    
    func addTask() {
        let checked = check()
        
        if !checked {
            return
        }
        
        let date = Date()
        
        
        if taskModel != nil {
            taskModel?.title = tfTitle
            taskModel?.desc = tfDescription
            taskModel?.remindTime = selectedDate
            taskModel?.updateTime = date
            
            updateTask(task: taskModel!)
            
            updateNotify(taskModel: taskModel!)
            
            toastManager.showToast(NSLocalizedString("updateTaskSuccessful", comment: ""))
        } else {
            let task = TaskInfo()
            task.title = tfTitle
            task.desc = tfDescription
            task.status = TaskStatus.PENDING.rawValue
            task.remindTime = selectedDate
            task.createTime = date
            task.taskId = Int64(date.timeIntervalSince1970)
            saveTask(task: task)
            addNotification(task: task)
            
            toastManager.showToast(NSLocalizedString("addTaskSuccessful", comment: ""))
        }
        
        back()
    }
    
    func check() -> Bool {
        if tfTitle.isEmpty {
            toastManager.showToast(NSLocalizedString("enterTitle", comment: ""))
            return false
        }
        
        if tfDescription.isEmpty {
            toastManager.showToast(NSLocalizedString("enterDescription", comment: ""))
            return false
        }
        
        return true
    }
    
    func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func updateNotify(taskModel : TaskModel) {
        removeNotification(withIdentifier: String(taskModel.taskId))
        
        let task = TaskInfo()
        task.title = taskModel.title!
        task.desc = taskModel.desc!
        task.status = taskModel.status
        task.remindTime = taskModel.remindTime
        task.createTime = taskModel.createTime
        task.updateTime = taskModel.updateTime
        task.taskId = taskModel.taskId
        
        addNotification(task : task)
    }
    
    func addNotification(task : TaskInfo) {
        let now = Date()
        var remindTime = Date()
        
        // 设置的提醒时间比当前时间小，则在5s后自动提示
        if task.remindTime! <= now {
            remindTime = now.addingTimeInterval(5)
        } else {
            remindTime = task.remindTime!
        }
        
        scheduleNotification(for: remindTime, withTitle: task.title, andBody: task.desc, notificationID: String(task.taskId))
    }
}

struct TaskDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailsView()
    }
}
