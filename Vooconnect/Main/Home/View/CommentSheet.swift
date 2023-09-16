//
//  CommentSheet.swift
//  Vooconnect
//
//  Created by Vooconnect on 31/12/22.
//

import SwiftUI

struct CommentSheet: View {
    
    @Binding var commentReplySheet: Bool
    @Binding var commentSheet: Bool
    @Binding var commentId: Int
    @Binding var reply_to_reply: String
    @State var placeholder: String = "Add comment..."
    @State var isReply: Bool = false
    var userVM: LogInViewModel = LogInViewModel()
    
    //    @State var commentText: String
    @StateObject private var likeVM: ReelsLikeViewModel = ReelsLikeViewModel()
    @StateObject private var userM: LogInViewModel = LogInViewModel()
    
    var body: some View {
        
        ZStack{
            VStack {
                
                Text("\(likeVM.postComment.count) Comments")
                    .font(.custom("Urbanist-Bold", size: 24))
                    .foregroundColor(Color(#colorLiteral(red: 0.1726317704, green: 0.1726317704, blue: 0.1726317704, alpha: 0.9040511175)))
                    .padding(.top, 30)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                    .opacity(0.2)
                
                ScrollView(showsIndicators: false) {

                    LazyVGrid(columns: gridLayoutLS, alignment: .center, spacing: columnSpacingLS, pinnedViews: []) {
                        Section()
                        {
                            ForEach(0..<likeVM.postComment.count, id: \.self) { index in
                                if likeVM.postComment[index].replyToCommentID == 0 {
                                    CommentList(commentReplySheet: $commentReplySheet, comment: likeVM.postComment[index], comments: likeVM.postComment, commentId: $commentId, placeholder: $placeholder, isReply: $isReply)

                                }
//                                LazyVGrid(columns: gridLayoutLS, alignment: .center, spacing: columnSpacingLS, pinnedViews: []) {
//                                    Section()
//                                    {
//                                        ForEach(0..<likeVM.postComment.count, id: \.self) { ind in
//
//                                            if likeVM.postComment[ind].replyToCommentID == likeVM.postComment[index].id {
//
//                                                CommentReplyList(commentSheet: $commentSheet, commentReplySheet: $commentReplySheet, comment: likeVM.postComments[ind], users: userM.usersList, commentId: $commentId, reply_to_reply: $reply_to_reply)
//
//                                            }
//                                            //                                }
//
//                                        }
//                                    }
//                                }
//                                .padding(.leading, 40)
                            }
                        }
                    }
                    .padding(.top)
                }
                .onTapGesture{
                    isReply = false
                placeholder = "Add comment..."
                }

                if likeVM.commentDataModel.showAtTheRate == true  {
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
                                    likeVM.commentDataModel.commentText = "\(user.username ?? "") "
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
                                            likeVM.commentDataModel.commentText += String(UnicodeScalar(j)!)
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

                    ReelsCommentTextField(text: $likeVM.commentDataModel.commentText, showEmoji: $likeVM.commentDataModel.showEmoji, showAtTheRate: $likeVM.commentDataModel.showAtTheRate, placeholder: $placeholder)

                    Button {
                        if isReply == true {
                            print("Reply To --- \(reply_to_reply)")
                            if reply_to_reply.isEmpty {
                                likeVM.replyToCommentApi(commentId: commentId){ isSuccess in
                                    if isSuccess == true {
                                        likeVM.commentDataModel.commentText = ""
                                        commentSheet.toggle()
                                    }
                                }
                            }else{
                                likeVM.replyToReplyApi(commentId: commentId, reply_to_reply: reply_to_reply){ isSuccess in
                                    if isSuccess == true {
                                        likeVM.commentDataModel.commentText = ""
                                        commentSheet.toggle()
                                    }
                                }
                            }
                        }else{
                            likeVM.addCommentApi(){ isSuccess in
                                if isSuccess == true {
                                    likeVM.commentDataModel.commentText = ""
                                    commentSheet.toggle()
                                }
                            }
                        }
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


struct CommentSheet_Previews: PreviewProvider {
    @State static var commentReplySheet = false
    @State static var commentSheet = false
    @State static var commentId = 0
    @State static var reply_to_reply = ""
    
    static var previews: some View {
        CommentSheet(commentReplySheet: $commentReplySheet, commentSheet: $commentSheet, commentId: $commentId, reply_to_reply: $reply_to_reply)
    }
}
