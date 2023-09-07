//////
//////  ReelsView.swift
//////  ReelsTest
//////
//////  Created by Vooconnect on 05/11/22.
//////
////
////import SwiftUI
////import AVKit
////
////struct ReelsView: View {
////
////    @State var currentReel: Int
////    @StateObject private var reelsVM = ReelsViewModel()
////
////    @Binding var topBar: Bool
////
////    @State var reelId: Int = 0
////    @State var reelTagIndex: Int = 0
////
////    @Binding var bool: Bool
////    @Binding var cameraView: Bool
////    @Binding var live: Bool
////    @Binding var bottomSheetBlock: Bool
////    @Binding var bottomSheetReport: Bool
////    @Binding var myProfileView: Bool
////    @Binding var creatorProfileView: Bool
////    @Binding var musicView: Bool
////    @Binding var liveViewer: Bool
////    @Binding var commentSheet: Bool
////    @Binding var commentReplySheet: Bool
////    @Binding var postedBy: String
////    @Binding var selectedReelId: Int
////
////    var body: some View {
////
////        // Setting Width and height for rotated view...
////
////        GeometryReader { proxy in
////
////            let size = proxy.size
////
////            // Vertical Page Tab View...
////            TabView(selection: $currentReel) {
//////                ForEach($reels) { $reel in
////                ForEach(reelsVM.allReels.indices, id: \.self) { index in
////
////                    ReelsPlyer(commentSheet: $commentSheet, commentReplySheet: $commentReplySheet, reelsDetail: reelsVM.allReels[index], showTwo: $bool, cameraView: $cameraView, live: $live, myProfileView: $myProfileView, creatorProfileView: $creatorProfileView, musicView: $musicView, liveViewer: $liveViewer, postedBy: $postedBy, selectedReelId: $selectedReelId, currentReel: $currentReel, bottomSheetBlock: $bottomSheetBlock, bottomSheetReport: $bottomSheetReport, topBar: $topBar, urll: URL(string: getImageVideoBaseURL + reelsVM.allReels[index].contentURL!)!)
////                    // setting width...
////                        .frame(width: size.width, height: size.height)
////                        .padding()
////                    // Rotating Content...
////                        .rotationEffect(.init(degrees: -90))
////                        .ignoresSafeArea(.all, edges: .top)
////                        .tag(index)
////
////                }
////
////            }
////            .onChange(of: reelTagIndex) { index in
////                if index != 0 {
////                    topBar = false
////                }else{
////                    topBar = true
////                }
////            }
////            .rotationEffect(.init(degrees: 90))
////            // Since view is rotated setting height as width...
////            .frame(width: size.height)
////            .tabViewStyle(.page(indexDisplayMode: .never))
////            // setting max width...
////            .frame(width: size.width)
////
////
////        }
////
////
////        .ignoresSafeArea(.all, edges: .top)
////        .background(Color.white.ignoresSafeArea())
////        // setting intial reel...
////        .onAppear {
//////                currentReel = reelsVM.allReels.first?.postID ?? 1
////
////        }
////    }
////
////
////
////}
////
////struct ReelsView_Previews: PreviewProvider {
////    static var previews: some View {
//////        ReelsView()
////        HomePageView()
////    }
////}
////
//////var player = AVPlayer()
////
////struct ReelsPlyer: View {
////
//////    @Binding var commentText: String
////    @Binding var commentSheet: Bool
////    @Binding var commentReplySheet: Bool
////    @StateObject private var reelsVM = ReelsViewModel()
////
////    let reelsDetail: Post
////
////    @State var currentTab = "recommended"
////    @Namespace var animation
////
////    let url = URL(string: "reels/1671107665992-test.mp4")
////
////    //    @Binding var reel: Reel
////
////    @State var show: Bool = false
////    @State var longPressPopUp: Bool = false
////
////    @Binding var showTwo: Bool
////    @Binding var cameraView: Bool
////    @Binding var live: Bool
////    @Binding var myProfileView: Bool
////    @Binding var creatorProfileView: Bool
////    @Binding var musicView: Bool
////    @Binding var liveViewer: Bool
////    @Binding var postedBy: String
////    @Binding var selectedReelId: Int
////
////    @Binding var currentReel: Int
////    // Expanding title if its clicked...
////    @State var showMore = false
////
////    @State var isMuted = false
////    @State var volumeAnimation = false
////
////    @State private var likeAnimation: Bool = false
////
////    @State private var likeCount: Int = 0
////
////    @StateObject private var likeVM: ReelsLikeViewModel = ReelsLikeViewModel()
////    @State var likeAndUnlike = false
////    //    @StateObject private var reelsVM = ReelsViewModel()
////
////    @State var playButtonTest: Bool = false
////
////    @Binding var bottomSheetBlock: Bool
////    @Binding var bottomSheetReport: Bool
////    //    @State private var bottomSheetMoreOption = false
////
////    @State private var bookMarkMassage: Bool = false
////
////    @State var plusIcon: Bool = false
////
////    @State private var doubleTapLikeCount: Bool = true
////    @State private var followRecommendedTextColor: Bool = false
////
////    @Binding var topBar: Bool
////
////    @State private var playAndPause: Bool = false
////    @State private var playAndPauseOpacity: Double = 0.001
////
////    @State var player = AVPlayer()
////    var urll: URL
////
////    var body: some View {
////
////        ZStack {
////
////            CustomVideoPlayer(player: player)
////                .edgesIgnoringSafeArea(.all)
////
////                .onAppear {
////                    player.replaceCurrentItem(with: AVPlayerItem(url: urll)) //<-- Here
////                    player.play()
////                }
////                .onDisappear {
////                    DispatchQueue.main.async {
////                        player.pause()
////                    }
////
////                }
////
//////            Image("")
////
////            GeometryReader { proxy -> Color in
////
////                let minY = proxy.frame(in: .global).minY
////
////                let size = proxy.size
////
////                DispatchQueue.main.async {
////
////                    if -minY < (size.height / 2) && minY < (size.height / 2) {
////                        player.play()
////                    } else {
////                        player.pause()
////                    }
////
////                }
////                return Color.clear
////            }
////
////
////            Color.black.opacity(0.01)
////                .onTapGesture(count: 2) {
////                    likeAnimation = true
////                    likeAndUnlike = true
////                    print("Double tapped!")
////
//////                    doubleTapLikeCount = true
////
////
////                    if doubleTapLikeCount == true {
////                        likeCount = likeCount+1
////                        likeVM.reelsLikeApi()
////                    } else {
//////                        likeCount = likeCount-1
////                    }
////
//////                    likeVM.reelsLikeApi()
////
////                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
////                        likeAnimation = false
//////                        likeAndUnlike = false
////                        doubleTapLikeCount = false
////                    }
////
////                }
////
////            if likeAnimation {
////                HeartLike(isTapped: $likeAnimation, taps: 1)
////            }
////
////
////
////                // Live
////                HStack {
////                    // Live
////                    Button {
////
//////                        player.pause()
////
////                        show = false
////                        showTwo = false
////
////                        liveViewer.toggle()
////
////                    } label: {
////                        Image("Live")
////
////                    }
////
////
////                    Spacer()
////                    VStack {
////                        Button {
////                            show = false
////                            showTwo = false
////
////                            let postID = reelsDetail.postID ?? 0
////                            print("PostIddddd========",postID)
////                            UserDefaults.standard.set(postID, forKey: "postID")
//////                            likeVM.blockPostApi()
////                            bottomSheetBlock.toggle()
////
////                        } label: {
////                            Image("ReportIcon")
////                                .resizable()
////                                .scaledToFill()
////                                .frame(width: 26, height: 26)
////
////                        }
////
////
////                        Button {
////                            show = false
////                            showTwo = false
////
////                            let postID = reelsDetail.postID ?? 0
////                            print("PostIddddd========",postID)
////                            UserDefaults.standard.set(postID, forKey: "postID")
////                            bottomSheetReport.toggle()
////
////                        } label: {
////                            Image("BlockUserbutton")
////                                .resizable()
////                                .scaledToFill()
////                                .frame(width: 26, height: 26)
////
////                        }
////                        .padding(.top, -5)
////                    }
////
////                }
//////                .padding(.leading)
////                .padding(.leading, -1)
////                .padding(.trailing, 10)
////                .frame(maxHeight: .infinity, alignment: .top)
////
////
////            // Center
////
////            ZStack {
////
////                if bookMarkMassage == true {
////
////                    Text(likeVM.bookMarkDataModel.successMessage)
////                        .foregroundColor(.white)
////
////                }
////
////
////                Button {
////
////                    playAndPause.toggle()
////
////                    if playAndPause == true {
////                        player.pause()
////                    } else {
////                        player.play()
////                    }
////                } label: {
//////                    Image(playAndPause ? "ReelsPause" : "ReelsPause")
////                    Image("ReelsPause")
////                        .frame(width: 100, height: 100)
////                        .opacity(0.001)
////                }
////                .onTapGesture {
////
////                }
////
////
////            }
////
////
////                // Recommended
////                VStack {
////
////                    HStack {
////
////                        Text("Recommended")
////                            .font(.custom("Urbanist-Bold", size: 16))
////                            .frame(width: 150, height: 42)
////                            .background(
////                                ZStack {
////                                    if currentTab == "recommended" {
////                                        Color.white
////                                            .cornerRadius(21)
////                                            .matchedGeometryEffect(id: "TAB", in: animation)
////                                    }
////                                }
////                                    .padding(.leading, 6)
////                            )
////
////                            .foregroundColor(followRecommendedTextColor ? Color(#colorLiteral(red: 0.787740171, green: 0.787740171, blue: 0.787740171, alpha: 0.3994205298)) : .black)
////                            .onTapGesture {
////                                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
////                                    currentTab = "recommended"
////                                    followRecommendedTextColor.toggle()
////                                    show = false
////                                    showTwo = false
////
////                                }
////                            }
////
////
////                        Text("Followers")
////                            .font(.custom("Urbanist-Bold", size: 16))
////                            .frame(width: 150, height: 42)
//////                            .foregroundColor(currentTab ? .black : .red)
////                            .background(
////                                ZStack {
////                                    if currentTab == "followers" {
////                                        Color.white
////                                            .cornerRadius(21)
////                                            .matchedGeometryEffect(id: "TAB", in: animation)
////                                    }
////                                }
////                                    .padding(.trailing, 6)
////
////                            )
////                            .foregroundColor(followRecommendedTextColor ? .black : Color(#colorLiteral(red: 0.787740171, green: 0.787740171, blue: 0.787740171, alpha: 0.3994205298)))
////                            .onTapGesture {
////                                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
////                                    currentTab = "followers"
////                                    followRecommendedTextColor.toggle()
////                                    show = false
////                                    showTwo = false
////                                }
////                            }
////
////                    }
////
////                    .frame(width: 300, height: 45)
////                    .background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)))
////                    .cornerRadius(22.5)
////                    .rotationEffect(.degrees(270))
////
////                }
////                .frame(maxWidth: .infinity, alignment: .topLeading)
////                .padding(.leading, -110)
////                .padding(.top, -120)
////
////
////                // Creator Detail
////                VStack {
////
////                    HStack(alignment: .bottom) {
////
////                        VStack(alignment: .leading, spacing: 10) {
////
////                            HStack(spacing: 10) {
////
//////                                Image("CreaterProfileIcon")
////                                CreatorProfileImageView(allReels: reelsDetail)
//////                                    .resizable()
////                                    .aspectRatio(contentMode: .fill)
////                                    .frame(width: 55, height: 55)
////                                    .cornerRadius(10)
////                                    .background(
////
////                                        RoundedRectangle(cornerRadius: 10)
////                                            .stroke(Color.white,lineWidth: 6)
////                                    )
//////                                    .clipShape(Circle())
////
////                                VStack(alignment: .leading, spacing: 5) {
////                                    HStack {
//////                                        Text("jenny Wilson")
////                                        Text(reelsDetail.creatorFirstName ?? "jenny Wilson")
////                                            .font(.custom("Urbanist-Bold", size: 18))
////                                            .foregroundColor(.white)
////
//////                                        Text("jenny Wilson")
////                                        Text(reelsDetail.creatorLastName ?? "")
////                                            .font(.custom("Urbanist-Bold", size: 18))
////                                            .foregroundColor(.white)
////
////                                    }
////
////                                    Text("Actress & Singer")
////                                        .font(.custom("Urbanist-Medium", size: 14))
////                                        .foregroundColor(.white.opacity(7))
//////                                        .foregroundColor(Color("GrayFour"))
////
////                                }
////
////                            }
////                            .padding(.bottom, 1)
////
////                            // Title Custom View...
////
//////                            Text("Hi everyone. in this video I will sing a song")
////                            Text(reelsDetail.title ?? "")
////                                .font(.custom("Urbanist-Medium", size: 14))
////                                .foregroundColor(.white)  // change
//////                                .foregroundColor(.black)
////                            Text("#song #music #love #Beauty")
////                                .font(.custom("Urbanist-Medium", size: 12))
////                                .foregroundColor(.white)
////                                .padding(.top, -10)
////
////                        }
////
////                        Spacer(minLength: 20)
////
////                        // List of Buttons...
////                        // Traling PopUp
////                        VStack {
////                            if self.show {
////                                VStack {
////                                    PopOverTwo(show: $show, camera: $cameraView, live: $live)
////                                        .background(Color.white)
////                                        .cornerRadius(15)
////
////                                    DiamondTwo()
////                                        .frame(width: 40, height: 30)
////                                        .padding(.top, -23)
////                                        .padding(.trailing, -110)
////                                        .foregroundColor(.white)
//////                                                .rotationEffect(Angle(degrees: 20))
////                                }
//////                                        .padding(.trailing, 100)
////                                .padding(.bottom, -10)
////                            }
////                        }
////                        .padding(.bottom, 195)
////                        .padding(.trailing, -50)
////
////
////                        // All Traling Button
////                        VStack(spacing: 10) {
////
////                            Button {
////                                plusIcon.toggle()
////                                show.toggle()
////                                showTwo = false
//////                                showMore.toggle()
////                            } label: {
////                                Image(show ? "PlusPurple" : "PlusIcon")  // PlusPurple
////
////                            }
////
////                            Button {
//////                                playButtonTest.toggle()
////                                show = false
////                                showTwo = false
////
////                                playAndPause.toggle()
////
////                                if playAndPause == true {
////                                    player.pause()
////                                } else {
////                                    player.play()
////                                }
////
////                            } label: {
////                                Image("Play")
////
////                            }
////
////                            Button {
//////                                if volumeAnimation {
//////                                    return
//////                                }
////                                show = false
////                                showTwo = false
////
////                                isMuted.toggle()
////                                // Muting player...
////                                player.isMuted = isMuted
////                                withAnimation {volumeAnimation.toggle()}
////
////                            } label: {
////                                Image(isMuted ? "VolumeUp" : "VolumeUp")
////
////                            }
////
////                            Button {
////
////                                show = false
////                                showTwo = false
////
////                            } label: {
////                                Image("Sound")
////
////                            }
////
////                        }
//////                        .padding(.trailing, -95)
////                            .padding(.bottom, 20)
////
//////                    reel: reel
////
////                    }
////
////                    // Music View...
////
////                    HStack {
////
//////                        Image("musicProfileIcon")
////                        CreatorProfileImageView(allReels: reelsDetail)
//////                                    .resizable()
////                            .aspectRatio(contentMode: .fill)
////                            .frame(width: 24, height: 24)
////                            .cornerRadius(10)
////
////                        Image("MusicIcon")
////
////                        Text("Favorite Girl by Justin Bieber")
////                            .font(.caption)
////                            .fontWeight(.semibold)
////
////                        Spacer(minLength: 20)
////
////
////                    }
////                    .padding(.top, 1)
////
////                    .padding(.bottom, 10)
////
////                    // Floting Menue
////                    // LIKE
////                    HStack(spacing: 13) {
////
////                                VStack {
////                                    Image(likeAndUnlike ? "HeartRedLV" : "LikeWhiteR") // LikeWhiteR LikeRedR LikeRedTwoR LikeRedThreeR
////                                        .resizable()
////                                        .scaledToFill()
////                                        .frame(width: 28, height: 28)
////                                        .clipped()
////                                        .onTapGesture {
////                                            doubleTapLikeCount = true
////                                            show = false
////                                            showTwo = false
////                                            print("Success ====== 2")
////                                            likeAndUnlike.toggle()
////                                            likeVM.reelsLikeDataModel.userUUID = reelsDetail.creatorUUID ?? ""
////                                            likeVM.reelsLikeDataModel.postID = reelsDetail.postID ?? 0
////
////                                            if likeAndUnlike == true {
////                                                likeCount = likeCount+1
////                                            } else {
////                                                likeCount = likeCount-1
////                                            }
////
////                                            likeVM.reelsLikeApi()
////
////                                            if longPressPopUp == true {
////                                                longPressPopUp = false
////                                            }
////                                        }
////
////                                        .onLongPressGesture(minimumDuration: -0.5) {
////                                            longPressPopUp.toggle()
////                                        }
////
////                                    Text("\(likeCount)")
////                                        .font(.custom("Urbanist-Regular", size: 8))
////                                        .offset(y: -3)
////
////                                    NavigationLink(destination: CreatorProfileView(id: reelsDetail.creatorUUID ?? "").navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $myProfileView){}
////                                }
////
////                            Button {
////                                let postID = reelsDetail.postID ?? 0
////                                print("PostIddddd========",postID)
////                                UserDefaults.standard.set(postID, forKey: "postID")
////
////                                commentSheet.toggle()
////
////
////
////                                show = false
////                                showTwo = false
////                            } label: {
////                                VStack {
////                                    Image("Comment")
////                                        .resizable()
////                                        .scaledToFill()
////                                        .frame(width: 28, height: 28)
////
//////                                    Text("22k")
////                                    Text("\(reelsDetail.commentCount ?? 0)")
////                                        .font(.custom("Urbanist-Regular", size: 8))
////                                        .offset(y: -3)
////                                }
////                            }
////
////                            Button {
////                                show = false
////                                showTwo = false
//////                                DispatchQueue.global(qos: .background).async {
//////                                DispatchQueue.main.async {
////                                    share()
//////                                }
////
////                            } label: {
////                                VStack {
////                                    Image("Share")
////                                        .resizable()
////                                        .scaledToFill()
////                                        .frame(width: 28, height: 28)
////
//////                                    Text("22k")
////                                    Text("\(reelsDetail.shareCount ?? 0)")
////                                        .font(.custom("Urbanist-Regular", size: 8))
////                                        .offset(y: -3)
////                                }
////                            }
////
////
////                            Button {
////                                show = false
////                                showTwo = false
////                                likeVM.bookMarkDataModel.successMessage = ""
////                                bookMarkMassage = true
////
////                                likeVM.bookMarkDataModel.userUUID = reelsDetail.creatorUUID ?? ""
////                                likeVM.bookMarkDataModel.postID = reelsDetail.postID ?? 0
////                                likeVM.bookMarkApi()
////
////                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
////                                    bookMarkMassage = false
////                                }
////
////                            } label: {
////                                VStack {
////                                    Image("Save")
////                                        .resizable()
////                                        .scaledToFill()
////                                        .frame(width: 28, height: 28)
////
//////                                    Text("22k")
////                                    Text("\(reelsDetail.bookmarkCount ?? 0)")
////                                        .font(.custom("Urbanist-Regular", size: 8))
////                                        .offset(y: -3)
////
////                                }
////                            }
////
////                            Button {
////                                show = false
////                                showTwo = false
////                                myProfileView.toggle()
////                            } label: {
////                                VStack {
////
////                                    CreatorProfileImageView(allReels: reelsDetail)
////                                        .aspectRatio(contentMode: .fill)
////                                        .frame(width: 28, height: 28)
////                                        .cornerRadius(14)
////                                        .background(
////
////                                            RoundedRectangle(cornerRadius: 14)
////                                                .stroke(Color.white,lineWidth: 1)
////                                        )
////                                        .offset(y: 3)
////
////                                    Text("")
////                                        .font(.custom("Urbanist-Regular", size: 10))
////                                        .offset(y: -5)
////                                }
////                            }
////
////                            Button {
////                                show = false
////                                showTwo = false
////                                creatorProfileView.toggle()
////                            } label: {
////                                VStack {
////                                    UserProfileImageView()
////                                        .aspectRatio(contentMode: .fill)
////                                        .frame(width: 28, height: 28)
////                                        .cornerRadius(14)
////                                        .background(
////
////                                            RoundedRectangle(cornerRadius: 14)
////                                                .stroke(Color.white,lineWidth: 1)
////                                        )
////                                        .offset(y: 3)
////
////                                    Text("")
////                                        .font(.custom("Urbanist-Regular", size: 10))
////                                        .offset(y: -5)
////
////                                }
////
////                            }
////                        }
////                    .onTapGesture {
////                        show = false
////                        showTwo = false
////                    }
////
////                    .padding(.top, 3)
////                    .padding(.leading, 15)
////                    .padding(.trailing, 15)
////                    .background(
////                        LinearGradient(colors: [
////                            Color("GradientOneOne"),
////                            Color("GradientTwoTwo"),
////                        ], startPoint: .leading, endPoint: .trailing)
////                    )
////                    .cornerRadius(40)
////
////
////                }
////
////                .padding(.horizontal)
////                .padding(.bottom, 20)
////                .foregroundColor(.white)
////                .frame(maxHeight: .infinity, alignment: .bottom)
////
////                HStack {
////                    if self.showTwo {
////                            VStack {
////                                Diamond()
////                                    .frame(width: 60, height: 40)
////                                    .padding(.bottom, -30)
////                                    .padding(.leading, -50)
////                                    .foregroundColor(.white)
////
////                                PopOverTwo(show: $show, camera: $cameraView, live: $live)
////                                    .background(Color.white)
////                                    .cornerRadius(15)
////                            }
////                        }
////                        Spacer()
////                    }
////                .frame(maxHeight: .infinity, alignment: .top)
////                .padding(.top, 5)
////                .padding(.leading, 5)
////
////                HStack {
////                    if longPressPopUp {
////                        LongPressPopUp()
////                    }
////                }
////                .frame(maxHeight: .infinity, alignment: .bottom)
////                .padding(.bottom, 70)
////
////        }
////
////            .onTapGesture {
////                show = false
////                showTwo = false
////                print("Tappedd")
////            }
////        .onAppear {
////            DispatchQueue.main.async {
////                likeCount = reelsDetail.likeCount ?? 0
////            }
////
////        }
////
////        .onDisappear {
////            DispatchQueue.main.async {
////                player.pause()
////            }
////
////        }
////
////
////    }
////
////    private func share() {
////        guard let urlShare = URL(string: "https://vooconnect.com/") else { return }
////        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
////           UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
//////        UIApplication.shared.win
////    }
////
////}
////
////
////struct AcctionButtions: View {
//////    var reel: Reel
////
////    var body: some View {
////
////        VStack(spacing: 10) {
////
////            Button {
////
////            } label: {
////                Image("PlusIcon")
////
////            }
////
////            Button {
////
////            } label: {
////                Image("Play")
////
////            }
////
////            Button {
////
////            } label: {
////                Image("VolumeUp")
//////                Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
////
////            }
////
////            Button {
////
////            } label: {
////                Image("Sound")
////
////            }
////
////        }
////    }
////}
////
////
////let sampleText = "fdsgkldfgjodgmlhjasjuhmr9 gurih ughwau idhfu9 erh ko iuhgefguyh reiuhgy8 ureh iughf greiuwe g8yewgr igruiaew8ug reugt "
////
////struct PopOverTwo: View {
////
////    @Binding var show: Bool
////    @Binding var camera: Bool
////    @Binding var live: Bool
////
////    var body: some View {
////
////        VStack(alignment: .leading, spacing: 15) {
////
////            VStack {
////
////                Button {
//////                    show.toggle()
////                    camera.toggle()
////                } label: {
////                    HStack(spacing: 15) {
////                        Text("Posts")
////                            .padding(.trailing, 3)
////                        //                    Spacer()
////                        Image("PopUpPlay")
////                    }
////                }
////                Button {
//////                    show.toggle()
//////                    cameraTwo.toggle()
////                    live.toggle()
////                } label: {
////                    HStack(spacing: 15) {
////                        Text("Live")
////                            .padding(.trailing)
////                        //                    Spacer()
////                        Image("PopUpVideo")
////
////                    }
////                }
////            }
////            .foregroundColor(.black)
////            .frame(width: 100)
////            .padding(10)
////        }
////
////
////    }
////
////}
////
////
////struct ArrowShapeTwo: Shape {
////
////    func path(in rect: CGRect) -> Path {
////
////        let centent = rect.width / 2
////        return Path { path in
////
////            path.move(to: CGPoint(x: 0, y: 0))
////            path.addLine(to: CGPoint(x: rect.width, y: 0))
////            path.addLine(to: CGPoint(x: rect.width, y: rect.height - 20))
////
////            path.addLine(to: CGPoint(x: centent - 15, y: rect.height - 20))
////            path.addLine(to: CGPoint(x: centent, y: rect.height - 5))
////            path.addLine(to: CGPoint(x: centent + 15, y: rect.height - 20))
////
////            path.addLine(to: CGPoint(x: 0, y: rect.height - 20))
////
////
////        }
////
////    }
////
////}
////
////struct Diamond: Shape {
////
////    func path(in rect: CGRect) -> Path {
////        Path { path in
////            let horizontalOffset: CGFloat = rect.width * 0.2
////            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
////
////            path.addLine(to: CGPoint(x: rect.maxX - horizontalOffset, y: rect.midY))
////            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
////            path.addLine(to: CGPoint(x: rect.minX + horizontalOffset, y: rect.midY))
////            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
////        }
////    }
////}
////
////struct DiamondTwo: Shape {
////
////    func path(in rect: CGRect) -> Path {
////        Path { path in
////            let horizontalOffset: CGFloat = rect.width * 0.2
////            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
////
////            path.addLine(to: CGPoint(x: rect.maxX - horizontalOffset, y: rect.midY))
////            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
////            path.addLine(to: CGPoint(x: rect.minX - horizontalOffset, y: rect.midY))
////            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
////        }
////    }
////}
////
////// MARK: Offset Preference Key
////struct OffsetKey: PreferenceKey {
////    static var defaultValue: CGFloat = 0
////    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
////        value = nextValue()
////    }
////}
////
////// Offset View Extension
////extension View {
////    @ViewBuilder
////    func offset(coordinateSpace: CoordinateSpace, completion: @escaping (CGFloat)->()) -> some View {
////        self
////            .overlay {
////                GeometryReader { proxy in
////                    let minY = proxy.frame(in: coordinateSpace).minY
////                    Color.clear
////                        .preference(key: OffsetKey.self, value: minY)
////                        .onPreferenceChange(OffsetKey.self) { value in
////                            completion(value)
////                        }
////                }
////            }
////    }
////}
////below old code
//
////
////  ReelsView.swift
////  ReelsTest
////
////  Created by Vooconnect on 05/11/22.
////
//
//import SwiftUI
//import AVKit
//
//struct ReelsView: View {
//
//    @State var currentReel: Int
//    @StateObject private var reelsVM = ReelsViewModel()
//
//    @Binding var topBar: Bool
//
//    @State var reelId: Int = 0
//    @State var reelTagIndex: Int = 0
//
//    @Binding var bool: Bool
//    @Binding var cameraView: Bool
//    @Binding var live: Bool
//    @Binding var bottomSheetBlock: Bool
//    @Binding var bottomSheetReport: Bool
//    @Binding var myProfileView: Bool
//    @Binding var creatorProfileView: Bool
//    @Binding var musicView: Bool
//    @Binding var liveViewer: Bool
//    @Binding var commentSheet: Bool
//    @Binding var commentReplySheet: Bool
//    @Binding var postedBy: String
//    @Binding var selectedReelId: Int
//
//    var body: some View {
//
//        // Setting Width and height for rotated view...
//
//
//        GeometryReader { proxy in
//
//            let size = proxy.size
//
//            // Vertical Page Tab View...
//            TabView(selection: $reelTagIndex) {
//                //                ForEach($reels) { $reel in
//                ForEach(reelsVM.allReels.indices, id: \.self) { index in
//
//                    ReelsPlyer(commentSheet: $commentSheet, commentReplySheet: $commentReplySheet, reelsDetail: reelsVM.allReels[index], showTwo: $bool, cameraView: $cameraView, live: $live, myProfileView: $myProfileView, creatorProfileView: $creatorProfileView, musicView: $musicView, liveViewer: $liveViewer, postedBy: $postedBy, selectedReelId: $selectedReelId, currentReel: $currentReel, bottomSheetBlock: $bottomSheetBlock, bottomSheetReport: $bottomSheetReport, topBar: $topBar, urll: URL(string: getImageVideoBaseURL + reelsVM.allReels[index].contentURL!)!)
//                    // setting width...
//                        .frame(width: size.width, height: size.height)
//                        .padding()
//                    // Rotating Content...
//                        .rotationEffect(.init(degrees: -90))
//                        .ignoresSafeArea(.all, edges: .top)
//                        .tag(index)
//
//                }
//
//            }
//            .onChange(of: reelTagIndex) { index in
//                if index != 0 {
//                    topBar = false
//                }else{
//                    topBar = true
//                }
//            }
//            .rotationEffect(.init(degrees: 90))
//            // Since view is rotated setting height as width...
//            .frame(width: size.height)
//            .tabViewStyle(.page(indexDisplayMode: .never))
//            // setting max width...
//            .frame(width: size.width)
//
//        }
//        .ignoresSafeArea(.all, edges: .top)
//        .background(Color.white.ignoresSafeArea())
//        // setting intial reel...
//
//    }
//
//}
//
//struct ReelsView_Previews: PreviewProvider {
//    static var previews: some View {
//        //        ReelsView()
//        HomePageView()
//    }
//}
//
////var player = AVPlayer()
//
//struct ReelsPlyer: View {
//
//    //    @Binding var commentText: String
//    @Binding var commentSheet: Bool
//    @Binding var commentReplySheet: Bool
//    @StateObject private var reelsVM = ReelsViewModel()
//
//    let reelsDetail: Post
//
//    @State var currentTab = "recommended"
//    @Namespace var animation
//
//    let url = URL(string: "reels/1671107665992-test.mp4")
//
//    //    @Binding var reel: Reel
//
//    @State var show: Bool = false
//    @State var longPressPopUp: Bool = false
//
//    @Binding var showTwo: Bool
//    @Binding var cameraView: Bool
//    @Binding var live: Bool
//    @Binding var myProfileView: Bool
//    @Binding var creatorProfileView: Bool
//    @Binding var musicView: Bool
//    @Binding var liveViewer: Bool
//    @Binding var postedBy: String
//    @Binding var selectedReelId: Int
//
//    @Binding var currentReel: Int
//    // Expanding title if its clicked...
//    @State var showMore = false
//
//    @State var isMuted = false
//    @State var volumeAnimation = false
//
//    @State private var likeAnimation: Bool = false
//
//    @State private var likeCount: Int = 0
//
//    @StateObject private var likeVM: ReelsLikeViewModel = ReelsLikeViewModel()
//    @State var likeAndUnlike = false
//    //    @StateObject private var reelsVM = ReelsViewModel()
//
//    @State var playButtonTest: Bool = false
//
//    @Binding var bottomSheetBlock: Bool
//    @Binding var bottomSheetReport: Bool
//    //    @State private var bottomSheetMoreOption = false
//
//    @State private var bookMarkMassage: Bool = false
//
//    @State var plusIcon: Bool = false
//
//    @State private var doubleTapLikeCount: Bool = true
//    @State private var followRecommendedTextColor: Bool = false
//
//    @Binding var topBar: Bool
//
//    @State private var playAndPause: Bool = false
//    @State private var playAndPauseOpacity: Double = 0.001
//
//    @State var player = AVPlayer()
//
//    var urll: URL
//
//    var body: some View {
//
//
//        ZStack {
//
//            CustomVideoPlayer(player: player)
//                .edgesIgnoringSafeArea(.all)
//
//                .onAppear {
//                    player.replaceCurrentItem(with: AVPlayerItem(url: urll)) //<-- Here
//                    player.play()
//                }
//                .onDisappear {
//                    DispatchQueue.main.async {
//                        player.pause()
//                    }
//
//                }
//
//            //            Image("")
//
//            GeometryReader { proxy -> Color in
//
//                let minY = proxy.frame(in: .global).minY
//
//                let size = proxy.size
//
//                DispatchQueue.main.async {
//
//                    if -minY < (size.height / 2) && minY < (size.height / 2) {
//                        player.play()
//                    } else {
//                        player.pause()
//                    }
//
//                }
//                return Color.clear
//            }
//
//
//
//            Color.black.opacity(0.01)
//                .onTapGesture(count: 2) {
//                    likeAnimation = true
//                    likeAndUnlike = true
//                    print("Double tapped!")
//
//                    //                    doubleTapLikeCount = true
//
//
//                    if doubleTapLikeCount == true {
//                        likeCount = likeCount+1
//                        likeVM.reelsLikeApi()
//                    } else {
//                        //                        likeCount = likeCount-1
//                    }
//
//                    //                    likeVM.reelsLikeApi()
//
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                        likeAnimation = false
//                        //                        likeAndUnlike = false
//                        doubleTapLikeCount = false
//                    }
//
//                }
//
//            if likeAnimation {
//                HeartLike(isTapped: $likeAnimation, taps: 1)
//            }
//
//            // Live
//            HStack {
//                // Live
//                Button {
//
//                    //                        player.pause()
//
//                    show = false
//                    showTwo = false
//
//                    liveViewer.toggle()
//
//                } label: {
//                    Image("Live")
//
//                }
//
//
//                Spacer()
//                VStack (alignment: .trailing) {
//                    Button {
//                        show = false
//                        showTwo = false
//
//                        //                            let postID = reelsDetail.postID ?? 0
//                        //                            print("PostIddddd========",postID)
//                        //                            UserDefaults.standard.set(postID, forKey: "postID")
//                        //                            likeVM.blockPostApi()
//                        //                            bottomSheetBlock.toggle()
//                        bottomSheetReport.toggle()
//
//                    } label: {
//                        Image("ReportIcon")
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 26, height: 26)
//
//                    }
//
//                    Button {
//
//                        let postID = reelsDetail.postID ?? 0
//                        print("PostIddddd========",postID)
//                        UserDefaults.standard.set(postID, forKey: "postID")
//                        bottomSheetBlock.toggle()
//
//                    } label: {
//                        Image("BlockUserbutton")
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 26, height: 26)
//
//                    }
////                    .padding(.top, -5)
//
//                }
//
//
//
//            }
//            //                .padding(.leading)
//            .padding(.leading, -1)
//            .padding(.trailing, 10)
//            .frame(maxHeight: .infinity, alignment: .top)
//
//
//            // Center
//
//            ZStack {
//
//
//                if bottomSheetBlock {
//                    HStack {
//                        VStack{
//                            DiamondTwo()
//                                .frame(width: 80, height: 50)
//                                .padding(.bottom, -35)
//                                .padding(.leading,120)
//                                .foregroundColor(.white)
//
//                            PopOverThree(bottomSheetBlock: $bottomSheetBlock)
//                                .background(Color.white)
//                                .cornerRadius(32)
//                        }
//                        .frame(maxHeight: .infinity, alignment: .top)
//                        .padding(.top, 70)
//                        .padding(.trailing,5)
//                    }
//                    .frame(maxWidth: .infinity, alignment: .trailing)
//
//
//                }
//
//                if bookMarkMassage == true {
//
//                    Text(likeVM.bookMarkDataModel.successMessage)
//                        .foregroundColor(.white)
//
//                }
//
//
//                Button {
//                    playorstop()
//                } label: {
//                        Image("PlayWhiteN")
//                            .frame(width: 100, height: 100)
//                            .opacity(playAndPauseOpacity)
//                }
//
//            }
//
//
//            // Recommended
//            VStack {
//
//                HStack {
//
//                    Text("Recommended")
//                        .font(.custom("Urbanist-Bold", size: 16))
//                        .frame(width: 150, height: 42)
//                        .background(
//                            ZStack {
//                                if currentTab == "recommended" {
//                                    Color.white
//                                        .cornerRadius(21)
//                                        .matchedGeometryEffect(id: "TAB", in: animation)
//                                }
//                            }
//                                .padding(.leading, 6)
//                        )
//
//                        .foregroundColor(followRecommendedTextColor ? Color(#colorLiteral(red: 0.787740171, green: 0.787740171, blue: 0.787740171, alpha: 0.3994205298)) : .black)
//                        .onTapGesture {
//                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
//                                currentTab = "recommended"
//                                followRecommendedTextColor.toggle()
//                                show = false
//                                showTwo = false
//
//                            }
//                        }
//
//
//                    Text("Followers")
//                        .font(.custom("Urbanist-Bold", size: 16))
//                        .frame(width: 150, height: 42)
//                    //                            .foregroundColor(currentTab ? .black : .red)
//                        .background(
//                            ZStack {
//                                if currentTab == "followers" {
//                                    Color.white
//                                        .cornerRadius(21)
//                                        .matchedGeometryEffect(id: "TAB", in: animation)
//                                }
//                            }
//                                .padding(.trailing, 6)
//
//                        )
//                        .foregroundColor(followRecommendedTextColor ? .black : Color(#colorLiteral(red: 0.787740171, green: 0.787740171, blue: 0.787740171, alpha: 0.3994205298)))
//                        .onTapGesture {
//                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
//                                currentTab = "followers"
//                                followRecommendedTextColor.toggle()
//                                show = false
//                                showTwo = false
//                            }
//                        }
//
//                }
//
//                .frame(width: 300, height: 45)
//                .background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)))
//                .cornerRadius(22.5)
//                .rotationEffect(.degrees(270))
//
//            }
//            .frame(maxWidth: .infinity, alignment: .topLeading)
//            .padding(.leading, -110)
//            .padding(.top, -120)
//
//
//            // Creator Detail
//            VStack {
//
//                HStack(alignment: .bottom) {
//
//                    VStack(alignment: .leading, spacing: 10) {
//
//                        Button{
//                            show = false
//                            showTwo = false
//                            creatorProfileView.toggle()
//                        }label: {
//                            HStack(spacing: 10) {
//
//                                //                                Image("CreaterProfileIcon")
//                                CreatorProfileImageView(allReels: reelsDetail)
//                                //                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: 55, height: 55)
//                                    .cornerRadius(10)
//                                    .background(
//
//                                        RoundedRectangle(cornerRadius: 10)
//                                            .stroke(Color.white,lineWidth: 6)
//                                    )
//                                //                                    .clipShape(Circle())
//
//                                VStack(alignment: .leading, spacing: 5) {
//                                    HStack {
//                                        //                                        Text("jenny Wilson")
//                                        Text(reelsDetail.creatorFirstName ?? "jenny Wilson")
//                                            .font(.custom("Urbanist-Bold", size: 18))
//                                            .foregroundColor(.white)
//
//                                        //                                        Text("jenny Wilson")
//                                        Text(reelsDetail.creatorLastName ?? "")
//                                            .font(.custom("Urbanist-Bold", size: 18))
//                                            .foregroundColor(.white)
//
//                                    }
//
//                                    ForEach(likeVM.userInterestCategory, id: \.id) { categ in
//                                        if categ.user_uuid == reelsDetail.creatorUUID {
//
//                                            ForEach(likeVM.interestCategory, id: \.id) { uiCateg in
//                                                if categ.category_id == uiCateg.id {
//
//                                                    Text("\(uiCateg.category_name)")
//                                                        .font(.custom("Urbanist-Medium", size: 14))
//                                                        .foregroundColor(.white.opacity(7))
//
//                                                }
//                                            }
//                                        }
//                                    }
//
////                                    Text("Actress & Singer")
////                                        .font(.custom("Urbanist-Medium", size: 14))
////                                        .foregroundColor(.white.opacity(7))
//                                    //                                        .foregroundColor(Color("GrayFour"))
//
//                                }
//
//                            }
//                            .padding(.bottom, 1)
//                        }
//
//                        // Title Custom View...
//
//                        Button {
//
//                        } label: {
//                            HStack {
//                                Image("AddUserCP")
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(width: 16, height: 16)
//
//
//                                Button {
//                                    likeVM.followApi(user_uuid: reelsDetail.creatorUUID!)
//                                }label: {
//                                    Text("Follow")
//                                        .font(.custom("Urbanist-Bold", size: 16))
//                                        .fontWeight(Font.Weight.medium)
//                                }
//
//                            }
//                            .padding(.horizontal,20)
//                            .padding(.vertical,8)
//                        }
//                        .background(
//                            LinearGradient(colors: [
//                                Color("buttionGradientOne"),
//                                Color("buttionGradientTwo"),
//                            ], startPoint: .leading, endPoint: .trailing)
//                        )
//                        .foregroundColor(.white)
//                        .cornerRadius(30)
//
//                        //                            Text("Hi everyone. in this video I will sing a song")
//                        Text(reelsDetail.title ?? "")
//                            .font(.custom("Urbanist-Medium", size: 14))
//                            .foregroundColor(.white)  // change
//                        //                                .foregroundColor(.black)
//                        Text("#song #music #love #Beauty")
//                            .font(.custom("Urbanist-Medium", size: 12))
//                            .foregroundColor(.white)
//                            .padding(.top, -10)
//
//                    }
//
//                    Spacer(minLength: 20)
//
//                    // List of Buttons...
//                    // Traling PopUp
//                    VStack {
//                        if self.show {
//                            VStack {
//                                PopOverTwo(show: $show, camera: $cameraView, live: $live)
//                                    .background(Color.white)
//                                    .cornerRadius(15)
//
//                                DiamondTwo()
//                                    .frame(width: 40, height: 30)
//                                    .padding(.top, -23)
//                                    .padding(.trailing, -110)
//                                    .foregroundColor(.white)
//                                //                                                .rotationEffect(Angle(degrees: 20))
//                            }
//                            //                                        .padding(.trailing, 100)
//                            .padding(.bottom, -10)
//                        }
//                    }
//                    .padding(.bottom, 195)
//                    .padding(.trailing, -50)
//
//
//                    // All Traling Button
//                    VStack(spacing: 10) {
//
//                        Button {
//                            plusIcon.toggle()
//                            show.toggle()
//                            showTwo = false
//                            //                                showMore.toggle()
//                        } label: {
//                            Image(show ? "PlusPurple" : "PlusIcon")  // PlusPurple
//
//                        }
//
//                        Button {
//                            //                                playButtonTest.toggle()
//                            show = false
//                            showTwo = false
//
//                            playAndPause.toggle()
//
//                            if playAndPause == true {
//                                player.pause()
//                            } else {
//                                player.play()
//                            }
//
//                        } label: {
//                            Image("Play")
//
//                        }
//
//                        Button {
//                            //                                if volumeAnimation {
//                            //                                    return
//                            //                                }
//                            show = false
//                            showTwo = false
//
//                            isMuted.toggle()
//                            // Muting player...
//                            player.isMuted = isMuted
//                            withAnimation {volumeAnimation.toggle()}
//
//                        } label: {
//                            Image(isMuted ? "VolumeUp" : "VolumeUp")
//
//                        }
//
//                        Button {
//
//                            show = false
//                            showTwo = false
//
//                        } label: {
//                            Image("Sound")
//
//                        }
//
//                    }
//                    //                        .padding(.trailing, -95)
//                    .padding(.bottom, 20)
//
//                    //                    reel: reel
//
//                }
//
//                // Music View...
//                Button {
//                    selectedReelId = reelsDetail.postID ?? 0
//                    postedBy = reelsDetail.creatorUUID ?? ""
//                    print(postedBy)
//
//                    show = false
//                    showTwo = false
//                    musicView.toggle()
//                }label: {
//                    HStack {
//
//                        //                        Image("musicProfileIcon")
//                        CreatorProfileImageView(allReels: reelsDetail)
//                        //                                    .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 24, height: 24)
//                            .cornerRadius(10)
//
//                        Image("MusicIcon")
//
//                        Text("Favorite Girl by Justin Bieber")
//                            .font(.caption)
//                            .fontWeight(.semibold)
//
//                        Spacer(minLength: 20)
//
//
//                    }
//                    .padding(.top, 1)
//
//                    .padding(.bottom, 10)
//                }
//
//                // Floting Menue
//                // LIKE
//                HStack(spacing: 13) {
//
//                    VStack {
//                        Image(likeAndUnlike ? "HeartRedLV" : "LikeWhiteR") // LikeWhiteR LikeRedR LikeRedTwoR LikeRedThreeR
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 28, height: 28)
//                            .clipped()
//                            .onTapGesture {
//                                doubleTapLikeCount = true
//                                show = false
//                                showTwo = false
//                                print("Success ====== 2")
//                                likeAndUnlike.toggle()
//                                likeVM.reelsLikeDataModel.userUUID = reelsDetail.creatorUUID ?? ""
//                                likeVM.reelsLikeDataModel.postID = reelsDetail.postID ?? 0
//
//                                if likeAndUnlike == true {
//                                    likeCount = likeCount+1
//                                } else {
//                                    likeCount = likeCount-1
//                                }
//
//                                likeVM.reelsLikeApi()
//
//                                if longPressPopUp == true {
//                                    longPressPopUp = false
//                                }
//                            }
//
//                            .onLongPressGesture(minimumDuration: -0.5) {
//                                longPressPopUp.toggle()
//                            }
//
//                        Text("\(likeCount)")
//                            .font(.custom("Urbanist-Regular", size: 8))
//                            .offset(y: -3)
//
//                    }
//
//                    Button {
//                        let postID = reelsDetail.postID ?? 0
//                        print("PostIddddd========",postID)
//                        UserDefaults.standard.set(postID, forKey: "postID")
//
//                        commentSheet.toggle()
//
//
//
//                        show = false
//                        showTwo = false
//                    } label: {
//                        VStack {
//                            Image("Comment")
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: 28, height: 28)
//
//                            //                                    Text("22k")
//                            Text("\(reelsDetail.commentCount ?? 0)")
//                                .font(.custom("Urbanist-Regular", size: 8))
//                                .offset(y: -3)
//                        }
//                    }
//
//                    Button {
//                        show = false
//                        showTwo = false
//                        //                                DispatchQueue.global(qos: .background).async {
//                        //                                DispatchQueue.main.async {
//                        share()
//                        //                                }
//
//                    } label: {
//                        VStack {
//                            Image("Share")
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: 28, height: 28)
//
//                            //                                    Text("22k")
//                            Text("\(reelsDetail.shareCount ?? 0)")
//                                .font(.custom("Urbanist-Regular", size: 8))
//                                .offset(y: -3)
//                        }
//                    }
//
//
//                    Button {
//                        show = false
//                        showTwo = false
//                        likeVM.bookMarkDataModel.successMessage = ""
//                        bookMarkMassage = true
//
//                        likeVM.bookMarkDataModel.userUUID = reelsDetail.creatorUUID ?? ""
//                        likeVM.bookMarkDataModel.postID = reelsDetail.postID ?? 0
//                        likeVM.bookMarkApi()
//
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                            bookMarkMassage = false
//                        }
//
//                    } label: {
//                        VStack {
//                            Image("Save")
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: 28, height: 28)
//
//                            //                                    Text("22k")
//                            Text("\(reelsDetail.bookmarkCount ?? 0)")
//                                .font(.custom("Urbanist-Regular", size: 8))
//                                .offset(y: -3)
//
//                        }
//                    }
//
//                    Button {
//                        postedBy = reelsDetail.creatorUUID ?? ""
//                        //                                player.pause()
//                        show = false
//                        showTwo = false
//                        creatorProfileView.toggle()
//                    } label: {
//                        VStack {
//
//                            CreatorProfileImageView(allReels: reelsDetail)
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 28, height: 28)
//                                .cornerRadius(14)
//                                .background(
//
//                                    RoundedRectangle(cornerRadius: 14)
//                                        .stroke(Color.white,lineWidth: 1)
//                                )
//                                .offset(y: 3)
//
//                            Text("")
//                                .font(.custom("Urbanist-Regular", size: 10))
//                                .offset(y: -5)
//                        }
//                    }
//
//                    Button {
//                        //                                player.pause()
//                        show = false
//                        showTwo = false
//                        myProfileView.toggle()
//                    } label: {  // UserProfileImageView
//                        VStack {
//
//                            UserProfileImageView()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 28, height: 28)
//                                .cornerRadius(14)
//                                .background(
//
//                                    RoundedRectangle(cornerRadius: 14)
//                                        .stroke(Color.white,lineWidth: 1)
//                                )
//                                .offset(y: 3)
//
//                            Text("")
//                                .font(.custom("Urbanist-Regular", size: 10))
//                                .offset(y: -5)
//
//                        }
//
//                    }
//                }
//                .onTapGesture {
//                    show = false
//                    showTwo = false
//                }
//
//                .padding(.top, 3)
//                .padding(.leading, 15)
//                .padding(.trailing, 15)
//                //                    .background(.purple)
//                .background(
//                    LinearGradient(colors: [
//                        Color("GradientOneOne"),
//                        Color("GradientTwoTwo"),
//                    ], startPoint: .leading, endPoint: .trailing)
//                )
//                .cornerRadius(40)
//
//
//            }
//
//            .padding(.horizontal)
//            .padding(.bottom, 20)
//            .foregroundColor(.white)
//            .frame(maxHeight: .infinity, alignment: .bottom)
//
//            HStack {
//                if self.showTwo {
//                    VStack {
//                        Diamond()
//                            .frame(width: 60, height: 40)
//                            .padding(.bottom, -30)
//                            .padding(.leading, -50)
//                            .foregroundColor(.white)
//
//                        PopOverTwo(show: $show, camera: $cameraView, live: $live)
//                            .background(Color.white)
//                            .cornerRadius(15)
//                    }
//                }
//                Spacer()
//            }
//            .frame(maxHeight: .infinity, alignment: .top)
//            .padding(.top, 5)
//            .padding(.leading, 5)
//
//
//            HStack {
//                if longPressPopUp {
//                    LongPressPopUp()
//                }
//            }
//            .frame(maxHeight: .infinity, alignment: .bottom)
//            .padding(.bottom, 70)
//
//        }
//        .onTapGesture {
//            show = false
//            showTwo = false
//
//            print("Tappedd")
//            postedBy = reelsDetail.creatorUUID ?? ""
//            //                player.pause()
//        }
//
//
//        //        .environmentObject(status)
//        .onAppear {
//            DispatchQueue.main.async {
//                likeCount = reelsDetail.likeCount ?? 0
//            }
//
//        }
//
//        .onDisappear {
//            DispatchQueue.main.async {
//                player.pause()
//            }
//
//        }
//
//    }
//
//    private func playorstop(){
//        playAndPause.toggle()
//
//        if playAndPause == true {
//            player.pause()
//            playAndPauseOpacity = 1.0
//        } else {
//            player.play()
//            playAndPauseOpacity = 0.001
//        }
//    }
//
//    private func share() {
//        guard let urlShare = URL(string: "https://vooconnect.com") else { return }
//        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
//        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
//        //        UIApplication.shared.win
//    }
//
//}
//
//
//struct AcctionButtions: View {
//    //    var reel: Reel
//
//    var body: some View {
//
//        VStack(spacing: 10) {
//
//            Button {
//
//            } label: {
//                Image("PlusIcon")
//
//            }
//
//            Button {
//
//            } label: {
//                Image("Play")
//
//            }
//
//            Button {
//
//            } label: {
//                Image("VolumeUp")
//                //                Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
//
//            }
//
//            Button {
//
//            } label: {
//                Image("Sound")
//
//            }
//
//        }
//    }
//}
//
//
//let sampleText = "fdsgkldfgjodgmlhjasjuhmr9 gurih ughwau idhfu9 erh ko iuhgefguyh reiuhgy8 ureh iughf greiuwe g8yewgr igruiaew8ug reugt "
//
//struct PopOverTwo: View {
//
//    @Binding var show: Bool
//    @Binding var camera: Bool
//    @Binding var live: Bool
//
//    var body: some View {
//
//        VStack(alignment: .leading, spacing: 15) {
//
//            VStack {
//
//                Button {
//                    //                    show.toggle()
//                    camera.toggle()
//                } label: {
//                    HStack(spacing: 15) {
//                        Text("Posts")
//                            .padding(.trailing, 3)
//                        //                    Spacer()
//                        Image("PopUpPlay")
//                    }
//                }
//                Button {
//                    //                    show.toggle()
//                    //                    cameraTwo.toggle()
//                    live.toggle()
//                } label: {
//                    HStack(spacing: 15) {
//                        Text("Live")
//                            .padding(.trailing)
//                        //                    Spacer()
//                        Image("PopUpVideo")
//
//                    }
//                }
//            }
//            .foregroundColor(.black)
//            .frame(width: 100)
//            .padding(10)
//        }
//
//
//    }
//
//}
//
//struct PopOverThree: View {
//
//    @Binding var bottomSheetBlock: Bool
//    @StateObject private var likeVM: ReelsLikeViewModel = ReelsLikeViewModel()
//
//    var body: some View {
//
//        VStack(alignment: .center) {
//
//            Text("Do you want to block\nJenny Wilson?")
//                .font(.custom("Urbanist-Light", size: 14))
//                .fontWeight(Font.Weight.semibold)
//                .multilineTextAlignment(.center)
//                .lineLimit(2)
//                .padding(.top,13)
//                .padding(.leading,13)
//                .padding(.trailing,32)
//
//            HStack {
//
//                Button {
//                    bottomSheetBlock.toggle()
//                }
//            label: {
//
//                Text("Cancel")
//                    .font(.custom("Urbanist-Bold", size: 14))
//                    .fontWeight(Font.Weight.medium)
//                    .padding(.vertical,2.5)
//                    .padding(.horizontal,16)
//                    .foregroundColor(Color("buttionGradientOne"))
//
//            }
//            .background(
//               Color("BPurple")
//            )
//            .foregroundColor(.white)
//            .cornerRadius(30)
//
//                Button {
//                    likeVM.blockPostApi()
//                    bottomSheetBlock.toggle()
//                }
//            label: {
//
//                Text("Block")
//                    .font(.custom("Urbanist-Bold", size: 14))
//                    .fontWeight(Font.Weight.medium)
//                    .padding(.vertical,2.5)
//                    .padding(.horizontal,16)
//
//            }
//            .background(
//                LinearGradient(colors: [
//                    Color("buttionGradientOne"),
//                    Color("buttionGradientTwo"),
//                ], startPoint: .leading, endPoint: .trailing)
//            )
//            .foregroundColor(.white)
//            .cornerRadius(30)
//
//            }
//            .foregroundColor(.black)
//            .padding(.bottom,16)
//            .padding(.leading,8)
//            .padding(.trailing,20)
//            .padding(.top,8)
//        }
//        .frame(width: 200)
//        .cornerRadius(32)
//
//
//
//    }
//
//}
//
//
//struct ArrowShapeTwo: Shape {
//
//    func path(in rect: CGRect) -> Path {
//
//        let centent = rect.width / 2
//        return Path { path in
//
//            path.move(to: CGPoint(x: 0, y: 0))
//            path.addLine(to: CGPoint(x: rect.width, y: 0))
//            path.addLine(to: CGPoint(x: rect.width, y: rect.height - 20))
//
//            path.addLine(to: CGPoint(x: centent - 15, y: rect.height - 20))
//            path.addLine(to: CGPoint(x: centent, y: rect.height - 5))
//            path.addLine(to: CGPoint(x: centent + 15, y: rect.height - 20))
//
//            path.addLine(to: CGPoint(x: 0, y: rect.height - 20))
//
//
//        }
//
//    }
//
//}
//
//struct Diamond: Shape {
//
//    func path(in rect: CGRect) -> Path {
//        Path { path in
//            let horizontalOffset: CGFloat = rect.width * 0.2
//            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
//
//            path.addLine(to: CGPoint(x: rect.maxX - horizontalOffset, y: rect.midY))
//            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
//            path.addLine(to: CGPoint(x: rect.minX + horizontalOffset, y: rect.midY))
//            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
//        }
//    }
//}
//
//struct DiamondTwo: Shape {
//
//    func path(in rect: CGRect) -> Path {
//        Path { path in
//            let horizontalOffset: CGFloat = rect.width * 0.3
//            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
//
//            path.addLine(to: CGPoint(x: rect.maxX - horizontalOffset, y: rect.midY))
//            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
//            path.addLine(to: CGPoint(x: rect.minX - horizontalOffset, y: rect.midY))
//            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
//        }
//    }
//}
//
//// MARK: Offset Preference Key
//struct OffsetKey: PreferenceKey {
//    static var defaultValue: CGFloat = 0
//    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//        value = nextValue()
//    }
//}
//
//// Offset View Extension
//extension View {
//    @ViewBuilder
//    func offset(coordinateSpace: CoordinateSpace, completion: @escaping (CGFloat)->()) -> some View {
//        self
//            .overlay {
//                GeometryReader { proxy in
//                    let minY = proxy.frame(in: coordinateSpace).minY
//                    Color.clear
//                        .preference(key: OffsetKey.self, value: minY)
//                        .onPreferenceChange(OffsetKey.self) { value in
//                            completion(value)
//                        }
//                }
//            }
//    }
//}
//
///above is latest code

//  ReelsView.swift
//  ReelsTest
//
//  Created by Vooconnect on 05/11/22.
//

import SwiftUI
import AVKit
import Photos
import ARGear

struct ReelsView: View {
    
    @State var currentReel: Int
    @StateObject private var reelsVM = ReelsViewModel()
    
    @Binding var topBar: Bool
    
    @State var reelId: Int = 0
    @State var reelTagIndex: Int = 0
    
    @State var bool: Bool = false
    @Binding var cameraView: Bool
    @Binding var live: Bool
    @Binding var bottomSheetBlock: Bool
    @Binding var bottomSheetReport: Bool
    @Binding var myProfileView: Bool
    @Binding var creatorProfileView: Bool
    @Binding var musicView: Bool
    @Binding var liveViewer: Bool
    @Binding var commentSheet: Bool
    @Binding var commentReplySheet: Bool
    @Binding var postedBy: String
    @Binding var selectedReelId: Int
    @State private var offset: CGFloat = 0
    @State var videoIndex: Int = 0
    @State private var removeReel: Bool = false
    @State private var userUUid: String = ""

    
    var body: some View {
        
        // Setting Width and height for rotated view...
        
    
        
        GeometryReader { proxy in
            
            let size = proxy.size
            
            if reelsVM.allReels.count > 0 {
                // Vertical Page Tab View...
                TabView(selection: $reelTagIndex) {
                    //                ForEach($reels) { $reel in
                    ForEach(reelsVM.allReels.indices, id: \.self) { index in
                        
                        ReelsPlyer(commentSheet: $commentSheet, commentReplySheet: $commentReplySheet, reelsDetail: reelsVM.allReels[index], showTwo: $bool, cameraView: $cameraView, live: $live, myProfileView: $myProfileView, creatorProfileView: $creatorProfileView, musicView: $musicView, liveViewer: $liveViewer, postedBy: $postedBy, selectedReelId: $selectedReelId, currentReel: $currentReel, removeReel: $removeReel, userUUid: $userUUid, bottomSheetBlock: $bottomSheetBlock, bottomSheetReport: $bottomSheetReport, topBar: $topBar)
                        // setting width...
                            .frame(width: size.width, height: size.height)
                            .padding()
                        // Rotating Content...
                            .rotationEffect(.init(degrees: -90))
                            .ignoresSafeArea(.all, edges: .top)
                            .tag(index)
                    }
                    
                }
                .rotationEffect(.init(degrees: 90))
                // Since view is rotated setting height as width...
                .frame(width: size.height)
                .tabViewStyle(.page(indexDisplayMode: .never))
                // setting max width...
                .frame(width: size.width)
                .onChange(of: reelTagIndex) { index in
                    print("Current Index \(index)")
                    if index > videoIndex {
                        withAnimation(.easeInOut) {
                            print(videoIndex)
                            topBar = false
                            if removeReel{
                                removeReels(withCreatorUUID: userUUid)
                            }
                            removeReel = false
                        }
                        videoIndex = index
                    }else{
                        withAnimation(.easeInOut){
                            topBar = true
                            print("else index \(videoIndex)")
                        }
                        videoIndex = index
                    }
                }

            
            }else{
                VStack {
                        Image(systemName: "folder.badge.questionmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                    
                        Text("Empty post bucket !")
                        .padding(.top,10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.gray.opacity(0.1))
            }
            
            HStack {
                if self.bool {
                    VStack {
                        Diamond()
                            .frame(width: 60, height: 40)
                            .padding(.bottom, -30)
                            .padding(.leading, -50)
                            .foregroundColor(.white)
                        
                        PopOverTwo(show: $bool, camera: $cameraView, live: $live)
                            .background(Color.white)
                            .cornerRadius(15)
                    }
                }
                Spacer()
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top, 20)
            .padding(.leading, 5)
        
        }
        .ignoresSafeArea(.all, edges: .top)
        .background(Color.white.ignoresSafeArea())
        // setting intial reel...
        
    }
    func removeReels(withCreatorUUID creatorUUID: String) {
        reelsVM.allReels.removeAll { $0.creatorUUID == creatorUUID }
    }

    
}

struct ReelsView_Previews: PreviewProvider {
    static var previews: some View {
        //        ReelsView()
        HomePageView()
    }
}

//var player = AVPlayer()

struct ReelsPlyer: View {
    
    //    @Binding var commentText: String
    @Binding var commentSheet: Bool
    @Binding var commentReplySheet: Bool
    @StateObject private var reelsVM = ReelsViewModel()
    
    let reelsDetail: Post
    
    @State var currentTab = "recommended"
    @Namespace var animation
    
    let url = URL(string: "reels/1671107665992-test.mp4")
    
    //    @Binding var reel: Reel
    
    @State var show: Bool = false
    @State var longPressPopUp: Bool = false
    @State var selectedReaction: Int = 0
    @State var postID: Int = 0
    
    @Binding var showTwo: Bool
    @Binding var cameraView: Bool
    @Binding var live: Bool
    @Binding var myProfileView: Bool
    @Binding var creatorProfileView: Bool
    @Binding var musicView: Bool
    @Binding var liveViewer: Bool
    @Binding var postedBy: String
    @Binding var selectedReelId: Int
    
    @Binding var currentReel: Int
    // Expanding title if its clicked...
    @State var showMore = false
    
    @State var isMuted = false
    @State var volumeAnimation = false
    
    @State private var likeAnimation: Bool = false
    @Binding var removeReel: Bool
    @Binding var userUUid: String
    
    @State private var likeCount: Int = 0
    @State private var likeeeeCount: Int = 0
    @State private var bookmarkCount: Int = 0
    
    @StateObject private var likeVM: ReelsLikeViewModel = ReelsLikeViewModel()
    @State var likeAndUnlike = false
    @State var likeImage: String = "LikeWhiteR"
//    @State var selectedReaction: Int = 0
    //    @StateObject private var reelsVM = ReelsViewModel()
    
    @State var playButtonTest: Bool = false
    
    @Binding var bottomSheetBlock: Bool
    @Binding var bottomSheetReport: Bool
    //    @State private var bottomSheetMoreOption = false
    
    @State private var bookMarkMassage: Bool = false
    
    @State var plusIcon: Bool = false
    
    @State private var doubleTapLikeCount: Bool = true
    @State private var followRecommendedTextColor: Bool = false
    
    @Binding var topBar: Bool
    
    @State private var alert: Bool = false
    @State private var imagePause: Bool = false
    @State private var playAndPause: Bool = false
    @State private var playAndPauseOpacity: Double = 0.001
    
    @State var player = AVPlayer()
    @State private var image: UIImage?
    
//    var urll: URL
    @State private var tapCount = 0
    @State private var singleTapTimer: Timer?
    @State private var showHeartAnimation = false
    @State private var isTappedBookmark = false
    @State private var follow = false
    @State private var iconSize: CGFloat = 30.0
    
    var body: some View {
        
        
        ZStack {
            CustomVideoPlayer(player: player)
                .edgesIgnoringSafeArea(.all)
            
                .onAppear {
                    player.replaceCurrentItem(with: AVPlayerItem(url: URL(string: getImageVideoBaseURL + reelsDetail.contentURL!)!)) //<-- Here
                    player.play()
                    postID = reelsDetail.postID ?? 0
                    if reelsDetail.isLiked == 1{
                        if likeeeeCount == 0{
                            likeAndUnlike = true
                            likeeeeCount = likeeeeCount + 1
                            if let likesCount = reelsDetail.likeCount{
                                likeCount = likesCount
                            }
                            if reelsDetail.reactionType == 1{
                                likeImage = "HeartRedLV"
                            }else if (reelsDetail.reactionType == 2){
                                likeImage = "Love"
                            }else if (reelsDetail.reactionType == 3){
                                likeImage = "Haha"
                            }else if (reelsDetail.reactionType == 4){
                                likeImage = "Sad"
                            }else if (reelsDetail.reactionType == 5){
                                likeImage = "Angry"
                            }else if (reelsDetail.reactionType == 6){
                                likeImage = "Angry"
                            }
                        }
                    }
                }
                .onDisappear {
                    player.pause()
                    
                    
                }
                .onTapGesture {
                    // Increment tap count and start a timer
                    tapCount += 1
                    if tapCount == 1 {
                        singleTapTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                            print("Tapped")
                            postedBy = reelsDetail.creatorUUID ?? ""
                            playorstop()
                            tapCount = 0 // Reset tap count
                        }
                    } else if tapCount == 2 {
                        print("Double Tapped")
                        doubleTapLikeCount = true
                        show = false
                        showTwo = false
                        print("Success ====== 2")
                        likeAndUnlike = true
                        likeVM.reelsLikeDataModel.userUUID = reelsDetail.creatorUUID ?? ""
                        likeVM.reelsLikeDataModel.postID = reelsDetail.postID ?? 0
                        
                        if likeAndUnlike == true {
                            if reelsDetail.isLiked == 0{
                                if likeeeeCount == 0{
                                    likeeeeCount = likeeeeCount + 1
                                    likeCount = likeCount + 1
                                    likeVM.reelsLikeApi(reactionType: 1, postID: postID)
                                }
                            }
                            
                        }
                        showHeartAnimation = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showHeartAnimation = false
                        }
                        
                        
                        if longPressPopUp == true {
                            longPressPopUp = false
                        }
                        tapCount = 0 // Reset tap count
                        singleTapTimer?.invalidate()
                    }
                }
            if showHeartAnimation {
                HeartLike(isTapped: $showHeartAnimation, taps: 1)
            }
            HStack {
                // Live
                Button {

                    //                        player.pause()

                    show = false
                    showTwo = false

                    liveViewer.toggle()

                } label: {
                    Image("Live")

                }


                Spacer()
                if let uuid = UserDefaults.standard.string(forKey: "uuid"){
                    if reelsDetail.creatorUUID != uuid{
                        VStack (alignment: .trailing) {
                            Button {
                                show = false
                                showTwo = false
                                bottomSheetReport.toggle()

                            } label: {
                                Image("ReportIcon")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 26, height: 26)

                            }

                            Button {

                                let user_uuid = reelsDetail.creatorUUID ?? nil
                                print("user_uuid========",user_uuid as Any)
                                UserDefaults.standard.set(user_uuid, forKey: "user_uuid")
                                bottomSheetBlock.toggle()
                                removeReel = true
                                userUUid = user_uuid!

                            } label: {
                                Image("BlockUserbutton")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 26, height: 26)

                            }

                        }
                    }
                }



            }
            //                .padding(.leading)
            .padding(.leading, -1)
            .padding(.trailing, 10)
            .frame(maxHeight: .infinity, alignment: .top)


            // Center

            ZStack {


                if bottomSheetBlock {
                    HStack {
                        VStack{
                            DiamondTwo()
                                .frame(width: 80, height: 50)
                                .padding(.bottom, -35)
                                .padding(.leading,120)
                                .foregroundColor(.white)

                            PopOverThree(bottomSheetBlock: $bottomSheetBlock)
                                .background(Color.white)
                                .cornerRadius(32)
                        }
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top, 70)
                        .padding(.trailing,5)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)


                }

                if bookMarkMassage == true {

                    Text(likeVM.bookMarkDataModel.successMessage)
                        .foregroundColor(.white)
                }

                if imagePause {
                    Image("PlayWhiteN")
                        .frame(width: 100, height: 100)
                        .opacity(playAndPauseOpacity)
                }


            }


            // Recommended
            VStack {

                HStack {

                    Text("Recommended")
                        .font(.custom("Urbanist-Bold", size: 16))
                        .frame(width: 150, height: 42)
                        .background(
                            ZStack {
                                if currentTab == "recommended" {
                                    Color.white
                                        .cornerRadius(21)
                                        .matchedGeometryEffect(id: "TAB", in: animation)
                                }
                            }
                                .padding(.leading, 6)
                        )

                        .foregroundColor(followRecommendedTextColor ? Color(#colorLiteral(red: 0.787740171, green: 0.787740171, blue: 0.787740171, alpha: 0.3994205298)) : .black)
                        .onTapGesture {
                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
                                currentTab = "recommended"
                                followRecommendedTextColor.toggle()
                                show = false
                                showTwo = false

                            }
                        }


                    Text("Followers")
                        .font(.custom("Urbanist-Bold", size: 16))
                        .frame(width: 150, height: 42)
                    //                            .foregroundColor(currentTab ? .black : .red)
                        .background(
                            ZStack {
                                if currentTab == "followers" {
                                    Color.white
                                        .cornerRadius(21)
                                        .matchedGeometryEffect(id: "TAB", in: animation)
                                }
                            }
                                .padding(.trailing, 6)

                        )
                        .foregroundColor(followRecommendedTextColor ? .black : Color(#colorLiteral(red: 0.787740171, green: 0.787740171, blue: 0.787740171, alpha: 0.3994205298)))
                        .onTapGesture {
                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
                                currentTab = "followers"
                                followRecommendedTextColor.toggle()
                                show = false
                                showTwo = false
                            }
                        }

                }

                .frame(width: 300, height: 45)
                .background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)))
                .cornerRadius(22.5)
                .rotationEffect(.degrees(270))

            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(.leading, -110)
            .padding(.top, -120)


            // Creator Detail
            VStack {

                HStack(alignment: .bottom) {

                    VStack(alignment: .leading, spacing: 10) {

                        Button{
                            show = false
                            showTwo = false
                            creatorProfileView.toggle()
                        }label: {
                            HStack(spacing: 10) {
                                CreatorProfileImageView(allReels: reelsDetail)
                                //                                    .resizable();
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 55, height: 55)
                                    .cornerRadius(10)
                                    .background(

                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white,lineWidth: 6)
                                    )
                                //                                    .clipShape(Circle())

                                VStack(alignment: .leading, spacing: 5) {
                                    HStack {
                                        Text(reelsDetail.creatorFirstName ?? "jenny")
                                            .font(.custom("Urbanist-Bold", size: 18))
                                            .foregroundColor(.white)

                                        Text(reelsDetail.creatorLastName ?? "Wilson")
                                            .font(.custom("Urbanist-Bold", size: 18))
                                            .foregroundColor(.white)

                                    }

                                    ForEach(likeVM.userInterestCategory, id: \.id) { categ in
                                        if categ.user_uuid == reelsDetail.creatorUUID {

                                            ForEach(likeVM.interestCategory, id: \.id) { uiCateg in
                                                if categ.category_id == uiCateg.id {

                                                    Text("\(uiCateg.category_name)")
                                                        .font(.custom("Urbanist-Medium", size: 14))
                                                        .foregroundColor(.white.opacity(7))

                                                }
                                            }
                                        }
                                    }

//                                    Text("Actress & Singer")
//                                        .font(.custom("Urbanist-Medium", size: 14))
//                                        .foregroundColor(.white.opacity(7))
                                    //                                        .foregroundColor(Color("GrayFour"))

                                }

                            }
                            .padding(.bottom, 1)
                        }

                        // Title Custom View...

                        if let uuid = UserDefaults.standard.string(forKey: "uuid"){
                            if reelsDetail.creatorUUID != uuid{
                                Button {
                                    follow.toggle()
                                    if (follow == true) {
                                        likeVM.followApi(user_uuid: reelsDetail.creatorUUID!)
                                    }else{
                                        likeVM.unFollowApi(user_uuid: reelsDetail.creatorUUID!)
                                    }
                                } label: {
                                    HStack {
                                        if (follow == true){
                                            Image("UserPrivacy")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 16, height: 16)
                                        }else{
                                            Image("AddUserCP")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 16, height: 16)
                                        }
                                        
                                        
                                        Text(follow ? "Following" : "Follow")
                                            .font(.custom("Urbanist-Bold", size: 16))
                                        
                                        
                                    }
                                    .padding(.horizontal,20)
                                    .padding(.vertical,8)
                                }
                                .background(follow ? LinearGradient(colors: [
                                    Color.white,
                                ], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [
                                    Color("buttionGradientOne"),
                                    Color("buttionGradientTwo"),
                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .foregroundColor(follow ? Color("buttionGradientOne") : .white)
                                .cornerRadius(30)
                            }
                        }

                        //                            Text("Hi everyone. in this video I will sing a song")
                        Text(reelsDetail.title ?? "")
                            .font(.custom("Urbanist-Medium", size: 14))
                            .foregroundColor(.white)  // change
                        //                                .foregroundColor(.black)
//                        Text(reelsDetail.postDescription)
//                            .font(.custom("Urbanist-Medium", size: 12))
//                            .foregroundColor(.white)
//                            .padding(.top, -10)

                    }

                    Spacer(minLength: 20)

                    // List of Buttons...
                    // Traling PopUp
                    VStack {
                        if self.show {
                            VStack {
                                PopOverTwo(show: $show, camera: $cameraView, live: $live)
                                    .background(Color.white)
                                    .cornerRadius(15)

                                DiamondTwo()
                                    .frame(width: 40, height: 30)
                                    .padding(.top, -23)
                                    .padding(.trailing, -110)
                                    .foregroundColor(.white)
                                //                                                .rotationEffect(Angle(degrees: 20))
                            }
                            //                                        .padding(.trailing, 100)
                            .padding(.bottom, -10)
                        }
                    }
                    .padding(.bottom, 195)
                    .padding(.trailing, -50)


                    // All Traling Button
                    VStack(spacing: 10) {
                        
//                        Button {
//                            print("downloading")
//                            let markedVideoURL = URL(string: getImageVideoMarkedBaseURL + "/" + urll.lastPathComponent)
//                            print(markedVideoURL as Any)
//                            let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//                            let destinationUrl = docsUrl?.appendingPathComponent(urll.lastPathComponent)
//
//                            if let destinationUrl = destinationUrl {
//                                if FileManager().fileExists(atPath: destinationUrl.path) {
//                                    print("File already exists")
//                                    try! FileManager().removeItem(atPath: destinationUrl.path)
//                                    saveVideo(url: markedVideoURL!, destiURL: destinationUrl)
//                                } else {
//                                    saveVideo(url: markedVideoURL!, destiURL: destinationUrl)
//                                }
//                            }
//
//                            func saveVideo(url: URL, destiURL: URL) {
//                                let urlRequest = URLRequest(url: url)
//
//                                let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//                                    if let error = error {
//                                        print("Request error: ", error)
//
//                                        //                                                          self.isDownloading = false
//                                        return
//                                    }
//
//                                    guard let response = response as? HTTPURLResponse else { return }
//
//                                    if response.statusCode == 200 {
//                                        guard let data = data else {
//                                            //                                                              self.isDownloading = false
//                                            return
//                                        }
//                                        DispatchQueue.main.async {
//                                            do {
//                                                PHPhotoLibrary.shared().performChanges({
//                                                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: destiURL)
//                                                }) { saved, error in
//                                                    if saved {
//                                                        print("saved")
//                                                        //
//                                                    }
//                                                }
//                                                try data.write(to: destiURL, options: Data.WritingOptions.atomic)
//                                                DispatchQueue.main.async {
//                                                    //                                                                      self.isDownloading = false
//                                                }
//                                            } catch let error {
//                                                print("Error decoding: ", error)
//                                                //                                                                  self.isDownloading = false
//                                            }
//                                        }
//                                    }
//                                }
//                                dataTask.resume()
//
//                            }
//                        } label: {
//                            Image("DownloadLogo")  // PlusPurple
//
//                        }
                        
                        Button {
                            plusIcon.toggle()
                            show.toggle()
                            showTwo = false
                            //                                showMore.toggle()
                        } label: {
                            Image(show ? "PlusPurple" : "PlusIcon")  // PlusPurple

                        }

                        Button {
                            playorstop()

                        } label: {
                            Image(playAndPause ? "Pause" : "Play")
                            


                        }

                        Button {
                            //                                if volumeAnimation {
                            //                                    return
                            //                                }
                            show = false
                            showTwo = false

                            isMuted.toggle()
                            // Muting player...
                            player.isMuted = isMuted
                            withAnimation {volumeAnimation.toggle()}
                            print("Valum tapped")

                        } label: {
                            Image(isMuted ? "VolumeUp" : "VolumeUp")

                        }

                        Button {

                            show = false
                            showTwo = false

                        } label: {
                            Image("Sound")

                        }

                    }
                    //                        .padding(.trailing, -95)
                    .padding(.bottom, 20)

                    //                    reel: reel

                }

                // Music View...
                Button {
                    selectedReelId = reelsDetail.postID ?? 0
                    postedBy = reelsDetail.creatorUUID ?? ""
                    print(postedBy)

                    show = false
                    showTwo = false
                    musicView.toggle()
                }label: {
                    HStack {

                        //                        Image("musicProfileIcon")
                        CreatorProfileImageView(allReels: reelsDetail)
                        //                                    .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 24, height: 24)
                            .cornerRadius(10)

                        Image("MusicIcon")

                        Text(reelsDetail.musicTrack ?? "Oridinal Sound")
                            .font(.caption)
                            .fontWeight(.semibold)

                        Spacer(minLength: 20)


                    }
                    .padding(.top, 1)

                    .padding(.bottom, 10)
                }

                // Floting Menue
                // LIKE
                HStack(spacing: 13) {

                    VStack {
                        Image(likeImage) // LikeWhiteR LikeRedR LikeRedTwoR LikeRedThreeR
                            .resizable()
                            .scaledToFill()
                            .frame(width: 28, height: 28)
                            .clipped()
                            .onTapGesture {
//                                doubleTapLikeCount = true
                                show = false
                                showTwo = false
                                print("Success ====== 2")
                                likeAndUnlike.toggle()
                                likeVM.reelsLikeDataModel.userUUID = reelsDetail.creatorUUID ?? ""
                                likeVM.reelsLikeDataModel.postID = reelsDetail.postID ?? 0
                                    if likeAndUnlike == true {
                                        likeCount = likeCount+1
                                        likeeeeCount = likeeeeCount+1
                                        likeImage = "HeartRedLV"
                                    } else{
                                        likeCount = likeCount-1
                                        likeeeeCount = likeeeeCount-1
                                        likeImage = "LikeWhiteR"
                                    }

                                likeVM.reelsLikeApi(reactionType: 1, postID: postID)

                                if longPressPopUp == true {
                                    longPressPopUp = false
                                }
                            }

                            .onLongPressGesture(minimumDuration: -0.5) {
                                longPressPopUp.toggle()
                            }

                            Text("\(likeCount)")
                                .font(.custom("Urbanist-Regular", size: 8))
                                .offset(y: -3)

                    }

                    Button {
                        let postID = reelsDetail.postID ?? 0
                        print("PostIddddd========",postID)
                        UserDefaults.standard.set(postID, forKey: "postID")

                        commentSheet.toggle()



                        show = false
                        showTwo = false
                    } label: {
                        VStack {
                            Image("Comment")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 28, height: 28)

                            //                                    Text("22k")
                            Text("\(reelsDetail.commentCount ?? 0)")
                                .font(.custom("Urbanist-Regular", size: 8))
                                .offset(y: -3)
                        }
                    }

                    Button {
                        show = false
                        showTwo = false
                        //                                DispatchQueue.global(qos: .background).async {
                        //                                DispatchQueue.main.async {
//                        share()
                        //                                }
                        if let videoURL = URL(string: getImageVideoMarkedBaseURL + reelsDetail.contentURL!){
                            shareToFacebook(videoURL: videoURL, description: reelsDetail.postDescription!)
                        }
                    } label: {
                        VStack {
                            Image("Share")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 28, height: 28)

                            //                                    Text("22k")
                            Text("\(reelsDetail.shareCount ?? 0)")
                                .font(.custom("Urbanist-Regular", size: 8))
                                .offset(y: -3)
                        }
                    }


                    let iconColor: Color = isTappedBookmark ? Color("buttionGradientOne") : .white
                    Button {
                        show = false
                        showTwo = false
                        likeVM.bookMarkDataModel.successMessage = ""
                        bookMarkMassage = true
                        isTappedBookmark.toggle()

                        likeVM.bookMarkDataModel.userUUID = reelsDetail.creatorUUID ?? ""
                        likeVM.bookMarkDataModel.postID = reelsDetail.postID ?? 0
                        likeVM.bookMarkApi()
                        if bookmarkCount == 0{
                            bookmarkCount = bookmarkCount+1
                        }else{
                            bookmarkCount = bookmarkCount-1
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            bookMarkMassage = false
                        }

                    } label: {
                        VStack {
                            Image("Save")
                                .resizable()
                                .scaledToFill()
                                .foregroundColor(iconColor)
                                .frame(width: 28, height: 28)

                            //                                    Text("22k")
                            Text("\((reelsDetail.bookmarkCount ?? 0) + bookmarkCount)")
                                .font(.custom("Urbanist-Regular", size: 8))
                                .offset(y: -3)

                        }
                    }

                    Button {
                        postedBy = reelsDetail.creatorUUID ?? ""
                        //                                player.pause()
                        show = false
                        showTwo = false
                        creatorProfileView.toggle()
                    } label: {
                        VStack {

                            CreatorProfileImageView(allReels: reelsDetail)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 28, height: 28)
                                .cornerRadius(14)
                                .background(

                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color.white,lineWidth: 1)
                                )
                                .offset(y: 3)

                            Text("")
                                .font(.custom("Urbanist-Regular", size: 10))
                                .offset(y: -5)
                        }
                    }

                    Button {
                        //                                player.pause()
                        show = false
                        showTwo = false
                        myProfileView.toggle()
                    } label: {  // UserProfileImageView
                        VStack {

                            UserProfileImageView()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 28, height: 28)
                                .cornerRadius(14)
                                .background(

                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color.white,lineWidth: 1)
                                )
                                .offset(y: 3)

                            Text("")
                                .font(.custom("Urbanist-Regular", size: 10))
                                .offset(y: -5)

                        }

                    }
                }
                .onTapGesture {
                    show = false
                    showTwo = false
                }

                .padding(.top, 3)
                .padding(.leading, 15)
                .padding(.trailing, 15)
                //                    .background(.purple)
                .background(
                    LinearGradient(colors: [
                        Color("GradientOneOne"),
                        Color("GradientTwoTwo"),
                    ], startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(40)


            }

            .padding(.horizontal)
            .padding(.bottom, 20)
            .foregroundColor(.white)
            .frame(maxHeight: .infinity, alignment: .bottom)



            HStack {
                if longPressPopUp {
                    LongPressPopUp(likeImage: $likeImage, longPressPopUp: $longPressPopUp, selectedReaction: selectedReaction, postID: $postID, likeCount: $likeCount, likeeCount: $likeeeeCount, isLiked: $likeAndUnlike)
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 70)

        }
        


        //        .environmentObject(status)
        .onAppear {

//            if reelsDetail.isLiked == "1"{
//                likeAndUnlike = true
//            }
//            DispatchQueue.main.async {
//                likeCount = reelsDetail.likeCount ?? 0
//            }

        }

        .onDisappear {

            DispatchQueue.main.async {
                player.pause()
            }

        }

    }
    
    func toggleIconSize() {
        iconSize = playAndPause ? 30.0 : 30.0
    }
    
    func shareToFacebook(videoURL: URL, description: String) {
        let activityItems: [Any] = [videoURL, description]
                let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
                UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
    

    private func playorstop(){
        imagePause.toggle()
        if player.timeControlStatus == .playing{
            player.pause()
            playAndPauseOpacity = 1.0
            playAndPause = true
            show = false
            plusIcon = false
            showTwo = false
            print("Pause")
        }else{
            player.play()
            playAndPause = false
            playAndPauseOpacity = 0.001
            show = false
            plusIcon = false
            showTwo = false
            print("Play")
        }
    }
    
    private func share() {
        guard let urlShare = URL(string: "https://vooconnect.com") else { return }
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        //        UIApplication.shared.win
    }
    
}


struct AcctionButtions: View {
    //    var reel: Reel
    
    var body: some View {
        
        VStack(spacing: 10) {
            
//            Button {
//
//            } label: {
//                Image("PlusIcon")
//
//            }
            
            Button {
                
            } label: {
                Image("PlusIcon")
                
            }
            
            Button {
                
            } label: {
                Image("Play")
                
            }
            
            Button {
                
            } label: {
                Image("VolumeUp")
                //                Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                
            }
            
            Button {
                
            } label: {
                Image("Sound")
                
            }
            
        }
    }
}


let sampleText = "fdsgkldfgjodgmlhjasjuhmr9 gurih ughwau idhfu9 erh ko iuhgefguyh reiuhgy8 ureh iughf greiuwe g8yewgr igruiaew8ug reugt "


struct PopOverThree: View {
    
    @Binding var bottomSheetBlock: Bool
    @StateObject private var likeVM: ReelsLikeViewModel = ReelsLikeViewModel()
    
    var body: some View {
        
        VStack(alignment: .center) {
            
            Text("Do you want to block\nJenny Wilson?")
                .font(.custom("Urbanist-Light", size: 14))
                .fontWeight(Font.Weight.semibold)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.top,13)
                .padding(.leading,13)
                .padding(.trailing,32)
            
            HStack {
                
                Button {
                    bottomSheetBlock.toggle()
                }
            label: {
                
                Text("Cancel")
                    .font(.custom("Urbanist-Bold", size: 14))
                    .fontWeight(Font.Weight.medium)
                    .padding(.vertical,2.5)
                    .padding(.horizontal,16)
                    .foregroundColor(Color("buttionGradientOne"))
                
            }
            .background(
               Color("BPurple")
            )
            .foregroundColor(.white)
            .cornerRadius(30)
                
                Button {
                    likeVM.blockUserApi()
                    bottomSheetBlock.toggle()
                }
            label: {
                
                Text("Block")
                    .font(.custom("Urbanist-Bold", size: 14))
                    .fontWeight(Font.Weight.medium)
                    .padding(.vertical,2.5)
                    .padding(.horizontal,16)
                   
            }
            .background(
                LinearGradient(colors: [
                    Color("buttionGradientOne"),
                    Color("buttionGradientTwo"),
                ], startPoint: .leading, endPoint: .trailing)
            )
            .foregroundColor(.white)
            .cornerRadius(30)
                
            }
            .foregroundColor(.black)
            .padding(.bottom,16)
            .padding(.leading,8)
            .padding(.trailing,20)
            .padding(.top,8)
        }
        .frame(width: 200)
        .cornerRadius(32)
        
        
        
    }
    
}


struct ArrowShapeTwo: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let centent = rect.width / 2
        return Path { path in
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height - 20))
            
            path.addLine(to: CGPoint(x: centent - 15, y: rect.height - 20))
            path.addLine(to: CGPoint(x: centent, y: rect.height - 5))
            path.addLine(to: CGPoint(x: centent + 15, y: rect.height - 20))
            
            path.addLine(to: CGPoint(x: 0, y: rect.height - 20))
            
            
        }
        
    }
    
}

struct Diamond: Shape {
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            let horizontalOffset: CGFloat = rect.width * 0.2
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            
            path.addLine(to: CGPoint(x: rect.maxX - horizontalOffset, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + horizontalOffset, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        }
    }
}

struct DiamondTwo: Shape {
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            let horizontalOffset: CGFloat = rect.width * 0.3
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            
            path.addLine(to: CGPoint(x: rect.maxX - horizontalOffset, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX - horizontalOffset, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        }
    }
}

// MARK: Offset Preference Key
struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// Offset View Extension
extension View {
    @ViewBuilder
    func offset(coordinateSpace: CoordinateSpace, completion: @escaping (CGFloat)->()) -> some View {
        self
            .overlay {
                GeometryReader { proxy in
                    let minY = proxy.frame(in: coordinateSpace).minY
                    Color.clear
                        .preference(key: OffsetKey.self, value: minY)
                        .onPreferenceChange(OffsetKey.self) { value in
                            completion(value)
                        }
                }
            }
    }
}

