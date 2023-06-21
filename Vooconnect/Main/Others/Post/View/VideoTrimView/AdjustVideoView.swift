//
//  AdjustVideoView.swift
//  Vooconnect
//
//  Created by Mac on 16/06/2023.
//

import SwiftUI
import UIKit
import AVFoundation
import NavigationStack
import Foundation

struct AdjustVideoView: View {
    @State private var trimStartPosition: CGFloat = 0
    @State private var trimEndPosition: CGFloat = 1
    @Environment(\.presentationMode) var presentaionMode
    @State private var finalVideoUrl = URL(string: "")
    @EnvironmentObject private var navigationModel: NavigationModel
    @State private var navigateToNextView = false
    @State var player = AVPlayer()
    @State private var frames = [UIImage]()
    @ObservedObject var slider: CustomSlider
    @State private var showAlert = false
    @State private var isEditingTrimSlider = false
    @StateObject var playerVM: PlayerViewModel
    @State private var videoSize = 0.0
    @Binding var renderUrl: URL?
    @State private var isAlert: Bool = false
    @Binding var postModel: PostModel
    var callWhenBack : () -> ()
    var body: some View {
        NavigationView{
            ZStack{
                MyVideoPlayerView(playerVM: playerVM)
                VStack{
                    HStack{
                        Text("Done")
                            .foregroundColor(.white)
                    }
                    .cornerRadius(40)
                    .frame(width: UIScreen.main.bounds.width - 40, height: 70, alignment: .trailing)
                    .padding(20)
                    .onTapGesture {
                        self.callWhenBack()
                        presentaionMode.wrappedValue.dismiss()
                    }
//
                    Spacer()
                    
                    VStack(alignment: .center){
                        
                        SliderView(playerManager: playerVM, slider: slider, frames: $frames, isEditingSlider: $isEditingTrimSlider, validError: $showAlert)
                            .padding(.vertical, 50)
                        if slider.lowHandle.currentValue > 1 || slider.highHandle.currentValue < self.playerVM.player.currentItem!.asset.duration.seconds {
                            HStack {
                                Spacer()
                                Button {
                                    withAnimation {
                                        playerVM.isPlaying = false
                                        playerVM.currentTime = .zero
                                        slider.reset(start: 1, end: self.playerVM.player.currentItem!.asset.duration.seconds)
                                    }
                                } label: {
                                    RoundedRectangle(cornerRadius: 25)
                                        .foregroundColor(.white)
                                        .frame(width: 98, height: 56)
//                                        .normalShadow()
                                        .overlay (
                                            Text("Cancel")
                                                .foregroundColor(.black)
                                        )
                                }
                                Spacer(minLength: 20)
                                Button {
                                    cropVideo(sourceURL1: renderUrl, statTime: Float(slider.lowHandle.currentValue), endTime: Float(slider.highHandle.currentValue)) { result in
                                        switch result {

                                        case .success(let outputUrl):
                                            withAnimation {
                                                self.finalVideoUrl = outputUrl
                                                self.playerVM.reset(videoUrl: outputUrl)
                                                self.getVideoFrames()
                                                self.playerVM.isPlaying = false
                                                self.playerVM.currentTime = .zero
                                                self.slider.reset(start: 1, end: self.playerVM.player.currentItem!.asset.duration.seconds)
                                                postModel.contentUrl = finalVideoUrl
                                            }
                                        case .failure(let err):
                                            print(err)
                                        }
                                    }
                                } label: {
                                    RoundedRectangle(cornerRadius: 25)
                                        .foregroundColor(Color(uiColor: UIColor(red: 0.29, green: 0.27, blue: 0.29, alpha: 1.00)))
                                        .frame(width: 98, height: 56)
                                        .overlay (
                                            Text("Trim")
                                                .foregroundColor(.white)
                                        )
                                }
                                Spacer()
                            }

                        }else{
                           Text("")
                            .frame(width: 98, height: 56)
                        }
                    }
                    .padding(.bottom)
//                    Spacer(minLength: 20)
                    
                }
            }
            .onAppear {
                getVideoFrames()
                print("Frames are \(frames)")
                    }
            .onDisappear{
//                renderUrl = finalVideoUrl
//                postModel.contentUrl = finalVideoUrl
            }
        }
        
    }
    
    func getVideoFrames() {
            self.frames.removeAll()
            let videoDuration = self.playerVM.player.currentItem!.asset.duration
            
            let generator = AVAssetImageGenerator(asset: self.playerVM.player.currentItem!.asset)
            generator.appliesPreferredTrackTransform = true
            
            var frameForTimes = [NSValue]()
            let sampleCounts = 17
            let totalTimeLength = Int(videoDuration.seconds * Double(videoDuration.timescale))
            let step = totalTimeLength / sampleCounts
            
            for i in 0 ..< sampleCounts {
                let cmTime = CMTimeMake(value: Int64(i * step), timescale: Int32(videoDuration.timescale))
                frameForTimes.append(NSValue(time: cmTime))
            }
            
            generator.generateCGImagesAsynchronously(forTimes: frameForTimes, completionHandler: {requestedTime, image, actualTime, result, error in
                DispatchQueue.main.async {
                    if let image = image {
                        print(requestedTime.value, requestedTime.seconds, actualTime.value)
                        self.frames.append(UIImage(cgImage: image))
                    }
                }
            })
        }
    
    func cropVideo(sourceURL1: URL?, statTime:Float, endTime:Float, completion: @escaping (Result<URL,Error>) -> Void ) {
        if let renderUrl = postModel.contentUrl {
            let manager = FileManager.default

            guard let documentDirectory = try? manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {return}
            let mediaType = "mp4"
            //        if mediaType == kUTTypeMovie as String || mediaType == "mp4" as String {
            if mediaType == UTType.movie.identifier as String || mediaType == "mp4" as String {
                let asset = AVAsset(url: renderUrl as URL)
                let length = Float(asset.duration.value) / Float(asset.duration.timescale)
                print("video length: \(length) seconds")

                let start = statTime
                let end = endTime

                var outputURL = documentDirectory.appendingPathComponent("output")
                do {
                    try manager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
                    outputURL = outputURL.appendingPathComponent("\(UUID().uuidString).\(mediaType)")
                }catch let error {
                    print(error)
                }

                //Remove existing file
                _ = try? manager.removeItem(at: outputURL)


                guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {return}
                exportSession.outputURL = outputURL
                exportSession.outputFileType = .mp4

                let startTime = CMTime(seconds: Double(start ), preferredTimescale: 1000)
                let endTime = CMTime(seconds: Double(end ), preferredTimescale: 1000)
                let timeRange = CMTimeRange(start: startTime, end: endTime)

                exportSession.timeRange = timeRange
                exportSession.exportAsynchronously{
                    switch exportSession.status {
                    case .completed:
                        print("exported at \(outputURL)")
                        DispatchQueue.main.async {
                            self.renderUrl = outputURL
                            completion(.success(outputURL))
                        }
                    case .failed:
                        print("failed \(String(describing: exportSession.error))")
                        completion(.failure(exportSession.error!))
                    case .cancelled:
                        print("cancelled \(String(describing: exportSession.error))")
                        completion(.failure(exportSession.error!))
                    default: break
                    }
                }
            }
        }
       
    }
}
