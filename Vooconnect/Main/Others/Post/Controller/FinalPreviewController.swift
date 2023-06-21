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
    @Published var isRecording : Bool = false
    var audioRecorder : AVAudioRecorder!
    @Published var isPlaying: Bool = false
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    @Published var captioning: String = ""
    private var isImage : Bool
    private var speed : Float
    init(url : URL, isImage : Bool, speed : Float)
    {
        self.isImage = isImage
        self.speed = speed
        super.init()
        DispatchQueue.global(qos: .background).async{ [self] in
            if(!isImage)
            {
                self.videoPlayer = VideoMediaInput(url: url,speed: speed)
                videoPlayer.delegate = self
                setupRecognition()
                videoPlayer.onEndVideo = {
                    self.captioning = ""
//                    self.setupRecognition()
                }
                
            }else{
                videoPlayer = VideoMediaInput()
            }
        }
    }
    
    ///Play video from [videoPlayer] player
    func play(){
        videoPlayer.playVideo()
        isPlaying = true
    }
    
    ///Pause video from [videoPlayer] player
    func pause(){
        videoPlayer.pauseVideo()
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
                print("captioning is nil")
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
    
//    func cropVideo(sourceURL1: URL, startTime:Float, endTime:Float)
//    {
//        let manager = FileManager.default
//
//        guard let documentDirectory = try? manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {return}
//        let mediaType = "mp4"
//        if mediaType == kUTTypeMovie as String || mediaType == "mp4" as String {
//            let asset = AVAsset(url: sourceURL1 as URL)
//            let length = Float(asset.duration.value) / Float(asset.duration.timescale)
//            print("video length: \(length) seconds")
//
//            let start = startTime
//            let end = endTime
//
//            var outputURL = documentDirectory.appendingPathComponent("output")
//            do {
//                try manager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
//                outputURL = outputURL.appendingPathComponent("\(UUID().uuidString).\(mediaType)")
//            }catch let error {
//                print(error)
//            }
//
//            //Remove existing file
//            _ = try? manager.removeItem(at: outputURL)
//
//
//            guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {return}
//            exportSession.outputURL = outputURL
//            exportSession.outputFileType = .mp4
//
//            let startTime = CMTime(seconds: Double(start ), preferredTimescale: 1000)
//            let endTime = CMTime(seconds: Double(end ), preferredTimescale: 1000)
//            let timeRange = CMTimeRange(start: startTime, end: endTime)
//
//            exportSession.timeRange = timeRange
//            exportSession.exportAsynchronously{
//                switch exportSession.status {
//                case .completed:
//                    print("exported at \(outputURL)")
//                case .failed:
//                    print("failed \(exportSession.error)")
//
//                case .cancelled:
//                    print("cancelled \(exportSession.error)")
//
//                default: break
//                }
//            }
//        }
//    }
    
    
    
    
}
