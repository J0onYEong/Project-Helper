//
//  EmailLoginWaitingView.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/08/14.
//

import SwiftUI

enum EmailWaitingViewState: ViewState {
    static var initialState: EmailWaitingViewState = .congestion
    
    case appear, disappear, congestion
    
    var desciption: String {
        switch self {
        case .appear:
            return "appear"
        case .disappear:
            return "disappear"
        case .congestion:
            return "congestion"
        }
    }
}


struct EmailLoginWaitingView: View {
    @Binding var viewState: EmailWaitingViewState
    
    @State private var viewOffset: CGSize = originOffset
    
    static private var originOffset = CGSize(width: 500, height: 0)
    static private var targetOffset = CGSize(width: 0, height: 0)
    
    var body: some View {
        Group {
            Text("이메일이 발송되었어요! 메일함을 확인해주세요!")
        }
        .offset(viewOffset)
        .onChange(of: viewState) { state in
            switch state {
            case .appear:
                viewOffset = Self.targetOffset
            case .disappear:
                viewOffset = Self.targetOffset
            case .congestion:
                return
            }
        }
        
    }
}

//struct EmailLoginWaitingView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmailLoginWaitingView()
//    }
//}
