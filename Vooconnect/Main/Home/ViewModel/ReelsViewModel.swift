//
//  ReelsViewModel.swift
//  Vooconnect
//
//  Created by Vooconnect on 03/12/22.
//

import Foundation
import SwiftUI
import Combine
import Swinject

class ReelsViewModel: ObservableObject {
    
//    @Published var allReels: [ReelsModel] = []
    @Published var allReels: [Post] = []
    
    init() {
        getAllReels()
    }
    
    private var sessionNextUrl = ""
    
    func getAllReels() {

        var urlRequest = URLRequest(url: URL(string:  getBaseURL + EndPoints.reels)!)
        urlRequest.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: urlRequest) { httpData, httpResponse, httpError in
            if let data = httpData {
                
                do {
                    
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    print("the json Data", jsonData)
                    
                    let decodedData = try JSONDecoder().decode(ReelsModel.self, from: data)
//                    print("The decoded data", decodedData.data?.posts?[0].title ?? "")
                    
                    DispatchQueue.main.async {
                        
                        self.allReels = decodedData.data?.posts ?? self.allReels
                        
//                        self.allReels = decodedData.data?.posts ?? self.allReels
//                        self.sessionNextUrl = decodedData.data?.nextPage ?? ""
                        
                    }
                    
                } catch {
                    
                    print("kfdjghsjdgkjdhgiunkjsnviersjcndfcg========")
                    
                }
                
            } else {
                
            }
            
        }.resume()

    }
    
}


class GetCreatorImageVM: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let allReels: Post
    private let dataService: CreatorImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(allReels: Post) {
        self.allReels = allReels
        self.dataService = CreatorImageService(creatorImage: allReels)
        self.addSubscribers()
        self.isLoading = true
    }
    
    private func addSubscribers() {
        dataService.$image
            .sink { [weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] (returendImage) in
                self?.image = returendImage
            }
            .store(in: &cancellables)

    }
    
}


class GetProfileImageVM: ObservableObject {    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let dataService: ProfileImageService
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.dataService = ProfileImageService()
        self.addSubscribers()
        self.isLoading = true
    }
    
    private func addSubscribers() {
        dataService.$image
            .sink { [weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] (returendImage) in
                self?.image = returendImage
            }
            .store(in: &cancellables)
    }
    
}
