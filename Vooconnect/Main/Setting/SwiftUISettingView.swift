//
//  SwiftUISettingView.swift
//  Vooconnect
//
//  Created by Vooconnect on 19/12/22.
//

import SwiftUI
import Swinject
import SDWebImageSwiftUI

struct SwiftUISettingView: View {
    var userAuthanticationManager = Container.default.resolver.resolve(UserAuthenticationManager.self)!
    
    @StateObject var settingViewModel = SettingViewModel()
    @Environment(\.presentationMode) var presentaionMode
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            
            VStack {
                
                // header
                HStack {
                    Text("Settings")
                        .font(.urbanist(name: .urbanistBold, size: 24))
                    Spacer()
                }
                .padding(.leading)
                
                // profile photo
                HeaderView()
                    .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 20){
                        ForEach(SettingRowType.settingCases, id: \.self){ settingTowType in
                            SettingRowView(settingRowType: settingTowType, settingViewModel: settingViewModel) {
                                settingViewModel.settingRowActions(settingRowType: settingTowType)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
            }
            .navigate(to: getViewToNavigate(destination: settingViewModel.selectedSettingRowType), when: $settingViewModel.navigate)
        }
    }
}

extension SwiftUISettingView{
    func HeaderView() -> some View{
        HStack {
            
            if let profileImage = userAuthanticationManager.userDetail?.profileImage, !profileImage.isEmpty{
                let url = NetworkConstants.ProductDefinition.BaseAPI.getImageVideoBaseURL.rawValue + profileImage
                WebImage(url: URL(string: url) ?? URL(string: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fcommons.wikimedia.org%2Fwiki%2FFile%3AProfile_avatar_placeholder_large.png")!)
                    .resizable()
                    .placeholder(Image("profileicon"))
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .cornerRadius(10)
            }else{
                Image("profileicon")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .cornerRadius(10)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text(settingViewModel.getFullName())
                    .font(.custom("Urbanist-Bold", size: 18))
                    .foregroundColor(Color(#colorLiteral(red: 0.1726317704, green: 0.1726317704, blue: 0.1726317704, alpha: 1)))
                
                Button{
                    settingViewModel.settingRowActions(settingRowType: .viewProfile)
                } label: {
                    Text("View Your Profile")
                        .font(.custom("Urbanist-Medium", size: 14))
                        .foregroundColor(Color(#colorLiteral(red: 0.4560062289, green: 0.4560062289, blue: 0.4560062289, alpha: 0.7020126242)))
                }
                
            }
            .padding(.leading, 10)
            
            Spacer()
            
        }
        .background(Color(#colorLiteral(red: 0.5921568627, green: 0.3098039216, blue: 1, alpha: 0.09827711093)))
        .cornerRadius(10)
    }
}

extension SwiftUISettingView{
    /// Get a view to navigate on which
    func getViewToNavigate(destination: SettingRowType) -> AnyView {
        switch destination {
        case .viewProfile: return AnyView(CreatorProfileView())
        case .logout: return AnyView(ConnectWithEmailAndPhoneView( isFromSwitchProfile: .constant(false)))
        case .privacyPolicy: return AnyView(PrivacyPolicyView())
        case .language: return AnyView(LanguageView())
        case .qrCode: return AnyView(QRCodeView())
        case .manageAccount: return AnyView(ManageAccountsView())
        case .creator: return AnyView(CreatorView())
        case .security: return AnyView(SecurityView())
        case .balance: return AnyView(BalanceView())
        default: return AnyView(EmptyView())
        }
    }
}
