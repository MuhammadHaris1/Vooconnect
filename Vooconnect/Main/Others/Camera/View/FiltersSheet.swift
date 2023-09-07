//
//  FiltersView.swift
//  Vooconnect
//
//  Created by Vooconnect on 15/12/22.
//

import SwiftUI
import UIKit

struct FiltersSheet: View {
    //    typealias UIViewType = MyView
    
    @State private var portrait: Bool = true
    @State private var landscape: Bool = false
    @State private var food: Bool = false
    @State private var vibe: Bool = false
    @State var isPresented = false
    @ObservedObject var cameraModel: CameraViewModel
    
//    @State var filters: [Item]
    
    var body: some View {
        VStack {
            
            Text("Filters")
                .font(.custom("Urbanist-Bold", size: 24))
                .padding(.top, 30)
            
            ScrollView(.horizontal) {
                
                // All Button
                HStack {
                    
                    Image("cutF")
                    Image("SearchF")
                    Image("SavedF")
                    
                    HStack(spacing: 20) {
                        
                        Button {
                            portrait = true
                            landscape = false
                            food = false
                            vibe = false
                        } label: {
                            VStack {
                                Text("Portrait")
                                    .font(.custom("Urbanist-SemiBold", size: 18))
                                    .foregroundStyle( portrait ?
                                                      LinearGradient(colors: [
                                                        Color("buttionGradientTwo"),
                                                        Color("buttionGradientOne"),
                                                      ], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [
                                                        Color("gray"),
                                                        Color("gray"),
                                                      ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                
                                
                                ZStack {
                                    if portrait {
                                        Capsule()
                                            .fill((
                                                LinearGradient(colors: [
                                                    Color("buttionGradientTwo"),
                                                    Color("buttionGradientOne"),
                                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                            ))
                                            .padding(.horizontal, -5)
                                            .frame(height: 4)
                                    } else {
                                        Capsule()
                                            .fill((
                                                LinearGradient(colors: [
                                                    Color("grayOne"),
                                                    Color("grayOne"),
                                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                            ))
                                            .padding(.trailing, -18)
                                            .frame(height: 2)
                                    }
                                }
                                .padding(.top, -5)
                            }
                        }
                        
                        Button {
                            portrait = false
                            landscape = true
                            food = false
                            vibe = false
                        } label: {
                            VStack {
                                Text("Landscape")
                                    .font(.custom("Urbanist-SemiBold", size: 18))
                                    .foregroundStyle( landscape ?
                                                      LinearGradient(colors: [
                                                        Color("buttionGradientTwo"),
                                                        Color("buttionGradientOne"),
                                                      ], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [
                                                        Color("gray"),
                                                        Color("gray"),
                                                      ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                
                                ZStack {
                                    if landscape {
                                        Capsule()
                                            .fill((
                                                LinearGradient(colors: [
                                                    Color("buttionGradientTwo"),
                                                    Color("buttionGradientOne"),
                                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                            ))
                                            .padding(.horizontal, -5)
                                            .frame(height: 4)
                                    } else {
                                        Capsule()
                                            .fill((
                                                LinearGradient(colors: [
                                                    Color("grayOne"),
                                                    Color("grayOne"),
                                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                            ))
                                            .padding(.leading, -15)
                                            .padding(.trailing, -40)
                                            .frame(height: 2)
                                    }
                                }
                                .padding(.top, -5)
                            }
                        }
                        
                        Button {
                            portrait = false
                            landscape = false
                            food = true
                            vibe = false
                        } label: {
                            VStack {
                                Text("Food")
                                    .font(.custom("Urbanist-SemiBold", size: 18))
                                    .foregroundStyle( food ?
                                                      LinearGradient(colors: [
                                                        Color("buttionGradientTwo"),
                                                        Color("buttionGradientOne"),
                                                      ], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [
                                                        Color("gray"),
                                                        Color("gray"),
                                                      ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                
                                
                                ZStack {
                                    if food {
                                        Capsule()
                                            .fill((
                                                LinearGradient(colors: [
                                                    Color("buttionGradientTwo"),
                                                    Color("buttionGradientOne"),
                                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                            ))
                                            .padding(.horizontal, -5)
                                            .frame(height: 4)
                                    } else {
                                        Capsule()
                                            .fill((
                                                LinearGradient(colors: [
                                                    Color("grayOne"),
                                                    Color("grayOne"),
                                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                            ))
                                            .padding(.leading, -16)
                                            .padding(.trailing, -20)
                                            .frame(height: 2)
                                    }
                                }
                                .padding(.top, -5)
                            }
                        }
                        
                        Button {
                            portrait = false
                            landscape = false
                            food = false
                            vibe = true
                        } label: {
                            VStack {
                                Text("Vibe")
                                    .font(.custom("Urbanist-SemiBold", size: 18))
                                    .foregroundStyle( vibe ?
                                                      LinearGradient(colors: [
                                                        Color("buttionGradientTwo"),
                                                        Color("buttionGradientOne"),
                                                      ], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [
                                                        Color("gray"),
                                                        Color("gray"),
                                                      ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                
                                
                                ZStack {
                                    if vibe {
                                        Capsule()
                                            .fill((
                                                LinearGradient(colors: [
                                                    Color("buttionGradientTwo"),
                                                    Color("buttionGradientOne"),
                                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                            ))
                                            .padding(.horizontal, -5)
                                            .frame(height: 4)
                                    } else {
                                        Capsule()
                                            .fill((
                                                LinearGradient(colors: [
                                                    Color("grayOne"),
                                                    Color("grayOne"),
                                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                            ))
                                            .padding(.leading, -15)
                                            .padding(.trailing, -5)
                                            .frame(height: 2)
                                    }
                                }
                                .padding(.top, -5)                            }
                        }
                        
                    } // Button HStack
                    .padding(.leading, 8)
                    
                } // HStack
                
            } // ScrollView
            .padding(.leading)
            
            ScrollView(showsIndicators: false) {
                
                LazyVGrid(columns: gridLayoutCF, alignment: .center, spacing: columnSpacingCF, pinnedViews: []) {
                    Section()
                    {
                        ForEach(cameraModel.filterData?.categories ?? [] ,id: \.self) { category in
                            ForEach(category.items ?? [] ,id: \.self) { item in
                                FiltersList(filter: item)
                            }
                        }
                    }
                    .sheet(isPresented: $isPresented) {
                        FiltersList()
                            .ignoresSafeArea()
                        
                    }
                    
                    //            ScrollView(showsIndicators: false) {
                    //
                    //                LazyVGrid(columns: gridLayoutCF, alignment: .center, spacing: columnSpacingCF, pinnedViews: []) {
                    //                    Section()
                    //                    {
                    //                        ForEach(0..<8) { people in
                    //                            FiltersList()
                    //                        }
                    //                    }
                    //                }
                    //                .padding(.top, 10)
                    //            }
                    
                    
                }
            }
        }
    }
}
        
//        struct FiltersSheet_Previews: PreviewProvider {
//            static var previews: some View {
//                FiltersSheet(cameraModel: CameraViewModel())
//            }
//        }
