//
//  SoundsViewController.swift
//  Vooconnect
//
//  Created by JV on 25/02/23.
//

import Foundation

///SoundsView controller to show deezer music
class SoundsViewController : ObservableObject{
    let deezerApiManager = DeezerApiManager()
    @Published var songList = [DeezerSongModel]()
    @Published var favoritesSongList = [DeezerSongModel]()
    @Published var preview : String = ""
    
    ///Loads music on init when view loads
    func loadSongInit()
    {
        deezerApiManager.loadMusic(query: "a",callback: onLoadedMusic)
    }
    
    ///Search music based on [query]
    func searchSong(query : String)
    {
        clearSongList()
        deezerApiManager.loadMusic(query: query,callback: onLoadedMusic)
    }
    
    ///Saves in to database favorite songs
    func saveSong(songModel : DeezerSongModel){
        
    }
    
    func playSong(songModel : DeezerSongModel){
        if let prev = songModel.preview {
            preview = prev
            SoundsManagerHelper.instance.playAudioFromUrl(url: prev)
        }
        
    }
    
    ///receive deezer api manager response and fill list on SoundsView
    private func onLoadedMusic(list: [DeezerSongModel]){
        clearSongList()
        songList.append(contentsOf: list)
    }
    
    func clearSongList()
    {
        songList.removeAll()
    }
    
    init(){
        loadSongInit()
    }
    
}
