//
//  AdjustVideoView.swift
//  Vooconnect
//
//  Created by Mac on 16/06/2023.
//

import SwiftUI

struct MyVideoPlayerView: View {
//    @Binding var fullScreen: Bool
    @ObservedObject var playerVM: PlayerViewModel
    @State private var isMuted = false
    var filter_hex: String?
    var body: some View {
        ZStack {
            AVPlayerControllerRepresented(player: $playerVM.player)
//            if let filter_hex = filter_hex {
//                Rectangle()
////                    .foregroundColor(Color(filter_hex, alfa: 0.2))
//            }
            VStack {
//                HStack {
//                    Button {
//                        isMuted.toggle()
//                    } label: {
//                        Image(systemName: isMuted ? "speaker.slash.fill": "speaker.wave.2.fill")
//                            .foregroundColor(.white)
//                            .frame(width: 20, height: 20)
//                            .padding()
//                    }
//                    Spacer()
//                    Text("\(playerVM.currentTime)")
//                        .foregroundColor(.white)
//                        .font(.system(size: 10))
//                        .padding()
//                }
//                .padding(.top, fullScreen ? 80 : 0)
                Spacer()
                Button {
                    playerVM.playPause()
                } label: {
                    Image(systemName: playerVM.isPlaying ? "pause.circle.fill": "play.circle.fill")
                        .font(.system(size: 56))
                        .foregroundColor(.black.opacity(0.3))
                }
                Spacer()
            }
            Spacer()
        }
        .ignoresSafeArea()
        .onChange(of: isMuted) { value in
            playerVM.player.isMuted = value
        }
    }
}
