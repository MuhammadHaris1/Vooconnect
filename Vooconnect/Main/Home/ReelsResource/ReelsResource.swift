//
//  ReelsResource.swift
//  Vooconnect
//
//  Created by Vooconnect on 03/12/22.
//

import Foundation
import SwiftUI
import Combine
import Swinject

class CreatorImageService {
    
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    private let allReels: Post
    
    init(creatorImage: Post) {
        self.allReels = creatorImage
        getCreatorImage()
    }
    
    private func getCreatorImage() {
        guard let url = URL(string: getImageVideoBaseURL + (allReels.creatorProfileImage ?? "")) else { return }

        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returendImage) in
                self?.image = returendImage
                self?.imageSubscription?.cancel()
            })

    }
    
}


class ProfileImageService: ObservableObject {
    private var cancellable = Set<AnyCancellable>()
    private var appEventsManager = Container.default.resolver.resolve(AppEventsManager.self)!
    private var userAuthenticationManager = Container.default.resolver.resolve(UserAuthenticationManager.self)!
    
    @Published var image: UIImage? = nil
    
    init() {
        getCreatorImage()
        updateProfileImageObserver()
    }
    
    var profileImage: String{
        return userAuthenticationManager.userDetail?.profileImage ?? ""
    }
    
    private func getCreatorImage() {
        guard let url = URL(string: getImageVideoBaseURL + profileImage) else { return }

        NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returendImage) in
                self?.image = returendImage!
            })
            .store(in: &cancellable)

    }
    
    // Update the Profile Image when user update it from profile
    private func updateProfileImageObserver(){
        appEventsManager.updateProfileImage
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] type in
                getCreatorImage()
            })
            .store(in: &cancellable)
    }
    
}
