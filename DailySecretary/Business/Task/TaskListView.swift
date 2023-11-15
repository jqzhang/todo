//
//  TaskListView.swift
//  DailySecretary
//
//  Created by Vii on 2023/7/20.
//

import SwiftUI

struct TaskListView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var taskStatus : TaskStatus = TaskStatus.COMPLETED
    
    @State private var taskList: [TaskModel] = []
    
    @State private var selectedTask: TaskModel?
    
    @State private var showTaskDetailView: Bool = false
    
    @State private var isRefreshing: Bool = false
    
    var itemBackgroundColor : Color
    
    
    var body: some View {
        VStack {
            VStack {
                Group {
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
                }
                
                Spacer().frame(height: 10)
                
                if taskList.isEmpty {
                    VStack {
                        Spacer()
                        Image("NoneTask")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 199, height: 196)
                        
                        Spacer().frame(height: 30)
                        
                        Text(NSLocalizedString("noTodoFound", comment: ""))
                            .foregroundColor(ColorConstants.C575757)
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                }
                
                if !taskList.isEmpty {
                    PullToRefreshListView(items: $taskList, isRefreshing: $isRefreshing, itemContent: { item in
                        TaskListItemView(task: item, backgroundColor: itemBackgroundColor, itemClickAction: { task in
                            selectedTask = task
                            showTaskDetailView.toggle()
                        })
                    }, fetchData: {
                        getTaskList()
                    })
                }
            }
            .navigationBarHidden(true)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            
            NavigationLink(destination: TaskDetailsView(taskAction: TaskAction.view, taskModel: selectedTask), isActive: $showTaskDetailView) {
                EmptyView()
            }
        }
        .navigationBarHidden(true)
        .onAppear(){
            getTaskList()
        }
    }
    
    func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func getTitleText() -> String {
        if taskStatus == TaskStatus.COMPLETED {
            return NSLocalizedString("completed", comment: "") + NSLocalizedString("task", comment: "")
        }
        
        if taskStatus == TaskStatus.CANCELED {
            return NSLocalizedString("canceled", comment: "") + NSLocalizedString("task", comment: "")
        }
        
        return NSLocalizedString("pending", comment: "") + NSLocalizedString("task", comment: "")
    }
    
    private func getTaskList() {
        taskList = fetchTasksOrderByStatus(status: taskStatus.rawValue)
        isRefreshing = false
    }
}
