//
//  AudioPlayerViewModel.swift
//  Vooconnect
//
//  Created by Mac on 15/08/2023.
//

import AVFoundation
import Combine
import SwiftUI

final class AudioPlayerViewModel: ObservableObject {
    @Published var player = AVPlayer()
    @Published var isInPipMode: Bool = false
    @Published var isPlaying = false
    @Published var isFinishedPlaying = false
    
    @Published var isEditingCurrentTime = false
    @Published var currentTime: Double = .zero
    @Published var duration: Double?
//    @State var cameraModel = CameraViewModel()
//    @State var songModel : DeezerSongModel? = DeezerSongModel()
//    @EnvironmentObject var soundsViewBlocs: SoundsViewBloc
    
    private var subscriptions: Set<AnyCancellable> = []
    private var timeObserver: Any?
    
    deinit {
        if let timeObserver = timeObserver {
            player.removeTimeObserver(timeObserver)
        }
    }
    
    init(videoUrl: URL?) {
        if let videoUrl = videoUrl {
                    self.player = AVPlayer(url: videoUrl)
                }
        $isEditingCurrentTime
            .dropFirst()
            .filter({ $0 == false })
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.player.seek(to: CMTime(seconds: self.currentTime, preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)
                if self.player.rate != 0 {
                    self.player.play()
//                    self.player.rate = cameraModel.speed
                }
            })
            .store(in: &subscriptions)
        
        player.publisher(for: \.timeControlStatus)
            .sink { [weak self] status in
                switch status {
                case .playing:
                    self?.isPlaying = true
                case .paused:
                    self?.isPlaying = false
                case .waitingToPlayAtSpecifiedRate:
                    break
                @unknown default:
                    break
                }
            }
            .store(in: &subscriptions)
        
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.001, preferredTimescale: CMTimeScale(NSEC_PER_MSEC)), queue: .main) { [weak self] time in
            guard let self = self else { return }
            if self.isEditingCurrentTime == false {
                self.currentTime = time.seconds
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didPlayToEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)

    }
    
    
    func toggleMute() {
        player.isMuted.toggle()
    }
    
    func reset(videoUrl: URL) {
        self.isInPipMode = false
        self.isPlaying = false
        self.isFinishedPlaying = false
        
        self.isEditingCurrentTime = false
        self.currentTime = .zero
        self.player = AVPlayer(url: videoUrl)
        $isEditingCurrentTime
            .dropFirst()
            .filter({ $0 == false })
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.player.seek(to: CMTime(seconds: self.currentTime, preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)
                if self.player.rate != 0 {
                    self.player.play()
                }
            })
            .store(in: &subscriptions)
        
        player.publisher(for: \.timeControlStatus)
            .sink { [weak self] status in
                switch status {
                case .playing:
                    self?.isPlaying = true
                case .paused:
                    self?.isPlaying = false
                case .waitingToPlayAtSpecifiedRate:
                    break
                @unknown default:
                    break
                }
            }
            .store(in: &subscriptions)
        
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.001, preferredTimescale: CMTimeScale(NSEC_PER_MSEC)), queue: .main) { [weak self] time in
            guard let self = self else { return }
            if self.isEditingCurrentTime == false {
                self.currentTime = time.seconds
            }
        }
        //        self.objectWillChange.send()
    }
    
    @objc func didPlayToEnd() {
        isFinishedPlaying = true
        currentTime = .zero
        self.seekVideo(toPosition: 0.0)
    }
    
    func setCurrentItem(_ item: AVPlayerItem) {
        currentTime = .zero
        duration = nil
        player.replaceCurrentItem(with: item)
        
        item.publisher(for: \.status)
            .filter({ $0 == .readyToPlay })
            .sink(receiveValue: { [weak self] _ in
                self?.duration = item.asset.duration.seconds
            })
            .store(in: &subscriptions)
    }
    
    func playPause() {
        if player.timeControlStatus == .playing {
            player.pause()
        } else {
//            self.player.rate = cameraModel.speed
            player.play()
            isFinishedPlaying = false
        }
//        isPlaying.toggle()
    }
    
    func seekVideo(toPosition position: CGFloat) {
        let time: CMTime = CMTimeMakeWithSeconds(Float64(position), preferredTimescale: player.currentTime().timescale)
        player.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
    }
}
