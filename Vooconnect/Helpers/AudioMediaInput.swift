//
//  AudioMediaInput.swift
//  Vooconnect
//
//  Created by Mac on 11/08/2023.
//

import Foundation
import UIKit
import AVFoundation;
import MediaToolbox


class AudioMediaInput: NSObject {
    private let queue = DispatchQueue(label: "com.GenerateMetal.VideoMediaInput")
    
    var audioURL: URL!
    
    private var playerItemObserver: NSKeyValueObservation?
    var displayLink: CADisplayLink!
    var player = AVPlayer()
    var playerItem: AVPlayerItem!
    let videoOutput = AVPlayerItemVideoOutput(pixelBufferAttributes: [String(kCVPixelBufferPixelFormatTypeKey): NSNumber(value: kCVPixelFormatType_32BGRA)])
    var audioProcessingFormat:  AudioStreamBasicDescription?//UnsafePointer<AudioStreamBasicDescription>?
    var tap: Unmanaged<MTAudioProcessingTap>?
    var onEndVideo : () -> () = {}
    override init(){
        
    }
    
    convenience init(url: URL){
        self.init()
        self.audioURL = url
//        self.delegate = delegate
        
        self.playerItem = AVPlayerItem(url: url)
        
        playerItemObserver = playerItem.observe(\.status) { [weak self] item, _ in
            guard item.status == .readyToPlay else { return }
            self?.playerItemObserver = nil
            self?.player.play()
            self?.player.currentItem?.audioTimePitchAlgorithm = .timeDomain
        }
        
        
        player.replaceCurrentItem(with: playerItem)
        player.currentItem!.add(videoOutput)
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) {[weak self] notification in
            
            if let weakSelf = self {
                weakSelf.player.seek(to: CMTime.zero)
                self?.onEndVideo()
            }
            
        }
    }
    
    func onChange(for url : URL) {

        self.playerItem = AVPlayerItem(url: url)
        
        playerItemObserver = playerItem.observe(\.status) { [weak self] item, _ in
            guard item.status == .readyToPlay else { return }
            self?.playerItemObserver = nil
            self?.player.play()
            self?.player.currentItem?.audioTimePitchAlgorithm = .timeDomain
        }
        player.replaceCurrentItem(with: playerItem)
        player.currentItem!.add(videoOutput)
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) {[weak self] notification in
            
            if let weakSelf = self {
                weakSelf.player.seek(to: CMTime.zero)
                self?.onEndVideo()
            }
            
        }
    }
    
    func stopAllProcesses(){
        self.queue.sync {
            self.player.pause()
            self.player.isMuted = true
            self.player.currentItem?.audioMix = nil
            self.playerItem?.audioMix = nil
            self.playerItem = nil
            self.tap?.release()
        }
    }
    
    
    deinit{
        print(">> VideoInput deinited !!!! 📌📌")
        
        NotificationCenter.default.removeObserver(self)
        
        stopAllProcesses()
        
    }
    public func playAudio(){
        if (player.currentItem != nil) {
            print("Starting playback!")
            player.play()
        }
    }
    public func pauseAudio(){
        if (player.currentItem != nil) {
            print("Pausing playback!")
            player.pause()
//            self.player.isMuted = true
        }
    }
    
//    @objc func applicationDidBecomeActive(_ notification: NSNotification) {
//        playVideo()
//    }
    
    
    
    
    //MARK: GET AUDIO BUFFERS
    func setupProcessingTap(){
        
        var callbacks = MTAudioProcessingTapCallbacks(
            version: kMTAudioProcessingTapCallbacksVersion_0,
            clientInfo: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()),
            init: tapInit,
            finalize: tapFinalize,
            prepare: tapPrepare,
            unprepare: tapUnprepare,
            process: tapProcess)
        
        var tap: Unmanaged<MTAudioProcessingTap>?
        let err = MTAudioProcessingTapCreate(kCFAllocatorDefault, &callbacks, kMTAudioProcessingTapCreationFlag_PostEffects, &tap)
        self.tap = tap
        
        
        print("err: \(err)\n")
        if err == noErr {
        }
        
        print("tracks? \(playerItem.asset.tracks)\n")
        
        if let audioTrack = playerItem.asset.tracks(withMediaType: AVMediaType.audio).first {
            let inputParams = AVMutableAudioMixInputParameters(track: audioTrack)
            inputParams.audioTapProcessor = tap?.takeRetainedValue()
            // print("inputParms: \(inputParams), \(inputParams.audioTapProcessor)\n")
            let audioMix = AVMutableAudioMix()
            audioMix.inputParameters = [inputParams]
            
            playerItem.audioMix = audioMix
        } else {
            print("No audio track found.")
        }
    }
    
    //MARK: TAP CALLBACKS
    
    let tapInit: MTAudioProcessingTapInitCallback = {
        (tap, clientInfo, tapStorageOut) in
        tapStorageOut.pointee = clientInfo
        
//        print("init \(tap, clientInfo, tapStorageOut)\n")

    }
    
    let tapFinalize: MTAudioProcessingTapFinalizeCallback = {
        (tap) in
        print("finalize \(tap)\n")
    }
    
    let tapPrepare: MTAudioProcessingTapPrepareCallback = {
        (tap, itemCount, basicDescription) in
//        print("prepare: \(tap, itemCount, basicDescription)\n")
        let selfMediaInput = Unmanaged<VideoMediaInput>.fromOpaque(MTAudioProcessingTapGetStorage(tap)).takeUnretainedValue()
        selfMediaInput.audioProcessingFormat = AudioStreamBasicDescription(mSampleRate: basicDescription.pointee.mSampleRate,
                                                                           mFormatID: basicDescription.pointee.mFormatID, mFormatFlags: basicDescription.pointee.mFormatFlags, mBytesPerPacket: basicDescription.pointee.mBytesPerPacket, mFramesPerPacket: basicDescription.pointee.mFramesPerPacket, mBytesPerFrame: basicDescription.pointee.mBytesPerFrame, mChannelsPerFrame: basicDescription.pointee.mChannelsPerFrame, mBitsPerChannel: basicDescription.pointee.mBitsPerChannel, mReserved: basicDescription.pointee.mReserved)
    }
    
    let tapUnprepare: MTAudioProcessingTapUnprepareCallback = {
        (tap) in
        print("unprepare \(tap)\n")
    }
    
    let tapProcess: MTAudioProcessingTapProcessCallback = {
        (tap, numberFrames, flags, bufferListInOut, numberFramesOut, flagsOut) in
//        print("callback \(bufferListInOut)\n")

    let selfMediaInput = Unmanaged<VideoMediaInput>.fromOpaque(MTAudioProcessingTapGetStorage(tap)).takeUnretainedValue()
        
        let status = MTAudioProcessingTapGetSourceAudio(tap, numberFrames, bufferListInOut, flagsOut, nil, numberFramesOut)
        //print("get audio: \(status)\n")
        if status != noErr {
            print("Error TAPGetSourceAudio :\(String(describing: status.description))")
            return
        }
        
        selfMediaInput.processAudioData(audioData: bufferListInOut, framesNumber: UInt32(numberFrames))
    }
    func processAudioData(audioData: UnsafeMutablePointer<AudioBufferList>, framesNumber: UInt32) {
        var sbuf: CMSampleBuffer?
        var status : OSStatus?
        var format: CMFormatDescription?
        
        //FORMAT
//        var audioFormat = self.audioProcessingFormat//self.audioProcessingFormat?.pointee
        guard var audioFormat = self.audioProcessingFormat else {
            return
        }
        status = CMAudioFormatDescriptionCreate(allocator: kCFAllocatorDefault, asbd: &audioFormat, layoutSize: 0, layout: nil, magicCookieSize: 0, magicCookie: nil, extensions: nil, formatDescriptionOut: &format)
        if status != noErr {
            print("Error CMAudioFormatDescriptionCreater :\(String(describing: status?.description))")
            return
        }
        
        
//        print(">> Audio Buffer mSampleRate:\(Int32(audioFormat.mSampleRate))")
        var timing = CMSampleTimingInfo(duration: CMTimeMake(value: 1, timescale: Int32(audioFormat.mSampleRate)), presentationTimeStamp: self.player.currentTime(), decodeTimeStamp: CMTime.invalid)
        
        
        status = CMSampleBufferCreate(allocator: kCFAllocatorDefault,
                                      dataBuffer: nil,
                                      dataReady: Bool(truncating: 0),
                                      makeDataReadyCallback: nil,
                                      refcon: nil,
                                      formatDescription: format,
                                      sampleCount: CMItemCount(framesNumber),
                                      sampleTimingEntryCount: 1,
                                      sampleTimingArray: &timing,
                                      sampleSizeEntryCount: 0, sampleSizeArray: nil,
                                      sampleBufferOut: &sbuf);
        if status != noErr {
            print("Error CMSampleBufferCreate :\(String(describing: status?.description))")
            return
        }
        status =   CMSampleBufferSetDataBufferFromAudioBufferList(sbuf!,
                                                                  blockBufferAllocator: kCFAllocatorDefault ,
                                                                  blockBufferMemoryAllocator: kCFAllocatorDefault,
                                                                  flags: 0,
                                                                  bufferList: audioData)
        if status != noErr {
            print("Error cCMSampleBufferSetDataBufferFromAudioBufferList :\(String(describing: status?.description))")
            return
        }
        
//        let currentSampleTime = CMSampleBufferGetOutputPresentationTimeStamp(sbuf!);
//        print(" audio buffer at time: \(currentSampleTime)")
//        self.delegate?.videoFrameRefresh(sampleBuffer: sbuf!)
    
    }
    
    
}