//
//  MineView.swift
//  DailySecretary
//
//  Created by Vii on 2023/6/26.
//

import SwiftUI

struct MineView: View {
    
    @State private var  taskStatus : TaskStatus = TaskStatus.PENDING
    
    @State private var showTaskListView : Bool = false
    
    @State private var itemBackgroundColor : Color =  ColorConstants.C10275A
    
    @State private var showWebView : Bool = false
    
    @State private var webUrl : String = ""
    
    @State private var webTitle : String = ""
    
    var body: some View {
            ZStack{
                VStack(){
                    // My Task
                    Group {
                        Spacer().frame(height: 18)
                        HStack{
                            Text(NSLocalizedString("myTask", comment: ""))
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                                .foregroundColor(ColorConstants.C10275A)
                            
                            Spacer()
                        }
                        
                        Spacer().frame(height: 18)
                        
                        VStack {
                            HStack{
                                // 进行中
                                Button(action: {
                                    taskStatus = TaskStatus.PENDING
                                    itemBackgroundColor = ColorConstants.C858FE9
                                    showTaskListView.toggle()
                                }) {
                                    ZStack(alignment: .center){
                                        HStack{
                                            Spacer().frame(height: 69)
                                        }
                                        .background(ColorConstants.C858FE9.opacity(0.75))
                                        .cornerRadius(14)
                                        
                                        Text(NSLocalizedString("pending", comment: ""))
                                            .font(.system(size: 18))
                                            .foregroundColor(ColorConstants.White)
                                    }
                                }.buttonStyle(ButtonScaleStyle())
                            }
                            
                            Spacer().frame(height: 18)
                            
                            HStack{
                                // 已完成
                                Button(action: {
                                    taskStatus = TaskStatus.COMPLETED
                                    itemBackgroundColor = ColorConstants.C7EC8E7
                                    showTaskListView.toggle()
                                }) {
                                    ZStack(alignment: .center){
                                        HStack{
                                            Spacer().frame( height: 69)
                                        }
                                        .background(ColorConstants.C7EC8E7.opacity(0.75))
                                        .cornerRadius(14)
                                        
                                        Text(NSLocalizedString("completed", comment: ""))
                                            .font(.system(size: 18))
                                            .foregroundColor(ColorConstants.C10275A)
                                    }
                                }.buttonStyle(ButtonScaleStyle())
                                
                                Spacer().frame(width: 20)
                                
                                // 已取消
                                Button(action: {
                                    taskStatus = TaskStatus.CANCELED
                                    itemBackgroundColor = ColorConstants.CFFE4E4
                                    showTaskListView.toggle()
                                }) {
                                    ZStack(alignment: .center){
                                        HStack{
                                            Spacer().frame(height: 69)
                                        }
                                        .background(ColorConstants.CFFE4E4.opacity(0.75))
                                        .cornerRadius(14)
                                        
                                        Text(NSLocalizedString("canceled", comment: ""))
                                            .font(.system(size: 18))
                                            .foregroundColor(ColorConstants.C10275A)
                                    }
                                }.buttonStyle(ButtonScaleStyle())
                                
                                
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // 关于我们等内容
                    Group {
                        HStack {
                            // 隐私政策
                            Button (action: {
                                webUrl = "https://eixxoi22ahh.feishu.cn/docx/QtpodGc5DovRsfxcuMiczc7cnAe?from=from_copylink"
                                webTitle = NSLocalizedString("privacyPolicy", comment: "")
                                showWebView.toggle()
                            }) {
                                Text(NSLocalizedString("privacyPolicy", comment: ""))
                                    .font(.system(size: 14))
                                    .foregroundColor(ColorConstants.C8A8BB3)
                                    .frame(alignment: .leading)
                            }
                            .buttonStyle(ButtonScaleStyle())
                            
                            Spacer().frame(width: 20)
                            
                            // 关于我们
                            Button (action: {
                                webUrl = "https://eixxoi22ahh.feishu.cn/docx/Ixg1dwHkZoKHihxOHe3c8lQknVc?from=from_copylink"
                                webTitle = NSLocalizedString("aboutUs", comment: "")
                                showWebView.toggle()
                            }) {
                                Text(NSLocalizedString("aboutUs", comment: ""))
                                    .font(.system(size: 14))
                                    .foregroundColor(ColorConstants.C8A8BB3)
                                    .frame(alignment: .leading)
                            }
                            .buttonStyle(ButtonScaleStyle())
                        }
                    }
                    
                    Spacer().frame(height: 100)
                }
                
                NavigationLink(destination: TaskListView(taskStatus: taskStatus, itemBackgroundColor: itemBackgroundColor), isActive: $showTaskListView) {
                    EmptyView()
                }
                
                NavigationLink(destination: WebView(url: webUrl, title: webTitle), isActive: $showWebView) {
                    EmptyView()
                }
            }
            .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
    }
}


struct MineView_Previews: PreviewProvider {
    static var previews: some View {
        MineView()
    }
}
