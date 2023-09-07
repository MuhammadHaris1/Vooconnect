//
//  LiveViewersView.swift
//  Vooconnect
//
//  Created by Vooconnect on 23/12/22.
//

import SwiftUI
import AgoraVideoSwiftUI
import AgoraRtcKit

struct LiveViewersView: View {
    
    
    //Agora Start
    @State var isLocalInSession = false
    @State var isLocalAudioMuted = false
    
    @State var isRemoteInSession = false
    @State var isRemoteVideoMuted = true
    
    let localCanvas = VideoCanvas()
    let remoteCanvas = VideoCanvas()
    
    private let videoEngine = VideoEngine()
    private var rtcEngine: AgoraRtcEngineKit {
        get {
            return videoEngine.agoraEngine
        }
    }
    @State var idArr = [UInt]()
    //Agoora end
    
    
    @StateObject var cameraModel = CameraViewModel()
    
    
    @State var creatorDetaiSheet: Bool = false
    @State var weeklyRanking: Bool = false
    @State var viewers: Bool = false
    @State var goLiveTogetherSheet: Bool = false
    @State var questionAnswerSheet: Bool = false
    @State var giftSheet: Bool = false
    @State var sendSheet: Bool = false
    
    
    @State var sendRose: Bool = false
    
    @State private var commentFocused: Bool = false
    @State private var isEmoji: Bool = false
    @State private var comment: String = ""
    @State private var commentButton: Bool = false
    
    @State private var textFieldActive: Bool = false
    @FocusState private var focusedTwo: Bool
    @FocusState private var focused: Field?
    
    @Environment(\.presentationMode) var presentaionMode
    
    enum Field {
        case active
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                ZStack {
                    
                    if idArr.count <= 0 {
                        VideoSessionView(
                            backColor: Color("remoteBackColor"),
                            backImage: Image("vooconnectLogo"),
                            hideCanvas: !isLocalInSession,
                            canvas: localCanvas
                        ).edgesIgnoringSafeArea(.all)
                    } else {
                        VideoSessionView(
                            backColor: Color("remoteBackColor"),
                            backImage: Image("vooconnectLogo"),
                            hideCanvas: isRemoteVideoMuted || !isRemoteInSession || !isLocalInSession,
                            canvas: remoteCanvas
                        ).edgesIgnoringSafeArea(.all)
                    }
                    
                    
                    
//                    Image("ImageLV")
//                        .resizable()
//                        .scaledToFill()
//                        .ignoresSafeArea(.all)
                    
//                        .onTapGesture(count: 2) {
//                            print("Double tapped!")
//                        }
                    
                    // Top Headder
                    VStack {
                        
                        Text((UserDefaults.standard.value(forKey: UserdefaultsKey.streamTitle) as? String ?? "no title"))
                            .font(.custom("Urbanist-SemiBold", size: 14))
                            .foregroundColor(.white)
                            .padding(.vertical, 6)
                            .padding(.horizontal)
                            .background(Color(#colorLiteral(red: 0.2694437504, green: 0.284270972, blue: 0.3148175478, alpha: 0.6043822434)))
                            .cornerRadius(30)
                        
                        HStack {
                            
                            Button {
                                creatorDetaiSheet.toggle()
                            } label: {
                                Image("squareTwoS")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 48, height: 48)
                                    .cornerRadius(10)
                                    .clipped()
                            }

                            VStack(alignment: .leading) {
                                
                                Text("Sarah Wilona")
                                    .font(.custom("Urbanist-Bold", size: 14))
                                    .foregroundColor(.white)
                                
                                Text("Dancer & Singer")
                                    .font(.custom("Urbanist-Medium", size: 12))
                                    .foregroundColor(Color(#colorLiteral(red: 0.9022675753, green: 0.9022675753, blue: 0.9022675753, alpha: 0.2958402318)))
                                
                            }
                            
                            Spacer()
                            
                            Button {
                                
                            } label: {
                                Text("Follow")
                                    .font(.custom("Urbanist-SemiBold", size: 14))
                                    .foregroundColor(.white)
                            }
                            .padding(.vertical, 7)
                            .padding(.horizontal)
                            .background(LinearGradient(colors: [
                                Color("buttionGradientTwo"),
                                Color("buttionGradientOne"),
                              ], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .cornerRadius(20)

                            Spacer()
                            
                            HStack {
                                Image("UserLS")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 20, height: 20)
                                Text("3.6K")
                                    .font(.custom("Urbanist-SemiBold", size: 14))
                                    .foregroundColor(.white)
                            }
                            .onTapGesture {
                                viewers.toggle()
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 5)
                            .background(Color(#colorLiteral(red: 0.2694437504, green: 0.284270972, blue: 0.3148175478, alpha: 0.6004501242)))
                            .cornerRadius(30)
                            
                            Spacer()
                            
                            Button {
                                leaveChannel()
                                presentaionMode.wrappedValue.dismiss()
                            } label: {
                                Image("CategoriesLV")
                            }

                        }
                        
                        HStack {
                            
                            HStack {
                                Image("StarLV")
                                
                                Button {
                                    weeklyRanking.toggle()
                                } label: {
                                    Text("Weekly Tops")
                                        .font(.custom("Urbanist-Medium", size: 12))
                                        .foregroundColor(.white)
                                }

                                
                            }
                            .padding(.vertical, 6)
                            .padding(.horizontal)
                            .background(Color(#colorLiteral(red: 0.2694437504, green: 0.284270972, blue: 0.3148175478, alpha: 0.6004501242)))
                            .cornerRadius(30)
                            
                            HStack {
                                Image("DiscoveryLV")
                                Text("Explore")
                                    .font(.custom("Urbanist-Medium", size: 12))
                                    .foregroundColor(.white)
                            }
                            .padding(.vertical, 6)
                            .padding(.horizontal)
                            .background(Color(#colorLiteral(red: 0.2694437504, green: 0.284270972, blue: 0.3148175478, alpha: 0.6004501242)))
                            .cornerRadius(30)
                            
                            Spacer()
                            
                        }
                        
                        VStack {
                            ScrollView(showsIndicators: false) {
                                VStack {
                                    Spacer()
                                }
                                .background(Color.black)
                                Spacer()

                                LazyVGrid(columns: gridLayoutCommentLS, alignment: .center, spacing: columnSpacingCommentLS, pinnedViews: []) {
                                    Section()
                                    {
                                        ForEach(0..<8) { people in
                                            CommentListOnLive(creatorDetaiSheet: $creatorDetaiSheet)
                                        }
                                    }
                                }
                            }
                            .frame(height: percentHeight(percentage: 25))
                            .mask(LinearGradient(gradient: Gradient(stops: [
                                        .init(color: .clear, location: 0),
                                        .init(color: .black, location: 0.25),
                                        .init(color: .black, location: 0.75),
                                        .init(color: .clear, location: 1)
                                    ]), startPoint: .top, endPoint: .bottom))
                            
                            if commentButton {
                                LiveCommentTextField(text: $comment, placeholder: "comments.")
                                    .focused($focusedTwo)
                            }
                            
                        }
                        .frame(maxHeight: .infinity,alignment: .bottom)
                        .padding(.horizontal)
                        .padding(.bottom, 100)
                        
                    }
                    .frame(maxHeight: .infinity,alignment: .top)
                    .padding(.horizontal)
//                    .padding(.top, 40)
                    
                    // Gift Send
                    if sendRose {
                        
                        HStack {
                            
                            HStack {
                                
                                Image("squareTwoS")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipped()
                                    .cornerRadius(10)
                                    .padding(.leading, 10)
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    
                                    Text("Tynisha Obey")
                                        .font(.custom("Urbanist-Bold", size: 14))
                                        .foregroundColor(.white)
                                    
                                    Text("Sent Rose")
                                        .font(.custom("Urbanist-Medium", size: 12))
                                        .foregroundColor(.white)
                                        .opacity(0.3)
                                    
                                }
                                .padding(.trailing, 60)
                               
                            }
                            
                            .frame(height: 50)
                            .background(Color(#colorLiteral(red: 0.2694437504, green: 0.284270972, blue: 0.3148175478, alpha: 0.6004501242)))
                            .cornerRadius(20)
                            
                            .overlay (
                                Image("SendRoseLV")
                                    .offset(y: -20)
                                , alignment: .trailing

                            )
                            
                            Text("x6")
                                .font(.custom("Urbanist-Bold", size: 30))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            
                        }
                        
                        .frame(maxHeight: .infinity,alignment: .center)
                        .padding(.horizontal)
                        .padding(.bottom, 210)
                        
                    }
                    
                    
                    
                    // Comment List
//                    VStack {
//                        ScrollView(showsIndicators: false) {
//                            VStack {
//                                Spacer()
//                            }
//                            .background(Color.black)
//                            Spacer()
//
//                            LazyVGrid(columns: gridLayoutCommentLS, alignment: .center, spacing: columnSpacingCommentLS, pinnedViews: []) {
//                                Section()
//                                {
//                                    ForEach(0..<8) { people in
//                                        CommentListOnLive(creatorDetaiSheet: $creatorDetaiSheet)
//                                    }
//                                }
//                            }
//                        }
//                        .frame(height: 300)
//
//                        if commentButton {
//                            LiveCommentTextField(text: $comment, placeholder: "comments.")
//                                .focused($focusedTwo)
//                        }
//
//                    }
//                    .frame(maxHeight: .infinity,alignment: .bottom)
//                    .padding(.horizontal)
//                    .padding(.bottom, 100)
                    
                    // Bottom HStack
                    HStack {
                        HStack(spacing: 20) {
                            
                            HStack {
                                EmojiTextField(text: $comment, isEmoji: $isEmoji, resignClosur: { isEdit in
                                    commentFocused = isEdit
//                                    hideEditingParentView = isEdit
                                })
                                .placeholder(when: comment.isEmpty) {
                                    Text("Comments...").foregroundColor(.gray)
                                }
                                .frame(height: 46)
                                
                                if commentFocused == true {
                                    
                                    Button(action: {
                                        isEmoji.toggle()
                                    }) {
                                        
                                        Image("emoji")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20, alignment: .center)
                                    }
                                    
                                    Button(action: {
                                    }) {
                                        
                                        Image("send")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20, alignment: .center)
                                            .padding(.trailing)
                                    }
                                }
                            }
                            .padding(.leading)
                            .background(commentFocused ? Color(red: 244/255, green: 236/255, blue: 255/255) : Color(#colorLiteral(red: 0.1618552804, green: 0.1789564192, blue: 0.2178981602, alpha: 1)))
                            .cornerRadius(12)
                            .overlay(commentFocused ? RoundedRectangle(cornerRadius: 10).stroke(Color("buttionGradientOne"), lineWidth: 2).cornerRadius(10) : RoundedRectangle(cornerRadius: 10).stroke(Color("buttionGradientTwo"), lineWidth: 0).cornerRadius(10))
//                            Button {
//                                focusedTwo = true
//                                commentButton.toggle()
//                            } label: { // Regular
//                                HStack {
//
//                                    Text("comments.")
//                                        .font(.custom("Urbanist-Regular", size: 12))
//                                        .foregroundColor(Color(#colorLiteral(red: 0.6817840338, green: 0.6817839742, blue: 0.6817840338, alpha: 0.5040873344)))
//                                        .padding(.leading)
//                                        .frame(height: 46)
//
//                                    Spacer()
//                                }
//                                .background(Color(#colorLiteral(red: 0.1618552804, green: 0.1789564192, blue: 0.2178981602, alpha: 1)))
//                                .cornerRadius(12)
//                            }
                            
//                   Spacer()
//                            CustomTextFieldTwo(text: $comment, placeholder: "comments.")
//                                .padding(.leading)
//                                .frame(height: 46)
//                                .background(Color(#colorLiteral(red: 0.1618552804, green: 0.1789564192, blue: 0.2178981602, alpha: 1)))
//                                .cornerRadius(12)
                            if commentFocused == false {
                                VStack {
                                    Image("UserLV")
                                        .frame(width: 24, height: 24)
                                    Text("Live-To..")
                                        .font(.custom("Urbanist-Medium", size: 10))
                                        .foregroundColor(.white)
                                }
                                .onTapGesture {
                                    goLiveTogetherSheet.toggle()
                                }
                                
                                VStack {
                                    Image("QnALS")
                                        .frame(width: 24, height: 24)
                                    Text("QnA")
                                        .font(.custom("Urbanist-Medium", size: 10))
                                        .foregroundColor(.white)
                                }
                                .onTapGesture {
                                    questionAnswerSheet.toggle()
                                }
                                
                                VStack {
                                    Image("FrameLV")
                                        .frame(width: 24, height: 24)
                                    Text("Rose")
                                        .font(.custom("Urbanist-Medium", size: 10))
                                        .foregroundColor(.white)
                                }
                                .onTapGesture {
                                    sendRose = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        sendRose = false
                                    }
                                }
                                
                                VStack {
                                    Image("GiftLV")
                                        .frame(width: 24, height: 24)
                                    Text("Gift")
                                        .font(.custom("Urbanist-Medium", size: 10))
                                        .foregroundColor(.white)
                                }
                                .onTapGesture {
                                    giftSheet.toggle()
                                }
                                
                                VStack {
                                    Image("ShareLV")
                                        .frame(width: 24, height: 24)
                                    Text("5.7K")
                                        .font(.custom("Urbanist-Medium", size: 10))
                                        .foregroundColor(.white)
                                }
                                .onTapGesture {
                                    sendSheet.toggle()
                                }
                            }
                            
                        }
                        
                    }
                    .frame(maxHeight: .infinity,alignment: .bottom)
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                    .onAppear {
                        // This is our usual steps for joining
                        // a channel and starting a call.
                        self.initializeAgoraEngine()
                        self.setupVideo()
                        self.setupLocalVideo()
                        self.toggleLocalSession()
                    }
//                    .blurredSheet(.init(.white), show: $creatorDetaiSheet) {
//                        
//                    } content: {
//                        if #available(iOS 16.0, *) {
//                            ViewerProfileDetailSheet()
//                                .presentationDetents([.large,.medium,.height(500)])
//                        } else {
//                            // Fallback on earlier versions
//                        }
//                    }
                    
                    .blurredSheet(.init(.white), show: $weeklyRanking) {
                        
                    } content: {
                        if #available(iOS 16.0, *) {
                            WeeklyRankingSheet()
                                .presentationDetents([.large,.medium,.height(500)])
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    
                    .blurredSheet(.init(.white), show: $viewers) {
                        
                    } content: {
                        if #available(iOS 16.0, *) {
                            ViewersSheet()
                                .presentationDetents([.large,.medium,.height(500)])
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    
                    .blurredSheet(.init(.white), show: $goLiveTogetherSheet) {
                        
                    } content: {
                        if #available(iOS 16.0, *) {
                            GoLiveTogeRequestSheet()
                                .presentationDetents([.large,.medium,.height(500)])
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    
                    .blurredSheet(.init(.white), show: $questionAnswerSheet) {
                        
                    } content: {
                        if #available(iOS 16.0, *) {
                            QuestionAnswerSheet()
                                .presentationDetents([.large,.medium,.height(500)])
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    
                    .blurredSheet(.init(.white), show: $giftSheet) {
                        
                    } content: {
                        if #available(iOS 16.0, *) {
                            GiftPanelSheet()
                                .presentationDetents([.large,.medium,.height(500)])
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    
                    .blurredSheet(.init(.white), show: $sendSheet) {
                        
                    } content: {
                        if #available(iOS 16.0, *) {
                            SendSheet()
                                .presentationDetents([.large,.medium,.height(500)])
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    
                }
            }
            .onAppear {
                cameraModel.getFilterData()
            }
        }
    }
}





fileprivate extension LiveViewersView {
    func initializeAgoraEngine() {
        // init AgoraRtcEngineKit
        videoEngine.contentView = self
    }
    
    func setupVideo() {
        // In simple use cases, we only need to enable video capturing
        // and rendering once at the initialization step.
        // Note: audio recording and playing is enabled by default.
        rtcEngine.enableVideo()
        
        // Set video configuration
        // Please go to this page for detailed explanation
        // https://docs.agora.io/en/Voice/API%20Reference/oc/Classes/AgoraRtcEngineKit.html#//api/name/setVideoEncoderConfiguration:
        rtcEngine.setVideoEncoderConfiguration(
            AgoraVideoEncoderConfiguration(
                size: AgoraVideoDimension640x360,
                frameRate: .fps15,
                bitrate: AgoraVideoBitrateStandard,
                orientationMode: .adaptative, mirrorMode: AgoraVideoMirrorMode(rawValue: 0)!
        ))
    }
    
    func setupLocalVideo() {
        // This is used to set a local preview.
        // The steps setting local and remote view are very similar.
        // But note that if the local user do not have a uid or do
        // not care what the uid is, he can set his uid as ZERO.
        // Our server will assign one and return the uid via the block
        // callback (joinSuccessBlock) after
        // joining the channel successfully.
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.view = localCanvas.rendererView
        videoCanvas.renderMode = .hidden
        rtcEngine.setupLocalVideo(videoCanvas)
    }
    
    func joinChannel() {
        // Set audio route to speaker
        rtcEngine.setDefaultAudioRouteToSpeakerphone(true)
        rtcEngine.startPreview()
//        rtcEngine.setClientRole(.audience)
        
        // 1. Users can only see each other after they join the
        // same channel successfully using the same app id.
        // 2. One token is only valid for the channel name that
        // you use to generate this token.
        rtcEngine.joinChannel(byToken: Token, channelId: "nTest", info: nil, uid: 10) { str, value, val in
            print(str)
            print(value)
            print(val)
            
        }
    }

    func leaveChannel() {
        // leave channel and end chat
        rtcEngine.leaveChannel(nil)
    }
}

extension LiveViewersView {
    func log(content: String) {
        print(content)
    }
}

fileprivate extension LiveViewersView {
    func toggleLocalSession() {
        isLocalInSession.toggle()
        if isLocalInSession {
            joinChannel()
        } else {
            leaveChannel()
        }
    }
    
    func switchCamera() {
        rtcEngine.switchCamera()
    }
    
    func toggleLocalAudio() {
        isLocalAudioMuted.toggle()
        // mute/unmute local audio
        rtcEngine.muteLocalAudioStream(isLocalAudioMuted)
    }
}


struct LiveViewersView_Previews: PreviewProvider {
    static var previews: some View {
        LiveViewersView()
    }
}
