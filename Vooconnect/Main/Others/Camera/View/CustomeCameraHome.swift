//
//  CustomeCameraHome.swift
//  Vooconnect
//
//  Created by Vooconnect on 05/12/22.
//

import SwiftUI
import ARGear
import ARKit
//import DeepAR

struct CustomeCameraHome: View {
    
    @State private var circleProgress: CGFloat = 0.2
    @State private var widthAndHeight: CGFloat = 90
    @State private var progressColor: Color = .red
    @Environment(\.presentationMode) var presentaionMode
    
    @StateObject var cameraModel = CameraViewModel()
    @State private var preview: Bool = false
    @State private var photos: Bool = false
    
    @State private var soundView: Bool = false
    
    @State private var flash: Bool = false
    @State private var timerImage: Bool = false
    @State private var durationImage: Bool = false
    
    @State private var clickPhoto: Bool = false
    
    @StateObject var camera = CameraModelPhoto()
    
    @State var countdownTimerText = 0
    @State var countdownTimer : Int = 0
    @State var countdownText : Int = 0
    @State private var countdownTimer2 = 0
    @State private var progress: Double = 0
    
    @State var timerRunning = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var cameraFlip: Bool = false
    
    @State private var filersSheet: Bool = false
    @State private var beautySheet: Bool = false
    @State private var effectsSheet: Bool = false
    @State private var isShowPopup: Bool = false
    var toast_main_position = CGPoint(x: 0, y: 0)
    
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                if self.isShowPopup {
                    GeometryReader { geometry in
                        VStack {
                            Spacer()
                            Spacer()
                            Text("Beauty")
                                .frame(maxWidth: geometry.size.width * 0.8, maxHeight: 40.0)
                                .padding(.bottom, 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.black.opacity(0.50))
                                )
                                .foregroundColor(Color.white)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation {
                                            self.isShowPopup = false
                                        }
                                    }
                                }
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
                    }
                }

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

                NavigationLink(destination: AllMediaView(callback: {val in
//                    self.photos = false
                    self.cameraModel.previewURL = val.url
                    self.cameraModel.speed = 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        self.cameraModel.showPreview = true
                        self.preview = true
                    }
                })
                    .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $photos) {
                        EmptyView()
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

                HStack {
                    Spacer()
                    Button {
                        presentaionMode.wrappedValue.dismiss()
                    } label: {
                        Image("CameraBack")
                    }

                }
                .padding(.trailing)


                ZStack {   // (alignment: .bottom)
//                MARK: Camera View
//                     Text("MARK: Camera View")
//                    MyARView(arScene: $arScene, argConfig: $argConfig, argSession: $argSession, currentFaceFrame: $currentFaceFrame, nextFaceFrame: $nextFaceFrame, preferences: $preferences, arCamera: $arCamera, cameraPreviewCALayer: $cameraPreviewCALayer)

                    if clickPhoto == true {
                        CustomeCameraForPhoto(filtersSheeet: $filersSheet)
                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                            .padding(.top,10)
                            .padding(.bottom,30)

                    } else {
                        CustomeCameraView()
                            .environmentObject(cameraModel)
                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                            .padding(.top,10)
                            .padding(.bottom,30)

                    }

                    if timerRunning == true {

                        Text("\(countdownText)")
                            .foregroundColor(.white)
                            .padding()
                            .onReceive(timer) { _ in
                                if countdownText < countdownTimer && timerRunning {
                                    countdownTimer += 1
                                    countdownText += 1
                                } else {
                                    timerRunning = false
                                }

                            }
                            .font(.system(size: 40, weight: .bold))
                    }

                    // MARK: Controls
                    ZStack{

                        if clickPhoto == true {

                        } else {

                            VStack(alignment: .leading) {

                                VStack {

                                    VStack {

                                        VStack(spacing: 12) {

                                            VStack {


                                                Button {
                                                    cameraFlip.toggle()
                                                    print("Flip===========")
                                                    if self.cameraFlip == true {
                                                        self.cameraModel.isBackCamera = true
                                                        cameraModel.switchCamera()
                                                    } else {
                                                        self.cameraModel.isBackCamera = false
                                                        flash = false
                                                        self.cameraModel.checkPermission(isBackCamera: self.cameraModel.isBackCamera)
                                                    }

                                                } label: {
                                                    VStack{
                                                        Text("Flip")
                                                            .font(.custom("Urbanist-Regular", size: 10))
                                                            .foregroundColor(cameraFlip ? ColorsHelper.deepPurple : .white)
                                                            .padding(.bottom, -5)
                                                        Image(cameraFlip ? "FlipCameraPurple" :"CameraFlip2") //FlipCameraPurple
                                                    }

                                                }

                                            }

                                            VStack {

                                                Text("Flash")
                                                    .font(.custom("Urbanist-Regular", size: 10))
                                                    .foregroundColor(.white)
                                                    .padding(.bottom, -5)
                                                Button {
                                                    if self.cameraModel.isBackCamera == false {
                                                        flash.toggle()
                                                        self.cameraModel.toggleFlash()
                                                    } else {
                                                        print("Flash===========")
                                                    }

                                                } label: {
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
//                                                    countdownTimer = 7

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
                                                    Image(timerImage ? "TimerPurple" : "Timer2") // TimerPurple
                                                        .overlay {
                                                            Circle()
                                                                .strokeBorder(.white, lineWidth: 1)
                                                                .frame(width: 23, height: 23)
                                                                .background(Circle().fill(LinearGradient(colors: [
                                                                    Color("GradientOne"),
                                                                    Color("GradientTwo"),
                                                                ], startPoint: .top, endPoint: .bottom)
                                                                ))
                                                                .overlay {
//                                                                    Text("5")
                                                                    Text("\(countdownTimerText)")
                                                                        .foregroundColor(.white)
                                                                        .font(.custom("Urbanist-Bold", size: 8))
                                                                }
                                                                .offset(x: 10, y: 13)
                                                        }

                                                }

                                            }

                                            VStack {

                                                Text("Duration")
                                                    .font(.custom("Urbanist-Regular", size: 10))
                                                    .foregroundColor(.white)
                                                    .padding(.bottom, -5)
                                                Button {
                                                    print("Duration2===========")
                                                    durationImage = true
//                                                    print(cameraModel.maxDuration)
                                                    if cameraModel.maxDuration == 10 {
                                                        cameraModel.maxDuration = 20
                                                    } else if cameraModel.maxDuration == 20 {
                                                        cameraModel.maxDuration = 30
                                                    } else if cameraModel.maxDuration == 30 {
                                                        cameraModel.maxDuration = 60
                                                    } else if cameraModel.maxDuration == 60 {
                                                        cameraModel.maxDuration = 90
                                                    } else if cameraModel.maxDuration == 90 {
                                                        cameraModel.maxDuration = 120
                                                    } else {
                                                        cameraModel.maxDuration = 10
                                                    }

                                                } label: {
                                                    Image(durationImage ? "DurationPurple" : "Duration2")
                                                        .overlay {
                                                            Circle()
                                                                .strokeBorder(.white, lineWidth: 1)
                                                                .frame(width: 23, height: 23)
                                                                .background(Circle().fill(LinearGradient(colors: [
                                                                    Color("GradientOne"),
                                                                    Color("GradientTwo"),
                                                                ], startPoint: .top, endPoint: .bottom)
                                                                ))
                                                                .overlay {
                                                                    Text("\(Int(cameraModel.maxDuration))")
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

                                                Text("Speed")
                                                    .font(.custom("Urbanist-Regular", size: 10))
                                                    .foregroundColor(.white)
                                                    .padding(.bottom, -5)
                                                Button {
                                                    switch(cameraModel.speed)
                                                    {
                                                        case 0.25 : cameraModel.speed = 0.5
                                                        case 0.5 : cameraModel.speed = 1.0
                                                        case 1.0 : cameraModel.speed = 2.0
                                                        case 2.0 : cameraModel.speed = 3.0
                                                        default : cameraModel.speed = 0.25
                                                    }
                                                    print("speed: " + cameraModel.speed.description)

                                                } label: {
                                                    Image("Speed2")
                                                        .overlay {
                                                            Circle()
                                                                .strokeBorder(.white, lineWidth: 1)
                                                                .frame(width: 23, height: 23)
                                                                .background(Circle().fill(LinearGradient(colors: [
                                                                    Color("GradientOne"),
                                                                    Color("GradientTwo"),
                                                                ], startPoint: .top, endPoint: .bottom)
                                                                ))
                                                                .overlay {
                                                                    Text(
                                                                        cameraModel.speed < 1 ?
                                                                        "\(String(format: "%.2f", cameraModel.speed))":
                                                                        "\(Int(cameraModel.speed))")
                                                                        .foregroundColor(.white)
                                                                        .font(.custom("Urbanist-Bold", size: 8))
                                                                }
                                                                .offset(x: 10, y: 13)
                                                        }
                                                }

                                            }
                                            .padding(.bottom, 6)

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
                                                    if(cameraModel.songModel == nil)
                                                    {
                                                        Image("AddSound2")
                                                    }else
                                                    {
                                                        Image("AddSound2")
                                                    }

                                                }

                                            }

                                            VStack {

                                                Text("Beauty")
                                                    .font(.custom("Urbanist-Regular", size: 10))
                                                    .foregroundColor(.white)
                                                    .padding(.bottom, -5)
                                                Button {
                                                    print("Beauty2===========")
                                                    beautySheet.toggle()
//                                                    isShowPopup.toggle()
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
                                                    filersSheet.toggle()

                                                    print("Filter2===========")

                                                } label: {
                                                    Image("Filter2")
                                                }

                                            }

                                        }
                                    }
                                    .padding(.vertical)
                                    .padding(.horizontal, 10)
//                            .background(Color.gray)
//                                    .background(.ultraThinMaterial)
//                            .opacity(0.8)
//                            .opacity(1.0)
                                    .background(
                                        LinearGradient(colors: [ // GraySix
                                            Color("GrayFour"),    //  GrayFive // GrayFour // GrayFourR
                                            Color("GrayFour"),
                                        ], startPoint: .leading, endPoint: .trailing)) // GrayOneC
                                    .cornerRadius(50)

                                }
                                .frame(maxWidth: .infinity,alignment: .trailing)
                                .padding(.bottom, -20)
                                .padding(.trailing, 6)

                            }
                            .padding(.leading)
                            .padding(.bottom)
                        }

                        VStack(alignment: .leading) {

                            Button {
                                DispatchQueue.main.async {
                                    clickPhoto = false
                                    self.cameraModel.previewURL = nil
                                }
                            } label: {
                                Image(clickPhoto ? "VideoUnSlected" : "VideoSlected")
                            }

                            HStack {

                                Button {
                                    clickPhoto = true
                                    self.cameraModel.previewURL = nil
                                } label: {
                                    Image(clickPhoto ? "PhotoSlected" : "PhotoUnSlected") // PhotoSlected
                                }

                                Spacer()

                                if clickPhoto == true {  // CameraClick

                                    Text("")
                                        .frame(height: 58)
                                    .padding(.leading, 8)
                                    Spacer()

                                } else {
                                        Button {
                                            
                                            print("click")
                                            
                                            if cameraModel.isRecording{
                                                cameraModel.stopRecording()
                                                countdownTimer = countdownTimer2
                                                countdownTimerText = countdownTimer2
                                            }
                                            
                                            else {
                                                timerRunning = true
                                                countdownTimer = countdownTimer2
                                                countdownTimerText = countdownTimer2
                                                let afterTime = DispatchTimeInterval.seconds(self.countdownTimer)
                                                print("start recording in: " + self.countdownTimer.description)
                                                DispatchQueue.main.asyncAfter(deadline: .now() + afterTime) {
                                                    timerRunning = false
                                                    cameraModel.startRecording()
                                                    simulateVideoProgress()
                                                }
                                            }
                                        } label: {
                                            if cameraModel.isRecording {
                                                Image("CameraRecording")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 58, height: 58)
                                                    .offset(x: 10)
                                                    .overlay(
                                                        CircularProgressCameraView(progress: progress)
                                                            .frame(height: 54)
                                                            .offset(x: 10)
                                                    )
                                                
                                            } else {
                                                Image("CameraRecording")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 58, height: 58)
                                                    .offset(x: 10)
                                                    .overlay(
                                                        CircularProgressCameraView(progress: progress)
                                                            .frame(height: 54)
                                                            .offset(x: 10)
                                                    )
                                            }
                                        }
                                        .padding(.leading, 8) // 8
                                    }
                                
                                Spacer()
                                                                    
                                
                                // Preview Button
                                if(cameraModel.previewURL != nil && !cameraModel.isRecording)
                                {
                                    Button {
                                        if let videoURL = cameraModel.previewURL{
                                            
                                            if ((cameraModel.songModel?.preview) != nil){
                                                self.cameraModel.removeAudioFromVideo(videoURL: videoURL){url, error in
                                                    if let error = error {
                                                        print("Failed to remove audio: \(error.localizedDescription)")
                                                    } else {
                                                        cameraModel.previewURL = url
                                                        print("Audio removed video, new url: " + url!.absoluteString)
                                                        DispatchQueue.main.async {
                                                            print(("video recorded"))
                                                            countdownTimer = self.countdownTimer2
                                                            cameraModel.showPreview.toggle()
                                                            preview.toggle()
                                                        }
                                                    }
                                                }
                                            } else {
                                                DispatchQueue.main.async {
                                                    print(("video recorded"))
                                                    countdownTimer = self.countdownTimer2
                                                    cameraModel.showPreview.toggle()
                                                    preview.toggle()
                                                }
                                            }
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
    //                                        if cameraModel.previewURL == nil && !cameraModel.recordedURLs.isEmpty{
    //                                            // Merging Videos
    //                                            ProgressView()
    //                                                .tint(.black)
    //                                        }
    //                                        else{
    //                                            Label {
    //                                                Image(systemName: "chevron.right")
    //                                                    .font(.callout)
    //                                            } icon: {
    //                                                Text("Preview")
    //                                            }
    //                                            .foregroundColor(.black)
    //                                        }
                                        }
                                        .padding(.horizontal,20)
                                        .padding(.vertical,8)
                                        .background{
                                            Capsule()
                                                .fill(.white)
                                        }
                                    }
//                                    .opacity((cameraModel.previewURL == nil && cameraModel.recordedURLs.isEmpty) || cameraModel.isRecording ? 0 : 1)
                                }else{
                                    HStack{Text("                         ")}
                                }


                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .bottomLeading)

                    }
                    .frame(maxHeight: .infinity,alignment: .bottom)
                    .padding(.bottom,10)
                    .padding(.bottom,30)

                    Button {
                        countdownTimer = 3
                        cameraModel.recordedDuration = 0
                        cameraModel.previewURL = nil
                        cameraModel.recordedURLs.removeAll()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .topLeading)
                    .padding()
                    .padding(.top)
                    .opacity(!cameraModel.recordedURLs.isEmpty && cameraModel.previewURL != nil && !cameraModel.isRecording ? 1 : 0)


                    if cameraModel.isRecording {
                        Text("Recording")
                            .font(.custom("Urbanist-Regular", size: 14))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
                            .padding(.top, 40)
                    } else {

                    }
//                        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)

                }
                .padding(.top, -10)

                .padding(.bottom, -35)

                HStack {

                    Button {
                        photos.toggle()
                    } label: {
                        Image("UploadGalery")
                    }

                    Spacer()

                    Button {
                        effectsSheet.toggle()
                    } label: {
                        Image("CameraEffact")
                    }



                }
                .padding(.horizontal)
                .padding(.bottom, -5)

//                // Filters
//                .blurredSheet(.init(.white), show: $filersSheet) {
//
//                } content: {
//                    if #available(iOS 16.0, *) {
//                        FiltersSheet(cameraModel: cameraModel, filters: cameraModel.filter)
//                            .presentationDetents([.large,.medium,.height(300)])
//                            .onAppear {
//                                cameraModel.getFilterData()
//                            }
//                    } else {
//                        // Fallback on earlier versions
//                    }
//                }
//                .blurredSheet(.init(.white), show: $beautySheet) {
//
//                } content: {
//                    if #available(iOS 16.0, *) {
//                        BeautyView()
//
//                            .presentationDetents([.large,.medium,.height(140)])
//                            .onAppear {
//                                cameraModel.getFilterData()
//                            }
//                    } else {
//                        // Fallback on earlier versions
//                    }
//                }

                // Effects
                .blurredSheet(.init(.white), show: $effectsSheet) {

                } content: {
                    if #available(iOS 16.0, *) {
                        EffectsSheets()
                            .presentationDetents([.large,.medium,.height(500)])
                    } else {
                        // Fallback on earlier versions
                    }
                }

            }

            .animation(.easeInOut, value: cameraModel.showPreview)
            .navigationBarHidden(true)
        }
        
        
    }
    
    
    func simulateVideoProgress() {
        let stepFrequency = 13.899 // Number of steps per second (adjust as desired)
        let totalProgressSteps = cameraModel.maxDuration * stepFrequency
        let stepDuration = 1.0 / totalProgressSteps

        DispatchQueue.global(qos: .background).async {
            var shouldStop = false // Flag to indicate if the progress should be stopped
            var i = 0.0
            while i < totalProgressSteps {
                i += 1.0
                usleep(useconds_t(stepDuration * 1_000_000)) // Simulating delay in audio progress
                
                DispatchQueue.main.async {
                    if !cameraModel.isRecording {
                        shouldStop = true // Set the flag to stop the progress
                    }

                    if !shouldStop {
                        progress = Double(i + 1) / Double(totalProgressSteps)
                    }

                    if shouldStop || i == totalProgressSteps - 1 {
                        cameraModel.isRecording = false
                        print("Video Recording completed")
                        cameraModel.stopRecording()
                    }
                }

                if shouldStop {
                    break // Exit the loop if the progress should be stopped
                }
            }
        }
    }
}


struct CustomeCameraHome_Previews: PreviewProvider {
    static var previews: some View {
        CustomeCameraHome()
    }
}



struct circleee : View {
    
    var percent : Double = 0
    
    var body: some View {
        
        ZStack {
            
            Circle()
                .trim(from: 1, to: 1)
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                .fill(.white)
                .frame(width: 90, height: 90)
                .overlay(
                
                    Circle()
                        .trim(from: 0, to: percent * 0.01) //10 means 0.1
                        .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                        .fill(Color(.red))
                        .rotationEffect(.init(degrees: -90))
                )
        }
    }
}


struct CircleeTwo: View {
    
    @Binding var circleProgress: CGFloat
    
    var widthAndHeight: CGFloat
    var labelSize: CGFloat?
    var staticColor: Color?
    var progressColor: Color
    var showLabel: Bool?
    var lineWidth: CGFloat?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .stroke(self.staticColor ?? Color.gray, lineWidth: self.lineWidth ?? 15)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                Circle()
                    .trim(from: 0.0, to: self.circleProgress)
                    .stroke(self.progressColor, lineWidth: self.lineWidth ?? 15)
                    .frame(width: geometry.size.width, height: geometry.size.width)
                    .rotationEffect(Angle(degrees: -90))
                if self.showLabel ?? true {
                    Text("\(Int(self.circleProgress*100))%")
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .font(.custom("HelveticaNeue", size: self.labelSize ?? 20.0))
                }
            }
        }
            .frame(width: widthAndHeight, height: widthAndHeight)
    }
    
}


//struct MyARView: UIViewRepresentable {
//    @Binding var arScene: ARGScene?
//    @Binding var argConfig: ARGConfig?
//    @Binding var argSession: ARGSession?
//    @Binding var currentFaceFrame: ARGFrame?
//    @Binding var nextFaceFrame: ARGFrame?
//    @Binding var preferences: ARGPreferences
//    @Binding var arCamera: ARGCamera?
//    private let serialQueue = DispatchQueue(label: "serialQueue")
//    var arMedia: ARGMedia = ARGMedia()
//    @Binding var cameraPreviewCALayer: CALayer
//
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView()
//        setupScene(view: view)
//        return view
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {
//       
//    }
//    
//    private func setupScene(view: UIView) {
//        arScene = ARGScene(viewContainer: view)
//
//        arScene?.sceneRenderUpdateAtTimeHandler = {  renderer, time in
////            guard let self = self else { return }
//            self.refreshARFrame()
//        }
//
//        arScene?.sceneRenderDidRenderSceneHandler = { renderer, scene, time in
////            guard let _ = self else { return }
//        }
//
//        cameraPreviewCALayer.contentsGravity = .resizeAspect//.resizeAspectFill
//        cameraPreviewCALayer.frame = CGRect(x: 0, y: 0, width: arScene?.sceneView.frame.size.height ?? 0, height: arScene?.sceneView.frame.size.width ?? 0)
//        cameraPreviewCALayer.contentsScale = UIScreen.main.scale
//        view.layer.insertSublayer(cameraPreviewCALayer, at: 0)
////        setupCamera()
//    }
//    private func refreshARFrame() {
//        
//        guard self.nextFaceFrame != nil && self.nextFaceFrame != self.currentFaceFrame else { return }
//        self.currentFaceFrame = self.nextFaceFrame
//    }
//    private func setupCamera() {
////        arCamera = ARGCamera()
//
//        arCamera?.sampleBufferHandler = { output, sampleBuffer, connection in
////            guard let self = self else { return }
//
//            self.serialQueue.async {
//
//                self.argSession?.update(sampleBuffer, from: connection)
//            }
//        }
//
//        self.permissionCheck {
//            print("Asking for permissions")
//            self.arCamera?.startCamera()
//
//            self.setCameraInfo()
//        }
//    }
//    func setCameraInfo() {
//
//        if let device = arCamera?.cameraDevice, let connection = arCamera?.cameraConnection {
//            self.arMedia.setVideoDevice(device)
//            self.arMedia.setVideoDeviceOrientation(connection.videoOrientation)
//            self.arMedia.setVideoConnection(connection)
//        }
////        arMedia.setMediaRatio(arCamera?.ratio)
//        arMedia.setVideoBitrate(ARGMediaVideoBitrate(rawValue: self.preferences.videoBitrate) ?? ._4M)
//    }
//
//   
//    
//    
//    public func session(_ session: ARSession, didUpdate frame: ARFrame) {
//
////        let viewportSize = view.bounds.size
//        var updateFaceAnchor: ARFaceAnchor? = nil
//        var isFace = false
//        if let faceAnchor = frame.anchors.first as? ARFaceAnchor {
//            if faceAnchor.isTracked {
////                updateFaceAnchor = self.currentARKitFaceAnchor
//                isFace = true
//            }
//        } else {
//            if let _ = frame.anchors.first as? ARPlaneAnchor {
//            }
//        }
//
//        let handler: ARGSessionProjectPointHandler = { (transform: simd_float3, orientation: UIInterfaceOrientation, viewport: CGSize) in
//            return frame.camera.projectPoint(transform, orientation: orientation, viewportSize: viewport)
//        }
//            
//        if isFace {
//            if let faceAnchor = updateFaceAnchor {
////                self.argSession?.applyAdditionalFaceInfo(withPixelbuffer: frame.capturedImage, transform: faceAnchor.transform, vertices: faceAnchor.geometry.vertices, viewportSize: viewportSize, convert: handler)
//            } else {
//                self.argSession?.feedPixelbuffer(frame.capturedImage)
//            }
//        } else {
//            self.argSession?.feedPixelbuffer(frame.capturedImage)
//                }
//            }
//    
//    
//    
//    
//    func permissionCheck(_ permissionCheckComplete: @escaping PermissionCheckComplete) {
//        
////        let permissionLevel = self.permissionView.permission.getPermissionLevel()
////        self.permissionView.permission.grantedHandler = permissionCheckComplete
////        self.permissionView.setPermissionLevel(permissionLevel)
////
////        switch permissionLevel {
////        case .Granted:
////            break
////        case .Restricted:
////            self.removeSplashAfter(1.0)
////        case .None:
////            self.removeSplashAfter(1.0)
////        }
//    }
//    
//    func makeCoordinator() -> Coordinator  {
//        Coordinator(argSession: self.argSession ?? ARGSession(), currentFaceFrame: self.currentFaceFrame, nextFaceFrame: self.nextFaceFrame, preferences: self.preferences, arCamera: self.arCamera, cameraPreviewCALayer: self.cameraPreviewCALayer)
//    }
//    class Coordinator: NSObject, ARGSessionDelegate {
//        var arScene: ARGScene?
//        var argSession: ARGSession?
//        var currentFaceFrame: ARGFrame?
//        var nextFaceFrame: ARGFrame?
//        var preferences: ARGPreferences?
//        var arCamera: ARGCamera?
//        var cameraPreviewCALayer: CALayer?
//        
//        init(arScene: ARGScene? = nil ,argSession: ARGSession? = nil, currentFaceFrame: ARGFrame? = nil, nextFaceFrame: ARGFrame? = nil, preferences: ARGPreferences? = nil, arCamera: ARGCamera? = nil, cameraPreviewCALayer: CALayer? = nil) {
//            self.arScene = arScene
//            self.argSession = argSession
//            self.currentFaceFrame = currentFaceFrame
//            self.nextFaceFrame = nextFaceFrame
//            self.preferences = preferences
//            self.arCamera = arCamera
//            self.cameraPreviewCALayer = cameraPreviewCALayer
//            super.init()
//            self.setupARGearConfig()
//        }
//       
//        
//         func setupARGearConfig() {
//            do {
//                let config = ARGConfig(apiURL: API_HOST, apiKey: API_KEY, secretKey: API_SECRET_KEY, authKey: API_AUTH_KEY)
//                argSession = try ARGSession(argConfig: config, feature: [.faceMeshTracking])
//                argSession?.delegate = self
//                
//                let debugOption: ARGInferenceDebugOption = self.preferences?.showLandmark ?? ARGPreferences().showLandmark ? .optionDebugFaceLandmark2D : .optionDebugNON
//                argSession?.inferenceDebugOption = debugOption
//            } catch let error as NSError {
//                print("Failed to initialize ARGear Session with error: %@", error.description)
//            } catch let exception as NSException {
//                print("Exception to initialize ARGear Session with error: %@", exception.description)
//            }
//            print("Session Started")
//            DispatchQueue.main.async {
//                self.argSession?.run()
//            }
//        }
//        private func drawARCameraPreview() {
//
//            guard
//                let frame = self.currentFaceFrame,
//                let pixelBuffer = frame.renderedPixelBuffer
//                else {
//                return
//            }
//            
//            var flipTransform = CGAffineTransform(scaleX: -1, y: 1)
//            if self.arCamera?.currentCamera == .back {
//                flipTransform = CGAffineTransform(scaleX: 1, y: 1)
//            }
//
//            DispatchQueue.main.async {
//
//                CATransaction.flush()
//                CATransaction.begin()
//                CATransaction.setAnimationDuration(0)
//                if #available(iOS 11.0, *) {
//                    self.cameraPreviewCALayer?.contents = pixelBuffer
//                } else {
//                    self.cameraPreviewCALayer?.contents = self.pixelbufferToCGImage(pixelBuffer)
//                }
//                let angleTransform = CGAffineTransform(rotationAngle: .pi/2)
//                let transform = angleTransform.concatenating(flipTransform)
//                self.cameraPreviewCALayer?.setAffineTransform(transform)
//    //            self.cameraPreviewCALayer.frame = CGRect(x: 0, y: -self.getPreviewY(), width: self.cameraPreviewCALayer.frame.size.width, height: self.cameraPreviewCALayer.frame.size.height)
//    //            self.view.backgroundColor = .white
//                CATransaction.commit()
//            }
//        }
//        func didUpdate(_ arFrame: ARGFrame) {
//         self.drawARCameraPreview()
//
//         for face in arFrame.faces.faceList {
//            if face.isValid {
//               NSLog("landmarkcount = %d", face.landmark.landmarkCount)
//             
////              get face information (landmarkCoordinates , rotation_matrix, translation_vector)
////              let landmarkcount = face.landmark.landmarkCount
////              let landmarkCoordinates = face.landmark.landmarkCoordinates
////              let rotation_matrix = face.rotation_matrix
////              let translation_vector = face.translation_vector
//
//            }
//         }
//         
//         nextFaceFrame = arFrame
//         
//         if #available(iOS 11.0, *) {
//         } else {
//             self.arScene?.sceneView.sceneTime += 1
//         }
//     }
//        private func pixelbufferToCGImage(_ pixelbuffer: CVPixelBuffer) -> CGImage? {
//            let ciimage = CIImage(cvPixelBuffer: pixelbuffer)
//            let context = CIContext()
//            let cgimage = context.createCGImage(ciimage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelbuffer), height: CVPixelBufferGetHeight(pixelbuffer)))
//
//            return cgimage
//        }
//    }
//    
//}
