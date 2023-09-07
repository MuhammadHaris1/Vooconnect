//
//  MyProfileView.swift
//  Vooconnect
//
//  Created by Vooconnect on 19/12/22.
//

import SwiftUI

struct MyProfileView: View {
    
    @State var selectedImage: UIImage = UIImage(named: "profileicon")!
    @State var showImagePicker: Bool = false
    @State var showActionSheet: Bool = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State var actionSheetOption: ActionsheetOptions = .myProfile// Image shown on this screen
    
    @State var presentSwitchAccountSheet = false
    @State var navigateToFindFriends = false
    
    enum ActionsheetOptions {
        case myProfile
    }
    
    @State private var post: Bool = true
    @State private var privacy: Bool = false
    @State private var saved: Bool = false
    @State private var favourite: Bool = false
    
    @State private var settingView: Bool = false
    
    var body: some View {
//        NavigationView {
            ZStack {
                Color(.white)
                    .ignoresSafeArea()
                
                VStack {
                    
                    NavigationLink(destination: SwiftUISettingView()
                        .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $settingView) {
                            EmptyView() // genderVM.genderDataModel.navigate
                        }
                    
                    // Navigation Bar
                    HStack {
                        
                        Button {
                            navigateToFindFriends.toggle()
                        } label: {
                            Image("AddUserMP")
                        }
                        
                        Spacer()
                        
                        Button{
                            presentSwitchAccountSheet.toggle()
                        } label: {
                            Text("Andrew...")
                                .font(.custom("Urbanist-Bold", size: 24))
                                .foregroundColor(Color(#colorLiteral(red: 0.1726317704, green: 0.1726317704, blue: 0.1726317704, alpha: 1)))
                                .padding(.leading, 10)
                            Image("ArrowDownLogoM")
                        }
                        
                        Spacer()
                        
                        Button {
                            settingView.toggle()
                        } label: {
                            Image("SettingMP")
                        }
                        
                    }
                    .padding(.horizontal)
                    
                    ScrollView(showsIndicators: false) {
                        
                        // Profile Image
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .cornerRadius(10)
                            .clipped()
                            .overlay(
                                Image("EditSquareMP") // EditSquareMP  EditSquare
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                
                                    .onTapGesture {
                                        actionSheetOption = .myProfile
                                        showActionSheet.toggle()
                                    }
                                , alignment: .bottomTrailing
                            )
                            .padding(.top)
                            .actionSheet(isPresented: $showActionSheet) {
                                getActionSheet()
                            }
                        
                            .sheet(isPresented: $showImagePicker) {
                                ImagePicker(imageSelected: $selectedImage, sourceType: $sourceType)
                                
                            }
                        
                        VStack {
                            Text("@andrew_aisnley")
                                .font(.custom("Urbanist-Bold", size: 20))
                            
                            Text("Designer & Videographer")
                                .font(.custom("Urbanist-Medium", size: 14))
                        }
//                        .padding(.horizontal)
                        Button {
                            
                        } label: {
                            HStack {
                                Spacer()
                                Image("ChatMP")
                                Text("Edit Profile")
                                    .foregroundColor(Color(#colorLiteral(red: 1, green: 0.4038823843, blue: 0.4780470729, alpha: 1)))
                                Spacer()
                            }
                        }
                        .frame(height: 45)
                        .overlay {
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color(#colorLiteral(red: 1, green: 0.4038823843, blue: 0.4780470729, alpha: 1)), lineWidth: 2)
                        }
                        .padding(.horizontal)
                        // All Button to
                        HStack {
                            
                            VStack {
                                
                                Button {
                                    
                                    post = true
                                    privacy = false
                                    saved = false
                                    favourite = false
                                    
                                } label: {
                                    Image("ChatMP")
                                }
                                
                                ZStack {
                                    if post {
                                        Capsule()
                                            .fill((
                                                LinearGradient(colors: [
                                                    Color("buttionGradientTwo"),
                                                    Color("buttionGradientOne"),
                                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                            ))
                                            .frame(height: 4)
                                    } else {
                                        Capsule()
                                            .fill((
                                                LinearGradient(colors: [
                                                    Color("grayOne"),
                                                    Color("grayOne"),
                                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                            ))
                                        //                                        .padding(.leading, -5)
                                            .padding(.trailing, -9)
                                            .frame(height: 2)
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            VStack {
                                Button {
                                    post = false
                                    privacy = true
                                    saved = false
                                    favourite = false
                                } label: {
                                    Image("ChatMP")
                                }
                                
                                ZStack {
                                    if privacy {
                                        Capsule()
                                            .fill((
                                                LinearGradient(colors: [
                                                    Color("buttionGradientTwo"),
                                                    Color("buttionGradientOne"),
                                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                            ))
                                            .frame(height: 4)
                                    } else {
                                        Capsule()
                                            .fill((
                                                LinearGradient(colors: [
                                                    Color("grayOne"),
                                                    Color("grayOne"),
                                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                            ))
                                            .padding(.leading, -8)
                                            .padding(.trailing, -9)
                                            .frame(height: 2)
                                    }
                                }
                            }
                            Spacer()
                            
                            VStack {
                                Button {
                                    post = false
                                    privacy = false
                                    saved = true
                                    favourite = false
                                } label: {
                                    Image("ChatMP")
                                }
                                
                                ZStack {
                                    if saved {
                                        Capsule()
                                            .fill((
                                                LinearGradient(colors: [
                                                    Color("buttionGradientTwo"),
                                                    Color("buttionGradientOne"),
                                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                            ))
                                            .frame(height: 4)
                                    } else {
                                        Capsule()
                                            .fill((
                                                LinearGradient(colors: [
                                                    Color("grayOne"),
                                                    Color("grayOne"),
                                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                            ))
                                            .padding(.leading, -8)
                                            .padding(.trailing, -9)
                                            .frame(height: 2)
                                    }
                                }
                            }
                            Spacer()
                            
                            VStack {
                                Button {
                                    post = false
                                    privacy = false
                                    saved = false
                                    favourite = true
                                } label: {
                                    Image("ChatMP")
                                }
                                
                                ZStack {
                                    if favourite {
                                        Capsule()
                                            .fill((
                                                LinearGradient(colors: [
                                                    Color("buttionGradientTwo"),
                                                    Color("buttionGradientOne"),
                                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                            ))
                                            .frame(height: 4)
                                    } else {
                                        Capsule()
                                            .fill((
                                                LinearGradient(colors: [
                                                    Color("grayOne"),
                                                    Color("grayOne"),
                                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                            ))
                                            .padding(.leading, -8)
                                            .padding(.trailing, -9)
                                            .frame(height: 2)
                                    }
                                }
                            }
                            
                        }
                        .padding(.horizontal)
                        
                        LazyVGrid(columns: gridLayoutMP, alignment: .center, spacing: columnSpacingMP, pinnedViews: []) {
                            Section()
                            {
                                ForEach(0..<10) { people in
                                    MyPostView()
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                    }  // Scroll View
//                    Spacer()
                    
                }
                
            }
            .sheet(isPresented: $presentSwitchAccountSheet){
                SwitchAccountView()
//                    .presentationDetents([.medium, .large])
            }
            .navigate(to: FindFriendsView(), when: $navigateToFindFriends)
        
//        } // Navigation
        
    }
    
    private func getActionSheet() -> ActionSheet {
        
        let chooseFromGallery: ActionSheet.Button = .default(Text("Choose from Gallery")) {
            print("Choose from Gallery")
            sourceType = UIImagePickerController.SourceType.photoLibrary
            showImagePicker.toggle()
        }
        
        let capturePhoto: ActionSheet.Button = .default(Text("Capture Photo")) {
            print("Capture Photo")
            sourceType = UIImagePickerController.SourceType.camera
            showImagePicker.toggle()
        }
        let cancleButton: ActionSheet.Button = .cancel()
        let title = Text("what woud you like to do")
        
        switch actionSheetOption {
        case .myProfile:
            return ActionSheet(title: title,
                               message: nil,
                               buttons: [chooseFromGallery, capturePhoto, cancleButton])
        }
    }
}

struct MyProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileView()
    }
}
