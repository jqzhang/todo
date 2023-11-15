//
//  SplashView.swift
//  DailySecretary
//
//  Created by Vii on 2023/6/26.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            Image("SplashImg")
                .resizable()
                .scaledToFit()
                .frame(width: 291, height: 294)
            
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
