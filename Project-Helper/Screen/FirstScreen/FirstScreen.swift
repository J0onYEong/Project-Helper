//
//  FirstScreen.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/07/28.
//

import SwiftUI

enum FirstScreenState: CaseIterable, Identifiable, Hashable {
    var id: UUID { UUID() }
    
    case take1, take2, take3, congestion
    
    var desciption: String {
        switch self {
        case .take1:
            return "take1"
        case .take2:
            return "take2"
        case .take3:
            return "take3"
        case .congestion:
            return "congestion"
        }
    }
}
    
struct FirstScreen: View {
    
    @Binding var screenState: FirstScreenState

    @State private var titleViewState: FSTitleViewState = .congestion
    @State private var loginOptViewState: FSLoginOpState = .congestion
    @State private var enterEmailViewState: EnterEmailViewState = .congestion
    
    var body: some View {
        ZStack {
            Color.idleBackground
                .ignoresSafeArea()
                .zIndex(0)
            FSTitleView(viewState: $titleViewState)
            
            FSLoginOptionView(viewState: $loginOptViewState)
            
            EnterEmailView(viewState: $enterEmailViewState)
        }
        .onChange(of: screenState) { state in
            switch state {
            case .take1:
                take1()
            case .take2:
                take2()
            case .take3:
                take3()
            case .congestion:
                return
            }
        }
        .onChange(of: loginOptViewState) { state in
            if state == .clicked { screenState = .take3 }
        }
    }
}

extension FirstScreen {
    func take1() {
        loginOptViewState = .disappear
        titleViewState = .idle
        
        
        enterEmailViewState = .inactive
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            enterEmailViewState = .disappear
        }
    }
    
    func take2() {
        titleViewState = .upward
        Timer.scheduledTimer(withTimeInterval: FSTitleViewState.upward.animTime, repeats: false) { _ in
            loginOptViewState = .appear
        }
        
        
        enterEmailViewState = .inactive
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            enterEmailViewState = .disappear
        }
    }
    
    func take3() {
        titleViewState = .disappear
        loginOptViewState = .disappear
        
        
        enterEmailViewState = .appear
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            enterEmailViewState = .active
        }
    }
}

fileprivate struct TestView: View {
    @State private var state: FirstScreenState = .congestion
    var body: some View {
        ZStack {
            Color.idleBackground
                .ignoresSafeArea()
            FirstScreen(screenState: $state)
            
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
