//
//  LoginManager.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/07/22.
//

import Foundation
import FirebaseAuth
import FirebaseEmailAuthUI

enum EmailAuthError: Error {
    case emailSedingError
    case emailNotSaved
    case emailAuthenticationFailed
    
    var description: String {
        switch(self) {
        case .emailSedingError:
            return "이메일 전송중 오류가 발생했습니다."
        case .emailNotSaved:
            return "로컬 저장소에 문제가 발생했습니다."
        case .emailAuthenticationFailed:
            return "이메일을 사용한 인증에 실패했습니다."
        }
    }
}

class LoginManager {
    
    private init() { }
    
    static let shared = LoginManager()
    
    var currentUser: AuthDataResult?

    func createEmailLink(email: String, completion: ((EmailAuthError) -> ())? = nil) {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://choijunyeong.page.link/login-with-email")
        // The sign-in operation has to always be completed in the app.
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        
        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { error in
            if let _ = error {
                completion?(EmailAuthError.emailSedingError)
                return
            }
            
            UserDefaults.standard.set(email, forKey: "Email")
        }
    }
    
    func authenticationWithLink(link: URL, signInType: EmailLoginType = .newSignIn, completion: ((Result<AuthDataResult, EmailAuthError>) -> ())? = nil) {
        let linkStr = link.absoluteString
        UserDefaults.standard.set(link, forKey: "Link")
        guard let email = UserDefaults.standard.string(forKey: "Email") else {
            completion?(.failure(.emailNotSaved))
            return;
        }
        
        if Auth.auth().isSignIn(withEmailLink: linkStr) {
            switch signInType {
            case .newSignIn:
                Auth.auth().signIn(withEmail: email, link: linkStr) { authData, error in
                    if let _ = error { completion?(.failure(.emailAuthenticationFailed)); return }
                    
                    if let unwrappedAuthData = authData { completion?(.success(unwrappedAuthData)) }
                }
            case .addSignIn:
                let credential = EmailAuthProvider.credential(withEmail:email, link:linkStr)
                Auth.auth().currentUser?.link(with: credential) { authData, error in
                    if let _ = error { completion?(.failure(.emailAuthenticationFailed)); return }
                    
                    // The provider was successfully linked.
                    // The phone user can now sign in with their phone number or email.
                    if let unwrappedAuthData = authData { completion?(.success(unwrappedAuthData)) }
                    
                }
            case .reSignIn:
                let credential = EmailAuthProvider.credential(withEmail:email, link:linkStr)
                Auth.auth().currentUser?.reauthenticate(with: credential) { authData, error in
                    if let _ = error { completion?(.failure(.emailAuthenticationFailed)); return }
                    
                    // The user was successfully re-authenticated.
                    if let unwrappedAuthData = authData { completion?(.success(unwrappedAuthData)) }
                }
            }
        }
    }
}

extension LoginManager {
    enum EmailLoginType {
        case newSignIn
        case addSignIn
        case reSignIn
    }
}
