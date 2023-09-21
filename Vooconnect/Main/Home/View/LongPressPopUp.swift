//
//  LongPressPopUp.swift
//  Vooconnect
//
//  Created by Vooconnect on 23/11/22.
//

import SwiftUI

struct LongPressPopUp: View {
    @Binding var likeImage: String
    @Binding var longPressPopUp: Bool
//    @State var selectedReaction: Reactions?
    @State var selectedReaction: Int?
    @Binding var postID: Int
    @StateObject private var likeVM: ReelsLikeViewModel = ReelsLikeViewModel()
    @Binding var likeCount: Int
    @Binding var likeeCount: Int
    @Binding var isLiked: Bool
    
    
    var body: some View {
        
        HStack {
            
            Button {
                print("Success ====== 2")
                selectedReaction = 2
                likeImage = "LikeTwo"
                longPressPopUp = false
                if likeeCount == 0{
                    likeCount = likeCount + 1
                    likeeCount = likeeCount + 1
                    print("likeeCount+++++++++++++\(likeeCount)")
                }
                isLiked = true
                likeVM.reelsReactionApi(reactionType: 2, postID: postID)
                likeVM.reelsLikeDataModel.postID = postID 
            } label: {
                Image("LikeTwo")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            
            Button {
                print("Success ====== 3")
                selectedReaction = 3
                likeImage = "Love"
                longPressPopUp = false
                if likeeCount == 0{
                    likeCount = likeCount + 1
                    likeeCount = likeeCount + 1
                    print("likeeCount+++++++++++++\(likeeCount)")
                }
                isLiked = true
                likeVM.reelsReactionApi(reactionType: 3, postID: postID)
                likeVM.reelsLikeDataModel.postID = postID
            } label: {
                Image("Love")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            
            Button {
                print("Success ====== 4")
                selectedReaction = 4
                likeImage = "Haha"
                longPressPopUp = false
                if likeeCount == 0{
                    likeCount = likeCount + 1
                    likeeCount = likeeCount + 1
                    print("likeeCount+++++++++++++\(likeeCount)")
                }
                isLiked = true
                likeVM.reelsReactionApi(reactionType: 4, postID: postID)
                likeVM.reelsLikeDataModel.postID = postID
            } label: {
                Image("Haha")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            
            Button {
                print("Success ====== 5")
                selectedReaction = 5
                likeImage = "Sad"
                longPressPopUp = false
                if likeeCount == 0{
                    likeCount = likeCount + 1
                    likeeCount = likeeCount + 1
                    print("likeeCount+++++++++++++\(likeeCount)")
                }
                isLiked = true
                likeVM.reelsReactionApi(reactionType: 5, postID: postID)
                likeVM.reelsLikeDataModel.postID = postID
            } label: {
                Image("Sad")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            
            Button {
                print("Success ====== 6")
                selectedReaction = 6
                likeImage = "Angry"
                longPressPopUp = false
                print("likeeCount-------------\(likeeCount)")
                if likeeCount == 0{
                    likeCount = likeCount + 1
                    likeeCount = likeeCount + 1
                    print("likeeCount+++++++++++++\(likeeCount)")
                }
                isLiked = true
                likeVM.reelsReactionApi(reactionType: 6, postID: postID)
                likeVM.reelsLikeDataModel.postID = postID
            } label: {
                Image("Angry")
                    .resizable()
                    .frame(width: 50, height: 50)
            }

        }
        .padding(6)
        .padding(.bottom, -5)
        .background(RoundedRectangle(cornerRadius: 25).fill(Color.white))
        
    }
}

//enum Reactions {
//    case DisLike
//    case Like
//    case LikeTwo
//    case Love
//    case Haha
//    case Sad
//    case Angry
//}

//struct LongPressPopUp_Previews: PreviewProvider {
//    static var previews: some View {
//        LongPressPopUp()
//    }
//}
