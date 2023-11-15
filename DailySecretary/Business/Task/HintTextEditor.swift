//
//  HintTextEditor.swift
//  DailySecretary
//
//  Created by Vii on 2023/6/29.
//

import SwiftUI

struct HintTextEditor: View {
    
    @Binding var inputText: String
    @FocusState var requestFocus : Bool
    
    var placeholder: String
    
    init(inputText: Binding<String>, placeholder: String) {
        self._inputText = inputText
        self.placeholder = placeholder
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $inputText)
                .background(Color.clear)
                .focused($requestFocus)
                .frame(width: .infinity)
            
            if (inputText.isEmpty) {
                HStack(alignment: .center){
                    Text(placeholder)
                        .padding()
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .onTapGesture {
                            requestFocus = true
                        }
                        
                    Spacer()
                }
            }
        }
    }
}



struct HintTextEditor_Previews: PreviewProvider {
    
    @State static var placeholder = "Enter"
    @State static var inputText = ""
    
    static var previews: some View {
        HintTextEditor(inputText : $inputText, placeholder :"Enter")
            .foregroundColor(ColorConstants.C10275A)
            .font(.system(size: 16))
            .background(Color.clear)
        
    }
}




