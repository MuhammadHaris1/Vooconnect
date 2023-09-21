//
//  SoundsView.swift
//  Vooconnect
//
//  Created by Vooconnect on 19/12/22.
//

import SwiftUI
import SDWebImageSwiftUI
import Swinject

struct CreatorProfileView: View {
    
    private var appEventsManager = Container.default.resolver.resolve(AppEventsManager.self)!
    @StateObject var creatorProfileViewModel: CreatorProfileViewModel
    
    @State private var isCreaterTotalLikePopUpPresented = false
    @State private var creatorProfilePagerType: CreatorProfilePagerType = .post
    @State private var presentActionSheet = false
    @State private var presentImagePicker = false
    @State private var presentLoginView = false
    @State private var presentHomeView = false
    
//    @State var uuid = ""
    
    let columnSpacingCP: CGFloat = 1
    let rowSpacingCP: CGFloat = 1.68
    var gridLayoutCP: [GridItem] {
        return Array(repeating: GridItem(.flexible(), spacing: rowSpacingCP), count: 3)
    }
    
    public init(
        id: String? = nil
    ) {
        _creatorProfileViewModel = StateObject(
            wrappedValue: CreatorProfileViewModel(id: id)
        )
    }
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            
            VStack {
                
                CreatorNavBarView(creatorProfileViewModel: creatorProfileViewModel)
                
                ScrollView(showsIndicators: false) {
                    CreatorHeaderView(creatorProfileViewModel: creatorProfileViewModel, presentActionSheet: $presentActionSheet)
                    
                    CreatorNameView(creatorProfileViewModel: creatorProfileViewModel)
                    
                    CreatorStatesView(showStatesView: $creatorProfileViewModel.navigateToCreatorSearchView, creatorProfileViewModel: creatorProfileViewModel)
                    
                    if creatorProfileViewModel.isCurrentUserProfile{
                        HStack{
                            Spacer()
                            ButtonWithBorder(title: "Edit Profile", icon: "EditSquare"){
                                creatorProfileViewModel.navigateToEditProfile.toggle()
                            }
                            Spacer()
                        }
                        .padding(.vertical, 24)
                    } else{
                        CreatorInterationView(isCreaterTotalLikePopUpPresented: $isCreaterTotalLikePopUpPresented, creatorProfileViewModel: creatorProfileViewModel)
                    }
                    
                    CreatorProfilePagerView(creatorProfileViewModel: creatorProfileViewModel)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                    
                    switch creatorProfileViewModel.selectedPagerType{
                    case .post:
                        if creatorProfileViewModel.userPosts.count > 0{
                            LazyVGrid(columns: gridLayoutCP, alignment: .center, spacing: columnSpacingCP, pinnedViews: []) {
                                Section()
                                {
                                    ForEach(creatorProfileViewModel.userPosts, id:\.self) { post in
                                        CreatorPostView()
                                    }
                                }
                            }
                        }else{
                            Text("No User Posts")
                        }
                    case .lock:
                        if creatorProfileViewModel.privatePosts.count > 0{
                            LazyVGrid(columns: gridLayoutCP, alignment: .center, spacing: columnSpacingCP, pinnedViews: []) {
                                Section()
                                {
                                    ForEach(creatorProfileViewModel.privatePosts, id:\.self) { post in
                                        CreatorPostView()
                                    }
                                }
                            }
                        }else{
                            Text("No Private Posts")
                        }
                    case .save:
                        if creatorProfileViewModel.bookmarkedPosts.count > 0{
                            LazyVGrid(columns: gridLayoutCP, alignment: .center, spacing: columnSpacingCP, pinnedViews: []) {
                                Section()
                                {
                                    ForEach(creatorProfileViewModel.bookmarkedPosts, id:\.self) { post in
                                        CreatorPostView()
                                    }
                                }
                            }
                        }else{
                            Text("No Bookmarked Posts")
                        }
                    case .favorite:
                        if creatorProfileViewModel.favouritePosts.count > 0{
                            LazyVGrid(columns: gridLayoutCP, alignment: .center, spacing: columnSpacingCP, pinnedViews: []) {
                                Section()
                                {
                                    ForEach(creatorProfileViewModel.favouritePosts, id:\.self) { post in
                                        CreatorPostView()
                                    }
                                }
                            }
                        }else{
                            Text("No Favorite Posts")
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            if isCreaterTotalLikePopUpPresented{
                CreatorTotalLikePopUp(show: $isCreaterTotalLikePopUpPresented, creatorProfileViewModel: creatorProfileViewModel)
            }
            
            if creatorProfileViewModel.isUpdating{
                FullScreenProgressView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigate(
            to: CreatorSearchView(
                id: creatorProfileViewModel.userId,
                userName: creatorProfileViewModel.getFullName(),
                latitude: creatorProfileViewModel.getCoordinates().0,
                longitude: creatorProfileViewModel.getCoordinates().1
            ),
            when: $creatorProfileViewModel.navigateToCreatorSearchView
        )
        .sheet(isPresented: $creatorProfileViewModel.shareProfile) {
            ShareSheet(
                activityItems: [
                    ShareItemURLSource(
                        title: "Hi, I'm on Vooconnect",
                        desc: "Hey its \(creatorProfileViewModel.userDetail?.username ?? "") on Vooconnect follow me and watch my videos on the app.",
                        url: URL(string: "https://vooconnect/\(creatorProfileViewModel.userDetail?.username ?? "")")!
                    ),
                    URL(
                        string: "https://vooconnect/\(creatorProfileViewModel.userDetail?.username ?? "")"
                    )!
                ]
            )
        }
        .actionSheet(isPresented: $presentActionSheet, content: {
            getActionSheet()
        })
        .sheet(isPresented: $presentImagePicker) {
            if creatorProfileViewModel.selectedImageType == .profile{
                ImagePicker(imageSelected: $creatorProfileViewModel.selectedProfilePhoto, sourceType: $creatorProfileViewModel.sourceType){
                    creatorProfileViewModel.isProfilePhotoSelected = true
                    creatorProfileViewModel.updateUserProfile()
                }
            }else{
                ImagePicker(imageSelected: $creatorProfileViewModel.selectedCoverPhoto, sourceType: $creatorProfileViewModel.sourceType){
                    creatorProfileViewModel.isCoverPhotoSelected = true
                    creatorProfileViewModel.updateUserProfile()
                }
            }
            
        }
        .fullScreenCover(isPresented: $presentLoginView){
            ConnectWithEmailAndPhoneView(isFromSwitchProfile: .constant(true))
        }
        .fullScreenCover(isPresented: $presentHomeView){
            HomePageView()
        }
        .navigate(to: FindFriendsView(), when: $creatorProfileViewModel.navigateToFindFriends)
        .navigate(to: EditProfileView(), when: $creatorProfileViewModel.navigateToEditProfile)
        .alert(isPresented: $creatorProfileViewModel.isPresentAlert) {
            Alert(title: Text("Error"), message: Text(creatorProfileViewModel.errorString), dismissButton: .default(Text("Got it!")))
        }
        .onReceive(appEventsManager.presentLoginView) {
            if $0{
                presentLoginView = true
            }
        }
        .onReceive(appEventsManager.restartApp) {
            if $0{
                presentHomeView = true
            }
        }
        .navigate(
            to: CreatorProfileView(id: creatorProfileViewModel.selectedUserId),
            when: $creatorProfileViewModel.navigateToCreatorProfileView
        )
        .navigate(
            to: ProfileViewersView(),
            when: $creatorProfileViewModel.navigateToProfileViewers
        )
    }
    
    private func getActionSheet() -> ActionSheet {
        
        let chooseFromGallery: ActionSheet.Button = .default(Text("Choose from Gallery")) {
            creatorProfileViewModel.sourceType = .photoLibrary
            presentImagePicker.toggle()
        }
        
        let capturePhoto: ActionSheet.Button = .default(Text("Capture Photo")) {
            creatorProfileViewModel.sourceType = .camera
            presentImagePicker.toggle()
        }
        let cancleButton: ActionSheet.Button = .cancel()
        let title = Text("what would you like to do")
        
        return ActionSheet(
            title: title,
            message: nil,
            buttons: [chooseFromGallery, capturePhoto, cancleButton]
        )
    }
}
