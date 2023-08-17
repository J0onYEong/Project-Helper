//
//  DynamicShowingText.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/08/17.
//

import SwiftUI

fileprivate enum MovingTextState: ViewState {
    static var initialState: MovingTextState = .congestion
    
    case appear, disappear, congestion
}


fileprivate struct MovingText: View {
    @Binding var viewState: MovingTextState
    var str: String
    var startPos: CGSize
    var order: Int
    var duration: CGFloat
    var delay: CGFloat
    var color1: Color
    var color2: Color
    
    @State private var textPos = CGSize(width: 0, height: 0)
    
    var body: some View {
        Text(str)
            .font(.blackHansSans(30))
            .foregroundColor(color1)
            .padding([.trailing, .bottom], 1)
            .background(
                Text(str)
                    .font(.blackHansSans(30))
                    .foregroundColor(color2)
                    .offset(CGSize(width: 1, height: 1))
            )
            .offset(textPos)
            .padding(.vertical, 3)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .onAppear {
                textPos = startPos
            }
            .onChange(of: viewState) { state in
                switch state {
                case .appear:
                    withAnimation(.easeOut(duration: duration).delay(delay*Double(order))) {
                        textPos = CGSize(width: 0, height: 0)
                    }
                case .disappear:
                    withAnimation(.easeIn(duration: duration).delay(delay*Double(order))) {
                        textPos = startPos
                    }
                case .congestion:
                    return
                }
            }
    }
    
}

enum DSViewState: ViewState {
    static var initialState: DSViewState = .congestion
    
    case active, inactive, congestion
    
    var desciption: String {
        switch self {
        case .active:
            return "active"
        case .inactive:
            return "inactive"
        case .congestion:
            return "congestion"
        }
    }
}

struct DynamicShowingText: View {
    //Parameter
    @Binding var viewState: DSViewState
    var string: String
    var mainColor: Color
    var bgColor: Color
    
    //State
    @State private var textOffsetX = -50
    @State private var movingTextViewState: MovingTextState = .initialState
    @State private var timer: Timer?
    @State private var isTimerRunning = false
    
    //
    private var baseData: [String] { string.map({ String($0) }) }
    private let offsets = [
        CGSize(width: 0, height: 50),
        CGSize(width: 0, height: -50),
    ]
    private let durationTerm = 0.8
    private let delayTerm = 0.2
    
    var body: some View {
        
        HStack(spacing: 0) {
            Group {
                ForEach(baseData.mapArrayWithId()) { element in
                    MovingText(viewState: $movingTextViewState, str: element.str, startPos: offsets[element.id % 2], order: element.id, duration: durationTerm, delay: delayTerm, color1: mainColor, color2: bgColor)
                }
            }
        }
        .onChange(of: viewState) { state in
            switch state {
            case .active:
                activateMovingText()
            case .inactive:
                inactivateMovingText()
            case .congestion:
                return
            }
        }
    }
    
    private func changeState() {
        movingTextViewState = movingTextViewState == .appear ? .disappear : .appear
    }
    
    func activateMovingText() {
        //activate moving text
        changeState()
        
        //repeat animation
        let interval = Double(string.count) * delayTerm + (durationTerm-delayTerm)
        
        if !isTimerRunning {
            isTimerRunning = true;
            
            timer = Timer(timeInterval: interval, repeats: true, block: { _ in changeState()})
            
            RunLoop.main.add(timer!, forMode: .common)
        }
    }
    
    func inactivateMovingText() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
    }
}

fileprivate struct TestView: View {
    @State private var state: DSViewState = .initialState
    var body: some View {
        ZStack {
            Color.idleBackground
                .ignoresSafeArea()
            DynamicShowingText(viewState: $state, string: "이메일 확인해주세요!", mainColor: .white, bgColor: .sunflower)

            VStack {
                Spacer()
                Spacer()
                HStack { ForEach(DSViewState.allCases, id: \.self) { st in Button(st.desciption) { state = st } } }
                Spacer()
            }
        }
    }
}

struct DynamicShowingText_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
