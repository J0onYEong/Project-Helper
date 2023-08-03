//
//  FoucsedBackgroundView.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/07/24.
//

import SwiftUI

fileprivate struct RectForClipped: Shape {
    
    var value: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY+value))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY+value))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        
        return path
    }
}

fileprivate struct CircleForClipped: Shape {
    
    var value: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let center = CGPoint(x: rect.maxX, y: rect.maxY)
        let radius = rect.maxY
        
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addArc(center: center, radius: radius, startAngle: .degrees(-90), endAngle: .degrees(-180), clockwise: true)
        
        path.addLine(to: CGPoint(x: rect.minX+value, y: rect.maxY))
        
        path.addArc(center: center, radius: radius-value, startAngle: .degrees(-180), endAngle: .degrees(-90), clockwise: false)
        
        path.closeSubpath()
        
        return path
    }
}


enum FBPartViewState: ViewState {
    case active, inactive, congestion
    
    static var initialState: FBPartViewState = .congestion
}

fileprivate struct FoucsedBackgroundPart: AnimatableView {
    @Binding var viewState: FBPartViewState
    
    @State private var degree = 0.0
    @State private var width = 0.0
    
    var color: Color
    
    var lineWidth: Double
    
    var fd: Double
    var sd: Double
    
    var body: some View {
        GeometryReader { geo in
            let radius = geo.size.height
            let rectWidth = geo.size.width - radius
            
            HStack(spacing: 0) {
                QuaterCircle(degree: degree)
                    .fill(color)
                    .clipShape(CircleForClipped(value: lineWidth))
                    .frame(width: radius, height: radius)
                Rectangle()
                    .fill(.clear)
                    .overlay(alignment: .trailing) {
                        Rectangle()
                            .fill(color)
                            .clipShape(RectForClipped(value: lineWidth))
                            .frame(width: width)
                    }
                
            }
            .onChange(of: viewState) { state in
                switch state {
                case .active:
                    withAnimation(.linear(duration: fd)) {
                        width = rectWidth
                    }
                    
                    withAnimation(.linear(duration: sd).delay(fd)) {
                        degree = 90.0
                    }
                case .inactive:
                    withAnimation(.linear(duration: sd)) {
                        degree = 0.0
                    }
                    
                    withAnimation(.linear(duration: fd).delay(sd)) {
                        width = 0.0
                    }
                case .congestion:
                    return
                }
            }
        }
    }
}

enum FoucsedBackgroundViewState: ViewState {
    case active, inactive, congestion
    
    static var initialState: FoucsedBackgroundViewState { .congestion }
    
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


struct FoucsedBackgroundView: AnimatableView {
    
    @Binding var viewState: FoucsedBackgroundViewState
    
    @State private var fbpartViewState: FBPartViewState = .inactive
    
    @State private var bgColor: Color = .clear
    
    var lineColor: Color
    
    var backgroundOrg: Color = .clear
    var backgroundTar: Color
    
    var lineWidth: Double
    
    var fd: Double
    var sd: Double
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    FoucsedBackgroundPart(viewState: $fbpartViewState, color: lineColor, lineWidth: lineWidth, fd: fd, sd: sd)
                    FoucsedBackgroundPart(viewState: $fbpartViewState, color: lineColor, lineWidth: lineWidth, fd: fd, sd: sd)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                }
                HStack(spacing: 0) {
                    FoucsedBackgroundPart(viewState: $fbpartViewState, color: lineColor, lineWidth: lineWidth, fd: fd, sd: sd)
                        .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                    FoucsedBackgroundPart(viewState: $fbpartViewState, color: lineColor, lineWidth: lineWidth, fd: fd, sd: sd)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 0, z: 1))
                }
            }
            GeometryReader { geo in
                RoundedRectangle(cornerRadius: geo.size.height/2)
                    .fill(bgColor)
                    .onChange(of: viewState) { state in
                        withAnimation(.linear(duration: (fd+sd) * 0.65)) {
                            bgColor = state == .active ? backgroundTar : backgroundOrg
                        }
                    }
            }
            .padding(lineWidth)
        }
        .onChange(of: viewState) { state in
            switch state {
            case .active:
                fbpartViewState = .active
            case .inactive:
                fbpartViewState = .inactive
            case .congestion:
                fbpartViewState = .congestion
                return
            }
        }
    }
}


// MARK: - TEST
fileprivate struct TestView: View {
    @State private var state: FoucsedBackgroundViewState = .initialState
        
    let fd = 0.5
    let sd = 0.5
        
    var body: some View {
        ZStack {
            FoucsedBackgroundView(viewState: $state, lineColor: .red, backgroundTar: .cyan, lineWidth: 3.0, fd: fd, sd: sd)
                .frame(width: 300, height: 100)
            VStack {
                Spacer()
                Spacer()
                HStack { ForEach(FoucsedBackgroundViewState.allCases, id: \.self) { st in Button(st.desciption) { state = st } } }
                Spacer()
            }
        }
    }
}
    
struct FoucsedBackground_Previews: PreviewProvider {

    static var previews: some View {
        TestView()
    }
}
