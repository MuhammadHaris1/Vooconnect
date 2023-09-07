//
//  FinalVideoToPostView.swift
//  Vooconnect
//
//  Created by Vooconnect on 06/12/22.
// ReelsPostViewModel

import SwiftUI
import Photos
import SDWebImageSwiftUI
import FBSDKShareKit
//import SocialMedia
//import FacebookLogin
//import FacebookCore

struct FinalVideoToPostView: View {
    
    @Environment(\.presentationMode) var presentaionMode
    @State private var showPreview = false
    @State private var bottomSheetShown = false
    @State private var bottomSheetMoreOption = false
    @State private var loadingVideo = false
    @State private var homeView = false
    @State var text2: String = ""
    @State var description: String = ""
    
    @State var text = ""
    @State var didStartEditing = false
    
    @State var placeholder: String = "Add Video Description"
    
    //    @State var airplaneMode = true
    @State var toggleOn =  true
    @State var toggleOnTwo =  true
    @State var toggleOnThree =  false
    private enum Field: Int, CaseIterable {
        case captionn
    }
    @FocusState private var focusedField: Field?
    
    private let uploadReels: UploadReelsResource = UploadReelsResource()
    //    @State var selectedImage: UIImage = UIImage(named: "profileicon")!
    @StateObject var reelsPostVM = ReelsPostViewModel()
    
    //    var url: URL
    @State var postModel : PostModel
    @State var renderUrl : URL?
    @State private var saveToDevice = false
    @State private var autoCaption = false
    @State private var loader = false
    @State private var showTopicView = false
    @State private var videoCreditsView = false
    @State private var isShowPopup = false
    @State private var message = ""
    @State private var captionLang = ""
    @State private var selectedTopic = ""
    @State private var selectedCat: Int?
    @State private var videoData: Data?
    @State private var showPrivacySettings = false
    
    @State private var isFacebook = false
    @State private var isSocialMedia = false
    @State private var isWhatsApp = false
    @State private var isTwetter = false
    @State private var isInstagram = false
    @State private var isListView = false
    @GestureState private var tapGestureState = false
    @State private var extractedImage: UIImage?
    @FocusState private var isFocused: Bool
    @State var progress: Double = 0
    @State private var subLang: String = ""
    @State private var subAllow: String = ""
    @State private var subString: String = ""
    @State private var videoCreditsText: String = ""
    @State private var videoCreditsVisible: Bool = false
    @State var userNames: [String] = []
    @State var videoCredits: [String] = []
    
    var catSelected: (Int) -> () = {val in}
    @State private var selectedType: SocialMediaType?
    
    init(postModel : PostModel, renderUrl : URL?){
        _postModel = State(initialValue: postModel)
        _renderUrl = State(initialValue: renderUrl)
    }
    
//    private func selectMention(_ mention: String) {
//        let mentionRange = description.range(of: mentionData, options: .caseInsensitive)
//
//        if let range = mentionRange {
//            text.replaceSubrange(range, with: "\(mention)")
////            isListVisible = false
////            mentionData = ""
//        }
//    }
    
    var body: some View {
        NavigationView {
            ZStack {
                //                NavigationView {
                Color(.white)
                    .ignoresSafeArea()
                
                VStack {
                    
                    
                    
                    HStack {
                        Button {
                            presentaionMode.wrappedValue.dismiss()
                        } label: {
                            Image("BackButton")
                        }
                        
                        Text("Post")
                            .font(.custom("Urbanist-Bold", size: 24))
                            .foregroundColor(Color(#colorLiteral(red: 0.1726317704, green: 0.1726317704, blue: 0.1726317704, alpha: 1)))
                            .padding(.leading, 10)
                        Spacer()
                    }
                    //                    .padding(.leading)
                    
                    ScrollView(showsIndicators: false) {
                        
                        HStack {
                            DescriptionTextEditor(text: $description, isListVisible: $isListView, userNames: $userNames, videoCreditsVisible: $videoCreditsVisible, videoCreditsText: $videoCreditsText)
                                .focused($isFocused)
                                .onTapGesture{
                                    isFocused = true
                                }
                                .onChange(of: description) { newValue in
                                    print("value is\(newValue)")
                                    if let lastIndex = newValue.lastIndex(of: "@") {
                                        let substring = newValue.suffix(from: newValue.index(after: lastIndex))
                                        
                                        self.subString = String(substring)
                                        print("sub value is\(self.subString)")
                                    }
                                }
                            
                            
                            //                            Image("SelectCover")
                            if let image = extractedImage {
                                ExtractedImageView(image: image)
                                    .cornerRadius(15)
                            } else {
                                testCover()
                                    .cornerRadius(15)
                            }
                            //                            testCover()
                            //                                .cornerRadius(15)
                            
                            
                        }
                        .onAppear {
                            extractImageFromVideo(url: postModel.contentUrl!) { image in
                                DispatchQueue.main.async {
                                    extractedImage = image
                                }
                            }
                        }
                        .padding(.top,2)
                        
                        HStack(alignment: .top){
                            Text("Video credit to: ")
                                .font(.custom("Urbanist-Regular", size: 18))
                                .frame(width: 120)
                            if videoCreditsVisible {
                                CreditsView(videoCreditsText: $videoCreditsText)
                                    .padding(.trailing, 10)
                            }
                            Spacer()
                        }
                        .padding(.top,2)
                        
                        
                        // Hastag
                        HStack {
                            
                            HStack {
                                
                                Image("HastagLogo")
                                
                                Button {
                                    isFocused = true
                                    description += " #"
                                    
                                } label: {
                                    Text("Hashtag")
                                        .lineLimit(1)
                                        .font(.custom("Urbanist-SemiBold", size: 14))
                                        .foregroundStyle((LinearGradient(colors: [
                                            Color("buttionGradientTwo"),
                                            Color("buttionGradientOne"),
                                        ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                        ))
                                }
                                .padding(.leading, -4)
                                
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 8)
                            //                            .padding(5)
                            //                            .padding(.horizontal, 4)
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .strokeBorder((LinearGradient(colors: [
                                        Color("buttionGradientTwo"),
                                        Color("buttionGradientOne"),
                                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    ), lineWidth: 2)
                            }
                            
                            Spacer()
                            
                            HStack {
                                
                                Image("AttheRateLogo")
                                
                                Button {
                                    isFocused = true
                                    description += " @"
                                } label: {
                                    Text("Mention")
                                        .lineLimit(1)
                                        .font(.custom("Urbanist-SemiBold", size: 14))
                                        .foregroundStyle((LinearGradient(colors: [
                                            Color("buttionGradientTwo"),
                                            Color("buttionGradientOne"),
                                        ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                        ))
                                }
                                .padding(.leading, -4)
                                
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 8)
                            //                            .padding(5)
                            //                            .padding(.horizontal, 4)
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .strokeBorder((LinearGradient(colors: [
                                        Color("buttionGradientTwo"),
                                        Color("buttionGradientOne"),
                                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    ), lineWidth: 2)
                            }
                            
                            Spacer()
                            
                            HStack {
                                
                                Button {
                                    if (videoCreditsVisible == true){
                                        videoCreditsVisible = false
                                        videoCreditsView = false
                                    }else{
                                        videoCreditsView = true
                                    }
                                } label: {
                                    HStack{
                                        Image("VideoLogo")
                                        Text("Videos")
                                            .lineLimit(1)
                                            .font(.custom("Urbanist-SemiBold", size: 14))
                                    }
                                }
                                .frame(width: 80, height: 32)
                                .foregroundStyle(videoCreditsVisible ? LinearGradient(colors: [
                                    Color.white
                                ], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [
                                    Color("buttionGradientTwo"),
                                    Color("buttionGradientOne"),
                                ], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .background(videoCreditsVisible ? LinearGradient(colors: [
                                    Color("buttionGradientTwo"),
                                    Color("buttionGradientOne"),
                                    Color("buttionGradientOne"),
                                ], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [
                                    Color.clear,
                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .cornerRadius(25)
                                .overlay(videoCreditsVisible ?
                                         RoundedRectangle(cornerRadius: 25).stroke(Color.clear, lineWidth: 0) : RoundedRectangle(cornerRadius: 25).stroke(Color("buttionGradientOne"), lineWidth: 1.5))
                                
                            }
                            
                            Spacer()
                            
                            HStack {
                                
                                Image("CategorieLogo")
                                
                                Button {
                                    isFocused = false
                                    self.postModel.description = description
                                    showTopicView.toggle()
                                } label: {
                                    Text("Category")
                                        .lineLimit(1)
                                        .foregroundColor(.white)
                                        .font(.custom("Urbanist-SemiBold", size: 14))
                                }
                                
                                .padding(.leading, -4)
                                
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 8)
                            //                            .padding(5)
                            //                            .padding(.horizontal, 4)
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .strokeBorder((LinearGradient(colors: [
                                        Color("buttionGradientTwo"),
                                        Color("buttionGradientOne"),
                                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    ), lineWidth: 2)
                            }
                            .background(LinearGradient(colors: [
                                Color("buttionGradientTwo"),
                                Color("buttionGradientOne"),
                            ], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .cornerRadius(20)
                            
                        }
                        .padding(.top, 8)
                        .sheet(isPresented: $showTopicView) {
                            CatBotSheetView(selectedCat: selectedCat ?? 0, onItemSelected: { category in
                                selectedCat = category
                                self.catSelected(category)
                                showTopicView.toggle()
                            })
                        }
                        .sheet(isPresented: $videoCreditsView) {
                            VideoCreditsView(userNames: $videoCredits, videoCreditsView: $videoCreditsView, videoCreditsVisible: $videoCreditsVisible, videoCreditsText: $videoCreditsText)
                        }
                        
                        
                        
                        RoundedRectangle(cornerRadius: 0)
                            .frame(height: 1)
                            .foregroundColor(Color("GrayThree"))
                            .padding(.top)
                        if isListView {
                            ScrollView{
                                VStack(spacing: 20){
                                    
                                    ForEach (userNames, id: \.self){ user in
                                        HStack{
                                            Button{
                                                isListView = false
                                                if let lastIndex = description.lastIndex(of: "@") {
                                                    let range = lastIndex..<description.endIndex
                                                    description = description.replacingOccurrences(of: self.subString, with: user + " ", options: [], range: range)
                                                }
                                            }label: {
                                                Text(user)
                                                    .font(.custom("Urbanist-SemiBold", size: 18))
                                                    .foregroundColor(.black)
                                            }
                                            Spacer()
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }else{
                            VStack{
                                VStack(spacing: 20) {
                                    HStack {
                                        Image("ProfileLogo")
                                        
                                        Button {
                                            
                                        } label: {
                                            Text("Tag People")
                                                .font(.custom("Urbanist-SemiBold", size: 18))
                                                .foregroundColor(.black)
                                        }
                                        .padding(.leading, 12)
                                        
                                        Spacer()
                                        
                                        Image("ArrowLogo")
                                        
                                    }
                                    
                                    HStack {
                                        Image("LocationLogo")
                                        
                                        Button {
                                            
                                        } label: {
                                            Text("Location")
                                                .font(.custom("Urbanist-SemiBold", size: 18))
                                                .foregroundColor(.black)
                                        }
                                        .padding(.leading, 12)
                                        
                                        Spacer()
                                        
                                        Image("ArrowLogo")
                                        
                                    }
                                    
                                    HStack {
                                        Image("VisibalLogo")
                                        
                                        Button {
                                            //                                    bottomSheetShown.toggle()
                                            showPrivacySettings.toggle()
                                        } label: {
                                            Text("Visible to \(self.postModel.visibility.rawValue.prefix(1).capitalized + self.postModel.visibility.rawValue.dropFirst())")
                                                .font(.custom("Urbanist-SemiBold", size: 18))
                                                .foregroundColor(.black)
                                        }
                                        .padding(.leading, 12)
                                        
                                        Spacer()
                                        
                                        Image("ArrowLogo")
                                        
                                    }
                                    
                                    HStack {
                                        Image("AllowComment")
                                        
                                        Button {
                                            
                                        } label: {
                                            Text("Allow Comments")
                                                .font(.custom("Urbanist-SemiBold", size: 18))
                                                .foregroundColor(.black)
                                        }
                                        .padding(.leading, 12)
                                        
                                        Spacer()
                                        
                                        ZStack {
                                            Capsule()
                                                .frame(width:44,height:24)
                                                .foregroundColor(.clear)
                                                .background(toggleOn ?
                                                            LinearGradient(colors: [
                                                                Color("buttionGradientTwo"),
                                                                Color("buttionGradientOne"),
                                                            ], startPoint: .topLeading, endPoint: .bottomTrailing) :  LinearGradient(colors: [
                                                                Color("grayOne"),
                                                                Color("grayOne"),
                                                            ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                                )
                                                .cornerRadius(16)
                                            ZStack{
                                                Circle()
                                                    .strokeBorder(Color("buttionGradientOne"), lineWidth: 2)
                                                    .frame(width:22, height:22)
                                                    .overlay(
                                                        Circle()
                                                            .fill(Color.white))
                                            }
                                            .shadow(color: .black.opacity(0.14), radius: 4, x: 0, y: 2)
                                            .offset(x:toggleOn ? 9.5 : -9.5)
                                        }
                                        .onTapGesture {
                                            self.toggleOn.toggle()
                                            self.postModel.allowComments = self.toggleOn
                                        }
                                        
                                    }
                                    
                                    
                                    HStack {
                                        Image("AllowDuet")
                                        
                                        Button {
                                            
                                        } label: {
                                            Text("Allow Duo")
                                                .font(.custom("Urbanist-SemiBold", size: 18))
                                                .foregroundColor(.black)
                                        }
                                        .padding(.leading, 12)
                                        
                                        Spacer()
                                        
                                        ZStack {
                                            Capsule()
                                                .frame(width:44,height:24)
                                                .foregroundColor(.clear)
                                                .background(toggleOnTwo ?
                                                            LinearGradient(colors: [
                                                                Color("buttionGradientTwo"),
                                                                Color("buttionGradientOne"),
                                                            ], startPoint: .topLeading, endPoint: .bottomTrailing) :  LinearGradient(colors: [
                                                                Color("grayOne"),
                                                                Color("grayOne"),
                                                            ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                                )
                                                .cornerRadius(16)
                                            ZStack{
                                                Circle()
                                                    .strokeBorder(Color("buttionGradientOne"), lineWidth: 2)
                                                    .frame(width:22, height:22)
                                                    .overlay(
                                                        Circle()
                                                            .fill(Color.white))
                                            }
                                            .shadow(color: .black.opacity(0.14), radius: 4, x: 0, y: 2)
                                            .offset(x:toggleOnTwo ? 9.5 : -9.5)
                                        }
                                        .onTapGesture {
                                            self.toggleOnTwo.toggle()
                                            self.postModel.allowDuet = self.toggleOnTwo
                                        }
                                        
                                    }
                                    
                                    
                                    HStack {
                                        Image("AllowStitchLogo")
                                        
                                        Button {
                                            
                                        } label: {
                                            Text("Allow Knit")
                                                .font(.custom("Urbanist-SemiBold", size: 18))
                                                .foregroundColor(.black)
                                        }
                                        .padding(.leading, 12)
                                        
                                        Spacer()
                                        
                                        ZStack {
                                            Capsule()
                                                .frame(width:44,height:24)
                                                .foregroundColor(.clear)
                                                .background(toggleOnThree ?
                                                            LinearGradient(colors: [
                                                                Color("buttionGradientTwo"),
                                                                Color("buttionGradientOne"),
                                                            ], startPoint: .topLeading, endPoint: .bottomTrailing) :  LinearGradient(colors: [
                                                                Color("grayOne"),
                                                                Color("grayOne"),
                                                            ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                                )
                                                .cornerRadius(16)
                                            ZStack{
                                                Circle()
                                                    .strokeBorder(Color("buttionGradientOne"), lineWidth: 2)
                                                    .frame(width:22, height:22)
                                                    .overlay(
                                                        Circle()
                                                            .fill(Color.white))
                                            }
                                            .shadow(color: .black.opacity(0.14), radius: 4, x: 0, y: 2)
                                            .offset(x:toggleOnThree ? 9.5 : -9.5)
                                        }
                                        .onTapGesture {
                                            self.toggleOnThree.toggle()
                                            self.postModel.allowStitch = self.toggleOnThree
                                        }
                                        
                                    }
                                    
                                    
                                    HStack {
                                        Image("MoreOptionLogo")
                                        
                                        Button {
                                            bottomSheetMoreOption.toggle()
                                        } label: {
                                            Text("More Option")
                                                .font(.custom("Urbanist-SemiBold", size: 18))
                                                .foregroundColor(.black)
                                        }
                                        .padding(.leading, 12)
                                        
                                        Spacer()
                                        
                                        Image("ArrowLogo")
                                        
                                    }
                                    
                                }
                                .padding(.top)
                                
                                HStack {
                                    Text("Automatically share to:")
                                        .font(.custom("Urbanist-Bold", size: 18))
                                    Spacer()
                                    
                                }
                                .padding(.top)
                                
                                HStack {
                                    ForEach(SocialMediaType.allCases, id: \.self) { type in
                                        SocialMediaIconView(type: type, selectedType: $selectedType)
                                    }
                                    Spacer()
                                }
                                .padding(.top)
                                
                                HStack {
                                    Button {
                                        loadingVideo = true
                                        simulateVideoDownload()
                                        
                                    } label: {
                                        Spacer()
                                        HStack {
                                            
                                            Image("DraftLogo")
                                            
                                            Text("Drafts")
                                                .font(.custom("Urbanist-Bold", size: 16))
                                                .foregroundStyle(
                                                    LinearGradient(colors: [
                                                        Color("buttionGradientTwo"),
                                                        Color("buttionGradientOne"),
                                                    ], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                .padding()
                                        }
                                        Spacer()
                                    }
                                    .background(Color("SkipButtonBackground"))
                                    .cornerRadius(40)
                                    
                                    Spacer()
                                    Spacer()
                                    
                                    Button {
                                        loader = true
                                        if (postModel.description == ""){
                                            print("Description should not be nil")
                                            loader = false
                                            showMessagePopup(messages: "Description Needed")
                                            return
                                        }
                                        
                                        guard let selectedCat = selectedCat, selectedCat != 0 else {
                                            print("Category should be selected")
                                            loader = false
                                            showMessagePopup(messages: "Category Needed")
                                            return
                                        }
                                        uploadReelss { isSuccess in
                                            if isSuccess {
                                                if (self.saveToDevice){
                                                    print("Should save to device: " + self.saveToDevice.description)
                                                    Task {
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                                            downloadAndSaveWithCaptionVideo()
                                                        }
                                                        homeView = true
                                                        loader = false
                                                        print("Video downloaded into gallery")
                                                    }
                                                }else{
                                                    loader = false
                                                    print("success=========")
                                                    homeView = true
                                                }
                                                if (selectedType != nil){
                                                    DispatchQueue.main.async{
                                                        print("Facebook is true")
                                                        let fileName = UserDefaults.standard.string(forKey: "imageName") ?? ""
                                                        let videoURL =  URL(string: getImageVideoMarkedBaseURL + fileName)
                                                        print("shareable Url \(videoURL)")
                                                        shareToFacebook(videoURL: videoURL!)
                                                    }
                                                }
                                            } else {
                                                print("failed==========")
                                                loader = false
                                            }
                                        }
                                        
                                    } label: {
                                        Spacer()
                                        HStack {
                                            
                                            Image("PostLogo")
                                            
                                            Text("Post")
                                                .font(.custom("Urbanist-Bold", size: 16))
                                                .foregroundColor(.white)
                                                .padding()
                                        }
                                        Spacer()
                                        NavigationLink(destination: HomePageView()
                                            .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $homeView) {
                                                EmptyView()
                                            }
                                    }
                                    .background(
                                        LinearGradient(colors: [
                                            Color("buttionGradientTwo"),
                                            Color("buttionGradientOne"),
                                        ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                    .cornerRadius(40)
                                    
                                }
                                .padding(.top, 20)
                                
                            }}
                            //                    .toolbar(content: {
                            //                        ToolbarItem(placement: .keyboard) {
                            //                            Spacer()
                            //                        }
                            //                        ToolbarItem(placement: .keyboard) {
                            //                            Button("Done") {
                            //                                focusedField = nil
                            //                            }
                            //                        }
                            //                    })
                            
                        }
                        .padding(.horizontal)
                        //                .navigationBarHidden(true)
                        //            } CustomeSheetMoreOtptions
                    

                        .overlay{
                            if loadingVideo {
                                Color.black.opacity(0.3)
                                    .edgesIgnoringSafeArea(.all)
                                    .overlay(
                                        ZStack {
                                            CircularProgressView(progress: progress)
                                            Text("\(Int(progress * 100))%")
                                                .font(.custom("Urbanist-Regular", size: 22))
                                                .bold()
                                        }
                                        .frame(width: 60, height: 60)
                                    )
                            }
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
                    }
                    .onTapGesture{
                        isFocused = false
                        self.postModel.description = description
                    }
                    if bottomSheetShown {
                        Rectangle()
                            .fill(Color.black)
                            .opacity(0.7)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                bottomSheetShown.toggle()
                            }
                    }
                if loader{
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .overlay(
                            ProgressView()
                                .frame(width: 50, height: 50)
                                .padding()
                        )
                }
                    
//                    GeometryReader { geometry in
//                        BottomSheetView(
//                            isOpen: self.$bottomSheetShown,
//                            maxHeight: geometry.size.height * 0.5
//                        ) {
//                            PostVisibilityView(
//                                currentVisibility: self.postModel.visibility,
//                                callback:{type in
//                                    self.showPrivacySettings = false
//                                    self.postModel.visibility = type
//                                }
//                            )
//                            CustomeSheetView(callback: {type in
//                                self.postModel.visibility = type
//                                print("type of visibility")
//                                print(self.postModel.visibility)
//                            })
//                        }
//                    }.edgesIgnoringSafeArea(.all)
                if self.isShowPopup {
                    GeometryReader { geometry in
                        VStack {
                            Spacer()
                            Spacer()
                            Text(message)
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
                
                // More Option
                if bottomSheetMoreOption {
                    Rectangle()
                        .fill(Color.black)
                        .opacity(0.7)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            bottomSheetMoreOption.toggle()
                        }
                }
                    
                    GeometryReader { geometry in
                        BottomSheetView(
                            isOpen: self.$bottomSheetMoreOption,
                            maxHeight: geometry.size.height * 0.3
                        ) {
                            CustomeSheetMoreOtptions(
                                saveToDevice: {val in
                                self.saveToDevice = val
                            }, autoCation: {val in
                                self.autoCaption = val
                            }, captionLang: {val in
                                self.captionLang = val
                            })
                            
                        }
                    }.edgesIgnoringSafeArea(.all)
                    
                }
                .onTapGesture {
                    focusedField = nil
                }
                .navigationBarHidden(true)
            }
        }
    
    
    func simulateVideoDownload() {
        DispatchQueue.global(qos: .background).async {
            let totalProgressSteps = 100
            
            for i in 0..<totalProgressSteps {
                usleep(100_000) // Simulating delay in video download
                
                DispatchQueue.main.async {
                    progress = Double(i + 1) / Double(totalProgressSteps)
                    
                    if i == totalProgressSteps - 1 {
                        // Download completed
                        loadingVideo = false
                        print("Video download completed")
                        
                        // Call the function to save the video or image to the gallery here
                        saveVideoToGallery()
                    }
                }
            }
        }
        }
    
    func saveVideoToGallery(){
        print("Should save to device: "+self.saveToDevice.description)
            guard let renderUrl = self.renderUrl else{
                print("incorrect url, can't save to gallery")
                return
            }
            print("saving to device, url: " + renderUrl.absoluteString)
            if(self.postModel.isImageContent())
            {
                let data = try? Data(contentsOf: renderUrl)
                let image = UIImage(data: data!)
                UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
            }
            else{
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: renderUrl)
                }) { complete, error in
                    if complete {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                            print("Saved to gallery")
                        }
                    }
                }
            }
    }
    func shareToFacebook(videoURL: URL) {
        let activityItems: [Any] = [videoURL, self.description]
                let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
                UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
    func showMessagePopup(messages: String) {
        self.message = messages
        self.isShowPopup = true
    }
    
    func extractImageFromVideo(url: URL, completion: @escaping (UIImage?) -> Void) {
        let asset = AVAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        
        generator.appliesPreferredTrackTransform = true
        let time = CMTime(seconds: 0, preferredTimescale: 1)
        
        generator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { _, image, _, _, _ in
            guard let cgImage = image else {
                completion(nil)
                return
            }
            
            let uiImage = UIImage(cgImage: cgImage)
            completion(uiImage)
        }
    }
        
        func testCover() -> some View{
            let data = try? Data(contentsOf: self.renderUrl!)
            let image = UIImage(data: data!)
            return Image(uiImage: image ?? UIImage(imageLiteralResourceName: "SelectCover"))
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 132)
        }
        
        //    func stickerView(content : ContentOverlayModel) -> some View{
        //        Image(content.value)
        //            .resizable()
        //            .scaledToFit()
        //            .frame(width: 100 * content.scale, height: 100 * content.scale)
        ////            .offset(content.size)
        ////            .offset(CGSize(width: -content.size.width, height: -content.size.height))
        //    }
        //
        //    func textView(content : ContentOverlayModel) -> some View{
        //        Text(content.value)
        //            .urbanistBlack(fontSize: content.fontSize)
        //            .foregroundColor(content.color == .white ? .black : .white)
        //            .padding(.horizontal,12)
        //            .padding(.vertical,8)
        //            .background{
        //                if(content.enableBackground){
        //                    content.color
        //                        .cornerRadius(16)
        //                }
        //            }
        //            .fixedSize()
        //            .frame(maxWidth: UIScreen.main.screenWidth() - 36)
        //    }
        
        private func uploadReelss(complitionHandler : @escaping(Bool) -> Void) {
            self.postModel.contentUrl = self.renderUrl
            
            if (autoCaption == true){
                self.subAllow = "true"
                self.subLang = captionLang
            } else{
                self.subAllow = "false"
            }
            uploadReels.uploadReels(imageUploadRequest: self.postModel.contentUrl!, paramName: "asset", fileName: renderUrl?.lastPathComponent ?? "default.\(postModel.isImageContent() ? "png" : "mp4")", subtitleLang: self.subLang, subtitle_apply: subAllow) { responsee, errorMessage in
                if(!responsee || errorMessage == nil)
                {
                    
                    print("error uploading video")
                    complitionHandler(false)
                    return
                }
                print("image url \(self.postModel.contentUrl!)")
                let uuid = UserDefaults.standard.string(forKey: "uuid") ?? ""
                let reelsSize = UserDefaults.standard.string(forKey: "reelSize") ?? ""
                let fileName = UserDefaults.standard.string(forKey: "imageName") ?? ""
                var tag: [String] = []
                self.postModel.tagPeople.forEach { peopleId in
                    tag.append(peopleId.uid)
                }
                let content = ContentDetail(name: fileName, size: reelsSize)
                print("caption and lan:  ", self.captionLang, self.autoCaption)
                let postRes = ReelsPostRequest(userUUID: uuid, title: postModel.description, description: self.postModel.description, contentType: postModel.isImageContent() ? "image" : "video", category: self.selectedCat, musicTrack: postModel.songModel?.title, location: postModel.location.id, visibility: "public", musicUUID: postModel.songModel?.id, musicURL: postModel.songModel?.preview, content: [content], allowComment: self.postModel.allowComments, allowDuet: self.postModel.allowDuet, allowStitch: self.postModel.allowStitch, tags: tag )
                uploadReels.uploadPost(post: postRes, complitionHandler: {response, error in
                    DispatchQueue.main.async {
                        if(responsee == true) {
                            print("Sucessss......")
                            print("")
                            complitionHandler(true)
                        } else {
                            print("Errror.....")
                            complitionHandler(false)
                            loader = false
                        }
                    }
                })
            }
        }
    }

enum SocialMediaType: String, CaseIterable {
    case WhatsApp
    case Instagram
    case Facebook
    case Twetter
}
struct SocialMediaIconView: View {
    let type: SocialMediaType
    @Binding var selectedType: SocialMediaType?
    
    var isSelected: Bool {
        selectedType == type
    }
    
    var body: some View {
        Image("\(type.rawValue)Logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 50)
            .opacity(isSelected ? 1.0 : 0.5)
            .overlay(
                Circle()
                    .strokeBorder(isSelected ? LinearGradient(colors: [Color("buttionGradientTwo"), Color("buttionGradientOne")], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [Color.clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
            )
            .onTapGesture {
                if isSelected {
                    selectedType = nil
                } else {
                    selectedType = type
                }
            }
    }
}

struct ExtractedImageView: View {
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image ?? UIImage(imageLiteralResourceName: "SelectCover"))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaledToFill()
            .frame(width: 100, height: 132)
    }
}
struct CircularProgressView: View {
    let progress: Double
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.gray.opacity(0.5),
                    lineWidth: 5
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color("buttionGradientTwo"),
                            Color("buttionGradientOne"),
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(
                        lineWidth: 5,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
            
        }
    }
}


struct CircularProgressCameraView: View {
    let progress: Double
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.white,
                    lineWidth: 6
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.red,
                    style: StrokeStyle(
                        lineWidth: 6,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
            
        }
    }
}
