//
//  FinalPreview.swift
//  Vooconnect
//
//  Created by Vooconnect on 06/12/22.
//

import SwiftUI
import AVKit
import Photos
import AVPlayerViewController_Subtitles
import AVFoundation
import CoreImage
import CoreImage.CIFilterBuiltins
import NavigationStack
import PencilKit

// MARK: Final Video Preview
struct FinalPreview: View{
    @Environment(\.presentationMode) var presentaionMode
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject  var navigationModel: NavigationModel
    @State var controller : FinalPreviewController
    @StateObject var speechRecognizer = SpeechRecognizerHelper()
    @State  var postModel : PostModel = PostModel()
    @State var songModel : DeezerSongModel? = DeezerSongModel()
    @State var speed : Float = 1.0
    @State  var renderUrl : URL?
    @State var trimRenderUrl = URL(string: "")
    @Binding var showPreview: Bool
    @State  var finalVideoPost: Bool = false
     let uploadReels: UploadReelsResource = UploadReelsResource()
    @State  var isPlaying: Bool = false;
    @State  var loading: Bool = false
    @State  var stickerOffset = CGSize.zero
    @State  var textOffset = CGSize.zero
    @State  var accumulatedTextOffset = CGSize.zero
    @State  var accumulatedstickerOffset = CGSize.zero
    @State  var stickerScale : CGFloat = 1.0
    @State  var textScale : CGFloat = 1.0
    @State  var enableSticker : Bool = false
    @State  var markerStack : Bool = false
    @State  var markerHeader : Bool = false
    @State  var enableText : Bool = false
    @State  var showTextAlert = false
    @State  var showStickerView = false
    @State  var showPrivacySettings = false
    @State  var text = ""
    @State  var isRecording = false
    @State  var textView : AnyView?
    @State  var stickerTextName = ""
    @State  var adjustmentView = false
    @State  var voiceOverView = false
    @StateObject var cameraModel = CameraViewModel()
    @Binding var url: URL
    @State var changeURL = URL(string: "")
    @StateObject var drawingDocument = DrawingDocument()
    @State private var deletedLines = [Line]()
    
    @State private var selectedColor: Color = .black
    @State private var selectedLineWidth: CGFloat = 1
    
    let engine = DrawingEngine()
    @State private var showConfirmation: Bool = false
    @State var isTapped = false
    @State var generatedImage: UIImage?
    
    
    
//    @State var playermanager = PlayerViewModel()

    
    var body: some View{
        
        NavigationView {
            
            GeometryReader{proxy in
                let size = proxy.size
                let stickerView = stickerView(cameraSize: size)
                contentView(size:size)
                    .disabled(true)
                    .onDisappear{
//                        controller.videoPlayer.stopAllProcesses()
                         print("final preview disappear---------------------")
                    }
                    .onTapGesture {
                        if(controller.isPlaying) {
//                            controller.audioPlayer.pauseAudio()
                            controller.pause()
                        }else {
//                            controller.audioPlayer.playAudio()
                            controller.play()
                        }
                    }
                    .overlay {
                        if(markerStack){
                            markerView(cameraSize: size)
                        }
                        if(enableText && textView != nil){
                            textView(cameraSize: size)
                        }
                        if(enableSticker){
                            stickerView
                        }
                        if(self.postModel.enableCaptions){
                            VStack{
                                Spacer()
                                Text(self.controller.captioning)
                                    .font(.body)
                                    .background(Color.black.opacity(0.5))
                                    .foregroundColor(Color.white)
//                                    .offset(y:100)
                    //                .frame(height:350)
                                    .truncationMode(.head)
                                    .lineLimit(2)
                                    .padding()
                            }
                            .padding(.bottom,100)
                        }
                        if(loading){
                            ProgressView()
                                .foregroundColor(.white)
                        }
                    }
                    .overlay(alignment: .top){
                        if markerHeader {
                            HStack {
                                ColorPicker("line color", selection: $selectedColor)
                                    .labelsHidden()
                                Slider(value: $selectedLineWidth, in: 1...20) {
                                    Text("linewidth")
                                }.frame(maxWidth: 100)
                                Text(String(format: "%.0f", selectedLineWidth))
                                
                                Spacer()
                                
//                                Button {
//                                    let last = drawingDocument.lines.removeLast()
//                                    deletedLines.append(last)
//                                } label: {
//                                    Image(systemName: "arrow.uturn.backward.circle")
//                                        .imageScale(.large)
//                                }.disabled(drawingDocument.lines.count == 0)
//
//                                Button {
//                                    let last = deletedLines.removeLast()
//
//                                    drawingDocument.lines.append(last)
//                                } label: {
//                                    Image(systemName: "arrow.uturn.forward.circle")
//                                        .imageScale(.large)
//                                }.disabled(deletedLines.count == 0)
                                
                                Button(action: {
                                    markerHeader = false
                                    
                                }) {
                                    Text("Done")
                                }.foregroundColor(.white)
                                Button(action: {
                                    showConfirmation = true
                                }) {
                                    Text("Delete")
                                }.foregroundColor(.red)
                                    .confirmationDialog(Text("Are you sure you want to delete everything?"), isPresented: $showConfirmation) {
                                        
                                        Button("Delete", role: .destructive) {
                                            drawingDocument.lines = [Line]()
                                            deletedLines = [Line]()
                                        }
                                    }
                                
                            }.padding(.top, 30)
                                .padding()
                        }
                    }
                
                // MARK: Back Button
                    .overlay(alignment: .topLeading) {
                        Button {
                            showPreview.toggle()
                            presentaionMode.wrappedValue.dismiss()
                        } label: {
                            Image("BackButtonWhite")
                                .frame(width: 40, height: 40)
                        }
                        .padding(.leading)
                        .padding(.top, 70)
                    }
                
                // MARK: Traling Side Button
                    .overlay(alignment: .topTrailing) {
                        VStack {
                            
                            VStack {
                                
                                Button {
                                    if(enableText){
                                        self.postModel.contentOverlay.removeAll(where: {val in val.type == TypeOfOverlay.text})
                                        enableText = false
                                        textScale = 1.0
                                        textOffset = CGSize(width: 0, height: 0)
                                        self.postModel.audioContentUrl = nil
                                    }else{
                                        showTextAlert = true
                                    }
                                } label: {
                                    VStack{
                                        if(self.enableText)
                                        {
                                            
                                            Image("PreviewText")
                                            Text("Text")
                                                .font(.custom("Urbanist-Medium", size: 12))
                                                .foregroundColor(ColorsHelper.deepPurple)
                                                .padding(.top, -5)
                                        }else
                                        {
                                            Image("addText")
                                            Text("Text")
                                                .font(.custom("Urbanist-Medium", size: 12))
                                                .foregroundColor(.white)
                                                .padding(.top, -5)
                                        }
                                    }
                                    
                                }
                                Button {
                                    markerStack = true
                                    markerHeader = true
                                } label: {
                                    VStack{
                                        if(self.markerStack)
                                        {
                                            
                                            Image("editPurple")
                                            Text("Marker")
                                                .font(.custom("Urbanist-Medium", size: 12))
                                                .foregroundColor(ColorsHelper.deepPurple)
                                                .padding(.top, -5)
                                        }else
                                        {
                                            Image("edit")
                                            Text("Marker")
                                                .font(.custom("Urbanist-Medium", size: 12))
                                                .foregroundColor(.white)
                                                .padding(.top, -5)
                                        }
                                    }
                                    
                                }
//                                .alert("Add text", isPresented: $showTextAlert, actions: {
//                                    // Any view other than Button would be ignored
//                                    TextField(
//                                        "Text",
//                                        text: $text,
//                                        onEditingChanged:{val in
//                                            if(!val)
//                                            {
//                                                enableText = true
//                                                showTextAlert = false
//                                            }
//                                        }
//                                    )
//                                })
                                
                                
                                Button {
                                    enableSticker.toggle()
                                    if(!enableSticker){
                                        stickerScale = 1.0
                                        stickerOffset = CGSize(width: 0, height: 0)
                                    }else{
                                        showStickerView.toggle()
                                    }
//                                    controller.addStickerToVide(videoUrl: self.url, callback: {url in
//                                        self.url = url
//                                        self.controller.videoPlayer = AVPlayer(url: url)
//                                        self.controller.play()
//                                    })
                                } label: {
                                    if(self.enableSticker)
                                    {
                                        VStack{
                                            Image("stickerPurple")
                                            Text("Stickers")
                                                .font(.custom("Urbanist-Medium", size: 12))
                                                .foregroundColor(ColorsHelper.deepPurple)
                                                .padding(.top, -5)
                                        }
                                    }else{
                                        VStack{
                                            Image("PreviewStickers")
                                            Text("Stickers")
                                                .font(.custom("Urbanist-Medium", size: 12))
                                                .foregroundColor(.white)
                                                .padding(.top, -5)
                                        }
                                    }
                                    
                                }
                                
                                
//                                Button {
//
//                                } label: {
//                                    Image("PreviewFilter")
//                                }
//                                Text("Filters")
//                                    .font(.custom("Urbanist-Medium", size: 12))
//                                    .foregroundColor(.white)
//                                    .padding(.top, -5)
//
                                Button {
                                    
                                } label: {
                                    if(true)
                                    {
                                        Image("PreviewEffects")
                                    }else{
                                        Image("effectsPurple")
                                    }
                                }
                                Text("Effects")
                                    .font(.custom("Urbanist-Medium", size: 12))
                                    .foregroundColor(.white)
                                    .padding(.top, -5)
                                
                                Button {
                                    self.postModel.enableCaptions.toggle()
                                    self.postModel = self.postModel
                                    self.controller.forcePlay()
                                } label: {
                                    VStack{
                                        if(!self.postModel.enableCaptions)
                                        {
                                            Image("PreviewCaption")
                                            Text("Captions")
                                                .font(.custom("Urbanist-Medium", size: 12))
                                                .foregroundColor(.white)
                                                .padding(.top, -5)
                                        }else{
                                            Image("captionsPurple")
                                            Text("Captions")
                                                .font(.custom("Urbanist-Medium", size: 12))
                                                .foregroundColor(ColorsHelper.deepPurple)
                                                .padding(.top, -5)
                                        }
                                    }
                                }
                                
                                
                            }
                            
                            VStack {
                                
                                Button {
                                    adjustmentView = true
                                    controller.pause()
                                    
                                } label: {
                                    
                                    VStack{
                                        Image("PreviewPlay")
                                        Text("Adjust")
                                            .font(.custom("Urbanist-Medium", size: 12))
                                            .foregroundColor(.white)
//                                            .padding(.top, -5)
                                    }
                                }
                                
                                let url = self.postModel.contentUrl
                                let audioURL = URL(string: songModel?.preview ?? "")
//                                let pathUrl = url?.path
                                let asset = AVURLAsset(url: url!, options: nil)
                                let playermanager = PlayerViewModel(videoUrl: url!, speed: speed)
                                let audioPlayermanager = AudioPlayerViewModel(videoUrl: audioURL)
                                
                                NavigationLink(destination:
                                                AdjustVideoView(url: url, slider: CustomSlider(start: 1, end: asset.duration.seconds), playerVM: playermanager, audioPlayerVM: audioPlayermanager, renderUrl: $changeURL, postModel: $postModel, callWhenBack: callWithBack, speed: $speed)
                                    .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $adjustmentView) {
                                        EmptyView()
                                    }
                                
                                if(self.postModel.isImageContent() == false)
                                {
                                    Button {
                                        if(self.postModel.audioContentUrl != nil)
                                        {
                                            self.postModel.audioContentUrl = nil
                                            self.postModel = self.postModel
                                            self.controller.forcePlay()
                                            return
                                        }
                                        self.controller.textToSpeech(post: self.postModel, callback: {val in
                                            self.postModel.audioContentUrl = val
                                            self.postModel = self.postModel
                                            self.controller.forcePlay()
                                            let _ = SoundsManagerHelper.instance.playAudioFromUrl(url: val.absoluteString)
                                            
    //                                        #if DEBUG
    //                                            self.controller.mergeVideoAndAudio(videoUrl: self.postModel.contentUrl!, audioUrl: self.postModel.audioContentUrl!, completion: {error, url in
    //                                                guard let url = url else {
    //                                                    print("error merging audio")
    //                                                    return
    //                                                }
    //                                                print("merged text to speech with content")
    //                                                loading = false
    //                                                DispatchQueue.main.async {
    //                                                    self.postModel.contentUrl = url
    //                                                    self.controller.setNewUrl(url: url)
    //                                                    self.controller.forcePlay()
    //                                                }
    //                                            })
    //                                        #else
    //                                            self.controller.forcePlay()
    //                                            let _ = SoundsManagerHelper.instance.playAudioFromUrl(url: val.absoluteString)
    //                                        #endif
                                        })
                                    } label: {
                                        VStack{
                                            if(self.postModel.audioContentUrl != nil)
                                            {
                                                Image("speechPurple")
                                            }else{
                                                Image("speechIcon")
                                            }
                                            Text("Text To\nSpeech")
                                                .font(.custom("Urbanist-Medium", size: 12))
                                                .foregroundColor(.white)
                                            
                                            
    //                                            .padding(.top, -5)
                                        }
                                    }
                                }
//                                let playermanager = PlayerViewModel(videoUrl: url!)
                                NavigationLink(destination:
                                                SoundEditView(url: url,playerVM: playermanager, audioPlayerVM: audioPlayermanager, postModel: $postModel, songModel: songModel, speed: $speed, callWhenBack: callWithBack)
                                    .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $voiceOverView) {
                                        EmptyView()
                                    }
                                
                                Button {
                                    
                                    voiceOverView.toggle()
                                    
//                                    if(!isRecording){
//                                        controller.startRecording()
//                                    }else
//                                    {
//                                        controller.stopRecording()
//                                        mergeRecordAudioWithVideo()
//                                    }
//                                    isRecording.toggle()
                                    
                                    
                                } label: {
                                    VStack{
                                        Image("PreviewVoice")
                                        Text("Audio")
                                            .font(.custom("Urbanist-Medium", size: 12))
                                            .foregroundColor(.white)
                                            .padding(.top, -5)
                                        
                                        Text("Editing")
                                            .font(.custom("Urbanist-Medium", size: 12))
                                            .foregroundColor(.white)
                                            .padding(.top, -10)
                                    }
                                }
                                
                                
                                Button {
                                    loading = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0){
                                        controller.denoiseVideo(inputURL: self.postModel.contentUrl!, outputURL: self.postModel.contentUrl!){ outputUrll in
                                            if (outputUrll != nil){
                                                if let outputURL = outputUrll {
                                                    self.renderUrl = outputURL
                                                    self.postModel.contentUrl = outputURL
                                                    // Denoising process completed successfully, use the denoised video at "outputURL"
                                                    print("Denoised video saved at: \(outputURL)")
                                                    let isImage = !(renderUrl!.absoluteString.lowercased().contains(".mp4") || renderUrl!.absoluteString.lowercased().contains(".mov"))
                                                    controller = FinalPreviewController(url: renderUrl!, isImage: isImage, speed: speed)
                                                    loading = false
                                                    // Perform further actions, like displaying the denoised video or saving it to the camera roll
                                                } else {
                                                    // Error occurred during denoising process
                                                    print("Error: Noise reduction failed.")
                                                    // Handle the error if noise reduction fails
                                                }
                                            }
                                            //                                        controller.noiseReductionToVideo(videoUrl: self.postModel.contentUrl!.absoluteString,callback: {val in
                                            //                                            self.postModel.contentUrl = val
                                            //                                            self.controller.setNewUrl(url: self.postModel.contentUrl!)
                                            //                                            self.controller.play()
                                            //                                            loading = false
                                            //                                        })
                                        }
                                    }
                                } label: {
                                    Image("PreviewReduceNoise")
                                }
                                Text("Reduce")
                                    .font(.custom("Urbanist-Medium", size: 12))
                                    .foregroundColor(.white)
                                    .padding(.top, -5)
                                Text("Noise")
                                    .font(.custom("Urbanist-Medium", size: 12))
                                    .foregroundColor(.white)
                                    .padding(.top, -10)
                                
                                Button {
                                    self.showPrivacySettings = true
                                } label: {
                                    VStack{
                                        if(self.postModel.visibility != .everyone)
                                        {
                                            Image("privacyPurple")
                                            Text("Privacy Setting")
                                                .frame(width: 50)
                                                .multilineTextAlignment(.center)
                                                .font(.custom("Urbanist-Medium", size: 12))
                                                .foregroundColor(ColorsHelper.deepPurple)
                                        }else{
                                            Image("PreviewPrivacySettings")
                                            Text("Privacy Setting")
                                                .frame(width: 50)
                                                .multilineTextAlignment(.center)
                                                .font(.custom("Urbanist-Medium", size: 12))
                                                .foregroundColor(.white)
                                        }
                                        
//                                            .padding(.top, -5)
                                    }
                                }
                                
                                
                                //                            VStack {
                                //                                Text("Settings")
                                //                                    .font(.custom("Urbanist-Medium", size: 12))
                                //                                    .foregroundColor(.white)
                                //                                    .padding(.top, -5)
                                //                            }
                                
                            }
                            
                            
                        }
                        .onDisappear{
                            DispatchQueue.main.async {
                                controller.pause()
                                print("Player Stoped")
                            }
                        }
                        
                        .padding(.top, 100)
                        .padding(.trailing, 20)
                        
                    }
                
                
                // MARK: Next and Draft Button
                
                    .overlay(alignment: .bottom) {
                        
                        HStack {
                            Button {
                                
                            } label: {
                                Spacer()
                                Text("Post to Story")
                                    .font(.custom("Urbanist-Bold", size: 16))
                                    .foregroundStyle(
                                        LinearGradient(colors: [
                                            Color("buttionGradientTwo"),
                                            Color("buttionGradientOne"),
                                        ], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .padding()
                                Spacer()
                            }
                            .background(Color("SkipButtonBackground"))
                            .cornerRadius(40)
                            
                            Spacer()
                            Spacer()
                            
                            Button {
                                loading = true
                                self.renderUrl = self.postModel.contentUrl
                                if(self.postModel.audioContentUrl != nil)
                                {
                                    print("merging text to speech with content")
                                    self.controller.mergeVideoAndAudio(videoUrl: self.postModel.contentUrl!, audioUrl: self.postModel.audioContentUrl!, completion: {error, url in
                                        guard let url = url else {
                                            print("error merging audio")
                                            return
                                        }
                                        print("merged text to speech with content")
                                        loading = false
                                        self.renderUrl = url
                                        DispatchQueue.main.async {
                                                loading = true
                                                render(size: size,callback: {url in
                                                    loading = false
                                                    self.renderUrl = url
                                                    self.cameraModel.previewURL = url
                                                    if(enableSticker){
                                                        let model = postModel.contentOverlay.first(where: {val in val.type == .sticker})
                                                        if(model == nil){
                                                            self.postModel.contentOverlay.append(ContentOverlayModel(type: .sticker, size: stickerOffset, scale: stickerScale, value: self.stickerTextName, color: .black, fontSize: 0, enableBackground: false, font: .system))
                                                        }
                                                    }
                                                    if(enableText){
                                                        var model = postModel.contentOverlay.first(where: {val in val.type == TypeOfOverlay.text})
                                                        if(model != nil){
                                                            self.postModel.contentOverlay.removeAll(where: {val in val.type == TypeOfOverlay.text})
                                                            model!.size = textOffset
                                                            self.postModel.contentOverlay.append(model!)
                                                        }
                                                    }
                                                    finalVideoPost.toggle()
                                                })
                                            loading = true
                                        }
                                    })
                                }else{
                                        loading = true
                                        render(size: size,callback: {url in
                                            loading = false
                                            self.renderUrl = url
                                            if(enableSticker){
                                                let model = postModel.contentOverlay.first(where: {val in val.type == .sticker})
                                                if(model == nil){
                                                    self.postModel.contentOverlay.append(ContentOverlayModel(type: .sticker, size: stickerOffset, scale: stickerScale, value: self.stickerTextName, color: .black, fontSize: 0, enableBackground: false, font: .system))
                                                }
                                            }
                                            if(enableText){
                                                var model = postModel.contentOverlay.first(where: {val in val.type == TypeOfOverlay.text})
                                                if(model != nil){
                                                    self.postModel.contentOverlay.removeAll(where: {val in val.type == TypeOfOverlay.text})
                                                    model!.size = textOffset
                                                    self.postModel.contentOverlay.append(model!)
                                                }
                                            }
                                            finalVideoPost.toggle()
                                        })
                                    loading = true
                                }
                            } label: {
                                Spacer()
                                Text("Next")
                                    .font(.custom("Urbanist-Bold", size: 16))
                                    .foregroundColor(.white)
                                    .padding()
                                Spacer()
                            }
                            .background(
                                LinearGradient(colors: [
                                    Color("buttionGradientTwo"),
                                    Color("buttionGradientOne"),
                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .cornerRadius(40)
                            
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                        
                    }
                
                    .overlay{
                        if(showTextAlert){
                            EditTextView(
                                callback: {content,view in
                                    let model = postModel.contentOverlay.first(where: {val in val.type == TypeOfOverlay.text})
                                    if(model != nil){
                                        self.postModel.contentOverlay.removeAll(where: {val in val.type == TypeOfOverlay.text})
                                    }
                                    self.postModel.contentOverlay.append(content)
                                    textView = view
                                    self.showTextAlert = false
                                    self.enableText = true
                                },
                                cancellCallback:{
                                    self.showTextAlert = false
                                    self.enableText = false
                                },
                                currentContent:self.postModel.getTextOverlayContent
                            )
                        }
                        
                    }
                    .overlay{
                        if(showStickerView){
                            AddStickerView(callback: {content,stickerName in
                                self.postModel.contentOverlay.removeAll(where: {val in val.type == TypeOfOverlay.sticker})
                                self.stickerTextName = stickerName
                                self.postModel.contentOverlay.append(content)
                                self.enableSticker = true
                                self.showStickerView = false
                            },
                                cancellCallback:{
                                    self.showStickerView = false
                                    self.enableSticker = false
                                }
                            )
                            
                        }
                    }
                    .overlay{
                        if(self.showPrivacySettings)
                        {
                            PostVisibilityView(
                                currentVisibility: self.postModel.visibility,
                                callback:{type in
                                    self.showPrivacySettings = false
                                    self.postModel.visibility = type
                                }
                            )
                        }
                    }
                
                NavigationLink(destination: FinalVideoToPostView(postModel: self.postModel,renderUrl : self.renderUrl)
                    .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $finalVideoPost) {
                        EmptyView()
                    }
                
            }
            .ignoresSafeArea(.all)
            .navigationBarHidden(true)
        }
        .onAppear {
            print("final preview appear----------------")
            self.postModel.contentUrl = url
            self.postModel.speed = speed
            self.postModel.songModel = songModel
            controller.loadData(url: url)
            controller.audio = URL(string: songModel?.preview ?? "")
            print("URL FINAL PREVIEW1: " + url.absoluteString)
        }
    }
    
    
    func callWithBack()  {
        if let url = postModel.contentUrl {
            self.url = url
            for _ in 0...2{
                controller.loadData(url: url)
                controller.audio = URL(string: songModel?.preview ?? "")
                print("URL FINAL PREVIEW1: " + url.absoluteString)
            }
        }
    }
    
    func renderView(cameraSize : CGSize) -> some View{
        ZStack{
            if(enableText){
                textView(cameraSize: cameraSize)
            }
            if(enableSticker){
                stickerView(cameraSize: cameraSize)
            }
            if(markerStack){
                markerView(cameraSize: cameraSize)
            }
        }
    }
    
    @MainActor func render(size : CGSize, callback : @escaping (URL) -> ()) {
        //        let render = Image("PreviewStickers").asUIImage()
        var array = [(UIImage,CGSize)]()
        if(enableSticker){
            let view = stickerView(cameraSize: size).offset(CGSize(width: -stickerOffset.width, height: -stickerOffset.height))
            array.append((view.asUIImage(),stickerOffset))
        }
        if(enableText){
            let view = textView(cameraSize: size).offset(CGSize(width: -textOffset.width, height: -textOffset.height))
            array.append((view.asUIImage(),textOffset))
        }
        if(markerStack){
            let view = markerView(cameraSize: size).offset(x: 0,y: 0)
            array.append((view.asUIImage(),textOffset))
        }
        if(!enableText && !enableSticker && !markerStack){
            self.renderUrl = self.postModel.contentUrl
            callback(self.renderUrl!)
            return
        }
        print("CAMERA SIZE: "+size.debugDescription)
        controller.mergeVideoAndImage(video: self.renderUrl!, withForegroundImages: array, completion: {val in
                guard let url = val else{
                    print("merge url not correct")
                    return
                }
                DispatchQueue.main.async {
                    
                    callback(url)
                }
            })
        
        
    }
    
    
    
//    fileprivate func trimVideoAtUrl(_ url: URL) {
//
//    }
    
    
    ///Video or image content view
    func contentView(size:CGSize) -> some View{
        let isImage = self.postModel.isImageContent()
        
        return ZStack(alignment:.center){
            if isImage{
                VStack{
                    Spacer()
                    AsyncImage(url: self.postModel.contentUrl){image in
                        image.resizable()
                    }
                placeholder:{
                    ProgressView()
                }
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width,alignment: .center)
                    Spacer()
                }
            }else{
                VideoPlayer(player: controller.videoPlayer.player)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
            }
        }
        .background {
            Color.black
                .ignoresSafeArea(.all)
        }
    }
    
//    func entireView(size : CGSize) -> some View{
//        return ZStack{
//            contentView(size: size)
//                .overlay {
//                    if(enableText && textView != nil){
//                        textView(cameraSize: size)
//                    }
//                    if(enableSticker){
//                        stickerView
//                    }
//
//                    if(loading){
//                        ProgressView()
//                            .foregroundColor(.white)
//                    }
//                }
//
//        }
//
//
//    }
    
    
    func markerView(cameraSize: CGSize) -> some View{
        ZStack {
            Image(uiImage: UIImage.from(color: .clear, size: CGSize(width: cameraSize.width, height: cameraSize.height)))
                .opacity(0.1)
                .gesture(markerHeader ?
                         DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        let newPoint = value.location
                        if value.translation.width + value.translation.height == 0 {
                            // TODO: use selected color and linewidth
                            drawingDocument.lines.append(Line(points: [newPoint], color: selectedColor, lineWidth: selectedLineWidth))
                        } else {
                            let index = drawingDocument.lines.count - 1
                            drawingDocument.lines[index].points.append(newPoint)
                        }
                    }
                    .onEnded { value in
                        if let last = drawingDocument.lines.last?.points, last.isEmpty {
                            drawingDocument.lines.removeLast()
                        }
                    }
                         : nil  // Do nothing when markerHeader is false
                )
            ForEach(drawingDocument.lines){ line in
                DrawingShape(points: line.points)
                    .stroke(line.color, style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
            }
        }
    }
    
    func stickerView(cameraSize : CGSize) -> some View{
        Image(uiImage: stickerTextName.image()!)
            .resizable()
            .scaledToFit()
            .frame(width: 100 * self.stickerScale, height: 100 * self.stickerScale)
//            .scaleEffect(stickerScale)
            .offset(x: stickerOffset.width, y: stickerOffset.height )
            .gesture(
                DragGesture(minimumDistance: 2)
                    .onChanged { gesture in
                        let width = gesture.translation.width
                        let height = gesture.translation.height
                        let accWidth = self.accumulatedstickerOffset.width
                        let accHeight = self.accumulatedstickerOffset.height
                        self.stickerOffset = CGSize(width: width + accWidth, height: height + accHeight)
                    }
                    .onEnded { gesture in
                        let offset = CGSize(width: gesture.translation.width + self.accumulatedstickerOffset.width, height: gesture.translation.height + self.accumulatedstickerOffset.height)
                        self.accumulatedstickerOffset = offset
                        self.stickerOffset = offset
                    }
            )
            .gesture(
                MagnificationGesture()
                   .onChanged() { val in
                       let scale = self.stickerScale * val.magnitude * 0.5
                       if(scale > 0.8 && scale < 10){
                           self.stickerScale = scale
                       }
                   }
                    
            )
            .animation(.linear, value: stickerOffset)
            .animation(.linear, value: stickerScale)
    }
    
    func textView(cameraSize : CGSize) -> some View{
        return (textView ?? AnyView(Text("")))
            .disabled(true)
            .offset(textOffset)
            .onTapGesture {
                if(textView != nil)
                {
                    self.showTextAlert = true
                    self.enableText = false
                }
            }
            .gesture(
                DragGesture(minimumDistance: 2)
                    .onChanged { gesture in
                        let width = gesture.translation.width
                        let height = gesture.translation.height
                        let accWidth = self.accumulatedTextOffset.width
                        let accHeight = self.accumulatedTextOffset.height
                        self.textOffset = CGSize(width: width + accWidth, height: height + accHeight)
                    }
                    .onEnded{gesture in
                        let offset = CGSize(width: gesture.translation.width + self.accumulatedTextOffset.width, height: gesture.translation.height + self.accumulatedTextOffset.height)
                        self.accumulatedTextOffset = offset
                        self.textOffset = accumulatedTextOffset
                    }
            )
            .gesture(
                MagnificationGesture()
                   .onChanged() { val in
                       let scale = self.textScale * val.magnitude
                       if(scale < 3 && scale > 0.25){
                           self.textScale = scale
                       }
                   }
            )
            .animation(.linear, value: textOffset)
    }
    
    
//    struct AVPlayerView: UIViewControllerRepresentable {
//
//        @Binding var videoController: AVPlayerViewController
//
////        private var player: AVPlayer {
////            return AVPlayer(url: videoURL!)
////        }
//
//        func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
//            playerController.modalPresentationStyle = .fullScreen
////            playerController.player = player
//            playerController.player?.play()
//        }
//
//        func makeUIViewController(context: Context) -> AVPlayerViewController {
//            return videoController
//        }
//    }
    
//    private func uploadReelss(complitionHandler : @escaping(Bool) -> Void) {
//        uploadReels.uploadReels(imageUploadRequest: url, paramName: "asset", fileName: "fs.mp4") { responsee, errorMessage in
//            DispatchQueue.main.async {
//                if(responsee == true) {
//                    print("Sucessss......")
//                    complitionHandler(true)
//                } else {
//                    print("Errror.....=======")
//                    complitionHandler(false)
//                }
//            }
//        }
//    }
    
}

extension UIImage {
    static func from(color: UIColor, size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}
//struct FinalPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        FinalPreview(url: URL(string: "")!, showPreview: .constant(true), songModel: nil)
//    }
//}
