//
//  CreatorProfileComponents.swift
//  Vooconnect
//
//  Created by Online Developer on 08/03/2023.
//

import SwiftUI
import Swinject
import SDWebImageSwiftUI
import UniformTypeIdentifiers

enum CreatorProfilePagerType: CaseIterable{
    case post
    case lock
    case save
    case favorite
    
    var activeIcon: String{
        switch self {
        case .post:
            return "CategoryCP"
        case .lock:
            return "Lock Active"
        case .save:
            return "BookmarkActive"
        case .favorite:
            return "FavoriteActive"
        }
    }
    
    var notActiveIcon: String{
        switch self {
        case .post:
            return "CategoryCP Disabled"
        case .lock:
            return "Lock Disabled"
        case .save:
            return "BookmarkCP"
        case .favorite:
            return "HeartCP"
        }
    }
    
    var privateNotActiveIcon: String{
        switch self {
        case .save:
            return "BookmarkSlashEye"
        case .favorite:
            return "FavoriteSlashEye"
        default:
            return ""
        }
    }
    
    var privateActiveIcon: String{
        switch self {
        case .save:
            return "BookmarkSlashEyeEnable"
        case .favorite:
            return "FavoriteSlashEyeEnable"
        default:
            return ""
        }
    }
    
    static var activeProfileCases: [CreatorProfilePagerType]{
        [.post, .save, .favorite]
    }
}

struct CreatorPostView: View {
    var body: some View {
        WebImage(url: URL(string: "https://i0.wp.com/classicalguitarmagazine.com/wp-content/uploads/2020/10/Thu-Le-1-e1603561684425.jpg?fit=999%2C675&ssl=1")!)
            .resizable()
            .scaledToFill()
            .frame(width: (UIScreen.screenWidth/3) - 12, height: 200)
            .clipShape(Rectangle())
    }
}

struct CreatorStatesView: View{
    
    @Binding var showStatesView: Bool
    @StateObject var creatorProfileViewModel: CreatorProfileViewModel
    
    var body: some View{
        HStack(spacing: 0){
            if let stats = creatorProfileViewModel.userStats{
                CountView(count: stats.postsCount ?? 0, title: "Posts")
                Spacer()
                LineView()
                Spacer()
                CountView(count: stats.followersCount ?? 0, title: "Followers")
                    .onTapGesture {
                        showStatesView.toggle()
                    }
                Group{
                    Spacer()
                    LineView()
                    Spacer()
                    CountView(count: stats.followingsCount ?? 0, title: "Following")
                        .onTapGesture {
                            showStatesView.toggle()
                        }
                    Spacer()
                    LineView()
                    Spacer()
                    CountView(count: stats.likesCount ?? 0, title: "Likes")
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top)
    }
    
    func CountView(count: Int, title: String) -> some View{
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.urbanist(name: .urbanistBold, size: 24))
            Text(title)
                .font(.urbanist(name: .urbanistMedium, size: 14))
        }
    }
    
    func LineView() -> some View{
        Rectangle()
            .frame(width: 1, height: 53)
            .foregroundColor(Color.customBlack)
    }
}

struct BackButton: View{
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View{
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image("BackButton")
        }
    }
}

struct ButtonWithImage: View{
    var imageName: String
    var action: (()->())
    var body: some View{
        Button {
            action()
        } label: {
            Image(imageName)
                .resizable()
                .frame(width: 24, height: 24)
        }
    }
}

struct CreatorNavBarView: View{
    var appEventsManager = Container.default.resolver.resolve(AppEventsManager.self)!
    
    @StateObject var creatorProfileViewModel: CreatorProfileViewModel
    
    var body: some View{
        HStack {
            BackButton()
            
            if creatorProfileViewModel.isCurrentUserProfile{
                Button{
                    appEventsManager.presentBottomSheet.send(.switchAccount)
                } label: {
                    HStack(spacing: 0){
                        Spacer()
                        Text(creatorProfileViewModel.getFullName())
                            .font(.urbanist(name: .urbanistBold, size: 24))
                            .foregroundColor(.black)
                            .lineLimit(1)
                            .frame(width: 120)
                        Image("ArrowDownLogoM")
                            .padding(.leading, 10)
                        Spacer()
                    }
                }
            } else {
                Text(creatorProfileViewModel.getFullName())
                    .font(.urbanist(name: .urbanistBold, size: 24))
                    .foregroundColor(Color.customBlack)
                    .padding(.leading, 10)
            }
            
            Spacer()
            
            if creatorProfileViewModel.isCurrentUserProfile{
                ButtonWithImage(imageName: "AddUserMP"){
                    creatorProfileViewModel.navigateToFindFriends.toggle()
                }
            }
            
            ButtonWithImage(imageName: "callicon"){  }
            if !creatorProfileViewModel.isCurrentUserProfile{
                ButtonWithImage(imageName: "NotificationCP"){  }
            }
            
            ButtonWithImage(imageName: creatorProfileViewModel.isCurrentUserProfile ? "ShowSettings" : "MoreOptionLogoM"){
                withAnimation{
                    if creatorProfileViewModel.isCurrentUserProfile{
                        creatorProfileViewModel.navigateToProfileViewers.toggle()
                    }else{
                        appEventsManager.presentBottomSheet.send(.creatorMoreOptions(creatorProfileViewModel: creatorProfileViewModel))
                    }
                }
            }
        }
    }
}

struct CreatorHeaderView: View{
    
    @StateObject var creatorProfileViewModel: CreatorProfileViewModel
    @Binding var presentActionSheet: Bool
    
    var body: some View{
        ZStack(alignment: .bottomTrailing){
            ZStack{
                if creatorProfileViewModel.isCoverPhotoSelected{
                    Image(uiImage: creatorProfileViewModel.selectedCoverPhoto)
                        .resizable()
                        .scaledToFill()
                }else if let coverImage = creatorProfileViewModel.userDetail?.coverImage{
                    let url = NetworkConstants.ProductDefinition.BaseAPI.getImageVideoBaseURL.rawValue + coverImage
                    WebImage(url: URL(string: url)!)
                        .resizable()
                        .placeholder(Image("CoverPlaceholderCP"))
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .scaledToFill()
                }else{
                    Image("CoverPlaceholderCP")
                        .resizable()
                        .scaledToFill()
                }
            }
            .frame(height: 200)
            .clipped()
            .overlay(
                ProfileImage().offset(y: 33),
                alignment: .bottom
            )
            
            if creatorProfileViewModel.isCurrentUserProfile{
                ButtonWithImage(imageName: "EditSquareWhite"){
                    creatorProfileViewModel.selectedImageType = .cover
                    presentActionSheet.toggle()
                }
                .padding([.trailing, .bottom], 3)
            }
        }
    }
    
    func ProfileImage() -> some View {
        ZStack(alignment: .bottomTrailing){
            ZStack{
                if creatorProfileViewModel.isProfilePhotoSelected{
                    Image(uiImage: creatorProfileViewModel.selectedProfilePhoto)
                        .resizable()
                        .scaledToFill()
                }else if let profileImage = creatorProfileViewModel.userDetail?.profileImage{
                    let url = NetworkConstants.ProductDefinition.BaseAPI.getImageVideoBaseURL.rawValue + profileImage
                    WebImage(url: URL(string: url) ?? URL(string: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fcommons.wikimedia.org%2Fwiki%2FFile%3AProfile_avatar_placeholder_large.png")!)
                        .resizable()
                        .placeholder(Image("profileicon"))
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .scaledToFill()
                }else{
                    Image("profileicon")
                        .resizable()
                        .scaledToFill()
                }
            }
            .frame(width: 150, height: 150)
            .clipped()
            .cornerRadius(10)
            .background(
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.purpleYellowGradient,lineWidth: 10)
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white,lineWidth: 6)
                }
            )
            
            if creatorProfileViewModel.isCurrentUserProfile{
                ButtonWithImage(imageName: "EditSquareMP"){
                    creatorProfileViewModel.selectedImageType = .profile
                    presentActionSheet.toggle()
                }
                .padding([.trailing, .bottom], 3)
            }
        }
    }
}

struct CreatorNameView: View{
    @StateObject var creatorProfileViewModel: CreatorProfileViewModel
    var body: some View{
        ZStack(alignment: .topTrailing){
            VStack {
                HStack(spacing: 4){
                    Button{
                        UIPasteboard.general.setValue("@\(creatorProfileViewModel.userDetail?.username ?? "")",
                                    forPasteboardType: UTType.plainText.identifier)
                    } label: {
                        Text("@\(creatorProfileViewModel.userDetail?.username ?? "")")
                            .foregroundColor(.black)
                            .font(.urbanist(name: .urbanistBold, size: 20))
                    }
                    
                    if creatorProfileViewModel.isCurrentUserProfile{
                        Image("QrCodeCP")
                    }
                }
                
                Text("\(creatorProfileViewModel.userDetail?.bio ?? "No Bio")")
                    .font(.urbanist(name: .urbanistMedium, size: 14))
            }
        }
        .frame(height: 52)
        .padding(.top, 46)
    }
}

struct CreatorChatButton: View{
    let action: (()->())
    
    var body: some View{
        Button {
            action()
        } label: {
            Spacer()
            Image("ChatCP")
            Text("Message")
                .font(.urbanist(name: .urbanistBold))
                .foregroundStyle(Color.primaryGradient)
            Spacer()
        }
        .frame(height: 40)
        .overlay {
            RoundedRectangle(cornerRadius: 40)
                .strokeBorder(Color.primaryGradient, lineWidth: 2)
        }
        .cornerRadius(40)
    }
}

struct CreatorInterationView: View{
    var appEventsManager = Container.default.resolver.resolve(AppEventsManager.self)!
    @Binding var isCreaterTotalLikePopUpPresented: Bool
    @ObservedObject var creatorProfileViewModel: CreatorProfileViewModel
    
    var body: some View{
        let userDetail = creatorProfileViewModel.userDetail
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 0) {
                Spacer()
                PrimaryFillButton(title: "Follow", icon: "AddUserCP", isIconExist: true){ }
                    .frame(width: 135)
                PrimaryFillButton(title: "Subscribe", icon: "WorkCreator", isIconExist: true, gradient: Color.pinkGradient){
                    appEventsManager.presentBottomSheet.send(.subscriberView)
                }
                .padding(.leading, 12)
                .frame(width: 135)
                
                HStack(spacing: 2){
                    Spacer()
                    
                    if let _ = userDetail?.instagram{
                        ImageButton(imageName: "AutoLayoutHorizontalTwoCP"){ }
                    }
                    
                    Spacer(minLength: 0)
                    
                    if let facebookUserId = userDetail?.facebook{
                        ImageButton(imageName: "FacebookCP"){
                            let url  = URL(string: "https://facebook.com/\(facebookUserId)")
                            if UIApplication.shared.canOpenURL(url! as URL){
                                UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
                            }
                        }
                    }
                    
                    Spacer(minLength: 0)
                    
                    if let twitterUsername = userDetail?.twitter{
                        ImageButton(imageName: "TwitterCP"){
                            let url  = URL(string: "https://twitter.com/\(twitterUsername)")
                            if UIApplication.shared.canOpenURL(url! as URL){
                                UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
                            }
                        }
                    }
                    
                    Spacer(minLength: 0)
                    
                    ImageButton(imageName: "AutoLayoutHorizontalCP"){
                        isCreaterTotalLikePopUpPresented.toggle()
                    }
                    .padding(.leading, 3)
                    
                    Spacer()
                }
                Spacer()
            }
            .padding(.top)
        }
    }
    
    func ImageButton(imageName: String, action: @escaping (()->())) -> some View{
        Button {
            action()
        } label: {
            Image(imageName)
                .frame(width: 40, height: 40)
        }
    }
}

struct CreatorTotalLikePopUp: View {
    
    @Binding var show: Bool
    @ObservedObject var creatorProfileViewModel: CreatorProfileViewModel
    
    var body: some View {
        let username = creatorProfileViewModel.userDetail?.username ?? ""
        let likesCount = creatorProfileViewModel.userStats?.likesCount ?? 0
        ZStack {
            
            Color
                .black
                .opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    show.toggle()
                }
            
            VStack {
                Image("GroupCP")
                    .padding(.top, 40)
                Text("\(likesCount) Total Likes")
                    .font(.urbanist(name: .urbanistBold, size: 24))
                    .foregroundStyle(Color.primaryGradient)
                    .padding(.top)
                    .padding(.bottom, 10)
                
                Text("\(username) received a total of \(likesCount) likes from all videos.")
                    .font(.urbanist(name: .urbanistRegular))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.customBlack)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
                
                OkButton()
            }
            .background(.white)
            .cornerRadius(40)
            .padding(.horizontal, 40)
        }
    }
    
    func OkButton() -> some View{
        Button {
            show.toggle()
        } label: {
            HStack {
                Spacer()
                Text("OK")
                    .font(.urbanist(name: .urbanistBold))
                    .foregroundColor(.white)
                    .frame(height: 58)
                Spacer()
                
            }
            .customGradient()
            .cornerRadius(30)
        }
        .padding(.horizontal)
        .padding(.bottom, 30)
    }
}

struct CreatorProfilePagerView: View{
    
    @StateObject var creatorProfileViewModel: CreatorProfileViewModel
    
    var body: some View{
        HStack(spacing: 0){
            
            if creatorProfileViewModel.isCurrentUserProfile{
                ForEach(CreatorProfilePagerType.allCases, id:\.self){ type in
                    PagerCellView(type: type, isSelected: creatorProfileViewModel.selectedPagerType == type){
                        withAnimation{
                            creatorProfileViewModel.selectedPagerType = type
                        }
                    }
                }
            } else{
                ForEach(CreatorProfilePagerType.activeProfileCases, id:\.self){ type in
                    PagerCellView(type: type, isSelected: creatorProfileViewModel.selectedPagerType == type){
                        withAnimation{
                            creatorProfileViewModel.selectedPagerType = type
                        }
                    }
                }
            }
        }
    }
    
    func PagerCellView(type: CreatorProfilePagerType, isSelected: Bool, action: @escaping (()->())) -> some View{
        Button{
            action()
        } label: {
            VStack {
                Image(icon(type: type, isSelected: isSelected))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                Capsule()
                    .fill(isSelected ? Color.primaryGradient : Color.grayGradient)
                    .frame(height: isSelected ? 4 : 2)
            }
        }
    }
    
    /// Get icon for pager tabs
    func icon(type: CreatorProfilePagerType, isSelected: Bool) -> String{
        if creatorProfileViewModel.isCurrentUserProfile{
            if type == .favorite || type == .save{
                if isSelected{
                    return type.privateActiveIcon
                }
                return type.privateNotActiveIcon
            } else{
                if isSelected{
                    return type.activeIcon
                }else{
                    return type.notActiveIcon
                }
            }
        } else{
            if isSelected{
                return type.activeIcon
            }else{
                return type.notActiveIcon
            }
        }
    }
}
