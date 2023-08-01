//
//  FSTitleView.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/08/01.
//

import SwiftUI

struct FSTitleView: View {
    //애니메이션
    @State private var titleOffset = titleOrgOffset
    static private let titleOrgOffset = CGSize(width: 0, height: 0)
    @State private var showingKorTitle = true
    
    //Title 기본 설정
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
                        ZStack {
                            if showingKorTitle {
                                ZStack {
                                    LinearGradient(colors: [.clear, .black, .clear], startPoint: .leading, endPoint: .trailing)
                                    Text("너의 프로젝트 메이트")
                                        .font(.blackHansSans(12))
                                        .withGradient(gradient: LinearGradient(colors: [.clear, .waterBlue], startPoint: .top, endPoint: .bottom))
                                        .foregroundColor(.white)
                                }
                                .frame(width: 200, height: 15)
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
            .onAppear {
                //title idle animation
                timer1 = Timer(timeInterval: 0.01, repeats: true) {
                    _ in
                    gradientStopPer += 0.005
                    
                    if gradientStopPer >= 2.0 {
                        swap(&color1, &color2)
                        
                        gradientStopPer = 0.0
                    }
                }
                
                if let t = timer1 { RunLoop.main.add(t, forMode: .common) }
                
                
                //moving
                withAnimation(.easeOut(duration: 1.2).delay(1.0)) {
                    titleOffset = CGSize(width: 0, height: -(geo.size.height/2-50))
                }
                
                withAnimation(.linear(duration: 0.7).delay(1.0)) {
                    showingKorTitle = false
                }
                
            }
            .onDisappear {
                timer1?.invalidate()
            }
            .position(x: geo.size.width/2, y: geo.size.height/2)
        }
    }
}


struct FSTitleView_Previews: PreviewProvider {
    static var previews: some View {
        FSTitleView()
    }
}
