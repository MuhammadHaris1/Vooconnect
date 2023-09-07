//
//  SoundListView.swift
//  Vooconnect
//
//  Created by Vooconnect on 14/12/22.
//

import SwiftUI
import SwiftUIBloc

let columnSpacingSound: CGFloat = 20
let rowSpacingSound: CGFloat = 10
var gridLayoutSound: [GridItem] {
    return Array(repeating: GridItem(.flexible(), spacing: rowSpacingSound), count: 1)
}

struct SoundListView: View {
    @State var songModel : DeezerSongModel
    @State var preview : DeezerSongModel? = nil
    var pickSong : (DeezerSongModel) -> () = {val in}
    @EnvironmentObject var soundsViewBloc: SoundsViewBloc
    var body: some View {
        HStack {
            
//            Image("MaskSound")
            BlocBuilderView(bloc: soundsViewBloc) { state in
                ZStack{
                    AsyncImage(url: URL(string: songModel.album!.cover))
        //                .resizable()
        //                .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipped()
                        .cornerRadius(16)
                    if(state.wrappedValue.preview != nil && state.wrappedValue.preview == songModel)
                    {
                        Image("PlayWhiteN")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
                .frame(alignment: .center)
                .button {
                    soundsViewBloc.playSong(songModel: songModel)
                }
            }
            
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text(songModel.title!)
                    .font(.custom("Urbanist-Bold", size: 18))
                    .foregroundColor(Color(#colorLiteral(red: 0.1726317704, green: 0.1726317704, blue: 0.1726317704, alpha: 0.901334851)))
                
                HStack {
                    
                    Text(songModel.artist!.name)  // Medium
                        .font(.custom("Urbanist-Medium", size: 14))
                        .foregroundColor(Color(#colorLiteral(red: 0.4560062289, green: 0.4560062289, blue: 0.4560062289, alpha: 0.6976148593)))
                    
                    Spacer()
                    
                    Text("65.1M")
                        .font(.custom("Urbanist-SemiBold", size: 14))
                        .foregroundColor(Color(#colorLiteral(red: 0.4560062289, green: 0.4560062289, blue: 0.4560062289, alpha: 0.6976148593)))
                    
                    if(soundsViewBloc.findOnFavoriteList(songModel: songModel))
                    {
                        Image("BookmarkSound")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 24, height: 24)
                            .button {
                                soundsViewBloc.deleteSong(songModel: songModel)
                            }
                    }else{
                        Image("BookmarkSoundTwo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 24, height: 24)
                            .button {
                                soundsViewBloc.saveSong(songModel: songModel)
                            }
                    }
                    
                    
                }
                
                Text(songModel.getDuration())
                    .font(.custom("Urbanist-Medium", size: 14))
                    .foregroundColor(Color(#colorLiteral(red: 0.4560062289, green: 0.4560062289, blue: 0.4560062289, alpha: 0.6976148593)))
                
            }
            
        }
        .button {
            pickSong(songModel)
        }
    }
    
    func isPlaying() -> Bool{
        if(preview == songModel)
        {
            return true
        }
        return false
    }
}

struct SoundListView_Previews: PreviewProvider {
    static var previews: some View {
//        SoundListView()
        SoundsView()
    }
}
