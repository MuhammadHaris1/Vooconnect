//
//  UserDetailSheet.swift
//  Vooconnect
//
//  Created by Vooconnect on 22/12/22.
//

import SwiftUI

struct UserDetailSheet: View {
    
//    @Binding var creatorDetaiSheet: Bool
    @State private var manage: Bool = false
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Spacer()
                Spacer()
//                Spacer()
                
                Image("squareTwoS")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipped()
                    .cornerRadius(10)
                    .padding(.leading)
                    .padding(.top, 30)
                
                Spacer()
                
                Button {
                    manage.toggle()
                } label: {
                    Text("Manage")
                        .font(.custom("Urbanist-Bold", size: 12))
                        .foregroundColor(Color(#colorLiteral(red: 0.1726317704, green: 0.1726317704, blue: 0.1726317704, alpha: 0.8969888245)))
                }
                
                .padding(.horizontal)
                .padding(.vertical, 3)
                .background(Color(.gray) .opacity(0.2))
                .cornerRadius(20)
                .offset(y: -33)
                
            }
            
            
            Text("@Tynisha Obey")
                .font(.custom("Urbanist-Bold", size: 20))
                .padding(.top, 3)
            
            Text("Dancer & Singer") //Medium
                .font(.custom("Urbanist-Medium", size: 14))
                .padding(.top, -5)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .opacity(0.2)
                .padding(.top, 8)
            
            // Follower Count
            HStack {
                
                HStack {
                    
                    VStack(spacing: 4) {
                        Text("823")
                            .font(.custom("Urbanist-Bold", size: 24))
                        Text("Post")  // Medium
                            .font(.custom("Urbanist-Medium", size: 14))
                    }
                    
                    
                    Spacer()
                    Rectangle()
                        .frame(width: 1, height: 53)
                        .foregroundColor(Color(#colorLiteral(red: 0.933, green: 0.933, blue: 0.933, alpha: 1)))
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("3.6M")
                            .font(.custom("Urbanist-Bold", size: 24))
                        Text("Followers")
                            .font(.custom("Urbanist-Medium", size: 14))
                    }
                    .onTapGesture {
//                        followerView.toggle()
                    }
                    Spacer()
                    
                }
                
                
                HStack {
                    
                    Rectangle()
                        .frame(width: 1, height: 53)
                        .foregroundColor(Color(#colorLiteral(red: 0.933, green: 0.933, blue: 0.933, alpha: 1)))
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("925")
                            .font(.custom("Urbanist-Bold", size: 24))
                        Text("Following")
                            .font(.custom("Urbanist-Medium", size: 14))
                    }
                    .onTapGesture {
//                        followerView.toggle()
                    }
                    
                    Spacer()
                    Rectangle()
                        .frame(width: 1, height: 53)
                        .foregroundColor(Color(#colorLiteral(red: 0.933, green: 0.933, blue: 0.933, alpha: 1)))
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("39M")
                            .font(.custom("Urbanist-Bold", size: 24))
                        Text("Likes")
                            .font(.custom("Urbanist-Medium", size: 14))
                    }
                    
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            // Follow Button
            HStack(spacing: 14) {
                
                HStack(spacing: 20) {
                    
                    Button {
                        
                    } label: {
                        Spacer()
                        Image("AddUserCP")
                        Text("Follow")
                            .font(.custom("Urbanist-SemiBold", size: 16))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .frame(height: 40)
                    .background(
                        LinearGradient(colors: [
                            Color("buttionGradientTwo"),
                            Color("buttionGradientOne"),
                        ], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .cornerRadius(40)
                    
                    Button {
                        
                    } label: {
                        Spacer()
                        Image("ChatCP")
                        Text("Message")
                            .font(.custom("Urbanist-SemiBold", size: 16))
                            .foregroundStyle((LinearGradient(colors: [
                                Color("buttionGradientTwo"),
                                Color("buttionGradientOne"),
                            ], startPoint: .topLeading, endPoint: .bottomTrailing)
                            ))
                        Spacer()
                    }
                    .frame(height: 40)
                    
                    .overlay {
                        RoundedRectangle(cornerRadius: 40)
                            .strokeBorder((LinearGradient(colors: [
                                Color("buttionGradientTwo"),
                                Color("buttionGradientOne"),
                            ], startPoint: .top, endPoint: .bottom)
                            ), lineWidth: 2)
                    }
                    .cornerRadius(40)
                    
                }
                
            }
            .padding(.top, 10)
            
            Spacer()
            
                .blurredSheet(.init(.white), show: $manage) {
                    
                } content: {
                    if #available(iOS 16.0, *) {
                        UserManageSheet(cancel: $manage)
//                            SearchView()
//                            Text("Hello From Sheets")
//                                .foregroundColor(.black)
                            .presentationDetents([.large,.medium,.height(300)])
                    } else {
                        // Fallback on earlier versions
                    }
                }
            
        }
        .padding(.horizontal)
    }
}

struct UserDetailSheet_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailSheet()
    }
}
