//
//  FoucsedBackground.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/07/24.
//

import SwiftUI

fileprivate struct FoucsedBackgroundPart: View {
    @State private var degree = 0.0
    @State private var width = 0.0
    
    var color: Color
    
    var active = false
    
    var fd: Double
    var sd: Double
    
    var body: some View {
        GeometryReader { geo in
            let radius = geo.size.height
            let rectWidth = geo.size.width - radius
            
            HStack(spacing: 0) {
                QuaterCircle(degree: degree)
                    .fill(color)
                    .frame(width: radius, height: radius)
                Rectangle()
                    .fill(.clear)
                    .overlay(alignment: .trailing) {
                        Rectangle()
                            .fill(color)
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
    
    var color: Color
    
    var lineWidth: Double
    
    var fd: Double
    var sd: Double
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    FoucsedBackgroundPart(color: color, active: active, fd: fd, sd: sd)
                    FoucsedBackgroundPart(color: color, active: active, fd: fd, sd: sd)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                }
                HStack(spacing: 0) {
                    FoucsedBackgroundPart(color: color, active: active, fd: fd, sd: sd)
                        .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                    FoucsedBackgroundPart(color: color, active: active, fd: fd, sd: sd)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 0, z: 1))
                }
            }
            GeometryReader { geo in
                RoundedRectangle(cornerRadius: geo.size.height/2)
                    .fill(.white)
            }
            .padding(lineWidth)
        }
    }
}

struct FoucsedBackground_Previews: PreviewProvider {
    static var previews: some View {
        FoucsedBackground(active: .constant(true),color: .red, lineWidth: 3.0, fd: 1.0, sd: 1.0)
            .frame(width: 300, height: 100)
    }
}
