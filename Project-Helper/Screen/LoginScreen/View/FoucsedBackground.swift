//
//  FoucsedBackground.swift
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


fileprivate struct FoucsedBackgroundPart: View {
    @State private var degree = 0.0
    @State private var width = 0.0
    
    
    var color: Color

    var active = false
    
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
            .onChange(of: active) { state in
                if state {
                    withAnimation(.linear(duration: fd)) {
                        width = rectWidth
                    }
                    
                    withAnimation(.linear(duration: sd).delay(fd)) {
                        degree = 90.0
                    }
                } else {
                    withAnimation(.linear(duration: sd)) {
                        degree = 0.0
                    }
                    
                    withAnimation(.linear(duration: fd).delay(sd)) {
                        width = 0.0
                    }
                }
            }
        }
        
    }
}

struct FoucsedBackground: View {
    @Binding var active: Bool
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
                    FoucsedBackgroundPart(color: lineColor, active: active, lineWidth: lineWidth, fd: fd, sd: sd)
                    FoucsedBackgroundPart(color: lineColor, active: active, lineWidth: lineWidth, fd: fd, sd: sd)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                }
                HStack(spacing: 0) {
                    FoucsedBackgroundPart(color: lineColor, active: active, lineWidth: lineWidth, fd: fd, sd: sd)
                        .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                    FoucsedBackgroundPart(color: lineColor, active: active, lineWidth: lineWidth, fd: fd, sd: sd)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 0, z: 1))
                }
            }
            GeometryReader { geo in
                RoundedRectangle(cornerRadius: geo.size.height/2)
                    .fill(bgColor)
                    .onChange(of: active) { state in
                        withAnimation(.linear(duration: (fd+sd) * 0.65)) {
                            bgColor = state ? backgroundTar : backgroundOrg
                        }
                    }
            }
            .padding(lineWidth)
        }
    }
}


// MARK: - TEST
fileprivate struct ForPreview: View {
    @State var trigger = false
    @State var isChanging = false
    @State var showingText = "active"
    
    let fd = 0.5
    let sd = 0.5
    
    var body: some View {
        VStack {
            Button(showingText) {
                trigger.toggle()
                isChanging = true
                
                Timer.scheduledTimer(withTimeInterval: fd+sd, repeats: false) { _ in
                    isChanging = false
                    showingText = trigger ? "inactive" : "active"
                }
            }
            .disabled(isChanging)
            
            FoucsedBackground(active: $trigger, lineColor: .red, backgroundTar: .cyan, lineWidth: 3.0, fd: fd, sd: sd)
                .frame(width: 300, height: 100)
        }
    }
}

struct FoucsedBackground_Previews: PreviewProvider {

    static var previews: some View {
        ForPreview()
    }
}
