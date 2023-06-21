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

// MARK: Final Video Preview
struct FinalPreview: View{
    @Environment(\.presentationMode) var presentaionMode
    @EnvironmentObject private var navigationModel: NavigationModel
    @ObservedObject private var controller : FinalPreviewController
    @StateObject var speechRecognizer = SpeechRecognizerHelper()
    @State private var postModel : PostModel
    @State var songModel : DeezerSongModel?
    @State var speed : Float
    @State private var renderUrl : URL?
    @State var trimRenderUrl = URL(string: "")
    @Binding var showPreview: Bool
    @State private var finalVideoPost: Bool = false
    private let uploadReels: UploadReelsResource = UploadReelsResource()
    @State private var isPlaying: Bool = false;
    @State private var loading: Bool = false
    @State private var stickerOffset = CGSize.zero
    @State private var textOffset = CGSize.zero
    @State private var accumulatedTextOffset = CGSize.zero
    @State private var accumulatedstickerOffset = CGSize.zero
    @State private var stickerScale : CGFloat = 1.0
    @State private var textScale : CGFloat = 1.0
    @State private var enableSticker : Bool = false
    @State private var enableText : Bool = false
    @State private var showTextAlert = false
    @State private var showStickerView = false
    @State private var showPrivacySettings = false
    @State private var text = ""
    @State private var isRecording = false
    @State private var textView : AnyView?
    @State private var stickerTextName = ""
    @State private var navigateToNextView = false
    
//    @State var playermanager = PlayerViewModel()
    
    init(url:URL, showPreview: Binding<Bool>,songModel : DeezerSongModel?, speed : Float = 1){
        _songModel = State(initialValue: songModel)
        _showPreview = showPreview
        _postModel = State(initialValue: PostModel())
        _speed = State(initialValue: speed)
        let isImage = !(url.absoluteString.lowercased().contains(".mp4") || url.absoluteString.lowercased().contains(".mov"))
        controller = FinalPreviewController(url: url, isImage:  isImage ,speed: speed)
        self.postModel.contentUrl = url
        self.postModel.speed = speed
        self.postModel.songModel = songModel
       
        print("URL FINAL PREVIEW1: " + (url.absoluteString ))
//        playermanager.videoUrl = url
    }
    ///add deezer audio to video
    func addSongAudio(){
        
        if(self.postModel.isImageContent() == false){
        }else{
            return
        }
        if(songModel == nil)
        {
            print("song not present on video")
            controller.play()
            loading = false
            return
        }
        loading = true
        controller.mergeVideoAndAudio(videoUrl: self.postModel.contentUrl!, audioUrl: URL(string: songModel?.preview ?? "")!, completion:{error, url in
            guard let url = url else{
                print("error merging video and audio")
                return
            }
            print("video and audio merge, new url: "+url.absoluteString)
            print("last url: "+self.postModel.contentUrl!.absoluteString)
            self.postModel.contentUrl = url
            loading = false
            DispatchQueue.main.async {
                self.controller.setNewUrl(url: url)
                self.controller.play()
            }
        })
    }
    
    ///add record audio to video
    func mergeRecordAudioWithVideo(){
        let audioURL = controller.audioRecorder.url
        controller.mergeVideoAndAudio(videoUrl: self.postModel.contentUrl!, audioUrl: audioURL, completion: {error, url in
            guard let url = url else{
                print("error merging video and audio")
                return
            }
            DispatchQueue.main.async {
                self.controller.setNewUrl(url: url)
                self.postModel.contentUrl = url
                controller.play()
            }
        })
    }
    
    var body: some View{
        
        NavigationView {
            
            GeometryReader{proxy in
                let size = proxy.size
                let stickerView = stickerView(cameraSize: size)
                contentView(size:size)
                    .disabled(true)
                    .onAppear{
                        addSongAudio()
                    }
                    .onTapGesture {
                        if(controller.isPlaying)
                        {
                            controller.pause()
                        }else
                        {
                            controller.play()
                        }
                    }
                    .overlay {
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
//                                    if(speechRecognizer.transcript != "")
//                                    {
//                                        speechRecognizer.reset()
//                                        self.postModel.enableCaptions = false
//                                        self.postModel.audioContentUrl = nil
//                                        print("reset transcript")
//                                        return
//                                    }
                                    
                                    self.postModel.enableCaptions.toggle()
                                    self.postModel = self.postModel
                                    self.controller.play()
                                    //                                    controller.getAudioFromVideoUrl(url: self.postModel.contentUrl!.absoluteString, callback: {val in
//                                        DispatchQueue.main.async {
////                                            self.controller.videoPlayer.player = vmInput.player
//
//                                        }
//                                    })
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
                                    navigateToNextView = true
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
//                                let pathUrl = url?.path
                                let asset = AVURLAsset(url: url!, options: nil)
                                let playermanager = PlayerViewModel(videoUrl: url!)
                                
                                
                                NavigationLink(destination:
                                                AdjustVideoView(slider: CustomSlider(start: 1, end: asset.duration.seconds), playerVM: playermanager, renderUrl:$renderUrl, postModel: $postModel, callWhenBack: callWithBack)
                                    .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $navigateToNextView) {
                                        EmptyView()
                                    }
                                
                                if(self.postModel.isImageContent() == false)
                                {
                                    Button {
                                        if(self.postModel.audioContentUrl != nil)
                                        {
                                            self.postModel.audioContentUrl = nil
                                            self.postModel = self.postModel
                                            self.controller.play()
                                            return
                                        }
                                        self.controller.textToSpeech(post: self.postModel, callback: {val in
                                            self.postModel.audioContentUrl = val
                                            self.postModel = self.postModel
                                            self.controller.play()
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
                                                Text("Speech")
                                                    .font(.custom("Urbanist-Medium", size: 12))
                                                    .foregroundColor(ColorsHelper.deepPurple)
                                            }else{
                                                Image("speechIcon")
                                                Text("Speech")
                                                    .font(.custom("Urbanist-Medium", size: 12))
                                                    .foregroundColor(.white)
                                                    
                                            }
                                            
                                            
    //                                            .padding(.top, -5)
                                        }
                                    }
                                }
                                
                                
                                
                                Button {
                                    if(!isRecording){
                                        controller.startRecording()
                                    }else
                                    {
                                        controller.stopRecording()
                                        mergeRecordAudioWithVideo()
                                    }
                                    isRecording.toggle()
                                    
                                    
                                } label: {
                                    if(!self.isRecording)
                                    {
                                        Image("PreviewVoice")
                                    }else{
                                        Image("microphonePurple")
                                    }
                                }
                                Text("Audio")
                                    .font(.custom("Urbanist-Medium", size: 12))
                                    .foregroundColor(.white)
                                    .padding(.top, -5)
                                
                                Text("Editing")
                                    .font(.custom("Urbanist-Medium", size: 12))
                                    .foregroundColor(.white)
                                    .padding(.top, -10)
                                
                                Button {
                                    loading = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0){
                                        controller.noiseReductionToVideo(videoUrl: self.postModel.contentUrl!.absoluteString,callback: {val in
                                            self.postModel.contentUrl = val
                                            self.controller.setNewUrl(url: self.postModel.contentUrl!)
                                            self.controller.play()
                                            loading = false
                                        })
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
                                            if(self.postModel.isImageContent()){
                                                let data = try? Data(contentsOf: self.renderUrl!)
                                                let uiImage = UIImage(data: data!)!
                                                let image = Image(uiImage: uiImage)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: UIScreen.main.screenWidth() ,height:UIScreen.main.screenHeight() )
            //                                        .rotationEffect(.degrees(90))
                                                    .overlay{
                                                        if(enableText && textView != nil){
                                                            textView(cameraSize: size)
                                                        }
                                                        if(enableSticker){
                                                            stickerView
                                                        }
                                                    }
                                                    .snapshot()
            //                                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                                                self.controller.storeImage(image, callback: {url in
                                                    loading = false
                                                    if(enableSticker){
                                                        let model = postModel.contentOverlay.first(where: {val in val.type == .sticker})
                                                        if(model == nil){
                                                            self.postModel.contentOverlay.append(ContentOverlayModel(type: .sticker, size: stickerOffset, scale: stickerScale, value: self.stickerTextName, color: .black, fontSize: 0, enableBackground: false, font: .system ))
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
                                                    self.renderUrl = url
                                                    finalVideoPost.toggle()
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
                                            }
                                            loading = true
                                        }
                                    })
                                }else{
                                    if(self.postModel.isImageContent()){
                                        let data = try? Data(contentsOf: self.renderUrl!)
                                        let uiImage = UIImage(data: data!)!
                                        let image = Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: UIScreen.main.screenWidth() ,height:UIScreen.main.screenHeight() )
    //                                        .rotationEffect(.degrees(90))
                                            .overlay{
                                                if(enableText && textView != nil){
                                                    textView(cameraSize: size)
                                                }
                                                if(enableSticker){
                                                    stickerView
                                                }
                                            }
                                            .snapshot()
    //                                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                                        self.controller.storeImage(image, callback: {url in
                                            loading = false
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
                                            self.renderUrl = url
                                            finalVideoPost.toggle()
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
                                    }
                                    loading = true
                                }
                                
                                
                                
                                
                            
                                
                                
//                                    uploadReelss { isSuccess in
//                                        if isSuccess {
//                                            print("success=========")
//                                        } else {
//                                            print("failed==========")
//                                        }
//                                    }
                                
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
        .onDisappear{
            controller.pause()
        }
    }
    
    func callWithBack()  {
        if let url = postModel.contentUrl {
            controller.videoPlayer.onChange(for: url )
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
        if(!enableText && !enableSticker){
            self.renderUrl = self.postModel.contentUrl
            callback(self.renderUrl!)
            return
        }
        print("CAMERA SIZE: "+size.debugDescription)
        if(postModel.isImageContent()){
            
        }else{
            controller.mergeVideoAndImage(video: self.renderUrl!, withForegroundImages: array, completion: {val in
                guard let url = val else{
                    print("merge url not correct")
                    return
                }
    //            PHPhotoLibrary.shared().performChanges({
    //                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
    //            }) { complete, error in
    //                if complete {
    //                    print("Saved to gallery")
    //                }
    //            }
                DispatchQueue.main.async {
    //                self.enableSticker = false
    //                self.enableText = false
    //                self.controller.videoPlayer = AVPlayer(url: url)
    //                self.postModel.contentUrl = url
                    
                    callback(url)
                }
            })
        }
        
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

//struct FinalPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        FinalPreview(url: URL(string: "")!, showPreview: .constant(true), songModel: nil)
//    }
//}
