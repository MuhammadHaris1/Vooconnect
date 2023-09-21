//
//  CommentReplySheet.swift
//  Vooconnect
//
//  Created by door on 16/05/2023.
//

import SwiftUI

struct CommentReplySheet: View {
    //    @State var commentText: String
        @StateObject private var likeVM: ReelsLikeViewModel = ReelsLikeViewModel()
        @StateObject private var userVM: LogInViewModel = LogInViewModel()
        @Binding var commentId: Int
        @Binding var reply_to_reply: String
        @Binding var commentReplySheet: Bool
        
        var body: some View {
            
            ZStack {
                VStack {
                    
                    if likeVM.commentDataModel.showAtTheRate == true {
                        ScrollView {
                            VStack(alignment: .trailing){
                                ForEach(userVM.usersList, id: \.self) { user in
                                    VStack{
                                        Text("\(user.username ?? "")")
                                            .foregroundColor(.black)
                                            .font(.custom("Urbanist-Bold", size: 12))
                                            .frame(maxWidth:.infinity,alignment:.leading)
                                            
                                        
                                        Text("\(user.first_name ?? "") \(user.last_name ?? "")")
                                            .foregroundColor(.black)
                                            .font(.custom("Urbanist-Medium", size: 12))
                                            .frame(maxWidth:.infinity,alignment:.leading)
                                    }
                                    .padding(.bottom,4)
                                    .padding(.leading,20)
                                    .onTapGesture(perform: {
                                        likeVM.commentDataModel.replyText = "\(user.username ?? "") "
                                        likeVM.commentDataModel.showAtTheRate.toggle()
                                    })
                                }
                            }
                            .padding(.top,3)
                            .padding(.bottom,3)
                        }
                        .foregroundColor(.black)
        //                    .background(.black)
                        .frame(height: 150)
                    }
                    
                    if likeVM.commentDataModel.showEmoji == true {
                        ScrollView {
                            VStack(alignment: .trailing){
                                ForEach(self.getEmojiList(), id: \.self) { i in
                                    HStack{
                                        
                                        ForEach(i, id: \.self){ j in
                                            Button {
                                                likeVM.commentDataModel.replyText += String(UnicodeScalar(j)!)
                                                likeVM.commentDataModel.showEmoji.toggle()
                                            }label: {
                                                
                                                if (UnicodeScalar(j)?.properties.isEmoji)! {
                                                    Text(String(UnicodeScalar(j)!))
                                                        .foregroundColor(.black)
                                                        .font(.custom("Urbanist-Bold", size: 20))
                                                        .frame(maxWidth:.infinity,alignment:.leading)
                                                }else{
                                                    Text("")
                                                        .foregroundColor(.black)
                                                        .font(.custom("Urbanist-Bold", size: 12))
                                                        .frame(maxWidth:.infinity,alignment:.leading)
                                                }
                                                
                                            }
                                        }
                                    }
                                    .padding(.bottom,4)
                                    .padding(.leading,20)
                                    .onTapGesture(perform: {
    //                                    likeVM.commentDataModel.commentText = "\(user.username ?? "") "
                                    })
                                }
                            }
                            .padding(.top,3)
                            .padding(.bottom,3)
                        }
                        .foregroundColor(.black)
    //                    .background(.black)
                        .frame(height: 150)
                    }
                    
                    HStack {

                        ReelsCommentTextField(text: $likeVM.commentDataModel.replyText, showEmoji: $likeVM.commentDataModel.showEmoji, showAtTheRate: $likeVM.commentDataModel.showAtTheRate, placeholder: "Add reply...")

                        Button {
                            print("Reply To --- \(reply_to_reply)")
                            if reply_to_reply.isEmpty {
                                likeVM.replyToCommentApi(commentId: commentId)
                            }else{
                                likeVM.replyToReplyApi(commentId: commentId, reply_to_reply: reply_to_reply)
                            }
                           
                            likeVM.commentDataModel.replyText = ""
                            commentReplySheet.toggle()
                        } label: {
                            Image("SendTwoLV")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 56, height: 56)
                        }


                    }
                    
                }
                .padding(.horizontal)
            }
        
        }
        
        func getEmojiList() -> [[Int]]{
            var emojis: [[Int]] = []
            
            for i in stride(from: 0x1F601, to:0x1F64F, by: 4) {
                var temp: [Int] = []
                
                for j in i...i + 3 {
                    temp.append(j)
                }
                
                emojis.append(temp)
            }
            
            return emojis
        }
}

//struct CommentReplySheet_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentReplySheet()
//    }
//}


