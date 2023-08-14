//
//  FSTitleView.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/08/01.
//

import SwiftUI

enum FSTitleViewState: ViewState {
    case idle, upward, disappear, congestion
    
    static var initialState: FSTitleViewState { .congestion }
    
    var desciption: String {
        switch self {
        case .idle:
            return "idle"
        case .upward:
            return "upward"
        case .disappear:
            return "disappear"
        case .congestion:
            return "congestion"
        }
    }
    
    var animTime: CGFloat {
        switch self {
        case .idle:
            return 1.5
        case .upward:
            return 1.2
        case .disappear:
            return 1.2
        case .congestion:
            return 0.0
        }
    }
}


struct FSTitleView: View {
    @Binding var viewState: FSTitleViewState
    
    @State private var animationTimer: Timer?
    @State private var isAnimationWorking = false
    @State private var nextState: FSTitleViewState?
    
    //Title 애니메이션 관련 prop
    @State private var titleOffset = titleOrgOffset
    static private let titleOrgOffset = CGSize(width: 0, height: 0)
    @State private var showingKorTitle = true
    
    //Title 기본 설정 prop
    @State private var gradientStopPer = 0.0
    @State private var color1: Color = .heavyPink
    @State private var color2: Color = .placeHolder1
    @State private var timer1: Timer?
    private let offsetList = [2, 4, 6]
    
    
    private var textGradient: LinearGradient {
        LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: color1, location: gradientStopPer), Gradient.Stop(color: color2, location: gradientStopPer)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                Spacer()
                VStack {
                    VStack(spacing: 0) {
                        //Title
                        ZStack {
                            ForEach(offsetList, id: \.self) { os in
                                Text("NUPLEME")
                                    .font(.rowdies(50, weight: .regular))
                                    .foregroundColor(.white.opacity(0.3))
                                    .offset(CGSize(width: os, height: os))
                                    .zIndex(Double(1/os))
                            }
                            Text("NUPLEME")
                                .font(.rowdies(50, weight: .regular))
                                .font(Font.system(size: 50, weight: .bold))
                                .foregroundColor(.white)
                                .withGradient(gradient: textGradient)
                                .zIndex(1)
                                .blur(radius: 0.2)
                        }
                        .padding(.bottom, showingKorTitle ? 10 : 0)
                        
                        //Kor Text
                        ZStack {
                            if showingKorTitle {
                                ZStack {
                                    LinearGradient(colors: [.clear, .black, .clear], startPoint: .leading, endPoint: .trailing)
                                        .scaledToFill()
                                    Text("너의 프로젝트 메이트")
                                        .font(.blackHansSans(12))
                                        .withGradient(gradient: LinearGradient(colors: [.clear, .waterBlue], startPoint: .top, endPoint: .bottom))
                                        .foregroundColor(.white)
                                }
                                .frame(width: 200, height: 15)
                                .clipShape(Rectangle())
                                .transition(.move(edge: .bottom))
                        
                            }
                        }
                        .frame(width: 200)
                        .clipShape(Rectangle())
                    }
                }
                Spacer()
            }
            .padding(.vertical, 15)
            .background( Color.mintChocolate )
            .offset(titleOffset)            
            .onDisappear { timer1?.invalidate() }
            .onChange(of: viewState) { state in
                //상태가 congestion일 경우는 애니메이션을 실행하지 않습니다.
                if state == .congestion { return }
                
                if !isAnimationWorking {
                    isAnimationWorking = true
                    switch(state) {
                    case .idle:
                        idleState()
                    case .upward:
                        moveToUpward(y: -(geo.size.height/2-50))
                    case .disappear:
                        disappearFromScreen(y: -(geo.size.height/2 + 300))
                    default:
                        return
                    }
                    //실핸한 애니메이션 타입을 별로 동작시간 만큼 isAnimationWorking값이 true가 됩니다.
                    animWorkingOn(state: state)
                } else {
                    //애니메이션이 동작중임으로 입력된 상태를 저장하고 현재상태를 혼잡상태로 변경합니다.
                    nextState = state
                    viewState = .congestion
                }
            }
            .onChange(of: isAnimationWorking) { state in
                if !state, let newState = nextState {
                    viewState = newState
                    nextState = nil
                }
            }
            .position(x: geo.size.width/2, y: geo.size.height/2)
        }
    }
}


// MARK: - Animation Function
extension FSTitleView {
    func animWorkingOn(state: FSTitleViewState) {
        animationTimer?.invalidate()
        animationTimer = Timer(timeInterval: state.animTime, repeats: false, block: { _ in isAnimationWorking = false })
        if let t = animationTimer { RunLoop.main.add(t, forMode: .common) }
    }
    
    // working = 1.5
    func idleState() {
        withAnimation(.easeOut(duration: 1.0)) {
            titleOffset = Self.titleOrgOffset
        }
        withAnimation(.easeOut(duration: 0.5).delay(1.0)) {
            showingKorTitle = true
        }
        
        if timer1 == nil {
            timer1 = Timer(timeInterval: 0.01, repeats: true) {
                _ in
                gradientStopPer += 0.005
                
                if gradientStopPer >= 2.0 {
                    swap(&color1, &color2)
                    
                    gradientStopPer = 0.0
                }
            }
            if let t = timer1 { RunLoop.main.add(t, forMode: .common) }
        }
        
    }
    
    
    // -(geo.size.height/2-50), working: 1.2
    func moveToUpward(y: CGFloat) {
        //moving
        withAnimation(.easeOut(duration: FSTitleViewState.disappear.animTime)) {
            titleOffset = CGSize(width: 0, height: y)
        }
        
        withAnimation(.linear(duration: 0.7)) {
            showingKorTitle = false
        }
    }
    
    // -(geo.size.height/2 + 300), working: 1.2
    func disappearFromScreen(y: CGFloat) {
        withAnimation(.easeOut(duration: FSTitleViewState.disappear.animTime)) {
            titleOffset = CGSize(width: 0, height: y)
        }
    }
}


fileprivate struct TestView: View {
    @State private var state: FSTitleViewState = .idle
    
    var body: some View {
        ZStack {
            FSTitleView(viewState: $state)
            VStack {
                Spacer()
                Spacer()
                HStack { ForEach(FSTitleViewState.allCases, id: \.self) { st in Button(st.desciption) { state = st } } }
                Spacer()
            }
        }
    }
}


struct FSTitleView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
