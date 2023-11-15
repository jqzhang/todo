//
//  FloatingTabBar.swift
//  DailySecretary
//
//  Created by Vii on 2023/7/10.
//

import SwiftUI

enum Tab {
    case home
    case addTask
    case mine
}

struct FloatingTabBarView: View {
    @EnvironmentObject var viewEnv: ViewEnv
    
    @State private var showTaskDetailsView = false
    
    @State private var selectedTab : Tab = .home
    
    @State var selectedDate : Date
    
    @State private var taskAction: TaskAction = TaskAction.view
    
    @State private var selectedTask: TaskModel?
    
//    private let homeView = HomeView(selectedDate : $selectedDate)
    
    private let mineView = MineView()
    
    init() {
        // 在构造函数中设置selectedDate的初始值
        _selectedDate = State<Date>(initialValue: Date())
    }
    
    var body: some View {
        VStack {
            Spacer().frame(height: 10)
            NavigationView {
                ZStack {
                    Group {
                        if selectedTab == .home {
                            HomeView(selectedDate : $selectedDate)
                        } else if selectedTab == .mine {
                            mineView
                        } else {
                            EmptyView()
                        }
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
                    
                    VStack{
                        Spacer()
                        FloatingTabBar(selectedTab: $selectedTab, action : {tab in
                            switch tab{
                            case .home:
                                selectedTab = .home
                                break
                            case .addTask:
                                showTaskDetailsView = true
                                taskAction = TaskAction.create
                                selectedTask = nil
                                break
                            case .mine :
                                selectedTab = .mine
                                break
                            }
                        })
                        Spacer().frame(height: 30)
                    }
                    
                    NavigationLink(destination: TaskDetailsView(taskAction:taskAction, taskModel: selectedTask), isActive: $showTaskDetailsView) { EmptyView() }
                }.edgesIgnoringSafeArea(.all)
            }
        }.onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("SelectedTaskNotification"))) { notification in
            handleSelectedTaskNotification(notification)
        }
    }
    
    
    func handleSelectedTaskNotification(_ notification: Notification) {
        // 处理通知的回调逻辑
        if let taskId = notification.object as? String {
            // 处理通知携带的数据
            print("收到通知，处理选中的任务：\(taskId)")
            let task = fetchTaskById(id: taskId)
            if (task != nil) {
                selectedTask = task
                taskAction = TaskAction.view
                showTaskDetailsView.toggle()
            }
        }
    }
}


struct FloatingTabBar: View {
    
    @Binding var selectedTab: Tab
    
    var action : (Tab)->Void
    
    var body: some View {
        
        HStack {
            
            Spacer()
            
            TabBarButton(normalIcon: "HomeNormal", selectedIcon: "HomeSelected", tab: .home, selectedTab: $selectedTab, action: {
                action(.home)
            })
            
            Spacer()
            
            TabBarButton(normalIcon: "TabAdd", selectedIcon: "TabAdd", tab: .addTask, selectedTab: $selectedTab, action: {
                action(.addTask)
            })
            
            Spacer()
            
            TabBarButton(normalIcon: "FolderNormal", selectedIcon: "FolderSelected", tab: .mine, selectedTab: $selectedTab, action: {
                action(.mine)
            })
            
            Spacer()
        }
        .background(ColorConstants.White.opacity(0.9))
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 30))
        
    }
}

struct TabBarButton: View {
    let normalIcon: String
    let selectedIcon: String
    let tab: Tab
    @Binding var selectedTab: Tab
    let action: () -> Void
    
    
    var body: some View {
        Button(action: action) {
            Image(selectedTab == tab ? selectedIcon : normalIcon)
                .font(.system(size: 24))
                .padding(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0))
        }
    }
}


struct FloatingTabBar_Previews: PreviewProvider {
    static var previews: some View {
        FloatingTabBarView()
    }
}
