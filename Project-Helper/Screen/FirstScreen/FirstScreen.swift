//
//  FirstScreen.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/07/28.
//

import SwiftUI

enum FirstScreenState: ViewState, Equatable {
    static var initialState: FirstScreenState = .congestion
    
    var id: UUID { UUID() }
    
    case take1, take2, take3, take4, congestion
    
    var desciption: String {
        switch self {
        case .take1:
            return "take1"
        case .take2:
            return "take2"
        case .take3:
            return "take3"
        case .take4:
            return "take4"
        case .congestion:
            return "congestion"
        }
    }
}
    
struct FirstScreen: View {
    @Binding var forTest: FirstScreenState
    
    @StateObject private var controller = FirstScreenController()
    
    var body: some View {
        ZStack {
            Color.idleBackground
                .ignoresSafeArea()
                .zIndex(0)
            
            FSLoginOptionView(viewState: $controller.loginOptViewState)
                .zIndex(1)
            
            FSTitleView(viewState: $controller.titleViewState)
                .zIndex(2)
            
            EnterEmailView(viewState: $controller.enterEmailViewState)
                .zIndex(3)
            
            EmailLoginWaitingView(viewState: $controller.emailWaitingViewState)
                .zIndex(3)
            
        }
        .onChange(of: controller.screenState) { state in
            switch state {
            case .take1:
                controller.take1()
            case .take2:
                controller.take2()
            case .take3:
                controller.take3()
            case .take4:
                controller.take4()
                return
            case .congestion:
                return
            }
        }
        .onChange(of: controller.loginOptViewState) { state in
            if state == .emailOptionClicked { controller.screenState = .take3 }
        }
        .onChange(of: controller.enterEmailViewState) { state in
            if state == .submitSuccess { controller.screenState = .take4 }
        }
        .onOpenURL {
            
            //!!현재 리다이렉션을 통한 앱호출이 로그인 밖에 없음으로 우선 url구분없이 진행
            controller.redirectionComplete(url: $0)
            
        }
        .onChange(of: forTest) { state in
            //!!!후에 삭제
            controller.screenState = state
        }
    }
}

fileprivate struct TestView: View {
    @State private var state: FirstScreenState = .congestion
    var body: some View {
        ZStack {
            Color.idleBackground
                .ignoresSafeArea()
            FirstScreen(forTest: $state)
            
            VStack {
                Spacer()
                Spacer()
                Spacer()
                HStack { ForEach(FirstScreenState.allCases, id: \.self) { st in Button(st.desciption) { state = st } } }
                Spacer()
            }
        }
    }
}

struct FirstScreen_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
