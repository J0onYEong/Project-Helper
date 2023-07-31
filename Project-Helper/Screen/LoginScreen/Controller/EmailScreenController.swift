//
//  EmailScreenController.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/07/28.
//

import SwiftUI

class EmailScreenController: ObservableObject {
    //input
    @Published var email = ""
    @Published var activeAnim = false
    
    //submit animation
    @Published var submitVar = SubmitVariation()
    
    //TextFeild
    @Published var lineColor: Color = .sunflower
    
    //Error
    @Published var error: EmailAuthError? = nil
    
    
    //Screen Option
    private(set) var bgColor: Color = .idleBackground
    
    var isEmailForm: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let regex = try! NSRegularExpression(pattern: emailRegex)
        let matches = regex.matches(in: email, range: NSRange(email.startIndex..., in: email))
        return !matches.isEmpty
    }
    
    func validationFailureConf() {
        lineColor = .softWarning
        
        submitVar.setToWrongEmail()
        
        withAnimation(.interpolatingSpring(stiffness: 10000, damping: 20)) {
            submitVar.damping()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.submitVar.clearScale()
        }
    }
    
    func validationSuccessConf() {
        lineColor = .sunflower
        submitVar.clearStr()
    }
    
    func editingChange(state: Bool) {
        if state {
            activeAnim = true
        }
    }
    
    func submit() -> Bool {
        if !isEmailForm {
            validationFailureConf()
            return false
        } else {
            validationSuccessConf()
            
            LoginManager.shared.createEmailLink(email: email) { self.error = $0 }
            return true
        }
    }
    
    func redirectionComplete(url: URL) {
        LoginManager.shared.authenticationWithLink(link: url) { self.error = $0 }
    }
}

extension EmailScreenController {
    struct SubmitVariation {
        var scaleAmount = 1.0
        var warningStr = ""
        
        private let targetScaleAmount = 1.1
        private let targetWarningStr = "잘못된 이메일 형식입니다."
        
        mutating func setToWrongEmail() {
            warningStr = targetWarningStr
        }
        
        mutating func clearStr() {
            warningStr = ""
        }
        
        mutating func damping() {
            scaleAmount = targetScaleAmount
        }
        
        mutating func clearScale() {
            scaleAmount = 1.0
        }
    }
}
