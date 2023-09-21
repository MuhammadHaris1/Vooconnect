//
//  CommentReplyList.swift
//  Vooconnect
//
//  Created by door on 16/05/2023.
//

import SwiftUI

struct CommentReplyList: View {
    @Binding var commentSheet: Bool
    @Binding var commentReplySheet: Bool
    
    @State var comment: CommentResponse
    @State var users: [Users] = []
    @State var likeUnlike: Bool = false
    
    @Binding var commentId: Int
    @Binding var reply_to_reply: String
    
    @StateObject private var likeVM: ReelsLikeViewModel = ReelsLikeViewModel()
    
    @State var username: String = ""
    //    @State var commentText: String = ""
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                
                
                Image("ImageCP")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 48, height: 48)
                    .cornerRadius(10)
                
                ForEach(users, id: \.self){ user in
                    
                    if user.uuid == comment.user_uuid && comment.reply_to_reply.isEmpty {
                        Text("\(user.username ?? "")")
                            .font(.custom("Urbanist-Bold", size: 16))
                            .foregroundColor(Color(#colorLiteral(red: 0.1726317704, green: 0.1726317704, blue: 0.1726317704, alpha: 0.9040511175)))
                            .padding(.leading, 10)
                        
                    }
                    
                    if !comment.reply_to_reply.isEmpty && user.uuid! == comment.reply_to_reply.split(separator: "/").first! {
                        Text("\(user.username ?? "")-")
                            .font(.custom("Urbanist-Bold", size: 16))
                            .foregroundColor(Color(#colorLiteral(red: 0.1726317704, green: 0.1726317704, blue: 0.1726317704, alpha: 0.9040511175)))
                            .padding(.leading, 10)
                    }
                    
                    if !comment.reply_to_reply.isEmpty && user.uuid! == comment.reply_to_reply.split(separator: "/").last! {
                        Text("\(user.username ?? "")")
                            .font(.custom("Urbanist-Bold", size: 16))
                            .foregroundColor(Color(#colorLiteral(red: 0.1726317704, green: 0.1726317704, blue: 0.1726317704, alpha: 0.9040511175)))
                            .padding(.leading, 5)
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
                    let uuid = UserDefaults.standard.string(forKey: "uuid") ?? ""
                    if comment.reply_to_comment_id != 0 {
                        commentId = comment.reply_to_comment_id
                        reply_to_reply = "\(uuid)/\(comment.user_uuid)"
                        print(commentId)
                        print(reply_to_reply)
                    }else{
                        commentId = comment.id
                    }
                    
                    
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
        
    }
}
//
//struct CommentReplyList_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentReplyList()
//    }
//}


