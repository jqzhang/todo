//
//  ToastView.swift
//  DailySecretary
//
//  Created by Vii on 2023/7/2.
//

import SwiftUI

class ToastManager: ObservableObject {
    @Published var showToast = false
    @Published var toastText = ""
    
    func showToast(_ text: String) {
        toastText = text
        showToast = true
    }
}

struct ToastModifier: ViewModifier {
    @EnvironmentObject var toastManager: ToastManager
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if toastManager.showToast {
                ToastView(text: toastManager.toastText)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                toastManager.showToast = false
                            }
                        }
                    }
            }
        }
    }
}

struct ToastView: View {
    let text: String
    @State private var isShowing = false
    
    var body: some View {
        VStack {
            Spacer().frame(height: 150)
            if isShowing {
                Text(text)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .transition(.opacity)
                
            }
            
            Spacer()
        }
        .onAppear(){
            withAnimation(.easeInOut(duration: 0.3)) {
                isShowing = true
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}


struct TestToastView : View {
    //    @EnvironmentObject var toastManager: ToastManager
    @StateObject var toastManager = ToastManager()
    
    var body: some View {
        ZStack {
            Button(action: {
                toastManager.showToast("Hello, Toast!")
            }, label: {
                Text("Show Toast")
            }).modifier(ToastModifier())
        }
        .environmentObject(toastManager)
    }
    
}


struct ToastView_Previews: PreviewProvider {
    @State var isShow = false
    
    
    static var previews: some View {
        TestToastView()
    }
}
