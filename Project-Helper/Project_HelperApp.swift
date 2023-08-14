//
//  Project_HelperApp.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/07/14.
//

import SwiftUI
import FirebaseCore
import FirebaseDynamicLinks

@main
struct Project_HelperApp: App {
    
    @UIApplicationDelegateAdaptor(MyAppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            MainScene()
        }
    }
}

class MyAppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
