//
//  EmailLoginWaitingView.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/08/14.
//

import SwiftUI

enum EmailWaitingViewState: ViewState {
    static var initialState: EmailWaitingViewState = .congestion
    
    case appear, disappear, active, inactive, congestion
    
    var desciption: String {
        switch self {
        case .appear:
            return "appear"
        case .disappear:
            return "disappear"
        case .active:
            return "active"
        case .inactive:
            return "inactive"
        case .congestion:
            return "congestion"
        }
    }
}

struct EmailLoginWaitingView: View {
    //
    @Binding var viewState: EmailWaitingViewState
    
    //
    @State private var dsViewState: DSViewState = .initialState
    @State private var viewOffset: CGSize = originOffset
    
    //
    static private var originOffset = CGSize(width: 500, height: 0)
    static private var targetOffset = CGSize(width: 0, height: 0)
    
    var body: some View {
        Group {
            DynamicShowingText(viewState: $dsViewState, string: "이메일 기다리는중", mainColor: .white, bgColor: .sunflower)
        }
        .offset(viewOffset)
        .onChange(of: viewState) { state in
            switch state {
            case .appear:
                viewOffset = Self.targetOffset
            case .disappear:
                viewOffset = Self.originOffset
            case .active:
                dsViewState = .active
            case .inactive:
                dsViewState = .inactive
            case .congestion:
                return
            }
        }
        
    }
}

fileprivate struct TestView: View {
    @State private var state: EmailWaitingViewState = .initialState
    var body: some View {
        ZStack {
            Color.idleBackground
                .ignoresSafeArea()
            
            EmailLoginWaitingView(viewState: $state)

            VStack {
                Spacer()
                Spacer()
                HStack { ForEach(EmailWaitingViewState.allCases, id: \.self) { st in Button(st.desciption) { state = st } } }
                Spacer()
            }
        }
    }
}


struct EmailLoginWaitingView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
