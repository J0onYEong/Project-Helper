//
//  LoginManager.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/07/22.
//

import Foundation
import FirebaseAuth
import FirebaseEmailAuthUI

class LoginManager {
    enum EmailLoginType {
        case newSignIn
        case addSignIn
        case reSignIn
    }
    
    
    private init() { }
    
    static let shared = LoginManager()
    
    var currentUser: AuthDataResult?

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
    
    func authenticationWithLink(link: URL, signInType: EmailLoginType = .newSignIn) {
        let linkStr = link.absoluteString
        UserDefaults.standard.set(link, forKey: "Link")
        guard let email = UserDefaults.standard.string(forKey: "Email") else {
            print("저장된 이메일이 없음")
            return;
        }
        
        if Auth.auth().isSignIn(withEmailLink: linkStr) {
            switch signInType {
            case .newSignIn:
                Auth.auth().signIn(withEmail: email, link: linkStr) {[weak self] user, error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    self?.currentUser = user
                }
            case .addSignIn:
                let credential = EmailAuthProvider.credential(withEmail:email, link:linkStr)
                Auth.auth().currentUser?.link(with: credential) { authData, error in
                    if let error = error {
                      // And error occurred during linking.
                      return
                    }
                    // The provider was successfully linked.
                    // The phone user can now sign in with their phone number or email.
                }
            case .reSignIn:
                let credential = EmailAuthProvider.credential(withEmail:email, link:linkStr)
                Auth.auth().currentUser?.reauthenticate(with: credential) { authData, error in
                  if let error = error {
                    // And error occurred during re-authentication.
                    return
                  }
                  // The user was successfully re-authenticated.
                }
            }
        }
    }
}
