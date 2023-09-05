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
    @Published var lineColor: Color = idleColor
    @Published var placeHolderString = ""
    
    //Delete Button
    @Published var deleteBtnColor: Color = idleColor
    @Published var showingDeleteBtn = false
    @Published var focusReqFromComtroller = false
    
    //Error
    @Published var error: EmailAuthError? = nil
    @Published var showAlert = false
    
    //Constant
    private static let idleColor: Color = .pointColor2
    private static let errorColor: Color = .errorTextColor
    
    var isEmailForm: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let regex = try! NSRegularExpression(pattern: emailRegex)
        let matches = regex.matches(in: email, range: NSRange(email.startIndex..., in: email))
        return !matches.isEmpty
    }
    
    func showPlaceHolder() {
        placeHolderString = "이메일을 입력하세요"
    }
    
    //Reset State
    func onDeleteBtnPressed() {
        email = ""
        focusReqFromComtroller = true
        resetUIConfig()
    }
    
    func resetUIConfig() {
        lineColor = Self.idleColor
        deleteBtnColor = Self.idleColor
        showingDeleteBtn = false
        
        //HidePlaceHolder
        placeHolderString = ""
        
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
        lineColor = Self.errorColor
        deleteBtnColor = Self.errorColor
        
        wrongFormatNoti.setToWrongEmail()
        
        withAnimation(.interpolatingSpring(stiffness: 10000, damping: 20)) {
            wrongFormatNoti.damping()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.wrongFormatNoti.clearScale()
        }
    }
    
    func validationSuccessConf() {
        lineColor = Self.idleColor
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
