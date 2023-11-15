//
//  PullToRefreshListView.swift
//  DailySecretary
//
//  Created by Vii on 2023/7/6.
//

import SwiftUI

struct PullToRefreshListView<Item: Identifiable, ItemView: View>: View {
    
    @Binding var items: [Item]
    @Binding var isRefreshing: Bool
    
    var itemContent: (Item) -> ItemView
    var fetchData: () -> Void
    
    init(items: Binding<[Item]>, isRefreshing: Binding<Bool>, itemContent: @escaping (Item) -> ItemView, fetchData: @escaping () -> Void) {
        self._items = items
        self._isRefreshing = isRefreshing
        self.itemContent = itemContent
        self.fetchData = fetchData
    }
    
    var body: some View {
        let dragGesture = DragGesture()
            .onChanged { value in
                if value.translation.height > 10 && !isRefreshing {
                    isRefreshing = true
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                        fetchData()
                    }
                }
            }.onEnded{ value in
                print("onEnded : ", value.translation.height)
                fetchData()
            }
        
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    if isRefreshing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    }
                    
                    ForEach(items) { item in
                        itemContent(item)
                    }
                    
                    Spacer().frame(height: 100) // 防止底部最后一天被tab 遮挡
                }
                .frame(width: geometry.size.width) // 设置列表宽度为父视图宽度
                .onAppear {
                    fetchData()
                }
                
            }
            .gesture(dragGesture)
        }
    }
}


struct PullToRefreshListView_Previews: PreviewProvider {
    @State private var items = ["Item 1", "Item 2", "Item 3", "Item 4"]
    
    static var previews: some View {
        Text("")
    }
}
