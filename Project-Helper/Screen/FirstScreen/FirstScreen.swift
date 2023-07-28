//
//  FirstScreen.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/07/28.
//

import SwiftUI

struct FirstScreen: View {
    
    @State private var gradientStopPer = 0.0
    @State private var color1: Color = .heavyPink
    @State private var color2: Color = .placeHolder1
    
    private var textGradient: LinearGradient {
        LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: color1, location: gradientStopPer), Gradient.Stop(color: color2, location: gradientStopPer)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    @State private var timer1: Timer?
    
    private var offsetList = [2, 4, 6]
    
    var body: some View {
        ZStack {
            Color.idleBackground
                .ignoresSafeArea()
            HStack {
                Spacer()
                VStack {
                    VStack(spacing: 0) {
                        ZStack {
                            ForEach(offsetList, id: \.self) { os in
                                Text("NUPLEME")
                                    .font(Font.system(size: 50, weight: .bold))
                                    .foregroundColor(.white.opacity(0.3))
                                    .offset(CGSize(width: os, height: os))
                                    .zIndex(Double(1/os))
                            }
                            Text("NUPLEME")
                                .font(Font.system(size: 50, weight: .bold))
                                .foregroundColor(.white)
                                .withGradient(gradient: textGradient)
                                .zIndex(1)
                                .blur(radius: 0.2)
                        }
                        .padding(.bottom, 20)
                        Text("너의 프로젝트 메이트")
                            .font(Font.system(size: 12, weight: .heavy))
                            .withGradient(gradient: LinearGradient(colors: [.clear, .waterBlue], startPoint: .top, endPoint: .bottom))
                            .frame(width: 200, height: 15)
                            .foregroundColor(.white)
                            .background(
                                LinearGradient(colors: [.clear, .black, .clear], startPoint: .leading, endPoint: .trailing)
                                
                            )
                            
                    }
                }
                Spacer()
            }
            .padding(.vertical, 15)
            .background(
                Color.mintChocolate
            )
        }
        .onAppear {
            timer1 = Timer(timeInterval: 0.01, repeats: true) {
                _ in
                gradientStopPer += 0.005
                
                if gradientStopPer >= 2.0 {
                    swap(&color1, &color2)
                    
                    gradientStopPer = 0.0
                }
            }
            
            if let t = timer1 {
                RunLoop.main.add(t, forMode: .common)
            }
        }
        .onDisappear {
            timer1?.invalidate()
        }
    }
}

extension Text {
    public func withGradient(gradient: LinearGradient) -> some View {
        self.overlay {
            gradient
                .mask(self)
        }
    }
}

struct FirstScreen_Previews: PreviewProvider {
    static var previews: some View {
        FirstScreen()
    }
}
