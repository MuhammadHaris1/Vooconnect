//
//  AudioRecrder.swift
//  Vooconnect
//
//  Created by Mac on 12/07/2023.
//
//
//
//
///
///
///
import AVFoundation
import Foundation
import AVFAudio



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



func getVideoDuration(url: URL) -> Double? {
    let asset = AVURLAsset(url: url)
    let duration = asset.duration
    let durationSeconds = CMTimeGetSeconds(duration)
    
    if durationSeconds.isNaN {
        return nil
    } else {
        return durationSeconds
    }
}





func mergeAudioToVideo(sourceAudioPath: String, sourceVideoPath: String, completion: @escaping (URL?, Error?) -> Void) {
    
    
    let fileManager = FileManager.default
    let composition = AVMutableComposition()
    
    let videoAsset = AVURLAsset(url: URL(fileURLWithPath: sourceVideoPath))
    let audioAsset = AVURLAsset(url: URL(fileURLWithPath: sourceAudioPath))
    
    guard let audioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid),
          let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid) else {
        completion(nil, NSError(domain: "AVError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create audio and video tracks."]))
        return
    }
    
    do {
        try audioTrack.insertTimeRange(CMTimeRange(start: .zero, duration: videoAsset.duration),
                                       of: audioAsset.tracks(withMediaType: .audio)[0],
                                       at: .zero)
        
        try videoTrack.insertTimeRange(CMTimeRange(start: .zero, duration: videoAsset.duration),
                                       of: videoAsset.tracks(withMediaType: .video)[0],
                                       at: .zero)
    } catch {
        completion(nil, error)
        return
    }
    
    let exportPath = NSTemporaryDirectory().appending("\(Date()).mp4")
    let exportURL = URL(fileURLWithPath: exportPath)
    
    if fileManager.fileExists(atPath: exportPath) {
        do {
            try fileManager.removeItem(at: exportURL)
        } catch {
            completion(nil, error)
            return
        }
    }
    
    guard let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
        completion(nil, NSError(domain: "AVError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create AVAssetExportSession."]))
        return
    }
    
    exporter.outputURL = exportURL
    exporter.outputFileType = .mov
    
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

