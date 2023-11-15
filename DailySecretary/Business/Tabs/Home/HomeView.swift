//
//  HomeView.swift
//  DailySecretary
//
//  Created by Vii on 2023/6/26.
//

import SwiftUI

struct HomeView: View {
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var selectedTask: TaskModel?
    
    @State private var taskAction: TaskAction = TaskAction.view
    
    @State private var currentTime = Date()
    
    @State private var taskList: [TaskModel] = []
    
    @State private var isRefreshing: Bool = false
    
    @State private var showTaskDetailView: Bool = false
    
    @State private var showTaskActionPopover: Bool = false
    
    @State private var showNotificationAlert: Bool = false
    
    @Binding var selectedDate : Date
    
    var body: some View {
        ZStack (alignment: .center) {
            VStack {
                Group {
                    HStack(alignment: .center) {
                        Text(NSLocalizedString("task", comment: ""))
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(ColorConstants.C10275A)
                            .lineLimit(1)
                            .cornerRadius(2)
                        
                        Spacer()
                        
                        HStack {
                            DatePicker(selection: $selectedDate, displayedComponents: [.date]) {
                            }
                            .datePickerStyle(CompactDatePickerStyle())
                            .labelsHidden()
                            .environment(\.locale, Locale(identifier: Locale.current.identifier))
                            .accentColor(ColorConstants.C10275A)
                            .font(.system(size: 14))
                            .background(ColorConstants.White)
                            .modifier(CustomDatePickerStyle())
                            .onReceive([self.selectedDate].publisher.first(), perform: { date in
                                // 在这里处理选中的日期事件
                                selectedDate = date
                                getTaskList()
                            })
                        }
                    }
                    
                    WeekCalendarView(date: $selectedDate) { date in
                        getTaskList()
                    }
                    
                    HStack(alignment: .center) {
                        Text(NSLocalizedString("today", comment: ""))
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(ColorConstants.Black)
                            .lineLimit(1)
                            .onTapGesture {
                                selectedDate = currentTime
                            }
                        
                        Spacer()
                        
                        Text(getTodayTime())
                            .font(.system(size: 14))
                            .foregroundColor(ColorConstants.Black)
                            .lineLimit(1)
                            .onAppear {
                                currentTime = Date()
                            }
                            .onReceive(timer) { _ in
                                currentTime = Date()
                            }
                            .onTapGesture {
                                selectedDate = currentTime
                            }
                    }
                }
                
                if taskList.isEmpty {
                    VStack {
                        Image("NoneTask")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 199, height: 196)
                        
                        Spacer().frame(height: 30)
                        
                        Text(NSLocalizedString("noSchedulesTip", comment: ""))
                            .foregroundColor(ColorConstants.C575757)
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                
                if !taskList.isEmpty {
                    PullToRefreshListView(items: $taskList, isRefreshing: $isRefreshing, itemContent: { item in
                        TaskItemView(task: item, itemClickAction: { task in
                            selectedTask = task
                            taskAction = TaskAction.view
                            showTaskDetailView.toggle()
                        }, moreIconClickAction: {  task in
                            selectedTask = task
                            showTaskActionPopover.toggle()
                        }
                        )
                    }, fetchData: {
                        getTaskList()
                    })
                }
            }
            .padding(EdgeInsets(top: 10, leading: 24, bottom: 0, trailing: 24))
            .frame(maxWidth: .infinity, // Full Screen Width
                   maxHeight: .infinity, // Full Screen Height
                   alignment: .topLeading)
            .navigationBarHidden(true)
            
            if showTaskActionPopover {
                TaskActionView(showTaskActionPopover: $showTaskActionPopover, taskModel: selectedTask!, editAction: {
                    taskAction = TaskAction.edit
                    showTaskDetailView.toggle()
                }, updateAction: {
                    getTaskList()
                })
            }
            
            NavigationLink(destination: TaskDetailsView(taskAction: taskAction, taskModel: selectedTask), isActive: $showTaskDetailView) {
                EmptyView()
            }
        }.onAppear(){
            getTaskList()
            // 调用方法检查通知权限
            checkNotificationAuthorization()
        }.alert(isPresented: $showNotificationAlert){
            Alert(title: Text(NSLocalizedString("tip", comment: "")),
                  message: Text(NSLocalizedString("openNotificatinTip", comment: "")),
                  primaryButton : .default(Text(NSLocalizedString("settings", comment: "")), action : {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }),
                  secondaryButton: .destructive(Text(NSLocalizedString("cancel", comment: "")), action : {
                GlobalVariables.showNotificationPer = false
                showNotificationAlert.toggle()
            })
            )
        }
    }
   
    
    private func getTodayTime() -> String {
        let formatter = DateFormatter()
        
        if isSameDay(selectedDate, Date()) {
            formatter.dateFormat = "HH:mm"
        } else {
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
        }
        return formatter.string(from: currentTime)
    }
    
    private func getTaskList() {
        taskList = fetchTasksOrderByTimeAndStatus(date: selectedDate, status: TaskStatus.PENDING.rawValue)
        isRefreshing = false
    }
    
    func checkNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                // 用户已经授权通知，可以进行后续操作
                break
            case .denied:
                // 用户拒绝了通知权限，弹出提示框引导用户跳转到设置页面
                openNotificationAlert()
            case .notDetermined:
                // 用户尚未授权通知，可以请求授权
                requestNotificationAuthorization()
            case .provisional:
                // 用户还没有做出选择，可以进行后续操作
                break
            default:
                break
            }
        }
    }
    
    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                // 用户授权了通知
            } else {
                // 用户拒绝了通知，弹出提示框引导用户跳转到设置页面
                openNotificationAlert()
            }
        }
    }
    
    func openNotificationAlert() {
        if GlobalVariables.showNotificationPer {
            showNotificationAlert = true
        } else {
            showNotificationAlert = false
        }
    }
}


