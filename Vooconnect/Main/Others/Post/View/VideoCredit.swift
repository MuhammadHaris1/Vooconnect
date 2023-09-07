//
//  VideoCredit.swift
//  Vooconnect
//
//  Created by Mac on 20/07/2023.
//

import SwiftUI


struct VideoCreditView: View{
    
    @State private var userName = ""
    
    var body: some View{
        NavigationView{
            HStack {
                Image("SearchS")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 20, alignment: .center)
                    .padding(.leading)
                TextField("Search", text: $userName)
//                    .focused($focusTextField)
                    .onChange(of: self.userName, perform: {val in
                        print("new textField val: \(val)")
                        if(val.isEmpty == false)
                        {
//                            soundsViewBloc.searchSong(query: val)
                        }
                    })
                    .onSubmit {
                        if(userName.isEmpty == false)
                        {
//                                    soundsViewBloc.searchSong(query: userName)
                        }
                    }
                    .frame(height: 20, alignment: .center)
                Image("FilterS")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 20, alignment: .center)
                    .padding(.trailing)
                    .button {
//                        self.showFilter = true
                    }
            }
            
            
            .frame(height: 55)
            .background(Color(#colorLiteral(red: 0.9688159823, green: 0.9688159823, blue: 0.9688159823, alpha: 1)))
            .cornerRadius(10)
            .padding(.top, 10)
        }
    }
    
}


struct VideoCreditPreview: PreviewProvider{
    static var previews: some View{
        VideoCreditView()
    }
}
