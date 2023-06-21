//
//  Foundation+Extension.swift
//  Vooconnect
//
//  Created by Mac on 15/06/2023.
//

import AVFoundation
import Accelerate
import MobileCoreServices

func reduceNoise(from videoURL: URL, outputFileURL: URL) {
    // Create an AVAsset from the video URL
    let asset = AVAsset(url: videoURL)
    
    // Create an AVAssetExportSession to export the edited video
    guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetPassthrough) else {
        print("Failed to create AVAssetExportSession")
        return
    }
    
    // Set the output file type and destination URL
    exportSession.outputFileType = .mp4
    exportSession.outputURL = outputFileURL
    
    // Create an AVMutableComposition for audio processing
    let composition = AVMutableComposition()
    
    do {
        // Create an AVAssetTrack for the video track
        let videoTrack = try composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        // Insert the video track into the composition
        try videoTrack?.insertTimeRange(CMTimeRangeMake(start: .zero, duration: asset.duration), of: asset.tracks(withMediaType: .video)[0], at: .zero)
        
        // Create an AVAssetTrack for the audio track
        let audioTrack = try composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        // Insert the audio track into the composition
        try audioTrack?.insertTimeRange(CMTimeRangeMake(start: .zero, duration: asset.duration), of: asset.tracks(withMediaType: .audio)[0], at: .zero)
    } catch {
        print("Failed to add tracks to composition: \(error.localizedDescription)")
        return
    }
    
    // Get the audio track from the composition
    guard let audioTrack = composition.tracks(withMediaType: .audio).first else {
        print("No audio track found in the video")
        return
    }
    
    // Create an AVAudioUnitEQ to reduce noise
    let audioEQ = AVAudioUnitEQ(numberOfBands: 1)
    
    if !audioEQ.bands.isEmpty {
        // Modify the noise reduction parameters
        let noiseReduction = audioEQ.bands[0]
        
        noiseReduction.bypass = false
        noiseReduction.filterType = .parametric
        noiseReduction.frequency = 1000.0
        noiseReduction.bandwidth = 2.0
        noiseReduction.gain = -20.0
    } else {
        print("No bands found in AVAudioUnitEQ")
        return
    }
    
    // Create an AVAudioMix to apply the audio effect
    let audioMix = AVMutableAudioMix()

    // Create an AVAudioMixInputParameters object and set the audio effect
    let audioMixInputParameters = AVMutableAudioMixInputParameters(track: audioTrack)
//        audioMixInputParameters.audioTapProcessor = audioTap

    // Set the audio mix input parameters in the audio mix
    audioMix.inputParameters = [audioMixInputParameters]

    // Set the audio mix in the export session
    exportSession.audioMix = audioMix
    
    // Export the edited video
    exportSession.exportAsynchronously {
        if exportSession.status == .completed {
            print("Noise reduction completed")
        } else if exportSession.status == .failed {
            print("Noise reduction failed: \(exportSession.error?.localizedDescription ?? "")")
        }
    }
}

func reduceBackgroundNoise(in videoURL: URL, outputURL: URL, completion: @escaping (URL?, Error?) -> Void) {
    // Create AVAsset from the input video URL
    let asset = AVAsset(url: videoURL)

    // Create an AVAssetExportSession to export the modified video
    guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {
        completion(nil, NSError(domain: "com.yourapp.domain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create AVAssetExportSession"]))
        return
    }

    // Setup output settings for the export session
    exportSession.outputFileType = .mov
    exportSession.outputURL = outputURL

    // Extract the audio track from the asset
    let audioTrack = asset.tracks(withMediaType: .audio).first

    // Configure an AVAudioMix to apply audio processing to reduce noise
    let audioMix = AVAudioMix()

    // Configure an AVAudioUnitEQ to apply noise reduction filters
    let audioEQ = AVAudioUnitEQ(numberOfBands: 1)
    audioEQ.bands[0].filterType = .highPass
    audioEQ.bands[0].frequency = 500 // Adjust this value to control noise reduction level

    

    // Assign the audio mix to the export session
    exportSession.audioMix = audioMix

    // Export the video with the modified audio
    exportSession.exportAsynchronously {
        switch exportSession.status {
        case .completed:
            completion(outputURL, nil)
        case .failed:
            completion(nil, exportSession.error)
        case .cancelled:
            completion(nil, NSError(domain: "com.yourapp.domain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Export session cancelled"]))
        default:
            break
        }
    }
}

// Usage example
//let inputURL = URL(fileURLWithPath: "path_to_input_video.mov")
//let outputURL = URL(fileURLWithPath: "path_to_output_video.mov")

////////

func extractAudioFromVideo(at videoURL: URL, completion: @escaping (URL?) -> Void) {
    let asset = AVAsset(url: videoURL)
    let audioURL = temporaryURL() // URL to store the extracted audio track

    let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
    exportSession?.outputFileType = .m4a
    exportSession?.outputURL = audioURL
    exportSession?.shouldOptimizeForNetworkUse = true
    exportSession?.exportAsynchronously {
        if exportSession?.status == .completed {
            completion(audioURL)
        } else {
            completion(nil)
        }
    }
}
func reduceNoise(in audioURL: URL, completion: @escaping (URL?) -> Void) {
    guard let audioFile = try? AVAudioFile(forReading: audioURL) else {
        completion(nil)
        return
    }

    let audioFormat = audioFile.processingFormat
    let audioFrameCount = UInt32(audioFile.length)

    guard let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount) else {
        completion(nil)
        return
    }

    do {
        try audioFile.read(into: audioBuffer)
    } catch {
        completion(nil)
        return
    }

    // Apply your noise reduction algorithm to the 'audioBuffer' using the Accelerate framework or any other library

    let processedAudioURL = temporaryURL() // URL to store the processed audio track

    guard let audioFileWriter = try? AVAudioFile(forWriting: processedAudioURL, settings: audioFormat.settings) else {
        completion(nil)
        return
    }

    do {
        try audioFileWriter.write(from: audioBuffer)
        completion(processedAudioURL)
    } catch {
        completion(nil)
    }
}

func mergeAudioWithVideo(videoURL: URL, audioURL: URL, completion: @escaping (URL?) -> Void) {
    let composition = AVMutableComposition()

    let videoAsset = AVAsset(url: videoURL)
    let audioAsset = AVAsset(url: audioURL)

    let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
    let audioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)

    if let videoAssetTrack = videoAsset.tracks(withMediaType: .video).first {
        try? videoTrack?.insertTimeRange(CMTimeRange(start: .zero, duration: videoAsset.duration), of: videoAssetTrack, at: .zero)
    }

    if let audioAssetTrack = audioAsset.tracks(withMediaType: .audio).first {
        try? audioTrack?.insertTimeRange(CMTimeRange(start: .zero, duration: videoAsset.duration), of: audioAssetTrack, at: .zero)
    }

    let outputURL = temporaryURL() // URL to store the merged video with the processed audio

    guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
        completion(nil)
        return
    }

    exportSession.outputURL = outputURL
    exportSession.outputFileType = .mov
    exportSession.shouldOptimizeForNetworkUse = true
    exportSession.exportAsynchronously {
        if exportSession.status == .completed {
            completion(outputURL)
        } else {
            completion(nil)
        }
    }
}




//func reduceNoise(in audioURL: URL, completion: @escaping (URL?) -> Void) {
//    let asset = AVAsset(url: audioURL)
//    guard let audioTrack = asset.tracks(withMediaType: .audio).first else {
//        completion(nil)
//        return
//    }
//
//    let reader: AVAssetReader
//    do {
//        reader = try AVAssetReader(asset: asset)
//    } catch {
//        completion(nil)
//        return
//    }
//
//    let outputSettings = [
//        AVFormatIDKey: kAudioFormatLinearPCM,
//        AVSampleRateKey: 44100.0,
//        AVNumberOfChannelsKey: 1,
//        AVLinearPCMBitDepthKey: 16,
//        AVLinearPCMIsFloatKey: false,
//        AVLinearPCMIsBigEndianKey: false
//    ] as [String: Any]
//
//    let writer: AVAssetWriter
//    do {
//        writer = try AVAssetWriter(outputURL: temporaryURL(), fileType: .caf)
//        let output = AVAssetWriterInput(mediaType: .audio, outputSettings: outputSettings)
//        writer.add(output)
//    } catch {
//        completion(nil)
//        return
//    }
//
//    let readerOutput = AVAssetReaderTrackOutput(track: audioTrack, outputSettings: nil)
//    reader.add(readerOutput)
//    let writerInput = writer.inputs.first!
//
//    writer.startWriting()
//    reader.startReading()
//    writer.startSession(atSourceTime: .zero)
//
//    let processingQueue = DispatchQueue(label: "audio_processing_queue")
//    writerInput.requestMediaDataWhenReady(on: processingQueue) {
//        while writerInput.isReadyForMoreMediaData {
//            guard let buffer = readerOutput.copyNextSampleBuffer() else {
//                writerInput.markAsFinished()
//                writer.finishWriting(completionHandler: {
//                    completion(writer.outputURL)
//                })
//                return
//            }
//
//            if let processedBuffer = reduceNoise(for: buffer) {
//                writerInput.append(processedBuffer)
//            }
//        }
//    }
//}
//
//func reduceNoise(for buffer: CMSampleBuffer) -> CMSampleBuffer? {
//    guard let audioBuffer = CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(
//        buffer,
//        bufferListSizeNeededOut: nil,
//        bufferListOut: nil,
//        bufferListSize: MemoryLayout<AudioBufferList>.size,
//        blockBufferAllocator: kCFAllocatorDefault,
//        blockBufferMemoryAllocator: kCFAllocatorDefault,
//        flags: kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment,
//        blockBufferOut: nil
//    ) == noErr else {
//        return nil
//    }
//
//    defer {
//        audioBuffer.deallocate()
//    }
//
//    guard let audioBufferList = AudioBufferList(
//        mNumberBuffers: 1,
//        mBuffers: audioBuffer.pointee.mBuffers
//    ).duplicate() else {
//        return nil
//    }
//
//    var pcmBuffer = AVAudioPCMBuffer(
//        pcmFormat: AVAudioFormat(
//            commonFormat: .pcmFormatFloat32,
//            sampleRate: 44100.0,
//            channels: 1,
//            interleaved: false
//        )!,
//        frameCapacity: AVAudioFrameCount(audioBuffer.pointee.mBuffers.mDataByteSize) / 4 // Assuming 32-bit float samples
//    )
//
//    let channelCount = Int(pcmBuffer!.format.channelCount)
//    let sampleCount = vDSP_Length(pcmBuffer!.frameLength)
//    let samples = UnsafeMutablePointer<Float>(OpaquePointer(pcmBuffer!.audioBufferList.pointee.mBuffers.mData))
//
//    // Apply your noise reduction algorithm to the 'samples' buffer
//
//    let outputBufferList = AudioBufferList.allocate(maximumBuffers: channelCount)
//    outputBufferList[0].mNumberChannels = 1
//    outputBufferList[0].mDataByteSize = UInt32(sampleCount) * UInt32(MemoryLayout<Float>.size)
//    outputBufferList[0].mData = UnsafeMutableRawPointer(samples)
//
//    let outputFormat = AVAudioFormat(
//        commonFormat: .pcmFormatFloat32,
//        sampleRate: pcmBuffer!.format.sampleRate,
//        channels: 1,
//        interleaved: false
//    )
//    let outputBuffer = CMSampleBuffer.makeAudioBufferListWithFormatDescription(
//        formatDescription: outputFormat!.streamDescription,
//        frameCount: sampleCount,
//        frameSize: UInt32(MemoryLayout<Float>.size),
//        bufferList: outputBufferList
//    )
//
//    return outputBuffer
//}
//
func temporaryURL() -> URL {
    let directory = NSTemporaryDirectory()
    let fileName = ProcessInfo().globallyUniqueString + ".caf"
    return URL(fileURLWithPath: directory).appendingPathComponent(fileName)
}


func cropVideo(sourceURL1: URL, startTime:Float, endTime:Float)
{
    let manager = FileManager.default

    guard let documentDirectory = try? manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {return}
    let mediaType = "mp4"
    if mediaType == kUTTypeMovie as String || mediaType == "mp4" as String {
        let asset = AVAsset(url: sourceURL1 as URL)
        let length = Float(asset.duration.value) / Float(asset.duration.timescale)
        print("video length: \(length) seconds")

        let start = startTime
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
            case .failed:
                print("failed \(exportSession.error)")

            case .cancelled:
                print("cancelled \(exportSession.error)")

            default: break
            }
        }
    }
}
