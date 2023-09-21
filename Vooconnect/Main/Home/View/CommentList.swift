//
//  CommentList.swift
//  Vooconnect
//
//  Created by Vooconnect on 31/12/22.
//

import SwiftUI

struct CommentList: View {
    
    @Binding var commentSheet: Bool
        @Binding var commentReplySheet: Bool
        
        @State var comment: CommentResponse
        @State var comments: [CommentResponse] = []
        @State var users: [Users] = []
        @State var likeUnlike: Bool = false
        
        @Binding var commentId: Int

        @StateObject private var likeVM: ReelsLikeViewModel = ReelsLikeViewModel()
        
        @State var username: String = ""
    //    @State var commentText: String = ""

        var body: some View {
            
    //        if comment.reply_to_comment_id == 0 {
                VStack(alignment: .leading) {

                    HStack {
                        
                        Image("ImageCP")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 48, height: 48)
                            .cornerRadius(10)

                        ForEach(users, id: \.self){ user in
                            if user.uuid == comment.user_uuid {
                                Text("\(user.username ?? "")")
                                    .font(.custom("Urbanist-Bold", size: 16))
                                    .foregroundColor(Color(#colorLiteral(red: 0.1726317704, green: 0.1726317704, blue: 0.1726317704, alpha: 0.9040511175)))
                                    .padding(.leading, 10)
                            }
                        }
                        

                        Spacer()

                        Image("MoreOptionLogo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 24, height: 24)
                    }

                    Text("\(comment.comment).")
                        .font(.custom("Urbanist-Regular", size: 14))
                        .foregroundColor(Color(#colorLiteral(red: 0.1726317704, green: 0.1726317704, blue: 0.1726317704, alpha: 0.9040511175)))

                    HStack {

                        Button {
                            likeUnlike.toggle()
                        } label: {
                            Image(likeUnlike ? "LikeRedC" :"LikeWhiteC")
                        }

                        Text("938")
                            .font(.custom("Urbanist-Medium", size: 12))
                            .foregroundColor(Color(#colorLiteral(red: 0.4560062289, green: 0.4560062289, blue: 0.4560062289, alpha: 0.7020126242)))

                        Text("3 days ago")
                            .font(.custom("Urbanist-Medium", size: 12))
                            .foregroundColor(Color(#colorLiteral(red: 0.4560062289, green: 0.4560062289, blue: 0.4560062289, alpha: 0.7020126242)))
                            .padding(.leading, 10)

                        Button {
                            commentId = comment.id
                            
                            print("Comment Id ------------ \(commentId)")
                         
                            commentReplySheet.toggle()
                            commentSheet.toggle()
                        } label: {
                            Text("Reply")
                                .font(.custom("Urbanist-Medium", size: 12))
                                .foregroundColor(Color(#colorLiteral(red: 0.4560062289, green: 0.4560062289, blue: 0.4560062289, alpha: 0.7020126242)))
                        }
                        .padding(.leading, 10)

                    }

                    
                }
    //        }
            
            }
}

//struct CommentList_Previews: PreviewProvider {
//    @State static var commentId: Int = 0
//    @State static var commentReplySheet: Bool = false
//    @State static var commentSheet: Bool = false
//    
//    static var previews: some View {
//        CommentList(commentSheet: $commentSheet, commentReplySheet: $commentReplySheet, commentId: $commentId)
//    }
//}
