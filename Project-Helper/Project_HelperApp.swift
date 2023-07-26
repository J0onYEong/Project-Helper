//
//  Project_HelperApp.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/07/14.
//

import SwiftUI
import FirebaseCore

@main
struct Project_HelperApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
