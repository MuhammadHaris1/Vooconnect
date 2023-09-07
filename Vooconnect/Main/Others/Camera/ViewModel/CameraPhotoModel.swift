//
//  CameraPhotoModel.swift
//  Vooconnect
//
//  Created by Vooconnect on 09/12/22.
//

import SwiftUI
import Foundation
import AVFoundation


// Camera Model...

class CameraModelPhoto: NSObject,ObservableObject,AVCapturePhotoCaptureDelegate {
    
    @Published var isTaken = false
    
    @Published var session = AVCaptureSession()
    
    @Published var alert = false
    
    // since were going to read pic data....
    @Published var output = AVCapturePhotoOutput()
    
    // preview....
    @Published var preview : AVCaptureVideoPreviewLayer!
    
    @Published var isBackCameraPhoto : Bool = true
    
    // Pic Data...
    
    @Published var isSaved = false
    
    @Published var picData = Data(count: 0)
    @Published var songModel : DeezerSongModel? = nil
    @Published var speed : Float = 1
    @Published var url : URL?
    @Published var VideoUrl : URL?
    
    private var outputSize = CGSize(width: 1079, height: 1919)
    private var imagesPerSecond: TimeInterval = 10
    private var selectedPhotosArray = [UIImage]()
    private var imageArrayToVideoURL: URL?
    private var asset: AVAsset!
    
    
    func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }

        do {
            try device.lockForConfiguration()

            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    print(error)
                }
            }

            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    func Check(isBackCamera : Bool){
        
        // first checking camerahas got permission...
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUpPhoto(isFront: isBackCamera)
            return
            // Setting Up Session
        case .notDetermined:
            // retusting for permission....
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                
                if status{
                    self.setUpPhoto(isFront: isBackCamera)
                }
            }
        case .denied:
            self.alert.toggle()
            return
            
        default:
            return
        }
    }
    
    func setUpPhoto(isFront : Bool){
        
        // setting up camera...
        
        do{
            
            // setting configs...
            self.session.beginConfiguration()
            
            if let inputs = session.inputs as? [AVCaptureDeviceInput] {
                for input in inputs {
                    session.removeInput(input)
                }
            }
            
            // change for your own...
            
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            
            let input = try AVCaptureDeviceInput(device: device!)
            
            // checking and adding to session...
            
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            
            // same for output....
            
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func switchCamera() {
        session.beginConfiguration()
        let currentInput = session.inputs.first as? AVCaptureDeviceInput
        session.removeInput(currentInput!)
        let newCameraDevice = currentInput?.device.position == .back ? getCamera(with: .front) : getCamera(with: .back)
        let newVideoInput = try? AVCaptureDeviceInput(device: newCameraDevice!)
        session.addInput(newVideoInput!)
        session.commitConfiguration()
    }

    func getCamera(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        guard let devices = AVCaptureDevice.devices(for: AVMediaType.video) as? [AVCaptureDevice] else {
            return nil
        }
        
        return devices.filter {
            $0.position == position
            }.first
    }
    
    // take and retake functions...
    
    func clearPicture(){
        self.session.startRunning()
    }
    
    func takePic(flash : Bool){
        
        
        DispatchQueue.global(qos: .background).async {
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            settings.flashMode = flash ? .on : .off
            self.output.capturePhoto(with: settings, delegate: self)
            
            DispatchQueue.main.async {
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in
                    self.session.stopRunning()
                }
                withAnimation{self.isTaken.toggle()}
            }
        }
    }
    
    func reTake(){
        
        DispatchQueue.global(qos: .background).async {
            
            self.session.startRunning()
            
            DispatchQueue.main.async {
                withAnimation{self.isTaken.toggle()}
                //clearing ...
                self.isSaved = false
                self.picData = Data(count: 0)
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            
        if let error = error {
            print(error.localizedDescription)
            return
        }
        print("picture taked")
        guard let imageData = photo.fileDataRepresentation()
                else { return }

        let image = UIImage(data: imageData)
        guard let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("outputImage.jpeg") else {
            print("error getting image url")
            return
        }
        self.url = imageURL
        print(imageURL)
        let data = image!.jpegData(compressionQuality: 100);
        do {
            try data?.write(to: imageURL);
            self.url = imageURL
            convertImageToVideo(url: imageURL)
        } catch {
            print("error saving image url")
        }
    }
    
    func createVideoFromImage(image: UIImage, originalSize: CGSize, duration: TimeInterval, completion: @escaping (Result<URL, Error>) -> Void) {
        // Clear the previous image array
        selectedPhotosArray.removeAll()
        
        
        var rotationAngle: CGFloat = 0.0
        switch image.imageOrientation {
        case .up, .upMirrored:
            rotationAngle = 0.0
        case .down, .downMirrored:
            rotationAngle = CGFloat.pi
        case .left, .leftMirrored:
            rotationAngle = -CGFloat.pi / 2
        case .right, .rightMirrored:
            rotationAngle = CGFloat.pi / 2 + (3/2 * CGFloat.pi)
        @unknown default:
            rotationAngle = 0.0
        }

        // Apply the reverse rotation transformation to bring the image to its original position
        if rotationAngle != 0.0 {
            if let rotatedImage = image.rotate(by: rotationAngle) {
                
                for i in 0...100 {
                    selectedPhotosArray.append(rotatedImage)
                }
            } else {
                for i in 0...100 {
                    selectedPhotosArray.append(image)
                }
            }
        } else {
            for i in 0...100 {
                selectedPhotosArray.append(image)
            }
        }
        
        
        // Calculate the frame rate based on the desired duration and the number of frames
        let totalFrames = Int(duration * 15) // 15 frames per second (fps)
        let repeatCount = totalFrames / selectedPhotosArray.count
        
        // Create an array to store the duplicated frames
        var duplicatedPhotosArray = [UIImage]()
        for photo in selectedPhotosArray {
            for _ in 0..<repeatCount {
                duplicatedPhotosArray.append(photo)
            }
        }
        
        // Adjust the number of frames to match the desired duration exactly
        let remainingFrames = totalFrames - duplicatedPhotosArray.count
        for i in 0..<remainingFrames {
            duplicatedPhotosArray.append(selectedPhotosArray[i % selectedPhotosArray.count])
        }
        
        // Calculate the actual duration based on the final number of frames and frame rate
        let finalDuration = Double(duplicatedPhotosArray.count) / 15
        
        if image.imageOrientation == .left || image.imageOrientation == .leftMirrored || image.imageOrientation == .right || image.imageOrientation == .rightMirrored {
            outputSize = CGSize(width: image.size.width, height: image.size.height)
        } else {
            outputSize = image.size
        }

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        imageArrayToVideoURL = documentsDirectory.appendingPathComponent("video1.MP4")

        removeFileAtURLIfExists(url: imageArrayToVideoURL)

        buildVideoFromImageArray(duration: finalDuration, completion: completion)
    }

    private func buildVideoFromImageArray(duration: TimeInterval, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let videoWriter = try? AVAssetWriter(outputURL: imageArrayToVideoURL!, fileType: .mp4) else {
            completion(.failure(NSError(domain: "VideoBuilder", code: -1, userInfo: [NSLocalizedDescriptionKey: "AVAssetWriter error"])))
            return
        }
        
        let outputSettings = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: NSNumber(value: Float(outputSize.width)),
            AVVideoHeightKey: NSNumber(value: Float(outputSize.height))
        ] as [String: Any]
        
        guard videoWriter.canApply(outputSettings: outputSettings, forMediaType: .video) else {
            completion(.failure(NSError(domain: "VideoBuilder", code: -1, userInfo: [NSLocalizedDescriptionKey: "Can't apply the Output settings..."])))
            return
        }
        
        let videoWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: outputSettings)
        let sourcePixelBufferAttributesDictionary = [
            kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32ARGB),
            kCVPixelBufferWidthKey as String: NSNumber(value: Float(outputSize.width)),
            kCVPixelBufferHeightKey as String: NSNumber(value: Float(outputSize.height))
        ]
        let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput, sourcePixelBufferAttributes: sourcePixelBufferAttributesDictionary)
        
        if videoWriter.canAdd(videoWriterInput) {
            videoWriter.add(videoWriterInput)
        }
        
        if videoWriter.startWriting() {
            let startTime = CMTime.zero
            videoWriter.startSession(atSourceTime: startTime)
            
            assert(pixelBufferAdaptor.pixelBufferPool != nil)
            let media_queue = DispatchQueue(label: "mediaInputQueue")
            
            videoWriterInput.requestMediaDataWhenReady(on: media_queue) {
                let fps: Int32 = 15
                let totalFrames = Int(duration * Double(fps))
                var frameCount: Int64 = 0
                var appendSucceeded = true
                
                // The frame duration determines the time interval between each frame (slideshow effect)
                let frameDuration = CMTimeMake(value: 1, timescale: fps)
                
                while !self.selectedPhotosArray.isEmpty {
                    if videoWriterInput.isReadyForMoreMediaData {
                        let nextPhoto = self.selectedPhotosArray.remove(at: 0)
                        let presentationTime = CMTimeMultiply(frameDuration, multiplier: Int32(frameCount))
                        var pixelBuffer: CVPixelBuffer? = nil
                        
                        let status = CVPixelBufferPoolCreatePixelBuffer(
                            kCFAllocatorDefault,
                            pixelBufferAdaptor.pixelBufferPool!,
                            &pixelBuffer
                        )
                        
                        if let pixelBuffer = pixelBuffer, status == 0 {
                            let managedPixelBuffer = pixelBuffer
                            CVPixelBufferLockBaseAddress(managedPixelBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
                            let data = CVPixelBufferGetBaseAddress(managedPixelBuffer)
                            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
                            let context = CGContext(
                                data: data,
                                width: Int(self.outputSize.width),
                                height: Int(self.outputSize.height),
                                bitsPerComponent: 8,
                                bytesPerRow: CVPixelBufferGetBytesPerRow(managedPixelBuffer),
                                space: rgbColorSpace,
                                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
                            )

                            let horizontalRatio = self.outputSize.width / nextPhoto.size.width
                            let verticalRatio = self.outputSize.height / nextPhoto.size.height
                            let scaleRatio = min(horizontalRatio, verticalRatio) // ScaleAspectFit
                            let newSize: CGSize = CGSize(width: nextPhoto.size.width * scaleRatio, height: nextPhoto.size.height * scaleRatio)
                            let x = (self.outputSize.width - newSize.width) / 2
                            let y = (self.outputSize.height - newSize.height) / 2

                            context?.draw(nextPhoto.cgImage!, in: CGRect(x: x, y: y, width: newSize.width, height: newSize.height))

                            CVPixelBufferUnlockBaseAddress(managedPixelBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
                            
                            appendSucceeded = pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: presentationTime)
                        } else {
                            print("Failed to allocate pixel buffer")
                            appendSucceeded = false
                        }
                    }
                    
                    if !appendSucceeded {
                        break
                    }
                    
                    frameCount += 1
                }
                
                videoWriterInput.markAsFinished()
                videoWriter.finishWriting {
                    print("-----video1 url = \(String(describing: self.imageArrayToVideoURL))")
                    
                    if let videoURL = self.imageArrayToVideoURL {
                        self.asset = AVAsset(url: videoURL)
                        self.exportVideoWithAnimation(completion: completion)
                    } else {
                        completion(.failure(NSError(domain: "VideoBuilder", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create video URL"])))
                    }
                }
            }
        }
    }
    
    private func exportVideoWithAnimation(completion: @escaping (Result<URL, Error>) -> Void) {
        // For now, just pass the URL back as the result.
        if let videoURL = imageArrayToVideoURL {
            completion(.success(videoURL))
        } else {
            completion(.failure(NSError(domain: "VideoBuilder", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create video URL"])))
        }
    }
    
    private func removeFileAtURLIfExists(url: URL?) {
        if let videoURL = url {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: videoURL.path) {
                do {
                    try fileManager.removeItem(at: videoURL)
                } catch let error as NSError {
                    print("Couldn't remove existing destination file: \(error)")
                }
            }
        }
    }
    
    func convertImageToVideo(url: URL) {
        // Assuming you have the image from the camera capture.
        guard let imageData = try? Data(contentsOf: url),
              let image = UIImage(data: imageData) else {
            print("Error loading the image from the URL.")
            return
        }
        
        // Perform video creation and merging asynchronously
        DispatchQueue.global().async {
            self.createVideoFromImage(image: image, originalSize: image.size, duration: 30.0) { result in
                switch result {
                case .success(let outputURL):
                    print("Video export completed successfully.")
                    print("Output URL: \(outputURL)")
                    
                    if let audioURL = URL(string: (self.songModel?.preview ?? "")!) {
                        self.mergeVideoAndAudio(videoUrl: outputURL, audioUrl: audioURL) { error, url in
                            guard let url = url else {
                                print("Error merging video and audio.")
                                return
                            }
                            print("Video and audio merge completed, new URL: \(url.absoluteString)")
                            DispatchQueue.main.async {
                                self.VideoUrl = url
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.VideoUrl = outputURL
                        }
                    }
                    
                case .failure(let error):
                    print("Video export failed with error: \(error.localizedDescription)")
                }
            }
        }

    }
    
    
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
    
    
    

    
    func savePic(){
        
        guard let image = UIImage(data: self.picData) else{return}
        
        // saving Image...
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        self.isSaved = true
        
        print("saved Successfully....")
    }
}


// setting view for preview...
struct CameraPreviewPhoto: UIViewRepresentable {
    
    @ObservedObject var camera : CameraModelPhoto
    
    func makeUIView(context: Context) ->  UIView {
     
        let view = UIView(frame: UIScreen.main.bounds)
        
        DispatchQueue.main.async {  // change
            
            camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
            camera.preview.frame = view.frame
            
            // Your Own Properties...
            camera.preview.videoGravity = .resizeAspectFill
            view.layer.addSublayer(camera.preview)
        }
        
        DispatchQueue.main.async {
            // starting session
            camera.session.startRunning()
            print("camera started--------------")
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
