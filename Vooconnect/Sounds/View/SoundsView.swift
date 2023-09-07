//
//  SoundsView.swift
//  Vooconnect
//
//  Created by Vooconnect on 14/12/22.
//

import SwiftUI
import SwiftUIBloc

struct SoundsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var userName: String = ""
    @State private var latest: Bool = true
    @State private var favorites: Bool = false
    @State private var showFilter : Bool = false
    @FocusState private var focusTextField: Bool
    var pickSong : (DeezerSongModel) -> () = {val in}
    var soundsViewBloc = SoundsViewBloc(SoundsViewBlocState())
    var body: some View {
        NavigationView {
            
            ZStack {
                Color(.white)
                    .ignoresSafeArea()
                
                VStack {
                    
                    //                    NavigationLink(destination: PreviewFromGallery()   // PreviewFromGallery()   // PreviewView()
                    //                        .navigationBarBackButtonHidden(true).navigationBarHidden(true), isActive: $imagePicker.showPreview) {
                    //                            EmptyView()
                    //                        }
                    
                    
                    // Top Bar
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image("BackButtonM")
                        }
                        
                        Spacer()
                        
                        Text("Sounds")
                            .font(.custom("Urbanist-Bold", size: 24))
                            .foregroundColor(.black)
                        
                        Image("ArrowDownLogoM")
                        
                        Spacer()
                        
                        Image("MoreOptionLogoM")
                            .button {
                                
                            }
                        
                    }
                    
                    // Search Bar
                    HStack {
                        Image("SearchS")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 20, height: 20, alignment: .center)
                            .padding(.leading)
                        TextField("Search", text: $userName)
                            .focused($focusTextField)
                            .onChange(of: self.userName, perform: {val in
                                print("new textField val: \(val)")
                                if(val.isEmpty == false)
                                {
                                    soundsViewBloc.searchSong(query: val)
                                }
                            })
                            .onSubmit {
                                if(userName.isEmpty == false)
                                {
//                                    soundsViewBloc.searchSong(query: userName)
                                }
                            }
                            .frame(height: 20, alignment: .center)
                        Image("FilterS")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 20, height: 20, alignment: .center)
                            .padding(.trailing)
                            .button {
                                self.showFilter = true
                            }
                    }
                    
                    
                    .frame(height: 55)
                    .background(Color(#colorLiteral(red: 0.9688159823, green: 0.9688159823, blue: 0.9688159823, alpha: 1)))
                    .cornerRadius(10)
                    .padding(.top, 10)
                    
                    // All button
                    HStack {
                        
                        Button {
                            latest = true
                            favorites = false
                            soundsViewBloc.showSearchSongList()
                            
                        } label: {
                            VStack {
                                Text("Latest")
                                    .font(.custom("Urbanist-SemiBold", size: 18))
                                    .foregroundStyle( latest ?
                                                      LinearGradient(colors: [
                                                        Color("buttionGradientTwo"),
                                                        Color("buttionGradientOne"),
                                                      ], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [
                                                        Color("gray"),
                                                        Color("gray"),
                                                      ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                
                                
                                ZStack {
                                    if latest {
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
                                            .padding(.trailing, -9)
                                            .frame(height: 2)
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            latest = false
                            favorites = true
                            soundsViewBloc.showFavoriteSongList()
                        } label: {
                            VStack {
                                Text("Favorites")
                                    .font(.custom("Urbanist-SemiBold", size: 18))
                                    .foregroundStyle( favorites ?
                                                      LinearGradient(colors: [
                                                        Color("buttionGradientTwo"),
                                                        Color("buttionGradientOne"),
                                                      ], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [
                                                        Color("gray"),
                                                        Color("gray"),
                                                      ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                
                                ZStack {
                                    if favorites {
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
                                        //                                            .padding(.trailing, -40)
                                            .frame(height: 2)
                                    }
                                }
                            }
                        }
                        
                        
                        
                    }
                    .padding(.top, 10)
                    
                    songList()
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color("grayOne"))
                        .padding(.horizontal, -20)
                    
                    HStack {
                        Spacer()
                        Text("Powered By")
                            .font(.custom("Urbanist-SemiBold", size: 18))
                        Image("DeezerSound")
                    }
                    .padding(.top, -5)
                    
                }
                .padding(.horizontal)
            }
            
            .navigationBarHidden(true)
            .onAppear{
                soundsViewBloc.loadSongInit()
            }
            .overlay{
                if(self.focusTextField)
                {
                    fastSearchListView()
                }
            }
            .overlay{
                if(self.showFilter )
                {
                    SoundsFilterView(
                        currentTypeFilter: self.soundsViewBloc.state.value.typeSoundsFilter,
                        callback: {val in
                            self.soundsViewBloc.setCurrentFilterType(type: val) 
                            self.showFilter = false
                        },
                        cancellCallback: {
                            self.showFilter = false
                        }
                    
                    )
                }
            }
        }
    }
    
    ///In this view you can see suggested words showed when `focusTextField` is active
    func fastSearchListView() -> some View{
        ScrollView{
            VStack{
                BlocBuilderView(bloc: soundsViewBloc) { state in
                    ForEach(state.wrappedValue.searchSongList) { song in
                        HStack(spacing:10){
                            Image("SearchS")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 20, height: 20, alignment: .center)
                                .padding(8)
                                .background{
                                    RoundedRectangle(cornerRadius: 100)
                                        .fill(Color.gray.opacity(0.15))
                                }
                            Text(song.title ?? "")
                                .foregroundColor(.black)
                                
                            Spacer()
                                
                        }
                        .padding(.horizontal,20)
                        .frame(width:UIScreen.main.screenWidth())
                        .button {
                            self.userName = song.title!
                            self.focusTextField = false
//                            self.soundsViewBloc.searchSong(query: song.title)
                        }
                        
                    }

                }
            }
        }
        .background{
            Color.white
        }
        .frame(width: 500)
        .offset(CGSize(width: 0, height: 120))
    }
    
    @ViewBuilder
    func songList() -> some View{
        ScrollView {
            LazyVGrid(columns: gridLayoutSound, alignment: .center, spacing: columnSpacingSound, pinnedViews: []) {
                Section()
                {
                    BlocBuilderView(bloc: soundsViewBloc) { state in
                        if(favorites){
                            ForEach(state.wrappedValue.favoriteSongList) { song in
                                songListView(songModel: song)
                            }
                        }else{
                            ForEach(state.wrappedValue.filterSongList) { song in
                                songListView(songModel: song)
                            }
                        }
//                        switch state.wrappedValue{
//                            case .searchSongList(let list):
//                                ForEach(list) { song in
//                                    songListView(songModel: song)
//                                }
//                            case .favoriteSongList(let list):
//                                ForEach(list) { song in
//                                    songListView(songModel: song)
//                                }
//                        }
                    }
                    
                }
            }
        }
        .padding(.top, 10)
        
//            ScrollView {
//                LazyVGrid(columns: gridLayoutSound, alignment: .center, spacing: columnSpacingSound, pinnedViews: []) {
//                    Section()
//                    {
//
////                        if(favorites)
////                        {
////                            ForEach(state.wrappedValue.favoriteSongList) { song in
////                                songListView(songModel: song, state: state.wrappedValue)
////                            }
////                        }else
////                        {
////                            ForEach(state.wrappedValue.searchSongList) { song in
////                                songListView(songModel: song,state: state.wrappedValue)
////                            }
////                        }
//                    }
//                }
//            }
//            .padding(.top, 10)
//        }

    }
    
    func songListView(songModel : DeezerSongModel) -> some View{
//        print(songModel.id)
        //        print(soundsViewBloc.state.value.preview?.!id)
        return SoundListView(
            songModel: songModel,
            preview: soundsViewBloc.state.value.preview,
            pickSong: {val in
                pickSong(val)
                presentationMode.wrappedValue.dismiss()
            }
        )
        .environmentObject(soundsViewBloc)
    }
}

struct SoundsView_Previews: PreviewProvider {
    static var previews: some View {
        SoundsView()
    }
}
