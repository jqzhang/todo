//
//  WebView.swift
//  DailySecretary
//
//  Created by Vii on 2023/7/21.
//

import SwiftUI
import WebKit

struct BrowserView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let wk = WKWebView()
        wk.navigationDelegate = context.coordinator
        wk.load(URLRequest(url: url))
        return wk
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: BrowserView

        init(_ parent: BrowserView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // 隐藏地址栏和 "Done" 按钮
            webView.evaluateJavaScript("document.body.style.marginTop = '-40px'; document.documentElement.style.webkitTouchCallout='none';") { _, _ in }
        }
    }
}

struct WebView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let url : String
    
    let title : String
    
    var body: some View {
        VStack{
            // Title bar
            ZStack{
                HStack(){
                    Spacer()
                    
                    Text(title)
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
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 20, trailing: 10))
            
            BrowserView(url: URL(string: url)!)
        }.navigationBarHidden(true)
    }
    
    func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(url: "http://www.baidu.com", title: "Title")
    }
}
