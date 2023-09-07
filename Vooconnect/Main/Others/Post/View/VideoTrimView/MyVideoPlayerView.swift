//
//  MyVideoPlayerView.swift
//  Vooconnect
//
//  Created by Mac on 16/06/2023.
//

import SwiftUI
import AVFoundation

struct MyVideoPlayerView: View {
    @ObservedObject var playerVM: PlayerViewModel
    @ObservedObject var audioPlayerVM: AudioPlayerViewModel
    @State private var isMuted = false
    @Binding var speed: Float
    var filter_hex: String?
    var body: some View {
        ZStack {
            AVPlayerControllerRepresented(player: $audioPlayerVM.player)
            AVPlayerControllerRepresented(player: $playerVM.player)
        }
//        .onAppear {
//            playerVM.player.rate = speed
//        }
        .onTapGesture {
            print("Tapped view with speed: \(speed)")
            if playerVM.player.timeControlStatus == .playing{
                playerVM.player.pause()
                audioPlayerVM.player.pause()
            }else{
                playerVM.player.rate = speed
                playerVM.player.play()
                audioPlayerVM.player.play()
            }
            playerVM.player.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
            audioPlayerVM.player.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
            playerVM.player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { time in
                if let duration = self.playerVM.player.currentItem?.duration, time >= duration {
                    self.audioPlayerVM.player.pause()
                }
            }
        }
        .ignoresSafeArea()
    }
}
