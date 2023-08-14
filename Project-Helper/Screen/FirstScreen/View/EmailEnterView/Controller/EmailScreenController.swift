//
//  EnterEmailViewController.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/07/28.
//

import SwiftUI

class EnterEmailViewController: ObservableObject {
    //input
    @Published var email = ""
    
    //submit animation
    @Published var wrongFormatNoti = WrongFormatNotification()
    
    //TextFeild
    @Published var lineColor: Color = .sunflower
    
    //Delete Button
    @Published var deleteBtnColor: Color = .sunflower
    @Published var showingDeleteBtn = false
    @Published var focusReqFromComtroller = false
    
    //Error
    @Published var error: EmailAuthError? = nil
    @Published var showAlert = false
    
    //Screen Option
    private(set) var bgColor: Color = .idleBackground
    
    var isEmailForm: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let regex = try! NSRegularExpression(pattern: emailRegex)
        let matches = regex.matches(in: email, range: NSRange(email.startIndex..., in: email))
        return !matches.isEmpty
    }
    
    //Reset State
    func onDeleteBtnPressed() {
        email = ""
        focusReqFromComtroller = true
        resetUIConfig()
    }
    
    func resetUIConfig() {
        lineColor = .sunflower
        deleteBtnColor = .sunflower
        showingDeleteBtn = false
        
        wrongFormatNoti.resetConfig()
    }
    
    func resetAllConfig() {
        email = ""
        
        resetUIConfig()
        
        error = nil
        showAlert = false
        
        wrongFormatNoti.resetConfig()
    }
    
    func validationFailureConf() {
        lineColor = .softWarning
        deleteBtnColor = .softWarning
        
        wrongFormatNoti.setToWrongEmail()
        
        withAnimation(.interpolatingSpring(stiffness: 10000, damping: 20)) {
            wrongFormatNoti.damping()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.wrongFormatNoti.clearScale()
        }
    }
    
    func validationSuccessConf() {
        lineColor = .sunflower
        wrongFormatNoti.clearText()
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
}

extension EnterEmailViewController {
    struct WrongFormatNotification {
        var scaleAmount = 1.0
        private(set) var text = ""
        
        private let targetScaleAmount = 1.1
        private let targetWarningStr = "잘못된 이메일 형식입니다."
        
        mutating func resetConfig() {
            clearText()
            clearScale()
        }
        
        mutating func setToWrongEmail() {
            text = targetWarningStr
        }
        
        mutating func damping() {
            scaleAmount = targetScaleAmount
        }
        
        mutating func clearText() { text = "" }
        mutating func clearScale() { scaleAmount = 1.0 }
    }
}
