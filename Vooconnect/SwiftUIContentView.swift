//
//  ContentView.swift
//  Vooconnect
//
//  Created by Voconnect on 01/11/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
//            LogInView()
            
            ConnectWithEmailAndPhoneView(isFromSwitchProfile: .constant(false))
            
//            CreateYourAccountView()
//            DashBordView()
//            OTPView()
//            ChooseYourInterestView()
//            GenderView()
//            TestView()
//            BirthDayView()
//            FillYourProfileView()
//            CreateNewPinView()
//            ForgotPasswordView()
//            CreateNewPasswordView()
//            ReelsView()
            
//            HomePageView()
            
//            CustomeCameraHome()
//            CustomeCameraHomeTwo()
//            FinalVideoToPostView()
//            CustomeSheetView()
//            AllMediaView()
//            SearchView()
//            SoundsView()
//            MyProfileView()
//            CreatorProfileView()
//            CreatorFollowersView()
//            LiveStreamingView()
//            GoLiveTogetherSheetView()
//            LiveViewersView()
//            GiftPanelSheet()
//            CommentSheet()
//            CommentList()
           
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


class UserdefaultsKey {
    static var streamTitle = "streamTitle"
    static var selectedTopics = "selectedTopics"
}
