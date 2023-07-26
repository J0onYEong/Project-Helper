//
//  LoginManager.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/07/22.
//

import Foundation
import FirebaseAuth

struct LoginManager {
    
    private init() { }
    
    static let shared = LoginManager()

    func createEmailLink(email: String) {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://choijunyeong.page.link/login-with-email")
        // The sign-in operation has to always be completed in the app.
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        
        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            UserDefaults.standard.set(email, forKey: "Email")
        }
    }
}
