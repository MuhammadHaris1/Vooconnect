//
//  View + Extensions.swift
//  Vooconnect
//
//  Created by Online Developer on 08/03/2023.
//

import SwiftUI
import FBSDKShareKit

extension View {
    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View {
        ZStack {
            self
            NavigationLink(
                "",
                destination: view,
                isActive: binding
            )
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func gradientForeground(colors: [Color] = [.gradientOne, .gradientTwo]) -> some View {
        self.overlay(
            LinearGradient(
                colors: colors,
                startPoint: .top,
                endPoint: .bottom)
        )
        .mask(self)
    }
    
    func shareOnFacebook(url: String){
        guard let url = URL(string: url) else {
            return
        }
        
        let content = ShareLinkContent()
        content.contentURL = url
        
        let dialog = ShareDialog(
            viewController: UIApplication.shared.windows.first!.rootViewController,
            content: content,
            delegate: nil
        )
        
        dialog.show()
    }
}

