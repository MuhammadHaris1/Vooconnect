//
//  PostVisibilityView.swift
//  Vooconnect
//
//  Created by JV on 25/03/23.
//

import SwiftUI
struct PostVisibilityView: View {
    var callback : (TypeOfVisibility) -> () = {val in}
    let list : [TypeOfVisibility] = [.everyone,.friends,.onlyMe,.premiumFollowers]
    @State var currentVisibility : TypeOfVisibility
    @State private var yOffset : CGFloat = 400
    init(currentVisibility : TypeOfVisibility = .everyone, callback : @escaping (TypeOfVisibility) -> () = {val in})
    {
        _currentVisibility = State(initialValue: currentVisibility)
        self.callback = callback
    }
    var body: some View {
        ZStack{
            background()
            postOptions()
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.yOffset = -50
            }
        }
    }
    
    func background() -> some View{
        Rectangle()
            .fill(Color.black.opacity(0.35))
            .ignoresSafeArea()
            .onTapGesture {
                self.yOffset = 400
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    callback(self.currentVisibility)
                }
            }
            .opacity(yOffset > 100 ? 0 : 1)
            .animation(.easeInOut, value: self.yOffset)
    }
    
    func postOptions() -> some View{
        VStack{
            Spacer()
            VStack(alignment:.leading){
                HStack{
                    Spacer()
                    Text("This post will be visible to \(currentVisibility.rawValue)")
                        .urbanistBold(fontSize: 20)
                        .padding(.bottom,10)
                    Spacer()
                }
                ForEach(list, id:\.self){type in
                    HStack{
                        Text(type.description)
                            .urbanistRegular(fontSize: 18)
                        Spacer()
                        if(self.currentVisibility == type)
                        {
                            RoundedRectangle(cornerRadius: 100)
                                .fill(ColorsHelper.deepPurple)
                                .frame(width: 20,height: 20)
                                .padding(6)
                                .background{
                                    RoundedRectangle(cornerRadius: 100)
                                        .strokeBorder(ColorsHelper.deepPurple, lineWidth: 4)
                                }
                        }else{
                            RoundedRectangle(cornerRadius: 100)
                                .fill(.white)
                                .frame(width: 20,height: 20)
                                .padding(6)
                                .background{
                                    RoundedRectangle(cornerRadius: 100)
                                        .strokeBorder(.black, lineWidth: 4)
                                }
                        }
                    }
                    .foregroundColor(.black)
                    .button {
                        self.currentVisibility = type
                    }
                    .padding(.bottom,10)
                    .animation(.linear, value: self.currentVisibility)
                }
                
            }
            .padding(.horizontal,48)
            .background{
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .padding(.vertical,-20)
                    .padding(.bottom,-100)
                    .frame(width: UIScreen.main.screenWidth() - 48)
                    
            }
            .offset(y : yOffset)
            .animation(.easeInOut, value: self.yOffset)
            
        }
    }
}

struct PostVisibilityView_Previews: PreviewProvider {
    static var previews: some View {
        PostVisibilityView()
    }
}
