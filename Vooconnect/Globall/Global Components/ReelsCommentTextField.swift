//
//  ReelsCommentTextField.swift
//  Vooconnect
//
//  Created by Voconnect on 31/12/22.
//

import SwiftUI

struct ReelsCommentTextField: View {
    
    @Binding var text: String
    @Binding var showEmoji: Bool
    @Binding var showAtTheRate: Bool
    @Binding var placeholder: String
//    @Binding var color: Bool
    @FocusState private var isFocused: Bool
    
    var body: some View {
        
        ZStack {
            HStack { //MessagePurpal1
                
                TextField(placeholder, text: $text)
                    .accentColor(Color("buttionGradientTwo"))
//                    .disableAutocorrection(true)
                    .textFieldStyle(PlainTextFieldStyle())
                    .focused($isFocused)
                    .placeholderr(when: text.isEmpty) {
                        Text(placeholder).foregroundColor(.gray)
                            .opacity(0.8)
                    }
                    .foregroundColor(Color(("buttionGradientTwo")))
                
                HStack(spacing: 10) {
                    
                    Button{
                        showAtTheRate.toggle()
                        text += " @"
                        showEmoji = false
                    }label: {
                        Image(isFocused ? "AttherateLV" : "AttherateGrayRC")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    
                    Image(isFocused ? "GiftLV2" : "GiftGrayRC")
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    Button{
                        showEmoji.toggle()
                        showAtTheRate = false
                    }label: {
                        Image(isFocused ? "EmojiLV" : "EmogiGrayRC")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }

                    
                }
                .padding(.trailing, 10)
                
            }
                .padding(.leading)
                .padding(.vertical)
        }
        .frame(height: 56)
        .background(isFocused ? Color(#colorLiteral(red: 0.9566952586, green: 0.925486505, blue: 1, alpha: 1)) : Color("txtFieldBackgroun"))
//        .background(Color("txtFieldBackgroun"))
        .cornerRadius(10)
//        .shadow(color: .gray, radius: 2, x: 0, y: 3)
        
            .overlay(isFocused ? RoundedRectangle(cornerRadius: 10).stroke(Color("buttionGradientOne"), lineWidth: 2).cornerRadius(10) : RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 0).cornerRadius(10))
        
//        .overlay(focused ? RoundedRectangle(cornerRadius: 10).stroke(color ? Color(.red) : Color("buttionGradientOne"), lineWidth: 2).cornerRadius(10) : RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: color ? 2 : 0).cornerRadius(10))
        
    }
}

struct ReelsCommentTextField_Previews: PreviewProvider {
    @State static var showEmoji = false
    @State static var showAtTheRate = false
    @State static var placeholder = ""
    static var previews: some View {
        ReelsCommentTextField(text: .constant(""), showEmoji: $showEmoji, showAtTheRate: $showAtTheRate, placeholder: $placeholder)
    }
}
