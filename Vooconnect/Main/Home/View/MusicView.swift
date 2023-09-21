//
//  MusicView.swift
//  Vooconnect
//
//  Created by door on 16/05/2023.
//

import SwiftUI
import AVKit
import AVFoundation
import SwiftUIBloc

struct MusicView: View {
    @Environment(\.presentationMode) var presentaionMode
    @Binding var reelId: Int
    @State var uuid = ""
    @StateObject private var userVM: LogInViewModel = LogInViewModel()
    @StateObject private var reelVM: ReelsViewModel = ReelsViewModel()
    @StateObject private var likeVM: ReelsLikeViewModel = ReelsLikeViewModel()
    @Binding var cameraView: Bool
    @State var audioPlayer: AVAudioPlayer!
//    @State private var audioPlayer: AVPlayer?
    @State var player: AVPlayer!
    @State var isPlaying = false
    @State var follow: Bool = false
    @State var viewerProfile = false
    @State var songModel: DeezerSongModel?
    var soundsViewBloc = SoundsViewBloc(SoundsViewBlocState())
    //    var thumbnailImageView: UIImageView
    @State var thumbnailImageView2: UIImage?
    @State var musicImage: Image?
    @State var musicURL: String = ""
    @State var reels: Post?
    var gridLayoutMP: [GridItem] {
        return Array(repeating: GridItem(.fixed(120), spacing: 1), count: 3)
    }
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.white)
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Button {
                            presentaionMode.wrappedValue.dismiss()
                        } label: {
                            Image("BackButton")
                        }
                        
                        Spacer()
                        
                        Button {
                            print(uuid)
                        } label: {
                            Image("ShareN")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 18, height: 18)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal,24)
                    
                    
                    //music picture with title
                    VStack {
                        
                        ForEach(reelVM.allReels, id: \.postID) { reel in
                            if reel.postID == reelId {
                                VStack(alignment: .leading){
                                    HStack{
                                        Image("MusicImage")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 140, height: 140)
                                        VStack (alignment: .leading) {
                                            Spacer()
                                            Text("\(reel.musicTrack ?? "Original Sound")")
                                                .font(.custom("Urbanist-Regular", size: 24))
                                                .fontWeight(Font.Weight.semibold)
                                                .lineLimit(2)
                                            Spacer(minLength: 10.0)
                                            Text("28,7M Videos")
                                                .font(.custom("Urbanist-Regular", size: 14))
                                                .fontWeight(Font.Weight.medium)
                                                .foregroundColor(.gray)
                                            Spacer()
                                        }
//                                        .frame(maxWidth: .infinity)
                                        Spacer()
                                    }
                                    
                                    //buttons
                                    HStack {
                                        Button {
                                            let audioOutputURL = FileManager.default.temporaryDirectory.appendingPathComponent("output.m4a")
                                            if let reelURL = reel.contentURL{
                                                print(reelURL)
                                                let videoReelURL = URL(string: reelURL)
                                                print("video URL: \(String(describing: videoReelURL))")
                                                extractAudio(sourceUrl: videoReelURL!) { result in
                                                    switch result {
                                                    case .success(let audioUrl):
                                                        play(url: audioUrl)
                                                    case .failure(let error):
                                                        print("Audio extraction and playback error: \(error)")
                                                    }
                                                }
                                            }
                                        } label: {
                                            HStack {
                                                Image("PlayS")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 16, height: 16)
                                                
                                                Text("Play Song")
                                                    .font(.custom("Urbanist-Regular", size: 16))
                                                    .fontWeight(Font.Weight.medium)
                                                    .foregroundColor(Color("buttionGradientOne"))
                                            }
                                        }
                                        .frame(maxWidth: .infinity)
                                        //                        .padding(.horizontal,10)
                                        .padding(.vertical,8)
                                        .overlay( RoundedRectangle(cornerRadius: 40)
                                            .stroke(Color("buttionGradientOne"), lineWidth: 2)
                                        )
                                        
                                        
                                        Button {
                                            
                                        } label: {
                                            HStack {
                                                Image("BookmarkSound")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 16, height: 16)
                                                
                                                Text("Add to Favourites")
                                                    .font(.custom("Urbanist-Regular", size: 16))
                                                    .fontWeight(Font.Weight.medium)
                                                    .foregroundColor(Color("buttionGradientOne"))
                                            }
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.horizontal,3)
                                        .padding(.vertical,8)
                                        .overlay( RoundedRectangle(cornerRadius: 40)
                                            .stroke(Color("buttionGradientOne"), lineWidth: 2)
                                        )
                                    }
                                    
                                    //singer
                                    HStack {
                                        VStack{
                                            HStack{
                                                Image(reel.creatorProfileImage ?? "squareTwoS")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 60, height: 60)
                                                    .padding(.trailing,20)
                                                VStack(alignment: .leading){
                                                    Text("\((reel.creatorFirstName ?? "John") + " " + (reel.creatorLastName ?? " Devise")) ")
                                                        .font(.custom("Urbanist-Regular", size: 18))
                                                        .fontWeight(Font.Weight.semibold)
                                                    Text("Profesional Singer")
                                                        .font(.custom("Urbanist-Regular", size: 14))
                                                        .fontWeight(Font.Weight.medium)
                                                        .foregroundColor(.gray)
                                                }
                                                .onTapGesture{
                                                    viewerProfile = true
                                                }
                                            }
                                        }
                                        Spacer()
                                        if let uid = UserDefaults.standard.string(forKey: "uuid"){
                                            if uuid != uid{
                                                Button {
                                                    follow.toggle()
                                                    if (follow == true) {
                                                        likeVM.followApi(user_uuid: uuid)
                                                    }else{
                                                        likeVM.unFollowApi(user_uuid: uuid)
                                                    }
                                                } label: {
                                                    
                                                    Text(follow ? "Following" : "Follow")
                                                        .font(.custom("Urbanist-Medium", size: 16))
                                                        .fontWeight(Font.Weight.medium)
                                                    
                                                }
                                                .padding(.vertical,6)
                                                .padding(.horizontal,16)
                                                .background(follow ? LinearGradient(colors: [
                                                    Color(.lightGray),
                                                ], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [
                                                    Color("buttionGradientOne"),
                                                    Color("buttionGradientTwo"),
                                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                                )
                                                .foregroundColor(follow ? Color("buttionGradientOne") : .white)
                                                .cornerRadius(30)
                                            }
                                        }
                                        
                                    }
                                }
                            }
                            
                        }
                    }
                    .padding(.horizontal,24)
                    .padding(.top,24)
                    
                    //divider
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .frame(height: 2.5)
                        .foregroundColor(Color.gray.opacity(0.1))
                        .padding(.horizontal,24)
                        .padding(.top,24)
                    
                    //use this sound
                    Button {
                        cameraView.toggle()
                    } label: {
                        HStack {
                            Image("MusicIcon")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 16, height: 16)
                            
                            
                            Text("Use this Sound")
                                .font(.custom("Urbanist-Bold", size: 16))
                                .fontWeight(Font.Weight.semibold)
                            
                        }
                        
                        .padding(.vertical,18)
                    }
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(colors: [
                            Color("buttionGradientOne"),
                            Color("buttionGradientTwo"),
                        ], startPoint: .leading, endPoint: .trailing)
                    )
                    .foregroundColor(.white)
                    .cornerRadius(30)
                    .padding(.horizontal,24)
                    .padding(.top,20)
                    
                    
                    ScrollView {
                        LazyVGrid(columns: gridLayoutMP, spacing: 1) {
                            ForEach(0...6, id: \.self) { item in
                                ZStack(alignment: .bottomLeading) {
                                    Image("ImageCP")
                                        .resizable()
                                        .scaledToFill()
                                    
                                    HStack {
                                        Image("PlayS")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 16, height: 16)
                                        
                                        Text("837.9 k")
                                            .foregroundColor(.white)
                                            .font(.custom("Urbanist-Regular", size: 10))
                                            .fontWeight(Font.Weight.medium)
                                    }
                                    .padding(.leading,10)
                                    .padding(.bottom,12)
                                    
                                }
                            }
                        }
                        .frame(height: 400)
                        .padding(.horizontal,24)
                    }
                    //                    .padding(.horizontal,24)
                    
                    
                    //                    Spacer()
                }
            }
        }
        .blurredSheet(.init(.white), show: $viewerProfile) {
            
        } content: {
            if #available(iOS 16.0, *) {
                ViewerProfileDetailSheet(reelId: reelId)
                    .presentationDetents([.large,.medium,.height(500)])
            } else {
                // Fallback on earlier versions
            }
        }
        
        
    }
    
    func extractAudio(sourceUrl: URL, completion: @escaping (Result<URL, Error>) -> ()) {
        let composition = AVMutableComposition()
        
        do {
            let asset = AVURLAsset(url: sourceUrl)
            guard let audioAssetTrack = asset.tracks(withMediaType: .audio).first else {
                completion(.failure(NSError(domain: "AudioTrackError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No audio track found"])))
                return
            }
            
            guard let audioCompositionTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) else {
                completion(.failure(NSError(domain: "AudioTrackError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create audio composition track"])))
                return
            }
            
            try audioCompositionTrack.insertTimeRange(audioAssetTrack.timeRange, of: audioAssetTrack, at: .zero)
        } catch {
            completion(.failure(error))
            return
        }
        
        let outputUrl = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("out.m4a")
        if FileManager.default.fileExists(atPath: outputUrl.path) {
            try? FileManager.default.removeItem(at: outputUrl)
        }
        
        let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetPassthrough)!
        exportSession.outputFileType = .m4a
        exportSession.outputURL = outputUrl
        
        exportSession.exportAsynchronously {
            if let error = exportSession.error {
                completion(.failure(error))
            } else if exportSession.status == .completed {
                completion(.success(outputUrl))
            } else {
                completion(.failure(NSError(domain: "ExportError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Export failed"])))
            }
        }
    }

    
    func play(url: URL) {
        print("playing \(url)")

        do {
            let playerItem = AVPlayerItem(url: url)

            self.player = try AVPlayer(playerItem: playerItem)
            player!.volume = 1.0
            player!.play()
        } catch let error as NSError {
            self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVPlayer init failed")
        }
    }
    
    func getThumbnailFromUrl(_ url: String?, _ completion: @escaping ((_ image: UIImage?)->Void)) {
        
        guard let url = URL(string: (url ?? "")) else { return }
        DispatchQueue.main.async {
            let asset = AVAsset(url: url)
            let assetImgGenerate = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            
            let time = CMTimeMake(value: 2, timescale: 1)
            do {
                let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                let thumbnail = UIImage(cgImage: img)
                completion(thumbnail)
            } catch let error{
                print("Error :: ", error)
                completion(nil)
            }
        }
    }
}

//struct MusicView_Previews: PreviewProvider {
//    @State var reelId: Int = 0
//    @State var cameraView: Bool = false
//    
//    static var previews: some View {
//        MusicView(reelId: reelId, cameraView: cameraView)
//    }
//}


//ForEach(likeVM.userInterestCategory, id: \.id) { categ in
//    if categ.user_uuid == uuid {
//        ForEach(likeVM.interestCategory, id: \.id) { uiCateg in
//            if categ.category_id == uiCateg.id {
//                Text("\(uiCateg.category_name)")
//                    .font(.custom("Urbanist-Regular", size: 14))
//                    .fontWeight(Font.Weight.medium)
//                    .foregroundColor(.gray)
//            }
//        }
//    }
//}
