//
//  MainTabView.swift
//  DailySecretary
//
//  Created by Vii on 2023/6/26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
//            HomeView(showFloatingTabBar: <#T##Binding<Bool>#>)
//                .tabItem {
//                    Image(systemName: "house")
//                    Text("首页")
//                }
//            TaskDetailsView()
//                .tabItem {
//                    Image(systemName: "plus.circle")
//                    Text("加号")
//                }
            MineView()
                .tabItem {
                    Image(systemName: "person")
                    Text("我的")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
