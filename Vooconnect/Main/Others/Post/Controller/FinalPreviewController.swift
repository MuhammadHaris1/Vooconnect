//
//  FinalPreviewController.swift
//  Vooconnect
//
//  Created by JV on 26/02/23.
//

import Foundation
import AVFoundation
import Accelerate
import UIKit
import SwiftVideoGenerator
import AVKit
import Speech
import MobileCoreServices

///Final preview controller
class FinalPreviewController :  NSObject , ObservableObject , AVAudioPlayerDelegate, VideoMediaInputDelegate
{
    @Published var videoPlayer = VideoMediaInput()
    @Published var audioPlayer = AudioMediaInput()
    @Published var isRecording : Bool = false
    var audioRecorder : AVAudioRecorder!
    @Published var isPlaying: Bool = false
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    @Published var captioning: String = ""
    private var isImage : Bool
    private var speed : Float
    @Published var audio: URL?
    init(url : URL, isImage : Bool, speed : Float)
    {
        self.isImage = isImage
        self.speed = speed
        super.init()
    }
    ///Load data in to the player when appear
    
    func loadData(url: URL){
        DispatchQueue.global(qos: .background).async{ [self] in
            if (self.audio != nil){
                if(!isImage){
                    self.videoPlayer = VideoMediaInput(url: url,speed: speed)
                    self.audioPlayer = AudioMediaInput(url: audio!)
                    videoPlayer.player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { time in
                        if let duration = self.videoPlayer.player.currentItem?.duration, time >= duration {
                            self.audioPlayer.player.pause()
                        }
                    }
                    videoPlayer.delegate = self
                    setupRecognition()
                }else{
                    videoPlayer = VideoMediaInput()
                }
                
            }else{
                if(!isImage){
                    self.videoPlayer = VideoMediaInput(url: url,speed: speed)
                    videoPlayer.delegate = self
                    setupRecognition()
                    videoPlayer.onEndVideo = {
                        self.audioPlayer.player.pause()
//                        self.captioning = ""
                        self.setupRecognition()
                    }
                    
                }else{
                    videoPlayer = VideoMediaInput()
                }
            }
        }
    }
    ///Play video from [videoPlayer] player
    func play(){
        videoPlayer.playVideo()
        audioPlayer.playAudio()
        videoPlayer.player.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
        audioPlayer.player.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
        videoPlayer.player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { time in
            if let duration = self.videoPlayer.player.currentItem?.duration, time >= duration {
                self.audioPlayer.player.pause()
            }
        }
        isPlaying = true
    }
    
    ///Pause video from [videoPlayer] player
    func pause(){
        videoPlayer.pauseVideo()
        audioPlayer.pauseAudio()
        
        isPlaying = false
    }
    
    ///Force AVPlayer to play the video
    func forcePlay(){
        play()
    }
    
    ///Set new `URL` to be played with the `videoPlayer` player
    func setNewUrl(url : URL)
    {
        if(isImage)
        {
            return
        }
        DispatchQueue.global(qos: .background).async{ [self] in
            self.videoPlayer = VideoMediaInput(url: url, speed: self.speed)
            self.videoPlayer.delegate = self
            self.setupRecognition()
        }
        
        
    }
    
    func videoFrameRefresh(sampleBuffer: CMSampleBuffer) {
        recognitionRequest?.appendAudioSampleBuffer(sampleBuffer)
    }
    
    private func setupRecognition() {
        let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        // we want to get continuous recognition and not everything at once at the end of the video
        recognitionRequest.shouldReportPartialResults = true
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            if let result = result {
                self?.captioning = result.bestTranscription.formattedString
            }else{
                print("captioning is nil and error is \(String(describing: error?.localizedDescription))")
            }

            // if connected to internet, then once in about every minute recognition task finishes
            // so we need to set up a new one to continue recognition
            if result?.isFinal == true {
                self?.recognitionRequest = nil
                self?.recognitionTask = nil

                self?.setupRecognition()
            }
        }
        self.recognitionRequest = recognitionRequest
    }
    
    
    ///Add microphone audio to the video
    func editAudio(){
        
    }
    
    
    
    func removeAudioFromVideo(videoURL: URL, completion: @escaping (URL?, Error?) -> Void) {
        let fileManager = FileManager.default
        let composition = AVMutableComposition()

        guard let sourceAsset = AVURLAsset(url: videoURL) as AVAsset? else {
            completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid video asset"]))
            return
        }

        guard let compositionVideoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to add video track"]))
            return
        }

        guard let sourceVideoTrack = sourceAsset.tracks(withMediaType: .video).first else {
            completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Video track not found"]))
            return
        }

        let timeRange = CMTimeRange(start: .zero, duration: sourceAsset.duration)

        do {
            try compositionVideoTrack.insertTimeRange(timeRange, of: sourceVideoTrack, at: .zero)
        } catch {
            completion(nil, error)
            return
        }

        // Create a layer instruction for the video track
        let videoLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTrack)

        // Get the track's natural size
        let naturalSize = sourceVideoTrack.naturalSize

        // Check if the video track's dimensions need to be swapped
        let shouldSwapDimensions = needsSwapDimensions(for: sourceVideoTrack.preferredTransform)

        // Swap the dimensions if necessary
        let renderSize: CGSize = shouldSwapDimensions ? CGSize(width: naturalSize.height, height: naturalSize.width) : naturalSize

        // Create a transform to rotate the video
        let transform = sourceVideoTrack.preferredTransform

        // Apply the transform to the layer instruction
        videoLayerInstruction.setTransform(transform, at: .zero)

        let videoCompositionInstruction = AVMutableVideoCompositionInstruction()
        videoCompositionInstruction.timeRange = CMTimeRange(start: .zero, duration: composition.duration)
        videoCompositionInstruction.layerInstructions = [videoLayerInstruction]

        // Create a video composition and set the instructions
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = renderSize
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
        videoComposition.instructions = [videoCompositionInstruction]

        // Export the video
        let exportPath = NSTemporaryDirectory().appending("\(Date()).mp4")
        let exportURL = URL(fileURLWithPath: exportPath)

        if fileManager.fileExists(atPath: exportPath) {
            do {
                try fileManager.removeItem(at: exportURL)
            } catch {
                completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to remove existing export file"]))
                return
            }
        }

        guard let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
            completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create AVAssetExportSession"]))
            return
        }

        // Set the video composition for the exporter
        exporter.videoComposition = videoComposition

        // Rotate the video track to its original size
        compositionVideoTrack.preferredTransform = transform.inverted()

        exporter.outputURL = exportURL
        exporter.outputFileType = .mp4

        exporter.exportAsynchronously {
            DispatchQueue.main.async {
                if exporter.status == .completed {
                    completion(exportURL, nil)
                } else {
                    completion(nil, exporter.error)
                }
            }
        }
    }

    // Function to check if video track's dimensions need to be swapped
    func needsSwapDimensions(for transform: CGAffineTransform) -> Bool {
        return transform.a == 0 && transform.d == 0 && (transform.b == 1.0 || transform.b == -1.0) && (transform.c == 1.0 || transform.c == -1.0)
    }
    
    ///add record audio to video
    
    
    
    
    ///Calling text to speech GCP API
    func textToSpeech(post : PostModel, callback : @escaping (URL) -> ()){
        let content = post.getTextOverlayContent
        if(content == nil)
        {
            return
        }
        let body: [String: Any] = ["input": ["ssml": "<speak>\(content!.value)</speak>"], "voice":["languageCode":"en-us","ssmlGender":"FEMALE","name":"en-US-Standard-B"],"audioConfig":["audioEncoding" : "MP3"]]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
//        let url = URL(string: "https://texttospeech.googleapis.com/v1/text:synthesize")
        let queryItems = [URLQueryItem(name: "key", value: "AIzaSyBcHMcpG_B_ucS_ib5xc2u7kSnh2fksqFg")]
        var urlComps = URLComponents(string: "https://texttospeech.googleapis.com/v1/text:synthesize")!
        urlComps.queryItems = queryItems
        var request = URLRequest(url: urlComps.url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }

            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            print("-----1> responseJSON: \(String(describing: responseJSON))")
            if let responseJSON = responseJSON as? [String: Any] {
                do{
                    print("-----2> responseJSON: \(responseJSON)")
                    let audioString = responseJSON["audioContent"] as? String ?? ""
                    let audioData = Data(base64Encoded: audioString, options: .ignoreUnknownCharacters)
                    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                    let fileUrl = URL(fileURLWithPath: documentsPath).appendingPathComponent("textToSpeech.mp3")
                    if FileManager.default.fileExists(atPath:fileUrl.path) {
                        try? FileManager.default.removeItem(at:fileUrl)
                    }
                    try audioData?.write(to: fileUrl)
                    DispatchQueue.main.async {
//                        SoundsManagerHelper.instance.playAudioFromUrl(url: fileUrl.absoluteString)
                        callback(fileUrl)
                    }
                }catch(let error){
                    print(error.localizedDescription)
                }
                
            }
        }
        task.resume()
        
        
    }
    
    ///STICKERS SECTION
    ///
    
//    func addStickerToVide(videoUrl : URL,callback : @escaping (URL) -> ()){
//        DispatchQueue.global(qos: .background).async {
//            if let urlData = try? Data(contentsOf: videoUrl) {
//                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//                let fileUrl = URL(fileURLWithPath: documentsPath).appendingPathComponent("out1.mp4")
//                if FileManager.default.fileExists(atPath:fileUrl.path) {
//                    try? FileManager.default.removeItem(at:fileUrl)
//                    print("removed")
//                }
//                try? urlData.write(to: fileUrl)
//                self.mergeVideoAndImage(video: fileUrl, withForegroundImages:[UIImage(named: "PreviewStickers.png")!],imagePosition: CGSize(width: 20, height: 20), completion: { (url) in
//                    guard let url = url else{
//                        return
//                    }
//                        DispatchQueue.main.async {
//                            callback(url)
//                        }
//                })
//            }
//        }
//    }
    
    ///Storing UIImage in to temp directory
    func storeImage(_ uiImage : UIImage, callback : @escaping (URL) -> ()){
        guard let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("fpOutput.png") else {
            print("error getting image url")
            return
        }
        let pngData = uiImage.pngData();
        do {
            try pngData?.write(to: imageURL);
            callback(imageURL)
        } catch {
            print("error saving image url")
        }
    }
    
    ///Merging video with and image and output and url
    func mergeVideoAndImage(
            video videoUrl: URL,
            withForegroundImages images: [(UIImage,CGSize)],
            completion: @escaping (URL?) -> Void) -> () {
                let tempUrlString = NSTemporaryDirectory().appending("outTemp.mp4")
                let outputUrlString = NSTemporaryDirectory().appending("_outFP.mp4")
                let outputPath = URL(fileURLWithPath: outputUrlString)
                if FileManager.default.fileExists(atPath: (outputPath.path)) {
                    do {
                        try FileManager.default.removeItem(atPath: (outputPath.path))
                    }
                    catch {
                        print ("Error deleting file")
                    }
                }
                
                if FileManager.default.fileExists(atPath: (URL(fileURLWithPath: tempUrlString).path)) {
                    do {
                        try FileManager.default.removeItem(atPath: (URL(fileURLWithPath: tempUrlString).path))
                    }
                    catch {
                        print ("Error deleting temp file")
                    }
                }
                
                //input file
                print(videoUrl.absoluteString)
                print(tempUrlString)
                print(outputUrlString)
                do{
                    let data = try Data(contentsOf: videoUrl)
                    try data.write(to: URL(fileURLWithPath: tempUrlString))
                    let asset = AVAsset.init(url: URL(fileURLWithPath: tempUrlString))
                    print (asset)
                    let composition = AVMutableComposition.init()
                    composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
                    let first = CMTimeRange(start: CMTime.zero, duration: asset.duration)
                    let fullRange = CMTimeRange(start: CMTime.zero, duration: CMTime(value: asset.duration.value, timescale: CMTimeScale(self.speed)))
                    composition.scaleTimeRange(first, toDuration: fullRange.duration)

                    //input clip
                    let clipVideoTrack = asset.tracks(withMediaType: AVMediaType.video)[0]

                    let parentlayer = CALayer()
                    let videoLayer = CALayer()

                    parentlayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                    videoLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                    
                    parentlayer.addSublayer(videoLayer)
                    
                    //Adding watermarks to the video
                    images.forEach{ image in
                        let imglogo = image.0
                        let watermarkLayer = CALayer()
                        let imagePosition = image.1
                        watermarkLayer.contents = imglogo.cgImage
                        let imageSize = CGSize(width: imglogo.size.width * 0.325, height: imglogo.size.height * 0.325)
                        let x = (UIScreen.main.screenWidth()/2) + (imagePosition.width * 1) - (imageSize.width * 0.5)
                        let y = (UIScreen.main.screenHeight()/2) + (imagePosition.height * -1) - (imageSize.height * 0.5)
                        watermarkLayer.frame = CGRect(x: x , y: y,width: imageSize.width, height: imageSize.height)
                        watermarkLayer.contentsRect = CGRect(x: 0, y: 0.1, width: 1, height: 1)
                        watermarkLayer.opacity = 1
    //                    watermarkLayer.borderWidth = 2.0
    //                    watermarkLayer.borderColor = CGColor.init(red: 100, green: 0, blue: 0, alpha: 1)
                        watermarkLayer.masksToBounds = true
                        parentlayer.addSublayer(watermarkLayer)
                    }
                    
                    let videoComposition = AVMutableVideoComposition()
                    videoComposition.renderSize = CGSize(width: parentlayer.frame.width, height: parentlayer.frame.height) //change it as per your needs.
                    videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
                    videoComposition.renderScale = 1.0

                    //creating videoComposition
                    videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayers: [videoLayer], in: parentlayer)

                    let instruction = AVMutableVideoCompositionInstruction()
                    instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: CMTimeMakeWithSeconds(Float64(60/self.speed), preferredTimescale: Int32(30/self.speed)))
                    let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: clipVideoTrack)
                    var t1 = CGAffineTransform(translationX: UIScreen.main.screenWidth() != clipVideoTrack.naturalSize.width ? clipVideoTrack.naturalSize.width/4 : 0, y: (clipVideoTrack.naturalSize.height * 0))
                    if(UIScreen.main.screenWidth() != clipVideoTrack.naturalSize.width)
                    {
                        t1 = t1.scaledBy(x: 0.475, y: 0.475)
                    }
                    print(clipVideoTrack.naturalSize.width)
                    print(clipVideoTrack.naturalSize.height)
                    print(UIScreen.main.screenWidth())
                    print(UIScreen.main.screenHeight())
                    let t2: CGAffineTransform = UIScreen.main.screenWidth() != clipVideoTrack.naturalSize.width ? t1.rotated(by: .pi/2) : t1
                    let finalTransform: CGAffineTransform = t2
                    transformer.setTransform(finalTransform, at: CMTime.zero)
                    instruction.layerInstructions = [transformer]
                    videoComposition.instructions = [instruction]
                    let exporter = AVAssetExportSession.init(asset: asset, presetName: AVAssetExportPresetHighestQuality)
                    exporter?.outputFileType = AVFileType.mov
                    exporter?.outputURL = outputPath
                    exporter?.videoComposition = videoComposition
                    
                    //Exporting video
                    exporter?.exportAsynchronously() { //handler -> Void in
                        if exporter?.status == .completed {
                            print("Export complete")
                            DispatchQueue.main.async(execute: {
                                completion(outputPath)
                            })
                            return
                        } else if exporter?.status == .failed {
                            print("Export failed - \(String(describing: exporter?.error))")
                        }
                        completion(nil)
                        return
                    }
                }catch(let error)
                {
                    print("merge video error - " + error.localizedDescription)
                }
        }
    
    
    ///AUDIO SECTION
    func startRecording(){
        
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Can not setup the Recording")
        }
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dateFormatter = DateFormatter()
        let fileName = path.appendingPathComponent("CO-Voice : \(dateFormatter.string(from: Date())).wav")
        
        
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            isRecording = true
            
        } catch {
            print("Failed to Setup the Recording")
        }
    }
    
    func stopRecording(){
        audioRecorder?.stop()
    }
    
//    ///refresh videoplayer
//    
//    private func refreshVideoPlayer() {
//            // Remove any existing player and playerLayer
//            player?.pause()
//            player = nil
//            playerLayer?.removeFromSuperlayer()
//            playerLayer = nil
//            
//            // Create a new AVPlayer with the updated URL
//            if let videoURL = videoURL {
//                player = AVPlayer(url: videoURL)
//                playerLayer = AVPlayerLayer(player: player)
//                
//                // Configure the playerLayer to fit the view's bounds
//                playerLayer?.frame = view.bounds
//                view.layer.addSublayer(playerLayer!)
//                
//                // Start playing the video
//                player?.play()
//            }
//        }
    
    //Get the audio from video, callback the url of the file
    
    func getAudioFromVideoUrl(url : String, callback : @escaping (URL) -> ()) {
        // Create a composition
        let composition = AVMutableComposition()
        do {
            let asset = AVURLAsset(url: URL(string: url)!)
             let audioAssetTrack = asset.tracks(withMediaType: AVMediaType.audio).first
             let audioCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
            try audioCompositionTrack!.insertTimeRange(audioAssetTrack!.timeRange, of: audioAssetTrack!, at: CMTime.zero)
            let outputUrl = URL(fileURLWithPath: NSTemporaryDirectory() + "out.m4a")
            if FileManager.default.fileExists(atPath: outputUrl.path) {
                try? FileManager.default.removeItem(atPath: outputUrl.path)
            }

            // Create an export session
            let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetPassthrough)!
            exportSession.outputFileType = AVFileType.m4a
            exportSession.outputURL = outputUrl

            // Export file
            exportSession.exportAsynchronously {
                if(exportSession.status == AVAssetExportSession.Status.completed)
                {
                    let outputURL = exportSession.outputURL
                    callback(outputURL!)
                }else{
                    print("GAFVU not completed")
                }
            }
        } catch {
            print("GAFVU: "+error.localizedDescription)
        }

        
    }
    
    func noiseReductionToVideo(videoUrl : String, callback : @escaping (URL) -> ()){
        getAudioFromVideoUrl(url: videoUrl, callback: {val in
            var signal = self.convertAudioToSignal(url: val.absoluteString)
            vDSP.threshold(signal,to: 1,with: .zeroFill,result: &signal)
            let inverseDCTSetup = vDSP.DCT(count: 1024,transformType: vDSP.DCTTransformType.III)
            var inverseDCT = inverseDCTSetup!.transform(signal)
            let divisor = Float(1024 / 2)
            vDSP.divide(inverseDCT,
                        divisor,
                        result: &inverseDCT)
            self.convertSignalToAudio(floatArray: signal, callback: {val2 in
                SoundsManagerHelper.instance.pause()
                SoundsManagerHelper.instance.playAudioFromUrl(url: val2.absoluteString)
            })
        })
    }
    
    private func convertSignalToAudio(floatArray : [Float], callback : @escaping (URL) -> ()){
        do{
            var floats = floatArray
            let audioBuffer = AudioBuffer(mNumberChannels: 1, mDataByteSize: UInt32(floats.count * MemoryLayout<Float>.size), mData: &floats)
            var bufferList = AudioBufferList(mNumberBuffers: 1, mBuffers: audioBuffer)
            let inputFormat = AVAudioFormat(
                                commonFormat: .pcmFormatFloat32,
                                sampleRate: 44100,
                                channels: AVAudioChannelCount(1),
                                interleaved: false
                            )!
            let outputAudioBuffer = AVAudioPCMBuffer(pcmFormat: inputFormat, bufferListNoCopy: &bufferList)!
            let settings: [String: Any] = [
                AVFormatIDKey: outputAudioBuffer.format.settings[AVFormatIDKey] ?? kAudioFormatLinearPCM,
                AVNumberOfChannelsKey: outputAudioBuffer.format.settings[AVNumberOfChannelsKey] ?? 1,
                AVSampleRateKey: outputAudioBuffer.format.settings[AVSampleRateKey] ?? 44100,
                AVLinearPCMBitDepthKey: outputAudioBuffer.format.settings[AVLinearPCMBitDepthKey] ?? 32
            ]

            let outputUrl = URL(fileURLWithPath: NSTemporaryDirectory() + "out2.wav")
            if FileManager.default.fileExists(atPath: outputUrl.path) {
                try? FileManager.default.removeItem(atPath: outputUrl.path)
            }
            let output = try AVAudioFile(forWriting: outputUrl, settings: settings, commonFormat: outputAudioBuffer.format.commonFormat, interleaved: outputAudioBuffer.format.isInterleaved)
            print("starting to save audio file")
            try output.write(from: outputAudioBuffer)
            print("saved audio on: "+output.url.path)
            callback(output.url)
        }catch{
            print("CSTA: "+error.localizedDescription)
        }
//
    }
    
    private func convertAudioToSignal(url : String) -> [Float]{
        if let url = URL(string: url) {
            let file = try! AVAudioFile(forReading: url)
            print("sample rate: "+file.fileFormat.sampleRate.description)
            if let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: 1, interleaved: false) {
                if let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: 44100) {
                    try! file.read(into: buf)

                    // this makes a copy, you might not want that
                    let floatArray = Array(UnsafeBufferPointer(start: buf.floatChannelData?[0], count:Int(buf.frameLength)))
                    return floatArray
                }
            }
        }
        print("CATS: array is empty")
        return []
    }
    
    ///Merging video and audio
    func mergeVideoAndAudio(videoUrl: URL,audioUrl: URL,shouldFlipHorizontally: Bool = false,
                            completion: @escaping (_ error: Error?, _ url: URL?) -> Void) {

        
        let mixComposition = AVMutableComposition()
        var mutableCompositionVideoTrack = [AVMutableCompositionTrack]()
        var mutableCompositionAudioTrack = [AVMutableCompositionTrack]()
        var mutableCompositionAudioOfVideoTrack = [AVMutableCompositionTrack]()

        //start merge

        let aVideoAsset = AVAsset(url: videoUrl)
        let aAudioAsset = AVAsset(url: audioUrl)
        let compositionAddVideo = mixComposition.addMutableTrack(withMediaType: AVMediaType.video,
                                                                       preferredTrackID: kCMPersistentTrackID_Invalid)
        
        
        let compositionAddAudio = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio,
                                                                 preferredTrackID: kCMPersistentTrackID_Invalid)!

        let compositionAddAudioOfVideo = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio,
                                                                        preferredTrackID: kCMPersistentTrackID_Invalid)!
        
        let first = CMTimeRange(start: CMTime.zero, duration: aVideoAsset.duration)
        let fullRange = CMTimeRange(start: CMTime.zero, duration: CMTime(value: aVideoAsset.duration.value, timescale: CMTimeScale(self.speed)))
        compositionAddVideo?.scaleTimeRange(first, toDuration: fullRange.duration)
        compositionAddAudio.scaleTimeRange(first, toDuration: fullRange.duration)
        compositionAddAudioOfVideo.scaleTimeRange(first, toDuration: fullRange.duration)

        let aVideoAssetTrack: AVAssetTrack = aVideoAsset.tracks(withMediaType: AVMediaType.video)[0]
        let aAudioOfVideoAssetTrack: AVAssetTrack? = aVideoAsset.tracks(withMediaType: AVMediaType.audio).first
        let aAudioAssetTrack: AVAssetTrack = aAudioAsset.tracks(withMediaType: AVMediaType.audio)[0]

        // Default must have tranformation
        compositionAddVideo?.preferredTransform = aVideoAssetTrack.preferredTransform

        if shouldFlipHorizontally {
            // Flip video horizontally
            var frontalTransform: CGAffineTransform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            frontalTransform = frontalTransform.translatedBy(x: -aVideoAssetTrack.naturalSize.width, y: 0.0)
            frontalTransform = frontalTransform.translatedBy(x: 0.0, y: -aVideoAssetTrack.naturalSize.width)
            compositionAddVideo?.preferredTransform = frontalTransform
        }

        mutableCompositionVideoTrack.append(compositionAddVideo!)
        mutableCompositionAudioTrack.append(compositionAddAudio)
        mutableCompositionAudioOfVideoTrack.append(compositionAddAudioOfVideo)
        

        do {
            try mutableCompositionVideoTrack[0].insertTimeRange(CMTimeRangeMake(start: CMTime.zero,
                                                                                duration: aVideoAssetTrack.timeRange.duration),
                                                                of: aVideoAssetTrack,
                                                                at: CMTime.zero)

            //In my case my audio file is longer then video file so i took videoAsset duration
            //instead of audioAsset duration
            try mutableCompositionAudioTrack[0].insertTimeRange(CMTimeRangeMake(start: CMTime.zero,
                                                                                duration: aVideoAssetTrack.timeRange.duration),
                                                                of: aAudioAssetTrack,
                                                                at: CMTime.zero)

            // adding audio (of the video if exists) asset to the final composition
            if let aAudioOfVideoAssetTrack = aAudioOfVideoAssetTrack {
                try mutableCompositionAudioOfVideoTrack[0].insertTimeRange(CMTimeRangeMake(start: CMTime.zero,
                                                                                           duration: aVideoAssetTrack.timeRange.duration),
                                                                           of: aAudioOfVideoAssetTrack,
                                                                           at: CMTime.zero)
            }
            
        } catch {
            print(error.localizedDescription)
        }

        // Exporting
        let savePathUrl: URL = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/newVideo.mp4")
        do { // delete old video
            try FileManager.default.removeItem(at: savePathUrl)
        } catch { print(error.localizedDescription) }
        
        let assetExport: AVAssetExportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)!
        assetExport.outputFileType = AVFileType.mp4
        assetExport.outputURL = savePathUrl
        assetExport.shouldOptimizeForNetworkUse = true
        

        assetExport.exportAsynchronously { () -> Void in
            switch assetExport.status {
            case AVAssetExportSession.Status.completed:
                print("success")
                completion(nil, savePathUrl)
            case AVAssetExportSession.Status.failed:
                print("failed \(assetExport.error?.localizedDescription ?? "error nil")")
                completion(assetExport.error, nil)
            case AVAssetExportSession.Status.cancelled:
                print("cancelled \(assetExport.error?.localizedDescription ?? "error nil")")
                completion(assetExport.error, nil)
            default:
                print("complete")
                completion(assetExport.error, nil)
            }
        }

    }
    
    
    
    ///AVAssetReader to read video frames

    
    func setupAssetReader(asset: AVAsset) -> (AVAssetReader, CGSize)? {
        do {
            let reader = try AVAssetReader(asset: asset)
            
            // Define the video track to read
            guard let videoTrack = asset.tracks(withMediaType: .video).first else {
                return nil
            }
            
            let naturalSize = videoTrack.naturalSize
            
            let outputSettings: [String: Any] = [
                kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
            ]
            
            let readerOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: outputSettings)
            readerOutput.alwaysCopiesSampleData = false
            reader.add(readerOutput)
            
            return (reader, naturalSize)
        } catch {
            print("Error setting up AVAssetReader: \(error.localizedDescription)")
            return nil
        }
    }

    
    ///AVAssetWriter to write the processed video
    
    
    func setupAssetWriter(url: URL, width: Int, height: Int) -> AVAssetWriter? {
        do {
            let writer = try AVAssetWriter(outputURL: url, fileType: .mp4)
            
            let outputSettings: [String: Any] = [
                AVVideoCodecKey: AVVideoCodecType.h264,
                AVVideoWidthKey: width,
                AVVideoHeightKey: height
            ]
            
            let writerInput = AVAssetWriterInput(mediaType: .video, outputSettings: outputSettings)
            writerInput.expectsMediaDataInRealTime = false
            writer.add(writerInput)
            
            return writer
        } catch {
            print("Error setting up AVAssetWriter: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    ///noise reduction function using a CIFilter

    func applyNoiseReduction(to pixelBuffer: CVPixelBuffer) -> CVPixelBuffer? {
        let inputImage = CIImage(cvPixelBuffer: pixelBuffer)
        guard let noiseReductionFilter = CIFilter(name: "CINoiseReduction") else {
            return nil
        }
        
        noiseReductionFilter.setValue(inputImage, forKey: kCIInputImageKey)
        noiseReductionFilter.setValue(0.02, forKey: "inputNoiseLevel")
        noiseReductionFilter.setValue(0.4, forKey: "inputSharpness")
        
        guard let outputImage = noiseReductionFilter.outputImage else {
            return nil
        }
        
        let context = CIContext()
        var outputPixelBuffer: CVPixelBuffer?
        CVPixelBufferCreate(nil, CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer), kCVPixelFormatType_32BGRA, nil, &outputPixelBuffer)
        context.render(outputImage, to: outputPixelBuffer!)
        
        return outputPixelBuffer
    }

    ///Process and denoise the video frames
    
    func denoiseVideo(inputURL: URL, outputURL: URL, completion: @escaping (URL?) -> Void) {
        let videoAsset = AVAsset(url: inputURL)

        guard let (reader, videoSize) = setupAssetReader(asset: videoAsset) else {
            print("Error setting up AVAssetReader.")
            completion(nil) // Call completion with nil to indicate an error
            return
        }

        guard let writer = setupAssetWriter(url: outputURL, width: Int(videoSize.width), height: Int(videoSize.height)) else {
            print("Error setting up AVAssetWriter.")
            completion(nil) // Call completion with nil to indicate an error
            return
        }

        let writerInput = writer.inputs.first!
        writer.startWriting()
        reader.startReading()
        writer.startSession(atSourceTime: CMTime.zero)

        let videoProcessingQueue = DispatchQueue(label: "com.yourapp.videoProcessingQueue")
        writerInput.requestMediaDataWhenReady(on: videoProcessingQueue) {
            while writerInput.isReadyForMoreMediaData {
                if let sampleBuffer = reader.outputs.first?.copyNextSampleBuffer() {
                    // Perform noise reduction on the sampleBuffer's video frame
                    if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
                        let denoisedPixelBuffer = self.applyNoiseReduction(to: pixelBuffer)
                        if let denoisedBuffer = denoisedPixelBuffer {
                            // Create a new CMSampleBuffer with the denoised pixel buffer
                            var newSampleBuffer: CMSampleBuffer?
                            var timingInfo = CMSampleTimingInfo()
                            CMSampleBufferGetSampleTimingInfo(sampleBuffer, at: 0, timingInfoOut: &timingInfo)

                            // Create CMVideoFormatDescription for the denoised pixel buffer
                            var formatDescription: CMVideoFormatDescription?
                            CMVideoFormatDescriptionCreateForImageBuffer(allocator: kCFAllocatorDefault, imageBuffer: denoisedBuffer, formatDescriptionOut: &formatDescription)

                            // Create the new sample buffer with the format description and timing info
                            CMSampleBufferCreateReadyWithImageBuffer(allocator: kCFAllocatorDefault,
                                                                     imageBuffer: denoisedBuffer,
                                                                     formatDescription: formatDescription!,
                                                                     sampleTiming: &timingInfo,
                                                                     sampleBufferOut: &newSampleBuffer)

                            // Append the denoised sample buffer to the writerInput
                            if let newSampleBuffer = newSampleBuffer {
                                writerInput.append(newSampleBuffer)
                            }
                        }
                    }
                } else {
                    writerInput.markAsFinished()
                    writer.finishWriting {
                        // Call the completion handler with the output URL once the writing is finished
                        completion(outputURL)
                    }
                    break
                }
            }
        }
    }

}
