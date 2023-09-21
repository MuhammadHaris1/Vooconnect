//
//  VooconnectApp.swift
//  Vooconnect
//
//  Created by Voconnect on 01/11/22.
//

import SwiftUI
import Swinject
import CoreData
import FBSDKCoreKit
import TwitterKit
import FBSDKShareKit
import FBSDKLoginKit
import AppTrackingTransparency

// Set global logger object
let logger = Logger()

// Set global DI objects container
private let container = Container.default.container

@main
struct VooconnectApp: App {
    
    @State private var showLaunchView: Bool = true
    @State private var isAnimating: Bool = false
    
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let uuid = UserDefaults.standard.string(forKey: "uuid")
    let tokenData = UserDefaults.standard.string(forKey: "accessToken")
    
    var body: some Scene {
        
        WindowGroup {
            ZStack {
                if isOnboarding {
                    OnBoardingView()
                } else if uuid == nil || tokenData == nil {
                    ConnectWithEmailAndPhoneView(isFromSwitchProfile: .constant(false))
                } else {
                    HomePageView()
                }
            }
            .overlay {
                LaunchView()
            }
//            ARGearView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    static private(set) var shared: AppDelegate! = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.shared = self
        
        // Facebook SDK Stuff
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Twitter SDK Stuff
        TWTRTwitter.sharedInstance().start(withConsumerKey: "HArguc8AeZe1mNtWnbtmI020q", consumerSecret: "Oyi2XaeVJTz3dGp8MCyWZKm2MnlBYImOvPNt8H6cM5Uizi7fFm")
        
        registerDIObjects()
        
        // Ask for Tracking
        requestTracking()
        RealmManager.shared.checkAndMigration()
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig: UISceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "VooconnectModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate{
    
    /// Register the DI objects that will be used in this app and also run some methods
    func registerDIObjects(){
        
        // Register UserAuthenticationManager
        UserAuthenticationManagerFactory.register(with: container)
        
        // Register NetworkAuthenticationModel
        let tempNetworkAuthenticationModel = NetworkAuthenticationModel()
        container.register(NetworkAuthenticationModel.self) { _ in tempNetworkAuthenticationModel }
        
        // Register AppEventsManager
        let tempAppEventsManager = AppEventsManager()
        container.register(AppEventsManager.self) { _ in  tempAppEventsManager }
        
        // Register GeneralManager
        GeneralManagerFactory.register(with: container)
    }
}

extension AppDelegate{
    func requestTracking(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print("Authorized ...")
                case .denied:
                    print("User has denied tracking")
                case .notDetermined:
                    print("Tracking authorization has not yet been determined")
                case .restricted:
                    print("Tracking is restricted on this device")
                @unknown default:
                    fatalError()
                }
            }
        }
    }
}


// MARK: - SceneDelegate

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        
        if url.absoluteString.contains("twitter") {
            TWTRTwitter.sharedInstance().scene(scene, openURLContexts: URLContexts)
        } else if url.absoluteString.contains("fb") {
            ApplicationDelegate.shared.application(
                UIApplication.shared,
                open: url,
                sourceApplication: nil,
                annotation: [UIApplication.OpenURLOptionsKey.annotation])
        }
    }
    

}
