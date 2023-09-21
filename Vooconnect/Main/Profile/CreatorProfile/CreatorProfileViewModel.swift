//
//  CreatorProfileViewModel.swift
//  Vooconnect
//
//  Created by Online Developer on 11/03/2023.
//

import SwiftUI
import Swinject

enum SelectedImageType{
    case profile
    case cover
}

class CreatorProfileViewModel: ObservableObject{
    private var userAuthanticationManager = Container.default.resolver.resolve(UserAuthenticationManager.self)!
    private var generalManager = Container.default.resolver.resolve(GeneralManager.self)!
    private var appEventsManager = Container.default.resolver.resolve(AppEventsManager.self)!
    
    /// Suggested Users
    @Published var suggestedUsers: [UserDetail] = []
    
    /// User detail
    @Published var userDetail: UserDetail?
    /// User Stats
    @Published var userStats: Stats?
    /// User Posts
    @Published var userPosts: [Post] = []
    /// Private Posts
    @Published var privatePosts: [Post] = []
    /// Bookmarked Posts
    @Published var bookmarkedPosts: [Post] = []
    /// Favourite Posts
    @Published var favouritePosts: [Post] = []
    
    /// Navigate to creator search view
    @Published var navigateToCreatorSearchView: Bool = false
    
    /// Checking current user is current user or other user
    @Published var isCurrentUserProfile = false
    /// User Id
    @Published var userId = ""
    /// Share Profile
    @Published var shareProfile = false
    
    // Navigate From More Options
    @Published var selectedUserId = ""
    @Published var navigateToCreatorProfileView = false
    
    // Image Picker Values
    @Published var selectedProfilePhoto: UIImage = UIImage(named: "profileicon")!
    @Published var selectedCoverPhoto: UIImage = UIImage(named: "profileicon")!
    @Published var sourceType = UIImagePickerController.SourceType.photoLibrary
    @Published var isProfilePhotoSelected = false
    @Published var isCoverPhotoSelected = false
    @Published var selectedImageType: SelectedImageType = .profile
    @Published var isUpdating = false
    @Published var errorString = ""
    @Published var isPresentAlert = false
    
    @Published var presentSwitchProfileView = false
    @Published var navigateToFindFriends = false
    @Published var selectedPagerType: CreatorProfilePagerType = .post
    @Published var navigateToEditProfile = false
    @Published var navigateToProfileViewers = false
    
    init(id: String? = nil){
        getUserDetail(id: id)
        getSuggested()
    }
    
    /// Get User Detail
    func getUserDetail(id: String?){
        if let id{
            // If user is other user not current user then fetch detail from server
            userId = id
            fetchUserDetail(id: id)
            getUserStats(id: id)
            getPosts(id: id)
            getBookmarkedPosts(id: id)
            getFavouritePosts(id: id)
            profileViewed(userId: id)
        }else{
            // If user is current user then get the user detail from UserAuthanticationManager
            userDetail = userAuthanticationManager.userDetail
            let uuid = userDetail?.uuid ?? ""
            userId = uuid
            getUserStats(id: uuid)
            getPosts(id: uuid)
            getBookmarkedPosts(id: uuid)
            getFavouritePosts(id: uuid)
            getPrivatePosts(id: uuid)
            isCurrentUserProfile = true
        }
    }
    
    /// Get user location coordinates from its detail
    func getCoordinates() -> (Double?, Double?) {
        let lat = userDetail?.lat
        let long = userDetail?.lon
        return (lat, long)
    }
    
    /// Get user detail from server
    /// - Parameter id: uuid for getting user detail
    func fetchUserDetail(id: String){
        let params: [String: Any] = [
            "user_uuid": id
        ]
        NetworkManager.makeEndpointCall(fromEndpoint: .userDetail, withDataType: UserModel.self, parameters: params) { [weak self] result in
            switch result {
            case .success(let userModel):
                self?.userDetail = userModel.user
                logger.error("Successfully fetched user detail!!!", category: .profile)
            case .failure(let error):
                logger.error("Error Fetching User Detail: \(error.localizedDescription)", category: .network)
            }
        }
    }
    
    /// Getting current user full name
    func getFullName() -> String{
        let user = userDetail
        return (user?.firstName ?? "") + " " + (user?.lastName ?? "")
    }
    
    /// Get User Stats
    func getUserStats(id: String){
        let params: [String: Any] = [
            "user_uuid": id
        ]
        NetworkManager.makeEndpointCall(fromEndpoint: .getUserStats, withDataType: StatsModel.self, parameters: params) { [weak self] result in
            switch result {
            case .success(let statsModel):
                self?.userStats = statsModel.stats
                logger.error("Successfully fetched user stats!!!", category: .profile)
            case .failure(let error):
                logger.error("Error Fetching User Stats: \(error.localizedDescription)", category: .profile)
            }
        }
    }
    
    /// Get User Posts
    func getPosts(id: String){
        let params: [String: Any] = [
            "user_uuid": id
        ]
        NetworkManager.makeEndpointCall(fromEndpoint: .getPosts, withDataType: PostsModel.self, parameters: params) { [weak self] result in
            switch result {
            case .success(let postModel):
                logger.error("Successfully fetched user posts!!!", category: .profile)
                guard let posts = postModel.posts else { return }
                self?.userPosts = posts
            case .failure(let error):
                logger.error("Error Fetching User Posts: \(error.localizedDescription)", category: .profile)
            }
        }
    }
    
    /// Get Bookmarked Posts
    func getBookmarkedPosts(id: String){
        let params: [String: Any] = [
            "user_uuid": id
        ]
        NetworkManager.makeEndpointCall(fromEndpoint: .getBookmarkedPosts, withDataType: PostsModel.self, parameters: params) { [weak self] result in
            switch result {
            case .success(let postModel):
                logger.error("Successfully fetched user bookmarked posts!!!", category: .profile)
                guard let posts = postModel.posts else { return }
                self?.bookmarkedPosts = posts
            case .failure(let error):
                logger.error("Error Fetching User Bookmarked Posts: \(error.localizedDescription)", category: .profile)
            }
        }
    }
    
    /// Get Favourite Posts
    func getFavouritePosts(id: String){
        let params: [String: Any] = [
            "user_uuid": id
        ]
        NetworkManager.makeEndpointCall(fromEndpoint: .getFavoritePosts, withDataType: PostsModel.self, parameters: params) { [weak self] result in
            switch result {
            case .success(let postModel):
                logger.error("Successfully fetched user favourite posts!!!", category: .profile)
                guard let posts = postModel.posts else { return }
                self?.favouritePosts = posts
            case .failure(let error):
                logger.error("Error Fetching User Favourite Posts: \(error.localizedDescription)", category: .profile)
            }
        }
    }
    
    /// Get Private Posts
    func getPrivatePosts(id: String){
        let params: [String: Any] = [
            "user_uuid": id
        ]
        NetworkManager.makeEndpointCall(fromEndpoint: .getPrivatePosts, withDataType: PostsModel.self, parameters: params) { [weak self] result in
            switch result {
            case .success(let postModel):
                logger.error("Successfully fetched user favourite posts!!!", category: .profile)
                guard let posts = postModel.posts else { return }
                self?.privatePosts = posts
            case .failure(let error):
                logger.error("Error Fetching User Favourite Posts: \(error.localizedDescription)", category: .profile)
            }
        }
    }
    
    /// Upload Profile Image or Cover Image
    func uploadFile(onComplete: ((String)->())?){
        let params: [String: Any] = [
            "upload_path": selectedImageType == .cover ? "cover" : "profile"
        ]
        let image = selectedImageType == .cover ? selectedCoverPhoto : selectedProfilePhoto
        let imageData = image.jpegData(compressionQuality: 1)!
        let media = Media(withMediaData: imageData, forKey: "asset", withMimeType: .photo)
        NetworkManager.makeEndpointCall(fromEndpoint: .uploadFile, withDataType: UploadFileModel.self, parameters: params, mediaData: media) { [weak self] result in
            switch result {
            case .success(let model):
                logger.error("Successfully uploaded the image", category: .profile)
                if let url = model.data?.first?.name {
                    onComplete?(url)
                }
            case .failure(let error):
                logger.error("Error Uploading the image: \(error.localizedDescription)", category: .profile)
                self?.isUpdating = false
                self?.errorString = "Error Uploading the image: \(error.localizedDescription)"
                self?.isPresentAlert = true
            }
        }
    }
    
    /// Upload the profile or cover iamge to the BE and then update the user profile
    func updateUserProfile(){
        isUpdating = true
        uploadFile { [weak self] url in
            
            let model = UpdateProfileModel(
                profileImage: self?.selectedImageType == .profile ? url : nil,
                coverImage: self?.selectedImageType == .cover ? url : nil
            )
            
            self?.generalManager.updateProfile(model: model) { (isSuccess, error) in
                self?.isUpdating = false
                self?.appEventsManager.updateProfileImage.send(true)
                if error == nil{
                    logger.info("Profile updated successfully.", category: .profile)
                    self?.userAuthanticationManager.refreshUserDetails()
                }else{
                    self?.errorString = error ?? "Unknown error."
                    self?.isPresentAlert = true
                }
            }
        }
    }
    
    /// Get Current User's Suggested Users
    func getSuggested(){
        let userDetail = userAuthanticationManager.userDetail
        guard let latitude = userDetail?.lat, let longitude = userDetail?.lon else { return }
        let params: [String: Any] = [
            "lat": latitude,
            "lon": longitude
        ]
        NetworkManager.makeEndpointCall(fromEndpoint: .getSuggestedUsers, withDataType: GetUsersModel.self, parameters: params) { [weak self] result in
            switch result {
            case .success(let model):
                logger.info("Successfully got suggested users.", category: .profile)
                guard let users = model.users, users.count > 0 else { return }
                self?.suggestedUsers = users
            case .failure(let error):
                logger.info("Error getting suggested users.: \(error.localizedDescription)", category: .profile)
            }
        }
    }

    /// Profile viewed by current user
    func profileViewed(userId: String){
        let params: [String: Any] = ["user_uuid": userId]
        NetworkManager.makeEndpointCall(fromEndpoint: .profileViewed, withDataType: NilModel.self, parameters: params) { result in
            switch result {
            case .success(_):
                logger.info("Successfully viewed profile.", category: .profile)
            case .failure(let error):
                logger.info("Error While Viewing Profile: \(error.localizedDescription)", category: .profile)
            }
        }
    }
}
