////
////  HomePageView.swift
////  Vooconnect
////
////  Created by Vooconnect on 02/11/22.
////
//
//import SwiftUI
//
//
//struct HomePageView: View {
//
//    @StateObject private var currentReactives = SetReactiveMethods()
//
//    @State var currentTab: Int = 0
//    @State var show: Bool = false
//
//    @State var topBar: Bool = true
//
//    @State var cameraView: Bool = false
//    @State var live: Bool = false
//    @State var finalVideoPost: Bool = false
//    @State var myProfileView: Bool = false //
//    @State var creatorProfileView: Bool = false
//    @State var musicView: Bool = false
//    @State var liveViewer: Bool = false
//
//    @State private var chatView: Bool = false
//    @State private var searchView: Bool = false
//
//    @State var showPopUp: Bool = false
//
//    @State private var bottomSheetBlock = false
//    @State private var bottomSheetReport = false
//
////    @State private var cameraView: Bool = false
//
////    @ObservedObject private var reelsVM: ReelsViewModel = ReelsViewModel()
//    @StateObject private var likeVM: ReelsLikeViewModel = ReelsLikeViewModel()
//
//    @State private var blockMassage: String = "You want to block this video"
//    @State private var reportMassage: String = "You want to report this video"
////    @State var commentText: String = ""
//
//    @StateObject var locationManager = LocationManager()
//
//    @State private var commentSheet: Bool = false
//    @State private var commentReplySheet: Bool = false
//    @State private var commentId: Int = 0
//    @State private var reply_to_reply: String = ""
//    @StateObject private var reelsVM = ReelsViewModel()
//    @State var postedBy: String = ""
//    @State var reelId: Int = 0
//
//    var body: some View {
//
//        ZStack{
//            NavigationView {
//
//                ZStack {
//
//                    Color(.white)
//                        .ignoresSafeArea()
//    //                    .onTapGesture(count: 2) {
//    //                        print("Double tapped!")
//    //                    }
//
//                    NavigationLink(destination: LiveStreamingView()  //SearchView
//                        .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $live) {
//                            EmptyView()
//                        }
//
//                    NavigationLink(destination: LiveViewersView()  //SearchView
//                        .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $liveViewer) {
//                            EmptyView()
//                        }
//
//                    VStack {
//
//                        NavigationLink(destination: ChatView()
//                            .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $chatView) {
//                                EmptyView()
//                            }
//
//                        NavigationLink(destination: CustomeCameraHome()   // CustomeCameraView()  CustomeCameraHome()
//                            .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $cameraView) {
//                                EmptyView()
//                            }
//
//                        NavigationLink(destination: SearchView()  //SearchView
//                            .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $searchView) {
//                                EmptyView()
//                            }
//
//                        NavigationLink(destination: CreatorProfileView()  //SearchView
//                            .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $creatorProfileView) {
//                                EmptyView()
//                            }
//
//                        NavigationLink(destination: MusicView(reelId: $reelId, uuid: postedBy, cameraView: $cameraView)  //SearchView
//                            .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $musicView) {
//                                EmptyView()
//                            }
//
//
//                        NavigationLink(destination: ReelsReportView()  //ReelsRportView
//                            .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $bottomSheetReport) {
//                                EmptyView()
//                            }
//
//
////                        Rectangle()
////                            .frame(maxWidth: .infinity)
////                            .frame(height: 2.5)
////                            .foregroundColor(.yellow)
////
////
////                            .alert(isPresented: $bottomSheetBlock) {
////                                Alert(
////                                    title: Text("Are you sure want to report this video?"),
////                                    message: Text(""),
////                                    primaryButton: .destructive(Text("Yes")) {
////                                        likeVM.blockPostApi()
////
////                                    },
////                                    secondaryButton: .cancel()
////                                )
////                            }
//
//
//                        if topBar {
//                            HStack {
//                                Button {
//                                    self.show.toggle()
//
//                                    print("Show Popup")
//
//    //                                showPopUp.toggle()
//        //                            status.bool.toggle()
//        //                            status.bool = true
//
//                                } label: {
//                                    Image("plusIcon")
//                                        .resizable()
//                                        .scaledToFill()
//                                        .frame(width: 32, height: 32)
//                                }
//
//                                Spacer()
//                                Spacer()
//
//                                Image("vooconnectLogoTwo")
//                                    .resizable()
//                                    .frame(width: 194, height: 48)
//                                    .offset(y: 5)
//                                Spacer()
//
//                                Button {
//                                    searchView.toggle()
//                                } label: {
//                                    Image("Search")
//                                        .resizable()
//                                        .scaledToFill()
//                                        .frame(width: 27, height: 27)
//                                }
//
//                                Button {
//                                    chatView.toggle()
//                                } label: {
//                                    Image("callicon")
//                                        .resizable()
//                                        .scaledToFill()
//                                        .frame(width: 32, height: 32)
//                                }
//
//                            }
//                            .padding(.horizontal, 25)
//                            .padding(.top, -10)
//                            .padding(.bottom, -8)
//                        }
//
//                        ZStack(alignment: .top) {
//                            TabView(selection: self.$currentTab) {
//
//                                ReelsView(currentReel: reelsVM.allReels.first?.postID ?? 0, topBar: $topBar, bool:  $show,
//                                          cameraView: $cameraView, live: $live, bottomSheetBlock: $bottomSheetBlock, bottomSheetReport:
//                                            $bottomSheetReport, myProfileView: $myProfileView,  creatorProfileView: $creatorProfileView,
//                                          musicView: $musicView, liveViewer: $liveViewer, commentSheet: $commentSheet, commentReplySheet:
//                                            $commentReplySheet, postedBy: $postedBy, selectedReelId: $reelId).tag(0)
//
////                                    .padding(.vertical, -16)
//
//                                NotificationsView().tag(1)
//
//                                SettingView().tag(2)
//
//                            }
//                            .tabViewStyle(.page(indexDisplayMode: .never))
//                            .edgesIgnoringSafeArea(.all)
//
////                            .alert(isPresented: $bottomSheetReport) {
////                                Alert(
////                                    title: Text("Are you sure want to block this user?"),
////                                    message: Text(""),
////                                    primaryButton: .destructive(Text("Yes")) {
////                                        likeVM.abuseReportPostApi()
////                                    },
////                                    secondaryButton: .cancel()
////                                )
////                            }
//
//                        }
//
//                        TabBarViewTwo(currentTab: self.$currentTab)
//
//                        Spacer()
//
//                    }
//
//                    .blurredSheet(.init(.white), show: $commentSheet) {
//
//                    } content: {
//                        if #available(iOS 16.0, *) {
//                            CommentSheet(commentReplySheet: $commentReplySheet,commentSheet: $commentSheet, commentId: $commentId, reply_to_reply: $reply_to_reply)
//                                .presentationDetents([.large,.medium,.height(500)])
//                        } else {
//                            // Fallback on earlier versions
//                        }
//                    }
//
//                    .blurredSheet(.init(.white), show: $commentReplySheet) {
//
//                    } content: {
//                        if #available(iOS 16.0, *) {
//                            CommentReplySheet(commentId: $commentId, reply_to_reply: $reply_to_reply, commentReplySheet: $commentReplySheet)
//                                .presentationDetents([.medium,.height(180)])
//                        } else {
//                            // Fallback on earlier versions
//                        }
//                    }
//                }
//                .navigationBarHidden(true)
//            }
//            .navigationViewStyle(.stack)
//
//            BottomSheet(isShowing: $currentReactives.isPresentBottomSheet, content: currentReactives.bottomSheetType.view())
//        }
//    }
//}
//
//struct HomePageView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomePageView()
//    }
//}
//
//struct TabBarViewTwo: View {
//
//    @Binding var currentTab: Int
//    @Namespace var namespace
//
//    var tabBarOptions: [String] = ["Home", "Notification", "AdditionalIcons"]
//    var body: some View {
//
//            HStack(spacing: 10) {
//                Spacer()
//                ForEach(Array(zip(self.tabBarOptions.indices,
//                                  self.tabBarOptions)), id: \.0, content: {
//                    index, name in
//                    TabBarItemTwo(currentTab: self.$currentTab,
//                               namespace: namespace.self,
//                               tabBarItemName: name,
//                               tab: index)
//
//                    Spacer()
//
//                })
//            }
//            .padding(.horizontal, -90)
//
//    }
//}
//
//
//
//struct TabBarItemTwo: View {
//    @Binding var currentTab: Int
//    let namespace: Namespace.ID
//
//    var tabBarItemName: String
//    var tab: Int
//
//    var body: some View {
//        Button {
//            self.currentTab = tab
//        } label: {
//            ZStack {
////                Spacer()
//                Image(tabBarItemName)
//                    .resizable()
//                    .frame(width: 30, height: 30)
//                if currentTab == tab && currentTab == 0 {
//                    GifImage("homeW-3-2") // homeW
//                        .frame(width: 40, height: 40)
//
//                } else if currentTab == tab && currentTab == 1 {
//                    GifImage("notificationW")
//                        .frame(width: 40, height: 40)
//
//                } else if currentTab == tab && currentTab == 2 {
//                    GifImage("settingsW2-2")
//                        .frame(width: 40, height: 40)
//                } else {
//
//                }
//
//
//            }
//            .animation(.spring(), value: self.currentTab)
//            .padding(.bottom, -10)
//        }
//        .buttonStyle(.plain)
//    }
//}
//
//below old code

//
//  HomePageView.swift
//  Vooconnect
//
//  Created by Vooconnect on 02/11/22.
//

import SwiftUI


struct HomePageView: View {
    
    @State var currentTab: Int = 0
    @State var show: Bool = false
    
    @State var topBar: Bool = true
    
    @State var cameraView: Bool = false
    @State var live: Bool = false
    @State var finalVideoPost: Bool = false
    @State var myProfileView: Bool = false //
    @State var creatorProfileView: Bool = false
    @State var musicView: Bool = false
    @State var liveViewer: Bool = false
    
    @State private var chatView: Bool = false
    @State private var searchView: Bool = false
    
    @State var showPopUp: Bool = false
    
    @State private var bottomSheetBlock = false
    @State private var bottomSheetReport = false
    
    //    @State private var cameraView: Bool = false
    
    //    @ObservedObject private var reelsVM: ReelsViewModel = ReelsViewModel()
    @StateObject private var likeVM: ReelsLikeViewModel = ReelsLikeViewModel()
    
    @State private var blockMassage: String = "You want to block this video"
    @State private var reportMassage: String = "You want to report this video"
    
    @State private var commentSheet: Bool = false
    @State private var commentReplySheet: Bool = false
    @State private var commentId: Int = 0
    @State private var reply_to_reply: String = ""
    @StateObject private var reelsVM = ReelsViewModel()
    @State var postedBy: String = ""
    @State var reelId: Int = 0
    //    @State var commentText: String = ""
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                Color(.white)
                    .ignoresSafeArea()
//                    .onTapGesture(count: 2) {
//                        print("Double tapped!")
//                    }
                
                NavigationLink(destination: LiveStreamingView()  //SearchView
                    .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $live) {
                        EmptyView()
                    }
                
                NavigationLink(destination: LiveViewersView()  //SearchView
                    .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $liveViewer) {
                        EmptyView()
                    }
                
                VStack {
                    
                    VStack {
                        NavigationLink(destination: ChatView()
                            .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $chatView) {
                                EmptyView()
                            }
                        
                        NavigationLink(destination: CustomeCameraHome()   // CustomeCameraView()  CustomeCameraHome()
                            .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $cameraView) {
                                EmptyView()
                            }
                        
                        NavigationLink(destination: MyProfileView()
                            .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $myProfileView) {
                                EmptyView()
                            }
                        
                        NavigationLink(destination: SearchView()  //SearchView
                            .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $searchView) {
                                EmptyView()
                            }
                        //in last code uuid was in creator profile view
                        NavigationLink(destination: CreatorProfileView()  //SearchView
                            .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $creatorProfileView) {
                                EmptyView()
                            }
                        
                        NavigationLink(destination: MusicView(reelId: $reelId, uuid: postedBy, cameraView: $cameraView)  //SearchView
                            .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $musicView) {
                                EmptyView()
                            }
                        
                        
                        NavigationLink(destination: ReelsReportView()  //ReelsRportView
                            .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $bottomSheetReport) {
                                EmptyView()
                            }
                        
//                        NavigationLink(destination: BlockPostViewSheet(massage: $blockMassage, dismis:  $bottomSheetBlock)  //BlocView
//                            .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $bottomSheetBlock) {
//                                EmptyView()
//                            }
                        
                
                    }
                    
                    
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .frame(height: 2.5)
                        .foregroundColor(Color.gray.opacity(0.1))
                    
                    
                    //                        .alert(isPresented: $bottomSheetReport) {
                    //                            Alert(
                    //                                title: Text("Are you sure want to report this video?"),
                    //                                message: Text(""),
                    //                                primaryButton: .destructive(Text("Yes")) {
                    //                                    bottomSheetReport.toggle()
                    ////                                    likeVM.abuseReportPostApi()
                    //                                },
                    //                                secondaryButton: .cancel()
                    //                            )
                    //                        }
                    
                    
                    if topBar {
                        HStack {
                            Button {
                                show.toggle()
                                
                                print("Show Popup")
                                print(show)
                                
                                //                                showPopUp.toggle()
                                //                            status.bool.toggle()
                                //                            status.bool = true
                                
                            } label: {
                                Image("plusIcon")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 32, height: 32)
                            }
                            
                            Spacer()
                            Spacer()
                            
                            
                            Image("vooconnectLogoTwo")
                                .resizable()
                                .frame(width: 194, height: 48)
                                .offset(y: 5)
                            
                            Spacer()
                            
                            Button {
                                searchView.toggle()
                            } label: {
                                Image("Search")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 27, height: 27)
                            }
                            
                            Button {
                                chatView.toggle()
                            } label: {
                                Image("callicon")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 32, height: 32)
                            }
                            
                        }
                        .padding(.horizontal, 25)
                        .padding(.top, -10)
                        .padding(.bottom, -8)
                        
//                        HStack {
//                            if self.show {
//                                VStack {
//                                    Diamond()
//                                        .frame(width: 60, height: 40)
//                                        .padding(.bottom, -30)
//                                        .padding(.leading, -50)
//                                        .foregroundColor(.white)
//
//                                    PopOverTwo(show: $show, camera: $cameraView, live: $live)
//                                        .background(Color.white)
//                                        .cornerRadius(15)
//                                }
//                            }
////                            Spacer()
//                        }
//                        .frame(maxHeight: .infinity, alignment: .top)
//                        .padding(.top, 5)
//                        .padding(.leading, 5)
                    }
                    
                    ZStack(alignment: .top) {
                        TabView(selection: self.$currentTab) {
                            
                            ReelsView(currentReel: reelsVM.allReels.first?.postID ?? 0, topBar: $topBar,
                                      cameraView: $cameraView, live: $live, bottomSheetBlock: $bottomSheetBlock, bottomSheetReport:
                                        $bottomSheetReport, myProfileView: $myProfileView,  creatorProfileView: $creatorProfileView,
                                      musicView: $musicView, liveViewer: $liveViewer, commentSheet: $commentSheet, commentReplySheet:
                                        $commentReplySheet, postedBy: $postedBy, selectedReelId: $reelId).tag(0)
                            NotificationsView().tag(1)
                        }
                        .onTapGesture {
                            show = false
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .edgesIgnoringSafeArea(.all)
                        .overlay(
                            HStack {
                                if self.show {
                                    VStack {
                                        Diamond()
                                            .frame(width: 60, height: 40)
                                            .padding(.bottom, -30)
                                            .padding(.leading, -50)
                                            .foregroundColor(.white)
                                        
                                        PopOverTwo(show: $show, camera: $cameraView, live: $live)
                                            .background(Color.white)
                                            .cornerRadius(15)
                                    }
                                }
                                Spacer()
                            }
                            .frame(maxHeight: .infinity, alignment: .top)
                            .padding(.top, 5)
                            .padding(.leading, 5)
                        )
                    
                        
                        //                        .alert(isPresented: $bottomSheetBlock) {
                        //                            Alert(
                        //                                title: Text("Are you sure want to block this user?"),
                        //                                message: Text(""),
                        //                                primaryButton: .destructive(Text("Yes")) {
                        //                                    likeVM.blockPostApi()
                        //                                },
                        //                                secondaryButton: .cancel()
                        //                            )
                        //                        }
                        
                    }
                    
                    TabBarViewTwo(currentTab: self.$currentTab)
                    
                    Spacer()
                    
                }
                
                .blurredSheet(.init(.white), show: $commentSheet) {
                    
                } content: {
                    if #available(iOS 16.0, *) {
                        CommentSheet(commentReplySheet: $commentReplySheet,commentSheet: $commentSheet, commentId: $commentId, reply_to_reply: $reply_to_reply)
                            .presentationDetents([.large,.medium,.height(500)])
                    } else {
                        // Fallback on earlier versions
                    }
                }
            
                .blurredSheet(.init(.white), show: $commentReplySheet) {

                } content: {
                    if #available(iOS 16.0, *) {
                        CommentReplySheet(commentId: $commentId, reply_to_reply: $reply_to_reply, commentReplySheet: $commentReplySheet)
                            .presentationDetents([.medium,.height(180)])
                    } else {
                        // Fallback on earlier versions
                    }
                }
                
                
                
                
            }
            //            .onDisappear {
            //                player.pause()
            //            }
            
            .navigationBarHidden(true)
        }
        
        
        
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}

struct TabBarViewTwo: View {
    
    @Binding var currentTab: Int
    @Namespace var namespace
    
    var tabBarOptions: [String] = ["Home", "Notification", "AdditionalIcons"]
    var body: some View {
        
        HStack(spacing: 10) {
            Spacer()
            ForEach(Array(zip(self.tabBarOptions.indices,
                              self.tabBarOptions)), id: \.0, content: {
                index, name in
                TabBarItemTwo(currentTab: self.$currentTab,
                              namespace: namespace.self,
                              tabBarItemName: name,
                              tab: index)
                
                Spacer()
                
            })
        }
        .padding(.horizontal, -90)
        
    }
}



struct TabBarItemTwo: View {
    @Binding var currentTab: Int
    let namespace: Namespace.ID
    
    var tabBarItemName: String
    var tab: Int
    
    var body: some View {
        Button {
            self.currentTab = tab
        } label: {
            ZStack {
                //                Spacer()
                Image(tabBarItemName)
                    .resizable()
                    .frame(width: 30, height: 30)
                if currentTab == tab && currentTab == 0 {
                    GifImage("homeW-3-2") // homeW
                        .frame(width: 40, height: 40)
                    
                } else if currentTab == tab && currentTab == 1 {
                    GifImage("notificationW")
                        .frame(width: 40, height: 40)
                    
                } else if currentTab == tab && currentTab == 2 {
                    GifImage("settingsW2-2")
                        .frame(width: 40, height: 40)
                } else {
                    
                }
                
                
            }
            .animation(.spring(), value: self.currentTab)
            .padding(.bottom, -10)
        }
        .buttonStyle(.plain)
    }
}


struct PopOverTwo: View {
    
    @Binding var show: Bool
    @Binding var camera: Bool
    @Binding var live: Bool
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15) {
            
            VStack {
                
                Button {
                    camera.toggle()
                } label: {
                    HStack(spacing: 15) {
                        Text("Posts")
                            .padding(.trailing, 3)
                        //                    Spacer()
                        Image("PopUpPlay")
                    }
                }
                Button {
                    live.toggle()
                } label: {
                    HStack(spacing: 15) {
                        Text("Live")
                            .padding(.trailing)
                        //                    Spacer()
                        Image("PopUpVideo")
                        
                    }
                }
            }
            .foregroundColor(.black)
            .frame(width: 100)
            .padding(10)
        }
        
        
    }
    
}

