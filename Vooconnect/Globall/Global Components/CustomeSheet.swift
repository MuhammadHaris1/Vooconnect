//
//  CustomeSheet.swift
//  Vooconnect
//
//  Created by Vooconnect on 21/12/22.
//

import SwiftUI

extension View{
    // MARK: Custom View Modifier
    func blurredSheet<Content: View>(_ style: AnyShapeStyle,show: Binding<Bool>,onDismiss: @escaping ()->(),@ViewBuilder content: @escaping ()->Content)->some View{
        self
            .sheet(isPresented: show, onDismiss: onDismiss) {
                content()
                    .background(RemovebackgroundColor())
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .background {
                        Rectangle()
                            
                            .fill(style)
                            .ignoresSafeArea(.container, edges: .all)
                            .cornerRadius(30)
                            .padding(.bottom, -40)
                    }
            }
    }
}

// MARK: Helper View
fileprivate struct RemovebackgroundColor: UIViewRepresentable{
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            uiView.superview?.superview?.backgroundColor = .clear
        }
    }
}
