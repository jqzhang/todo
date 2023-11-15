//
//  ButtonStyle.swift
//  DailySecretary
//
//  Created by Vii on 2023/6/29.
//
import SwiftUI


struct ButtonScaleStyle : ButtonStyle {
    
    let scaleValue : CGFloat
    
    init (scaleValue : CGFloat? = nil) {
        self.scaleValue = scaleValue ?? 0.98
    }
    
    func makeBody(configuration : Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaleValue : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .brightness(configuration.isPressed ? 0.02 : 0)
    }
    
}
