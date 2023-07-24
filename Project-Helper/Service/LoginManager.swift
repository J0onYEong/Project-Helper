//
//  LoginManager.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/07/22.
//

import Foundation
import FirebaseAuth


struct LoginManager {
    

    func createEmailLink() {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "project-helper-426b0.firebaseapp.com")
        // The sign-in operation has to always be completed in the app.
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        actionCodeSettings.setAndroidPackageName("com.example.android", installIfNotAvailable: false, minimumVersion: "12")
    }
}
