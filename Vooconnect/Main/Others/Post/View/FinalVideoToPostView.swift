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
    @State private var navigateToNextView = false
    @State private var showPreview = false
    @State private var bottomSheetShown = false
    @State private var bottomSheetMoreOption = false
    @State private var homeView = false
    @State var text2: String = ""
    @State var description: String = ""
    
    @State var text = ""
    @State var didStartEditing = false
    
    @State var placeholder: String = "Hi everyone, in this video I will sing a song #song #music #love #beauty Thanks to @Vooconnect Video credit to"
    
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
    @State private var isShowPopup = false
    @State private var message = ""
    @State private var captionLang = ""
    @State private var selectedTopic = ""
    @State private var selectedCat: Int?
    @State private var videoData: Data?
    
//    @State private var whatsAppImage: String = "WhatsAppLogo"
//    @State private var twetterImage: String = "TwetterLogo"
//    @State private var facebookImage: String = "FacebookLogo"
//    @State private var instagramImage: String = "InstagramLogo"
    
//    @State private var isFacebook = false
    @State private var isFacebook = false
    @State private var isWhatsApp = false
    @State private var isTwetter = false
    @State private var isInstagram = false
    @GestureState private var tapGestureState = false
    @State private var extractedImage: UIImage?
    
    
    var catSelected: (Int) -> () = {val in}
    
    init(postModel : PostModel, renderUrl : URL?){
        _postModel = State(initialValue: postModel)
        _renderUrl = State(initialValue: renderUrl)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                //                NavigationView {
                Color(.white)
                    .ignoresSafeArea()
                
                VStack {
                    
                    NavigationLink(destination: HomePageView()
                        .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $homeView) {
                            EmptyView()
                        }
                    
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
                            
                            //                            Text("Hi everyone, in this video I will sing a song #song #music #love #beauty Thanks to @Vooconnect Video credit to ")
                            
                            //                            TextView(text: $text2).frame(numLines: 5)
                            //                            TextViewTwo(text: $description, didStartEditing: $didStartEditing, placeholder: $placeholder
                            //                            )
                            TextField(placeholder, text: $description)
                                .focused($focusedField, equals: .captionn)
                                .onChange(of: description){val in
                                    print("ON CHANGE DESCRIPTION: " + self.postModel.description)
                                    self.postModel.description = val
                                }
                                .onTapGesture {
                                    didStartEditing = true
                                }
                            
                            
                                .padding(.horizontal)
                                .padding(.top, 5)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 15)
                                        .strokeBorder((LinearGradient(colors: [
                                            Color("GradientOne"),
                                            Color("GradientTwo"),
                                        ], startPoint: .top, endPoint: .bottom)
                                        ), lineWidth: 2)
                                        .frame(height: 136)
                                }
                                .padding(.trailing)
                            
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
                        
                        
                        
                        // Hastag
                        HStack {
                            
                            HStack {
                                
                                Image("HastagLogo")
                                
                                Button {
                                    self.description = self.postModel.description + " #"
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
                                    self.description = self.postModel.description + " @"
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
                                
                                Image("VideoLogo")
                                
                                Button {
                                    
                                } label: {
                                    Text("Videos")
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
                                
                                Image("CategorieLogo")
                                
                                Button {
                                    
                                    
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
                        
                        
                        
                        RoundedRectangle(cornerRadius: 0)
                            .frame(height: 1)
                            .foregroundColor(Color("GrayThree"))
                            .padding(.top)
                        
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
                                    bottomSheetShown.toggle()
                                } label: {
                                    Text("Visible to Everyone")
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
                                    Text("Allow Duet")
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
                                    Text("Allow Stitch")
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
                        
                        HStack{
                            VStack {
                                if isWhatsApp {
                                    Circle()
                                        .strokeBorder(Color.black, lineWidth: 2)
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Circle()
                                                .foregroundColor(.white) // Add a contrasting background color
                                                .frame(width: 46, height: 46) // Slightly smaller than the main circle
                                                .overlay(
                                                    Image("WhatsAppLogo") // Replace "yourImageName" with the actual name of your image asset
                                                        .resizable()
                                                        .scaledToFit()
                                                )
                                        )
                                        .onTapGesture {
                                            isWhatsApp.toggle()
                                        }
                                } else {
                                    Image("WhatsAppLogo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .opacity(tapGestureState ? 0.5 : 1.0)
                                        .animation(.easeInOut)
                                        .onTapGesture {
                                            isWhatsApp.toggle()
                                        }
                                }
                            }
                            .frame(width: 50, height: 50)
                            .gesture(
                                TapGesture()
                                    .updating($tapGestureState) { value, state, _ in
                                        state = true
                                    }
                                    .onEnded { _ in
                                        isWhatsApp.toggle()
                                    }
                            )
                            VStack {
                                if isInstagram {
                                    Circle()
                                        .strokeBorder(Color.black, lineWidth: 2)
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Circle()
                                                .foregroundColor(.white) // Add a contrasting background color
                                                .frame(width: 46, height: 46) // Slightly smaller than the main circle
                                                .overlay(
                                                    Image("InstagramLogo") // Replace "yourImageName" with the actual name of your image asset
                                                        .resizable()
                                                        .scaledToFit()
                                                )
                                        )
                                        .onTapGesture {
                                            isInstagram.toggle()
                                        }
                                } else {
                                    Image("InstagramLogo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .opacity(tapGestureState ? 0.5 : 1.0)
                                        .animation(.easeInOut)
                                        .onTapGesture {
                                            isInstagram.toggle()
                                        }
                                }
                            }
                            .frame(width: 50, height: 50)
                            .gesture(
                                TapGesture()
                                    .updating($tapGestureState) { value, state, _ in
                                        state = true
                                    }
                                    .onEnded { _ in
                                        isInstagram.toggle()
                                    }
                            )
                            VStack {
                                if isFacebook {
                                    Circle()
                                        .strokeBorder(Color.black, lineWidth: 2)
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Circle()
                                                .foregroundColor(.white) // Add a contrasting background color
                                                .frame(width: 46, height: 46) // Slightly smaller than the main circle
                                                .overlay(
                                                    Image("FacebookLogo") // Replace "yourImageName" with the actual name of your image asset
                                                        .resizable()
                                                        .scaledToFit()
                                                )
                                        )
                                        .onTapGesture {
                                            isFacebook.toggle()
                                        }
                                } else {
                                    Image("FacebookLogo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .opacity(tapGestureState ? 0.5 : 1.0)
                                        .animation(.easeInOut)
                                        .onTapGesture {
                                            isFacebook.toggle()
                                        }
                                }
                            }
                            .frame(width: 50, height: 50)
                            .gesture(
                                TapGesture()
                                    .updating($tapGestureState) { value, state, _ in
                                        state = true
                                    }
                                    .onEnded { _ in
                                        isFacebook.toggle()
                                    }
                            )
                            VStack {
                                if isTwetter {
                                    Circle()
                                        .strokeBorder(Color.black, lineWidth: 2)
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Circle()
                                                .foregroundColor(.white) // Add a contrasting background color
                                                .frame(width: 46, height: 46) // Slightly smaller than the main circle
                                                .overlay(
                                                    Image("TwetterLogo") // Replace "yourImageName" with the actual name of your image asset
                                                        .resizable()
                                                        .scaledToFit()
                                                )
                                        )
                                        .onTapGesture {
                                            isTwetter.toggle()
                                        }
                                } else {
                                    Image("TwetterLogo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .opacity(tapGestureState ? 0.5 : 1.0)
                                        .animation(.easeInOut)
                                        .onTapGesture {
                                            isTwetter.toggle()
                                        }
                                }
                            }
                            .frame(width: 50, height: 50)
                            .gesture(
                                TapGesture()
                                    .updating($tapGestureState) { value, state, _ in
                                        state = true
                                    }
                                    .onEnded { _ in
                                        isTwetter.toggle()
                                    }
                            )
//                                .onTapGesture {
//                                    twetterImage =
//                                }
                            Spacer()
                        }
                        .padding(.top)
                        
                        HStack {
                            Button {
                                
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
                                        print("success=========")
                                        navigateToNextView = true
                                        if (self.saveToDevice){
                                            print("Should save to device: " + self.saveToDevice.description)
                                            if (self.autoCaption) {
                                                Task {
                                                    downloadAndSaveWithCaptionVideo()
                                                    loader = false
                                                }
                                            } else {
                                                Task{
                                                    downloadAncdSaveVideo()
                                                    loader = false
                                                }
                                            }
                                        }
                                        if (isFacebook == true){
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
                                        .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $navigateToNextView) {
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
                            
                        }
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
                    
                    GeometryReader { geometry in
                        BottomSheetView(
                            isOpen: self.$bottomSheetShown,
                            maxHeight: geometry.size.height * 0.5
                        ) {
                            CustomeSheetView(callback: {type in
                                self.postModel.visibility = type
                                print("type of visibility")
                                print(self.postModel.visibility)
                            })
                        }
                    }.edgesIgnoringSafeArea(.all)
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
    func shareToFacebook(videoURL: URL) {
        let activityItems: [Any] = [videoURL, self.postModel.description]
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
            uploadReels.uploadReels(imageUploadRequest: self.postModel.contentUrl!, paramName: "asset", fileName: renderUrl?.lastPathComponent ?? "default.\(postModel.isImageContent() ? "png" : "mp4")") { responsee, errorMessage in
                if(!responsee || errorMessage == nil)
                {
                    
                    print("error uploading video")
                    complitionHandler(false)
                    return
                }
                let uuid = UserDefaults.standard.string(forKey: "uuid") ?? ""
                let reelsSize = UserDefaults.standard.string(forKey: "reelSize") ?? ""
                let fileName = UserDefaults.standard.string(forKey: "imageName") ?? ""
                var tag: [String] = []
                self.postModel.tagPeople.forEach { peopleId in
                    tag.append(peopleId.uid)
                }
                let content = ContentDetail(name: fileName, size: reelsSize)
                print("caption and lan:  ", self.captionLang, self.autoCaption)
                let postRes = ReelsPostRequest(userUUID: uuid, title: "This is title", description: self.postModel.description, contentType: postModel.isImageContent() ? "image" : "video", category: self.selectedCat, musicTrack: postModel.songModel?.title, location: postModel.location.id, visibility: "public", musicURL: postModel.songModel?.preview, content: [content], allowComment: self.postModel.allowComments, allowDuet: self.postModel.allowDuet, allowStitch: self.postModel.allowStitch, subtitle_apply: self.autoCaption, subtitleLang: self.captionLang, tags: tag )
                uploadReels.uploadPost(post: postRes, complitionHandler: {response, error in
                    DispatchQueue.main.async {
                        if(responsee == true) {
                            print("Sucessss......")
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

//struct FinalVideoToPostView_Previews: PreviewProvider {
//    static var previews: some View {
//        FinalVideoToPostView(url: URL (string: "http://www.example.com/image.jpg")!)
//    }
//}
//getImageVideoBaseURL + "/marked" + fileName

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
