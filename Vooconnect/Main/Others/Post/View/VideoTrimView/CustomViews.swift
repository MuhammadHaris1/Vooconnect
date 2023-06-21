//
//  AdjustVideoView.swift
//  Vooconnect
//
//  Created by Mac on 16/06/2023.
//

import SwiftUI
import NavigationStack
import PDFKit
import Kingfisher
import WrappingHStack
import UniformTypeIdentifiers

struct MyLink: View {
    var url = "https://www.google.com/"
    var text: String
    var fontSize: CGFloat = 13
    var body: some View {
        Link(destination: URL(string: url)!, label: {
            Text(text)
                .font(.system(size: fontSize))
                .underline()
        })
    }
}

import AVKit
struct AVPlayerControllerRepresented : UIViewControllerRepresentable {
    @Binding var player : AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = player
    }
}

struct NewMenuBaseView<Content: View>: View {
    @EnvironmentObject private var navigationModel: NavigationModel
    @State private var confirmAlert = false
    let content: Content
    var title: String
    var alertTitle: String
    var height: CGFloat
    var backButton: Bool
    var padding: Bool
    var viewId = ""
    
    init(padding: Bool = true, height: CGFloat = 105, title: String, backButton: Bool = true,alertTitle: String, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.title = title
        self.height = height
        self.backButton = backButton
        self.padding = padding
        self.alertTitle = alertTitle
    }
    var body: some View {
        ZStack {
            VStack(spacing: 0.0) {
                HStack {
                        if backButton {
                            Button(action: {
                                confirmAlert.toggle()
                            }) {
                                Image(systemName: "chevron.backward")
                                    .foregroundColor(Color.white)
                            }
                            .frame(height: 44)
                            .padding(.leading)
                        }
                        Spacer()
                        Text(title)
                            .foregroundColor(.white)
                            .font(.system(size: 17))
                            .fontWeight(.semibold)
//                            .if(!backButton) {$0.padding(.bottom)}
                        Spacer()
                    }
                ScrollView(showsIndicators: false) {
                    VStack {
                        content
                    }
                }
                .background(Color.white)
            }
        }
    }
}
