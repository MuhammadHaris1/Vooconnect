//
//  VideoCreditsView.swift
//  Vooconnect
//
//  Created by Mac on 04/08/2023.
//

import Foundation
import SwiftUI

struct VideoCreditsView: View{
    
    
    @State var userName: String = ""
    @Binding var userNames: [String]
    @FocusState private var focusTextField: Bool
    @Binding var videoCreditsView: Bool
    @Binding var videoCreditsVisible: Bool
    @Binding var videoCreditsText: String
    @State private var profile: [Image] = []
    
    
    var body: some View{
        VStack(alignment:.leading){
            HStack{
                Image("SearchS")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 20, alignment: .center)
                    .padding(.leading)
                TextField("Search", text: $userName)
                    .focused($focusTextField)
                    .onChange(of: self.userName, perform: {val in
                        print("new textField val: \(val)")
                        if focusTextField{
                            searchUsername(name: val)
                        }
                    })
                    .onSubmit {
                        if(userName.isEmpty == false)
                        {
//                                    soundsViewBloc.searchSong(query: userName)
                        }
                    }
                    .frame(height: 20, alignment: .center)
            }
            .padding(.top, 20)
            
            Spacer()
            Spacer()
            Spacer()
            
            ScrollView{
                VStack(spacing: 20){
                    
                    ForEach (userNames, id: \.self){ user in
                        HStack{
                           Image("ImageArtist")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                            Button{
                                videoCreditsView = false
                                videoCreditsVisible = true
                                videoCreditsText = user
                                
                                
                                
                            }label: {
                                Text(user)
                                    .font(.custom("Urbanist-SemiBold", size: 18))
                                    .foregroundColor(.black)
                            }
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear{
            searchUsername(name: userName)
        }
    }
    
    func searchUsername(name: String) {
        let baseURL = baseURL + EndPoints.mention  // Replace with your base URL
        let queryParameter = "?username=" + name
        var url = URLRequest(url: URL(string: baseURL + queryParameter)!)
        
//        let session = URLSession.shared
        let boundary = UUID().uuidString
//        var data = Data()
        
        if let tokenData = UserDefaults.standard.string(forKey: "accessToken") {
            url.allHTTPHeaderFields = ["Authorization": "Bearer \(tokenData)"]
            url.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "content-type")
            print("ACCESS TOKEN=========", tokenData)
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid HTTP response")
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("HTTP response status code: \(httpResponse.statusCode)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            print(String(data: data, encoding: .utf8)!)
            let decoder = JSONDecoder()
            
            do {
                let response = try decoder.decode(Response.self, from: data)
                print("Response: \(response)")
                userNames = response.data.map { $0.username }
//                profile = response.data.map {Image($0.profile_image)}
//                isListView = true
                
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}
