//
//  CustomeCameraHome.swift
//  Vooconnect
//
//  Created by Vooconnect on 05/12/22.
//

import SwiftUI
import ARGear

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
    
    @State var countdownTimerText = 3
    @State var countdownTimer : Int = 3
    @State private var countdownTimer2 = 3
    
    @State var timerRunning = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var cameraFlip: Bool = false
    
    @State private var filersSheet: Bool = false
    @State private var beautySheet: Bool = false
    @State private var effectsSheet: Bool = false
    @State private var isShowPopup: Bool = false
    var toast_main_position = CGPoint(x: 0, y: 0)
    
    // MARK: - ARGearSDK properties
    private var argConfig: ARGConfig?
    @State private var argSession: ARGSession?
    private var currentFaceFrame: ARGFrame?
    private var nextFaceFrame: ARGFrame?
    private var preferences: ARGPreferences = ARGPreferences()
    
    @State private var cameraPreviewCALayer = CALayer()
    
    // MARK: - Camera & Scene properties
    private let serialQueue = DispatchQueue(label: "serialQueue")
    private var currentCamera: CameraDeviceWithPosition = .front
    
    @State private var arCamera: ARGCamera!
    @State private var arScene: ARGScene!
//    private var arMedia: ARGMedia = ARGMedia()
    
    
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
                    NavigationLink(
                        destination: FinalPreview(
                            url: url,
                            showPreview: $cameraModel.showPreview,
                            songModel: cameraModel.songModel,
                            speed: cameraModel.speed
                        )
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
//                    MyARView(arScene: $arScene, argConfig: argConfig, argSession: argSession, currentFaceFrame: currentFaceFrame, nextFaceFrame: nextFaceFrame, preferences: preferences, arCamera: $arCamera, cameraPreviewCALayer: $cameraPreviewCALayer)

                    if clickPhoto == true {
                        CustomeCameraForPhoto(preview:{url in
                            print("picture taked: "+url.absoluteString)
                            self.cameraModel.previewURL = url
                            self.cameraModel.showPreview = true
                            self.preview.toggle()
                        }, soundView: $soundView, filtersSheeet: $filersSheet)
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

                                                    self.cameraModel.isBackCamera.toggle()

                                                    if self.cameraModel.isBackCamera == false {
                                                        self.cameraModel.switchCamera()
                                                    } else {
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

                                                    if countdownTimer == 3 {
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
                                                        countdownTimer = 3
                                                        countdownTimerText = 3
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
                                                                        "\(String(format: "%.2f", cameraModel.speed))x":
                                                                        "\(Int(cameraModel.speed))x")
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
                                            }


                                        }

                                    } label: {

                                        if cameraModel.isRecording {
                                            Image("CameraRecording")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 58, height: 58)

//                                                .overlay(content: {
//                                                    CircleeTwo(circleProgress: $circleProgress, widthAndHeight: widthAndHeight, progressColor: progressColor)
//                                                })

//                                                .overlay(
//
////                                                    circleee(percent: (cameraModel.recordedDuration / cameraModel.maxDuration))
//
//
////                                                       RoundedRectangle(cornerRadius: 29)
////                                                           .stroke(.blue, lineWidth: 4)
//////                                                           .frame(width: 58, height: 58, alignment: .center)
////                                                        .frame(width: 58 * (cameraModel.recordedDuration / cameraModel.maxDuration), height: 58 * (cameraModel.recordedDuration / cameraModel.maxDuration), alignment: .center)
//
//
//                                                   )
                                                
//                                                .frame(width: size.width * (cameraModel.recordedDuration / cameraModel.maxDuration))
                                            
                                                .offset(x: 10)

                                        } else {
                                            Image("VideoClick")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 58, height: 58)
                                                .offset(x: 10)
                                                
                                        }
                                        
    
                                        
                                    }
                                    .padding(.leading, 8) // 8
//                                    Spacer()
                                }
                                
                                Spacer()
                                                                    
                                
                                // Preview Button
                                if(cameraModel.previewURL != nil && !cameraModel.isRecording)
                                {
                                    Button {
                                        if let _ = cameraModel.previewURL{
                                            DispatchQueue.main.async {
                                                countdownTimer = self.countdownTimer2
                                                cameraModel.showPreview.toggle()
                                                preview.toggle()
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

                // Filters
                .blurredSheet(.init(.white), show: $filersSheet) {

                } content: {
                    if #available(iOS 16.0, *) {
                        FiltersSheet(cameraModel: cameraModel)
                            .presentationDetents([.large,.medium,.height(300)])
                            .onAppear {
                                cameraModel.getFilterData()
                            }
                    } else {
                        // Fallback on earlier versions
                    }
                }
                .blurredSheet(.init(.white), show: $beautySheet) {

                } content: {
                    if #available(iOS 16.0, *) {
                        BeautyView()

                            .presentationDetents([.large,.medium,.height(140)])
                            .onAppear {
                                cameraModel.getFilterData()
                            }
                    } else {
                        // Fallback on earlier versions
                    }
                }

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
            .onAppear {
                
                cameraModel.recordedDuration = 0
                runARGSession()
                initHelpers()
//                cameraModel.previewURL = nil
                setupARGearConfig()
                cameraModel.recordedURLs.removeAll()
            }
            
        }
        
        
    }
    
    
    
    // MARK: - ARGearSDK setupConfig
    private func setupARGearConfig() {
        do {
            let config = ARGConfig(
                apiURL: API_HOST,
                apiKey: API_KEY,
                secretKey: API_SECRET_KEY,
                authKey: API_AUTH_KEY
            )
            argSession = try ARGSession(argConfig: config, feature: [.faceMeshTracking])
//            argSession?.delegate = self
            
            let debugOption: ARGInferenceDebugOption = self.preferences.showLandmark ? .optionDebugFaceLandmark2D : .optionDebugNON
            argSession?.inferenceDebugOption = debugOption
            
        } catch let error as NSError {
            print("Failed to initialize ARGear Session with error: %@", error.description)
        } catch let exception as NSException {
            print("Exception to initialize ARGear Session with error: %@", exception.description)
        }
    }
//    private func setupCamera() {
//        arCamera = ARGCamera()
//
//        arCamera.sampleBufferHandler = { [weak self] output, sampleBuffer, connection in
//            guard let self = self else { return }
//
//            self.serialQueue.async {
//
//                self.argSession?.update(sampleBuffer, from: connection)
//            }
//        }
//
//        self.permissionCheck {
//            self.arCamera.startCamera()
//
//            self.setCameraInfo()
//        }
//    }
 
    
    private func connectAPI() {
        
        NetworkManager.shared.connectAPI { (result: Result<[String: Any], APIError>) in
            switch result {
            case .success(let data):
                RealmManager.shared.setARGearData(data) { success in
                    self.loadAPIData()
                }
            case .failure(.network):
                self.loadAPIData()
                break
            case .failure(.data):
                self.loadAPIData()
                break
            case .failure(.serializeJSON):
                self.loadAPIData()
                break
            }
        }
    }
    private func loadAPIData() {
        DispatchQueue.main.async {
            let categories = RealmManager.shared.getCategories()

            // Assuming mainBottomFunctionView is a UIKit view
//            mainBottomFunctionView.contentView.contentsCollectionView.contents = categories
//            mainBottomFunctionView.contentView.contentTitleListScrollView.contents = categories
//            mainBottomFunctionView.filterView.filterCollectionView.filters = RealmManager.shared.getFilters()
        }
    }
    
    private func initHelpers() {
        NetworkManager.shared.argSession = self.argSession
        BeautyManager.shared.argSession = self.argSession
        FilterManager.shared.argSession = self.argSession
        ContentManager.shared.argSession = self.argSession
        BulgeManager.shared.argSession = self.argSession
        
        BeautyManager.shared.start()
    }
    

    
    private func runARGSession() {
        argSession?.run()
    }
    
    private func stopARGSession() {
        argSession?.pause()
    }
    private func destroyARGSession() {
        argSession?.destroy()
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


struct MyARView: UIViewRepresentable {
    @Binding var arScene: ARGScene?
    
    
    var argConfig: ARGConfig?
    @State  var argSession: ARGSession?
    @State  var currentFaceFrame: ARGFrame?
    @State  var nextFaceFrame: ARGFrame?
    @State  var preferences: ARGPreferences = ARGPreferences()
    @Binding  var arCamera: ARGCamera?
    private let serialQueue = DispatchQueue(label: "serialQueue")
    
    @Binding var cameraPreviewCALayer: CALayer

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        setupScene(view: view)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
       
    }
    
    private func setupScene(view: UIView) {
        arScene = ARGScene(viewContainer: view)

        arScene?.sceneRenderUpdateAtTimeHandler = {  renderer, time in
//            guard let self = self else { return }
            self.refreshARFrame()
        }

        arScene?.sceneRenderDidRenderSceneHandler = { renderer, scene, time in
//            guard let _ = self else { return }
        }

        cameraPreviewCALayer.contentsGravity = .resizeAspect//.resizeAspectFill
        cameraPreviewCALayer.frame = CGRect(x: 0, y: 0, width: arScene?.sceneView.frame.size.height ?? 0, height: arScene?.sceneView.frame.size.width ?? 0)
        cameraPreviewCALayer.contentsScale = UIScreen.main.scale
        view.layer.insertSublayer(cameraPreviewCALayer, at: 0)
    }
    private func refreshARFrame() {
        
        guard self.nextFaceFrame != nil && self.nextFaceFrame != self.currentFaceFrame else { return }
        self.currentFaceFrame = self.nextFaceFrame
    }
    private func setupCamera() {
        arCamera = ARGCamera()
        
        arCamera?.sampleBufferHandler = { output, sampleBuffer, connection in
//            guard let self = self else { return }
            
            self.serialQueue.async {

                self.argSession?.update(sampleBuffer, from: connection)
            }
        }
        
//        self.permissionCheck {
//            self.arCamera.startCamera()
//
//            self.setCameraInfo()
//        }
    }
    
}
