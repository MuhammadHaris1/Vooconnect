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
