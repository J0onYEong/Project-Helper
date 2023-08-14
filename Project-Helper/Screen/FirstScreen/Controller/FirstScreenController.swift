//
//  FirstScreenController.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/08/14.
//

import SwiftUI

class FirstScreenController: ObservableObject {
    
    @Published var screenState: FirstScreenState = .initialState
    
    @Published var titleViewState: FSTitleViewState = .initialState
    @Published var loginOptViewState: FSLoginOpState = .initialState
    @Published var enterEmailViewState: EnterEmailViewState = .initialState
    @Published var emailWaitingViewState: EmailWaitingViewState = .initialState
    
    func redirectionComplete(url: URL) {
        LoginManager.shared.authenticationWithLink(link: url) { result in
            switch result {
            case .success(let authData):
                
                //take5(메인페이지로 화면전환) 예정
                
                return
            case .failure(let error):
                print("이메일 로그인 과정에서 에러발생")
                //재입력
                self.screenState = .take3
                return
            }
        }
    }
}


extension FirstScreenController {
    func take1() {
        loginOptViewState = .disappear
        titleViewState = .idle
        enterEmailViewState = .inactive
        emailWaitingViewState = .disappear
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            self.enterEmailViewState = .disappear
        }
    }
    
    func take2() {
        titleViewState = .upward
        emailWaitingViewState = .disappear
        Timer.scheduledTimer(withTimeInterval: FSTitleViewState.upward.animTime, repeats: false) { _ in
            self.loginOptViewState = .appear
        }
        
        enterEmailViewState = .inactive
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            self.enterEmailViewState = .disappear
        }
    }
    
    //email옵션이 선택된 경우
    func take3() {
        titleViewState = .disappear
        loginOptViewState = .disappear
        emailWaitingViewState = .disappear
        
        enterEmailViewState = .appear
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            self.enterEmailViewState = .active
        }
    }
    
    func take4() {
        enterEmailViewState = .inactive
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            self.enterEmailViewState = .disappear
            self.emailWaitingViewState = .appear
        }
    }
}
