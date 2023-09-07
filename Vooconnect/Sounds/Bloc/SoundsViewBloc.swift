//
//  SoundsViewBloc.swift
//  Vooconnect
//
//  Created by JV on 25/02/23.
//

import Foundation
import SwiftUIBloc

///This is the sounds view controller bloc, use this class to control soundsView with its SoundsViewBlocState
final class SoundsViewBloc: Bloc<SoundsViewBlocEvent, SoundsViewBlocState> {
    let deezerApiManager = DeezerApiManager()
    
    ///Loads music on init when view loads
    func loadSongInit()
    {
        print("loading songs")
        deezerApiManager.loadMusic(query: "a",callback: onLoadedMusic)
    }
    
    ///Search music based on `query`
    func searchSong(query : String)
    {
//        clearSongList()
        self.state.value.query = query
        yield(self.state.value)
        print("current query1: \(self.state.value.query)")
        deezerApiManager.loadMusic(query: query,callback: onLoadedMusic)
    }
    
    func filterSongList(){
        
    }
    
    ///Saves song on favorite list
    func saveSong(songModel : DeezerSongModel){
        self.state.value.favoriteSongList.append(songModel)
        yield(self.state.value)
    }
    
    ///Delete song from favorite list
    func deleteSong(songModel : DeezerSongModel){
        self.state.value.favoriteSongList.removeAll(where: {val in songModel == val})
        yield(self.state.value)
    }
    
    func playSong(songModel : DeezerSongModel){
        let response = SoundsManagerHelper.instance.playAudioFromUrl(url: songModel.preview!)
        if(response){
            self.state.value.preview = songModel
            yield(self.state.value)
        }else{
            self.state.value.preview = nil
            yield(self.state.value)
        }
    }
    func stopSong(){
        SoundsManagerHelper.instance.pause()
    }
    func showFavoriteSongList(){
//        yield(self.state.value)
    }
    
    func showSearchSongList(){
//        yield(self.state.value)
    }
    
    func findOnFavoriteList(songModel : DeezerSongModel) -> Bool{
        let _state = self.state.value
        return _state.favoriteSongList.contains(songModel)
    }
    
    ///receive deezer api manager response and fill list on SoundsView
    private func onLoadedMusic(list: [DeezerSongModel]){
        var _list = [DeezerSongModel]()
        print("current query: \(self.state.value.query)")
        for element in list{
            switch(self.state.value.typeSoundsFilter)
            {
                case .all: do {
                    _list.append(element)
                }
                case .title: do {
                    if((element.title?.lowercased().contains(self.state.value.query.lowercased())) != nil)
                    {
                        _list.append(element)
                    }
                }
                case .artist: do {
                    if((element.artist?.name.lowercased().contains(self.state.value.query.lowercased())) != nil)
                    {
                        _list.append(element)
                    }
                }
            }
        }
        
        self.state.value.searchSongList = list
        self.state.value.filterSongList = _list
        yield(self.state.value)
    }
    
    func clearSongList()
    {
        self.state.value.searchSongList = []
        self.state.value.filterSongList = []
        yield(self.state.value)
    }
    
    ///Change current filter applied to search
    func setCurrentFilterType(type : TypeOfSoundFilter)
    {
        self.state.value.typeSoundsFilter = type
        onLoadedMusic(list: self.state.value.searchSongList)
    }
}
