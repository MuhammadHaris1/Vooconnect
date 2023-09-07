//
//  SoundEditView.swift
//  Vooconnect
//
//  Created by Mac on 08/07/2023.
//

import SwiftUI
import SwiftUIBloc
import AVFoundation
import Foundation


struct SoundEditView: View {
    @State var url: URL?
    @StateObject var playerVM: PlayerViewModel
    @StateObject var audioPlayerVM: AudioPlayerViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var postModel: PostModel
    @State var songModel: DeezerSongModel?
    @State private var isRecording: Bool = false
    @State private var isButton: Bool = false
    @State private var soundView: Bool = false
//    @State private var playVideo: Bool = false
    @State private var progress: Double = 0
    @State private var videoDuration: Double = 0
    @State private var audioRecorder: AVAudioRecorder?
    @State private var outputUrl: URL?
    @State var cameraModel = CameraViewModel()
    var soundsViewBloc = SoundsViewBloc(SoundsViewBlocState())
    var pickSong : (DeezerSongModel) -> () = {val in}
    @Binding var speed: Float
    var callWhenBack : () -> ()
    
    var body: some View{
        
        NavigationLink(destination: SoundsView(
            pickSong: {song in
                cameraModel.songModel = song
                print("new song added to video: "+(cameraModel.songModel?.preview ?? ""))
            }
        )
            .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $soundView) {
                EmptyView()
            }
        NavigationView{
            
            ZStack(alignment: .top){
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    Spacer()
                    let width = UIScreen.main.bounds.width-150
                    let height = UIScreen.main.bounds.height-420
//                    let isImage = !(url!.absoluteString.lowercased().contains(".mp4") || url!.absoluteString.lowercased().contains(".mov"))
                    RoundedRectangle(cornerRadius: 20)
                        .overlay(
                            MyVideoPlayerView(playerVM: playerVM, audioPlayerVM: audioPlayerVM, speed: $speed)
                                .mask(RoundedRectangle(cornerRadius: 20))
                        )
                        .frame(width: width, height: height)
                        .onDisappear {
                            self.playerVM.isPlaying = false
                            self.audioPlayerVM.isPlaying = false
                            print("audioView disappear============")
                            
                        }

                    Spacer()
                    Text("Suggested audio")
                        .font(.custom("Urbanist-Bold", size: 14))
                        .foregroundColor(Color.white)
                    Text("Automatically sync your clips to any track")
                        .font(.custom("Urbanist-Regular", size: 14))
                        .foregroundColor(Color.white)
                    ScrollView(.horizontal){
                        HStack (alignment: .top, spacing: 20){
                            Spacer()
                            VStack{
                                Rectangle()
                                
                                    .fill(Color.white)
                                    .frame(width: 80, height: 80)
                                    .clipped()
                                    .cornerRadius(16)
                                    .overlay(
                                        Image("searchIcon")
                                    )
                                Text("Search")
                                    .font(.custom("Urbanist-Bold", size: 14))
                                    .foregroundColor(Color.white)
                            }
                            .onTapGesture {
                                soundView.toggle()
                            }
//                            Spacer(minLength: 20)
                            BlocBuilderView(bloc: soundsViewBloc) { state in
                                ForEach(state.wrappedValue.filterSongList) { song in
                                    songListView(songModel: song)
                                }
                            }
//                            ForEach(0..<10, id: \.self) { index in
//                                MusicItemView()
//                            }
                        }
                        .padding(.bottom)
                    }
                    Spacer()
                    
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: backButton)
            }
        }
        .onAppear {
            playerVM.player.rate = speed
            self.playerVM.isPlaying = true
            self.audioPlayerVM.isPlaying = true
            soundsViewBloc.loadSongInit()
        }
        
    }
    
    func songListView(songModel : DeezerSongModel) -> some View{
//        print(songModel.id)
        //        print(soundsViewBloc.state.value.preview?.!id)
        return MusicItemView(
            songModel: songModel,
            preview: soundsViewBloc.state.value.preview,
            pickSong: {val in
                pickSong(val)
                presentationMode.wrappedValue.dismiss()
            }, playVideo: playerVM, cameraModel: $cameraModel, audioPlayerVM: audioPlayerVM
        )
        .environmentObject(soundsViewBloc)
    }
    
    func simulateVideoDownload() {
        let stepFrequency = 10 // Number of steps per second (adjust as desired)
        let totalProgressSteps = Int(videoDuration) * stepFrequency
        let stepDuration = 1.0 / Double(totalProgressSteps)

        DispatchQueue.global(qos: .background).async {
            var shouldStop = false // Flag to indicate if the progress should be stopped

            for i in 0..<totalProgressSteps {
                usleep(useconds_t(stepDuration * 1_000_000)) // Simulating delay in audio progress
                
                DispatchQueue.main.async {
                    if !isRecording {
                        shouldStop = true // Set the flag to stop the progress
                    }

                    if !shouldStop {
                        progress = Double(i + 1) / Double(totalProgressSteps)
                    }

                    if shouldStop || i == totalProgressSteps - 1 {
                        isRecording = false
                        print("Audio Recording completed")
                        stopRecording()
                    }
                }

                if shouldStop {
                    break // Exit the loop if the progress should be stopped
                }
            }
        }
    }

    
    func prepareAudioRecorder() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
            
            let audioURL = documentDirectory.appendingPathComponent("\(Date()).m4a")
            
            audioRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            audioRecorder?.prepareToRecord()
        } catch {
            print("Failed to prepare audio recorder: \(error.localizedDescription)")
        }
    }
    
    func startRecording() {
        guard let audioRecorder = audioRecorder else {
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
            audioRecorder.record()
            print("Audio recording started")
        } catch {
            print("Failed to start audio recording: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        guard let audioRecorder = audioRecorder else {
            return
        }
        audioRecorder.stop()
        print("Recording stopped.")
        
        do {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            
            removeAudioFromVideo(videoURL: postModel.contentUrl!) { outputURL, error in
                if let error = error {
                    print("Failed to remove audio: \(error.localizedDescription)")
                } else {
                    print("Audio removed successfully.")
                    DispatchQueue.main.async {
                        let audioUrlPath = audioRecorder.url.path
                        print("Audio URL Path: \(audioUrlPath)")
                        let videoUrlPath = outputURL?.path
                        print("Video URL Path: \(videoUrlPath ?? "")")
                        
                        mergeAudioToVideo(sourceAudioPath: audioUrlPath, sourceVideoPath: videoUrlPath!) { url, error in
                            if let error = error {
                                print("Error merging audio and video: \(error.localizedDescription)")
                            } else if let mergedURL = url {
                                self.outputUrl = mergedURL
                                print("Merged audio and video URL: \(mergedURL)")
                                postModel.contentUrl = mergedURL
                                print("New URL: \(String(describing: postModel.contentUrl))")
                                playerVM.reset(videoUrl: mergedURL)
                                isButton = true
                            }
                        }
                    }
                }
            }
            
            print("Recording playback started.")
        } catch {
            print("Failed to play the recording: \(error.localizedDescription)")
        }
    }


    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths)
        return paths[0]
    }
    
    
    
    
    
    var backButton: some View {
        HStack{
            Button(action: {
                // Handle back button action here
                print("back")
                presentationMode.wrappedValue.dismiss()
                playerVM.player.pause()
                cameraModel.previewURL = postModel.contentUrl
                self.callWhenBack()
            }) {
                Image("BackButtonWhite")
                //                Text("Back")
            }
            Spacer()
            Button {
                if let songURL = cameraModel.songModel?.preview{
                    do {
                        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                        
                        removeAudioFromVideo(videoURL: postModel.contentUrl!) { outputURL, error in
                            if let error = error {
                                print("Failed to remove audio: \(error.localizedDescription)")
                            } else {
                                print("Audio removed successfully.")
                                DispatchQueue.main.async {
                                    let audioUrlPath = songURL
                                    print("Audio URL Path: \(audioUrlPath)")
                                    let videoUrlPath = outputURL?.path
                                    print("Video URL Path: \(videoUrlPath ?? "")")
                                    
                                    mergeAudioToVideo(sourceAudioPath: audioUrlPath, sourceVideoPath: videoUrlPath!) { url, error in
                                        if let error = error {
                                            print("Error merging audio and video: \(error.localizedDescription)")
                                        } else if let mergedURL = url {
                                            self.outputUrl = mergedURL
                                            print("Merged audio and video URL: \(mergedURL)")
                                            postModel.contentUrl = mergedURL
                                            print("New URL: \(String(describing: postModel.contentUrl))")
                                            playerVM.reset(videoUrl: mergedURL)
                                            isButton = true
                                        }
                                    }
                                }
                            }
                        }
                        
                        print("Recording playback started.")
                    } catch {
                        print("Failed to play the recording: \(error.localizedDescription)")
                    }
                    
                }
            } label: {
                RoundedRectangle(cornerRadius: 23)
                    .fill(LinearGradient(colors: [
                        Color("buttionGradientTwo"),
                        Color("buttionGradientOne"),
                    ], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 98, height: 46)
                    .overlay (
                        Text("Done")
                            .foregroundColor(.white)
                    )
            }
        }
    }
}
class AudioCaptureDelegate: NSObject, AVCaptureAudioDataOutputSampleBufferDelegate {
    private let sampleBufferHandler: (CMSampleBuffer) -> Void
       
       init(sampleBufferHandler: @escaping (CMSampleBuffer) -> Void) {
           self.sampleBufferHandler = sampleBufferHandler
       }
       
       func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
           sampleBufferHandler(sampleBuffer)
       }
}

struct MusicItemView: View {
    @State var songModel : DeezerSongModel
    @State var preview : DeezerSongModel? = nil
    var pickSong : (DeezerSongModel) -> () = {val in}
    @EnvironmentObject var soundsViewBloc: SoundsViewBloc
    @StateObject var playVideo: PlayerViewModel
    @Binding var cameraModel: CameraViewModel
    @StateObject var audioPlayerVM: AudioPlayerViewModel
    
    var body: some View {
        VStack (alignment: .center){
            BlocBuilderView(bloc: soundsViewBloc) { state in
                ZStack{
                    if (songModel.preview != nil) {
                        AsyncImage(url: URL(string: songModel.album!.cover))
                            .frame(width: 70, height: 70)
                            .clipped()
                            .cornerRadius(16)
                    }else{
                        Image("ImageArtist")
                            .frame(width: 70, height: 70)
                            .clipped()
                            .cornerRadius(16)
                    }
//                    if(state.wrappedValue.preview != nil && state.wrappedValue.preview == songModel)
//                    {
//                        Image("PlayWhiteN")
//                            .resizable()
//                            .frame(width: 20, height: 20)
//                    }
                }
                .frame(alignment: .center)
                .button {
                    audioPlayerVM.isPlaying = false
                    cameraModel.songModel = nil
                    soundsViewBloc.playSong(songModel: songModel)
                    cameraModel.songModel = songModel
                    playVideo.player.play()
                    playVideo.player.isMuted = true
                    playVideo.player.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
                    playVideo.player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { time in
                        // Check if the video reached its end
                        if let duration = playVideo.player.currentItem?.duration, time >= duration {
                            // Stop the song when the video is done
                            soundsViewBloc.stopSong()
                        }
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text(songModel.title!)
                    .font(.custom("Urbanist-Bold", size: 14))
                    .foregroundColor(Color.white)
                Text(songModel.artist!.name)  // Medium
                    .font(.custom("Urbanist-Medium", size: 10))
                    .foregroundColor(Color.white)
                
            }
            .frame(width: 70)
        }
    }
}


//                            ZStack {
//                                Spacer()
//                                CircularProgressView(progress: progress)
//                                Button(action: {
//                                    isRecording.toggle()
//                                    if isRecording {
//                                        startRecording()
//                                        simulateVideoDownload()
//                                    } else {
//                                        stopRecording()
//                                    }
//                                }) {
//                                    Image(systemName: self.isRecording ? "mic.fill" : "mic")
//                                        .font(.system(size: 40))
//                                        .foregroundColor(.white)
//                                }
//                            }
//                            .frame(width: 50, height: 50)

//                            if self.isButton {
//                                HStack {
//                                    Button(action: {
//                                        withAnimation {
//                                            cameraModel.previewURL = postModel.contentUrl
//                                            self.callWhenBack()
//
//                                            isButton = false
//                                        }
//                                    }) {
//                                        RoundedRectangle(cornerRadius: 25)
//                                            .fill(LinearGradient(
//                                                gradient: Gradient(colors: [Color("buttionGradientTwo"), Color("buttionGradientOne")]),
//                                                startPoint: .topLeading,
//                                                endPoint: .bottomTrailing
//                                            ))
//                                            .frame(width: 98, height: 56)
//                                            .overlay(
//                                                Text("Done")
//                                                    .foregroundColor(.white)
//                                            )
//                                    }
//                                }
//                            }
