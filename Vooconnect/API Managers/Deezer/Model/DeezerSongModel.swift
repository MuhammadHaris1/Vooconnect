//
//  DeezerMusicModel.swift
//  Vooconnect
//
//  Created by JV on 25/02/23.
//

import Foundation
struct DeezerSongModel: Identifiable, Codable, Equatable{
    internal init(id: String = UUID().uuidString, title: String? = nil, preview: String? = nil, duration: Int? = nil, artist: DeezerArtistModel? = nil, album: DeezerAlbumModel? = nil) {
        self.id = id
        self.title = title
        self.preview = preview
        self.duration = duration
        self.artist = artist
        self.album = album
    }
    
     
    
    static func == (lhs: DeezerSongModel, rhs: DeezerSongModel) -> Bool {
        lhs.id == rhs.id
    }
    
    
    var id = UUID().uuidString
    let title : String?
    let preview : String?
    var duration : Int?
    let artist : DeezerArtistModel?
    let album : DeezerAlbumModel?
    enum CodingKeys: String, CodingKey
    {
        case title
        case preview
        case album
        case artist
        case duration
    }
    
    func getDuration() -> String
    {
        let (_,m,s) = secondsToHoursMinutesSeconds(duration ?? 1)
        let sstr = s < 10 ? "0\(s)" : s.description
        let mstr = m < 10 ? "0\(m)" : m.description
        return "\(mstr):\(sstr)"
    }
    
    private func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

}
