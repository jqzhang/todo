//
//  ContentView.swift
//  DailySecretary
//
//  Created by Vii on 2023/6/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showMainTab = false
    
    var body: some View {
        if showMainTab {
            FloatingTabBarView()
        } else {
            SplashView()
                .onAppear {
                    // 5秒后跳转到主页
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showMainTab = true
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
