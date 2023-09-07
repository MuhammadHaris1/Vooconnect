//
//  CategoryView.swift
//  Vooconnect
//
//  Created by Farooq Haroon on 6/3/23.
//

//import Foundation
import SwiftUI


struct CatBotSheetView: View {
    @State private var entertainment: Bool = false
    @State private var gaming: Bool = false
    @State private var art: Bool = false
    @State private var animals: Bool = false
    @State private var comedy: Bool = false
    @State private var dance: Bool = false
    @State private var beauty: Bool = false
    @State private var music: Bool = false
    @State private var foodAndDrink: Bool = false
    @State private var sports: Bool = false
    @State private var diy: Bool = false
    @State private var scienceAndEducation: Bool = false
    @State private var travel: Bool = false
    @State private var family: Bool = false
    @State private var animeAndMovie: Bool = false
    @State private var technology: Bool = false
    @State private var outdoors: Bool = false
    @State private var culture: Bool = false
    @State private var health: Bool = false
    @State private var comics: Bool = false
    @ObservedObject var viewModel = CategoryViewModel()
    @State var selectedCat: Int
    var onItemSelected: ((Int) -> Void)?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.white)
                    .ignoresSafeArea()
                
                    VStack {
                        Spacer()
                        
                        VStack (alignment: .center){
                            
                            Text("Choose Your Interest")
                                .font(.custom("Urbanist-Bold", size: 24))
                                .foregroundColor(Color(#colorLiteral(red: 0.1726317704, green: 0.1726317704, blue: 0.1726317704, alpha: 1)))
//                                .foregroundColor(.black)
                                .padding(.leading, 10)
                        }
                        .padding(.leading)

                        ScrollView {
                            
                            VStack(spacing: 20) {
                                HStack {
                                    Text("Choose your interests and get the best video recommendations.")
                                        .font(.custom("Urbanist-Medium", size: 18))
                                        .foregroundColor(Color(#colorLiteral(red: 0.1726317704, green: 0.1726317704, blue: 0.1726317704, alpha: 1)))
                                        .multilineTextAlignment(.leading)
                                        .padding(.trailing)
                                        .padding(.top, 10)
                                    Spacer()
                                }
                                //Urbanist-Medium.ttf
                                
                                // One 1
                                HStack(spacing: 17) {
                                    
                                    Button {
                                        entertainment.toggle()
//                                        updateInterestVM.updateInterestDataModel.interestID.append(1)
                                        selectedCat = 1
                                        onItemSelected?(selectedCat)
                                    } label: {
                                        Text("Entertainment")
                                    }
                                    .buttonStyle(CatButtonStyle(isSelected: selectedCat == 1))
                                    
//                                    .background(
//                                        LinearGradient(colors: [
//                                            Color("buttionGradientTwo"),
//                                            Color("buttionGradientOne"),
//                                        ], startPoint: .topLeading, endPoint: .bottomTrailing)
//                                    )
                                    
                                    Button {
                                        gaming.toggle()
                                        selectedCat = 2
                                        onItemSelected?(selectedCat)
//                                        updateInterestVM.updateInterestDataModel.interestID.append(2)
                                        
                                    } label: {
                                        Text("Gaming")
                                    }
                                    .buttonStyle(CatButtonStyle(isSelected: selectedCat == 2))

                                    
                                    
                                    Spacer()
                                }
                                
                                // One 2
                                HStack(spacing: 17) {
                                    
                                    Button {
                                        art.toggle()
//                                        updateInterestVM.updateInterestDataModel.interestID.append(3)
                                        selectedCat = 3
                                        onItemSelected?(selectedCat)
                                    } label: {
                                        Text("Art")
                                    }
                                    .buttonStyle(CatButtonStyle(isSelected: selectedCat == 3))
                                    
                                    Button {
                                        animals.toggle()
//                                        updateInterestVM.updateInterestDataModel.interestID.append(4)
                                        selectedCat = 4
                                        onItemSelected?(selectedCat)
                                    } label: {
                                        Text("Animals")
                                    }
                                    .buttonStyle(CatButtonStyle(isSelected: selectedCat == 4))
                                    
                                    Button {
                                        comedy.toggle()
//                                        updateInterestVM.updateInterestDataModel.interestID.append(5)
                                        selectedCat = 5
                                        onItemSelected?(selectedCat)
                                    } label: {
                                        Text("Comedy")
                                    }
                                    .buttonStyle(CatButtonStyle(isSelected: selectedCat == 5))
                                    
                                    Spacer()
                                }
                                
                                // One 3
                                HStack(spacing: 17) {
                                    
                                    Button {
                                        dance.toggle()
                                        selectedCat = 6
                                        onItemSelected?(selectedCat)
//                                        updateInterestVM.updateInterestDataModel.interestID.append(6)
                                    } label: {
                                        Text("Dance")
                                    }
                                    .buttonStyle(CatButtonStyle(isSelected: selectedCat == 6))
                                    
                                    Button {
                                        beauty.toggle()
//                                        updateInterestVM.updateInterestDataModel.interestID.append(7)
                                        selectedCat = 7
                                        onItemSelected?(selectedCat)
                                    } label: {
                                        Text("Beauty")
                                    }
                                    .buttonStyle(CatButtonStyle(isSelected: selectedCat == 7))
                                    
                                    Button {
                                        music.toggle()
//                                        updateInterestVM.updateInterestDataModel.interestID.append(8)
                                        selectedCat = 8
                                        onItemSelected?(selectedCat)
                                    } label: {
                                        Text("Music")
                                    }
                                    .buttonStyle(CatButtonStyle(isSelected: selectedCat == 8))
                                    
                                    Spacer()
                                }
                                
                                // One 4
                                HStack(spacing: 17) {
                                    
                                    Button {
                                        foodAndDrink.toggle()
//                                        updateInterestVM.updateInterestDataModel.interestID.append(9)
                                        selectedCat = 9
                                        onItemSelected?(selectedCat)
                                    } label: {
                                        Text("Food & Drink")
                                    }
                                    .buttonStyle(CatButtonStyle(isSelected: selectedCat == 9))
                                    
                                    Button {
                                        sports.toggle()
//                                        updateInterestVM.updateInterestDataModel.interestID.append(10)
                                        selectedCat = 10
                                        onItemSelected?(selectedCat)
                                    } label: {
                                        Text("Sports")
                                    }
                                    .buttonStyle(CatButtonStyle(isSelected: selectedCat == 10))
                                    
                                    
                                    Spacer()
                                }
                                
                                // One 5
                                HStack(spacing: 17) {
                                    
                                    Button {
                                        scienceAndEducation.toggle()
//                                        updateInterestVM.updateInterestDataModel.interestID.append(11)
                                        selectedCat = 11
                                        onItemSelected?(selectedCat)
                                    } label: {
                                        Text("Science & Education")
                                    }
                                    .buttonStyle(CatButtonStyle(isSelected: selectedCat == 11))
                                    
                                    Button {
                                        travel.toggle()
//                                        updateInterestVM.updateInterestDataModel.interestID.append(12)
                                        selectedCat = 12
                                        onItemSelected?(selectedCat)
                                    } label: {
                                        Text("Travel")
                                    }
                                    .buttonStyle(CatButtonStyle(isSelected: selectedCat == 12))
                                    
                                    
                                    Spacer()
                                }
                                
                                // One 6
                                HStack(spacing: 17) {
                                    
                                    Button {
                                        family.toggle()
//                                        updateInterestVM.updateInterestDataModel.interestID.append(13)
                                        selectedCat = 13
                                        onItemSelected?(selectedCat)
                                    } label: {
                                        Text("Family")
                                    }
                                    .buttonStyle(CatButtonStyle(isSelected: selectedCat == 13))
                                    
                                    Button {
                                        animeAndMovie.toggle()
//                                        updateInterestVM.updateInterestDataModel.interestID.append(14)
                                        selectedCat = 14
                                        onItemSelected?(selectedCat)
                                    } label: {
                                        Text("Anime & Movie")
                                    }
                                    .buttonStyle(CatButtonStyle(isSelected: selectedCat == 14))
                                    
                                    
                                    Spacer()
                                }
                                
                                // One 7
                                HStack(spacing: 17) {
                                    
                                    Button {
                                        technology.toggle()
//                                        updateInterestVM.updateInterestDataModel.interestID.append(15)
                                        selectedCat = 15
                                        onItemSelected?(selectedCat)
                                    } label: {
                                        Text("Technology")
                                    }
                                    .buttonStyle(CatButtonStyle(isSelected: selectedCat == 15))
                                    
                                    Button {
                                        outdoors.toggle()
//                                        updateInterestVM.updateInterestDataModel.interestID.append(16)
                                        selectedCat = 16
                                        onItemSelected?(selectedCat)
                                    } label: {
                                        Text("Outdoors")
                                    }
                                    .buttonStyle(CatButtonStyle(isSelected: selectedCat == 16))
                                    
                                    
                                    Spacer()
                                }
                                
                                // One 8
                                HStack(spacing: 17) {
                                    
                                    Button {
                                        culture.toggle()
//                                        updateInterestVM.updateInterestDataModel.interestID.append(17)
                                        selectedCat = 17
                                        onItemSelected?(selectedCat)
                                    } label: {
                                        Text("Culture")
                                    }
                                    .buttonStyle(CatButtonStyle(isSelected: selectedCat == 17))
                                    
                                    Button {
                                        health.toggle()
//                                        updateInterestVM.updateInterestDataModel.interestID.append(18)
                                        selectedCat = 18
                                        onItemSelected?(selectedCat)
                                    } label: {
                                        Text("Health")
                                    }
                                    .buttonStyle(CatButtonStyle(isSelected: selectedCat == 18))
                                    
                                    Spacer()
                                }
                                
                                // One 9
                                HStack(spacing: 17) {
                                    Button {
                                        comics.toggle()
//                                        updateInterestVM.updateInterestDataModel.interestID.append(19)
                                        selectedCat = 19
                                        onItemSelected?(selectedCat)
                                    } label: {
                                        Text("Comics")
                                    }
                                    .buttonStyle(CatButtonStyle(isSelected: selectedCat == 19))
                                    
                                    
                                    Button {
                                        diy.toggle()
//                                        updateInterestVM.updateInterestDataModel.interestID.append(20)
                                        selectedCat = 20
                                        onItemSelected?(selectedCat)
                                    } label: {
                                        Text("DIY")
                                    }
                                    .buttonStyle(CatButtonStyle(isSelected: selectedCat == 20))
                                    
                                    Spacer()
                                }
                                
                            }
                            .padding(.leading)
                            .padding(.bottom, 40)
                            
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct CatButtonStyle : ButtonStyle {
    var isSelected: Bool
 
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("Urbanist-Bold", size: 18))
            .foregroundColor(isSelected ? .white : Color("buttionGradientOne"))
            .padding(.horizontal, 22)
            .padding(.vertical, 10)
            .background(isSelected ? LinearGradient(colors: [
                Color("buttionGradientTwo"),
                Color("buttionGradientOne"),
                Color("buttionGradientOne"),
            ], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [
                Color.clear,
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .cornerRadius(25)
            .overlay(isSelected ? RoundedRectangle(cornerRadius: 25).stroke(Color.clear, lineWidth: 0) : RoundedRectangle(cornerRadius: 25).stroke(Color("buttionGradientOne"), lineWidth: 1.5))
    }
}
