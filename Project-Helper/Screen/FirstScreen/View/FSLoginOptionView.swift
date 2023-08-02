//
//  FSLoginOptionView.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/08/01.
//

import SwiftUI

enum FSLoginOpState: CaseIterable, Identifiable, Hashable {
    var id: UUID { UUID() }
    
    case appear, disappear, clicked, congestion
    
    var desciption: String {
        switch self {
        case .appear:
            return "appear"
        case .disappear:
            return "disappear"
        case .clicked:
            return "clicked"
        case .congestion:
            return "congestion"
        }
    }
    
    var animTime: CGFloat {
        switch self {
        case .appear:
            return 0.1
        case .clicked:
            return 0.2
        case .disappear:
            return 0.2
        case .congestion:
            return 0.0
        }
    }
}



struct FSLoginOptionView: View {
    
    @Binding var viewState: FSLoginOpState
    
    @State private var btnScale = 0.0
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                Text("로그인 방식을 선택해 주세요")
                    .font(.blackHansSans(20))
                    .foregroundColor(.white)
                    .padding(.bottom, 15)
                    .scaleEffect(btnScale)
                    .font(Font(CTFont(.menuItem, size: 30)))
                
                HStack {
                    Spacer()
                    
                    Button {
                        viewState = .clicked
                        
                        
                    } label: {
                        ImageCircle(systemName: "apple.logo", lineColor: .sunflower)
                            .scaleEffect(btnScale)
                    }
                    
                    Spacer()
                    Spacer()
                    
                    Button {
                        viewState = .clicked
                        
                        
                    } label: {
                        ImageCircle(systemName: "envelope.fill", lineColor: .sunflower)
                            .scaleEffect(btnScale)
                    }
                    
                    Spacer()
                }
                .frame(maxHeight: 100)
            }
            .padding(.horizontal, 30)
            .position(x: geo.size.width/2, y: geo.size.height/2)
        }
        .onChange(of: viewState) { state in
            switch state {
            case .appear:
                appearToScreen()
            case .clicked:
                disappearFromScreen()
            case .disappear:
                disappearFromScreen()
            case .congestion:
                return
            }
        }
    }
}

extension FSLoginOptionView {
    func appearToScreen() {
        withAnimation(.interpolatingSpring(stiffness: 1000, damping: 20)) {
            btnScale = 1.0
        }
    }
    
    func disappearFromScreen() {
        withAnimation(.linear(duration: FSLoginOpState.disappear.animTime)) {
            btnScale = 0.0
        }
    }
}

fileprivate struct TestView: View {
    @State private var state: FSLoginOpState = .appear
    var body: some View {
        ZStack {
            Color.idleBackground
                .ignoresSafeArea()
            FSLoginOptionView(viewState: $state)
            
            VStack {
                Spacer()
                Spacer()
                HStack { ForEach(FSLoginOpState.allCases, id: \.self) { st in Button(st.desciption) { state = st } } }
                Spacer()
            }
        }
    }
}

struct FSLoginOptionView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
