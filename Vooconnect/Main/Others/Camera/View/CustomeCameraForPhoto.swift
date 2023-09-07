//
//  CustomeCameraForPhoto.swift
//  Vooconnect
//
//  Created by Vooconnect on 14/12/22.
//

import SwiftUI
import AVFoundation


import UIKit

struct CustomeCameraForPhoto: View {
    
    @StateObject var camera = CameraModelPhoto()
    @StateObject var cameraModel = CameraViewModel()
    
    @State private var timerImage: Bool = false
    @State private var preview: Bool = false
    @State var countdownTimerText = 0
    @State var countdownTimer = 0
    @State var countdownTimer2 = 0
    @State var timerRunning = false
    @State private var cameraFlip: Bool = false
    @State private var flashOn: Bool = false
    @State private var flash: Bool = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//    var preview : (URL) -> () = {val in}
    @State private var soundView: Bool = false
    @State private var videoURL: URL?
    @Binding var filtersSheeet: Bool
//    @Binding var preview: Bool
    
    
    
    var body: some View {
        if let url = cameraModel.previewURL ,cameraModel.showPreview {
            let isImage = !(url.absoluteString.lowercased().contains(".mp4") || url.absoluteString.lowercased().contains(".mov"))
            
            NavigationLink(
                destination: FinalPreview(
                    
                    controller: FinalPreviewController(url: url, isImage: isImage, speed: cameraModel.speed), songModel: cameraModel.songModel, speed: cameraModel.speed, showPreview: $cameraModel.showPreview,
                    url: .constant(url))
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
                
                ,
                isActive: $preview) {
                    EmptyView()
                }
        }
        
        NavigationLink(destination: SoundsView(
            pickSong: {song in
                cameraModel.songModel = song
                print("new song added to video: "+(cameraModel.songModel?.preview ?? ""))
            }
        )
            .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $soundView) {
                EmptyView()
            }
        
        
        ZStack{
            
            // Going to Be Camera preview...
            CameraPreviewPhoto(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            
            ZStack {
                
                VStack {
                    
                    VStack {
                        
                        VStack(spacing: 12) {
                            
                            VStack {
                                
                                Text("Flip")
                                    .font(.custom("Urbanist-Regular", size: 10))
                                    .foregroundColor(.white)
                                    .padding(.bottom, -5)
                                Button {
                                    cameraFlip.toggle()
                                    print("Flip===========")
                                    
                                    camera.isBackCameraPhoto.toggle()
                                    
                                    if camera.isBackCameraPhoto == false {
                                        camera.switchCamera()
                                        
//                                        flashOn = true
                                        
                                    } else {
                                        camera.Check(isBackCamera: camera.isBackCameraPhoto)
//                                        flashOn = false
                                    }
                                    
                                } label: {
//                                    Image("CameraFlip2")
                                    Image(cameraFlip ? "FlipCameraPurple" :"CameraFlip2")
                                }
                                
                            }
                            
                            VStack {
                                
                                Text("Flash")
                                    .font(.custom("Urbanist-Regular", size: 10))
                                    .foregroundColor(.white)
                                    .padding(.bottom, -5)
                                Button {
//                                    if flashOn {
//
//
//                                    }
                                    flash.toggle()
                                    self.camera.toggleFlash()
                                    
                                    print("Flash===========")
                                } label: {
//                                    Image("Flash2")
                                    Image(flash ? "Flash2" : "Flash3") //Flash3
                                }
                                
                            }
                            
                            VStack {
                                
                                Text("Timer")
                                    .font(.custom("Urbanist-Regular", size: 10))
                                    .foregroundColor(.white)
                                    .padding(.bottom, -5)
                                Button {
                                    print("Timer===========")
                                    
                                    timerImage = true
                                    
                                    if countdownTimer == 0 {
                                        countdownTimer = 3
                                        countdownTimerText = 3
                                    } else if countdownTimer == 3 {
                                        countdownTimer = 5
                                        countdownTimerText = 5
                                    } else if countdownTimer == 5 {
                                        countdownTimer = 10
                                        countdownTimerText = 10
                                    } else if countdownTimer == 10 {
                                        countdownTimer = 15
                                        countdownTimerText = 15
                                    } else if countdownTimer == 15 {
                                        countdownTimer = 20
                                        countdownTimerText = 20
                                    } else if countdownTimer == 20 {
                                        countdownTimer = 25
                                        countdownTimerText = 25
                                    } else if countdownTimer == 25 {
                                        countdownTimer = 30
                                        countdownTimerText = 30
                                    } else {
                                        countdownTimer = 0
                                        countdownTimerText = 0
                                    }
                                    countdownTimer2 = countdownTimer
                                    
                                } label: {
//                                            VStack {
                                    Image(timerImage ? "TimerPurple" : "Timer2")
                                        .overlay {
                                            Circle()
                                                .strokeBorder(.white, lineWidth: 1)
                                                .frame(width: 15, height: 15)
                                                .background(Circle().fill(LinearGradient(colors: [
                                                    Color("GradientOne"),
                                                    Color("GradientTwo"),
                                                ], startPoint: .top, endPoint: .bottom)
                                                ))
                                                .overlay {
                                                    Text("\(countdownTimerText)")
                                                        .foregroundColor(.white)
                                                        .font(.custom("Urbanist-Bold", size: 8))
                                                }
                                                .offset(x: 10, y: 13)
                                        }
                                    
                                }
                                
                            }
                            
                        
                            
                        }
                        .padding(.bottom, 12)
                        
                        VStack(spacing: 12) {
                            
                         
                            
                            VStack {
                                
                                Text("Add Sound")
                                    .font(.custom("Urbanist-Regular", size: 10))
                                    .foregroundColor(.white)
                                    .padding(.bottom, -5)
                                Button {
                                    
                                    if(cameraModel.songModel != nil)
                                    {
                                        cameraModel.songModel = nil
                                    }
                                    flash = false
                                    soundView.toggle()
                                    
                                    print("AddSound2===========")
                                } label: {
                                    Image("AddSound2")
                                }
                                
                            }
                            
                            VStack {
                                
                                Text("Beauty")
                                    .font(.custom("Urbanist-Regular", size: 10))
                                    .foregroundColor(.white)
                                    .padding(.bottom, -5)
                                Button {
                                    print("Beauty2===========")
                                    
                                } label: {
                                    Image("Beauty2")
                                }
                                
                            }
                            
                            VStack {
                                
                                Text("Filter")
                                    .font(.custom("Urbanist-Regular", size: 10))
                                    .foregroundColor(.white)
                                    .padding(.bottom, -5)
                                Button {
                                    filtersSheeet.toggle()
                                    print("Filter2===========")
                                    
                                } label: {
                                    Image("Filter2")
                                }
                                
                            }
                            
                        }
                    }
                    .padding(.vertical)
                    .padding(.horizontal, 10)
//                            .background(Color.red)
                    .background(
                        LinearGradient(colors: [ // GraySix
                            Color("GrayFour"),    //  GrayFive // GrayFour
                            Color("GrayFour"),
                        ], startPoint: .top, endPoint: .bottom))
                    .cornerRadius(50)
                    
                }
                .frame(maxWidth: .infinity,alignment: .trailing)
                .padding(.bottom, -20)
                
            }
            
            if timerRunning == true {
                
                Text("\(countdownTimer)")
                    .foregroundColor(.white)
                    .padding()
                    .onReceive(timer) { _ in
                        if countdownTimer > 0 && timerRunning {
                            countdownTimer -= 1
                        } else {
                            timerRunning = false
                        }
                        
                    }
                    .font(.system(size: 40, weight: .bold))
            }
            
            VStack{
                
//                if camera.isTaken {
//
//                    HStack {
//
//                        Button {
//                            countdownTimerText = countdownTimer2
//                            countdownTimer = countdownTimer2
//                            camera.reTake()
//                        } label: {
//                            Image(systemName: "xmark")
//                                .font(.title)
//                                .foregroundColor(.white)
//                        }
//                        .padding()
//                        .padding(.top)
//                        Spacer()
//
//                    }
//                }
                
                Spacer()
                
                HStack {
                    if camera.isTaken{
                        Text("                     ")
                        Spacer()
                    }
                    
                    Button {
                        timerRunning = true
                        self.countdownTimer = self.countdownTimer2
                        self.countdownTimerText = self.countdownTimer2
                        self.camera.clearPicture()
                        let afterTime = DispatchTimeInterval.seconds(self.countdownTimer)
                        print("start taking picture in: " + self.countdownTimer.description)
                        DispatchQueue.main.asyncAfter(deadline: .now() + afterTime) {
                            timerRunning = false
                            camera.takePic(flash: self.flash)
                        }
                    } label: {
                        Image("CameraClick")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 58, height: 58)
                            .offset(x: 8)
                    }
                    
                    if (camera.VideoUrl != nil){
                        Spacer()
                        Button {
                            cameraModel.previewURL = camera.VideoUrl
                            DispatchQueue.main.async {
                                print(("video recorded"))
                                countdownTimer = self.countdownTimer2
                                cameraModel.showPreview.toggle()
                                preview.toggle()
                            }
                        } label: {
                            Group{
                                Label {
                                    Image(systemName: "chevron.right")
                                        .font(.callout)
                                } icon: {
                                    Text("Preview")
                                }
                                .foregroundColor(.black)
                            }
                            .padding(.horizontal,20)
                            .padding(.vertical,8)
                            .background{
                                Capsule()
                                    .fill(.white)
                            }
                        }
                    }
                    
                }
                .padding(.bottom, 26)
                .padding(.horizontal, 12)
            }
        }
        
        .onAppear(perform: {
            camera.Check(isBackCamera: camera.isBackCameraPhoto)
            print("camera switch")
        })
        .alert(isPresented: $camera.alert) {
            Alert(title: Text("Please Enable Camera Access"))
        }
    }
    
    
}

struct CustomeCameraForPhoto_Previews: PreviewProvider {
    static var previews: some View {
        CustomeCameraForPhoto(filtersSheeet: .constant(false))
    }
}
