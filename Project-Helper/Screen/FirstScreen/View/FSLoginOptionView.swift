//
//  FSLoginOptionView.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/08/01.
//

import SwiftUI

struct ImageCircle: View {
    var systemName: String
    var lineColor: Color
    
    var body: some View {
        
        GeometryReader { geo in
            ZStack {
                Circle()
                    .fill(.cloud)
                Circle()
                    .strokeBorder(lineColor, lineWidth: geo.size.width/20)
                Image(systemName: systemName)
                    .resizable()
                    .scaledToFit()
                    .padding(geo.size.width/4)
            }
            .position(x: geo.size.width/2, y: geo.size.height/2)
        }
        .aspectRatio(contentMode: .fit)
        .foregroundColor(.black)
    }
}

struct FSLoginOptionView: View {
    
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
                        
                    } label: {
                        ImageCircle(systemName: "apple.logo", lineColor: .sunflower)
                            .scaleEffect(btnScale)
                    }
                    
                    Spacer()
                    Spacer()
                    
                    Button {
                        
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
        .onAppear {
            withAnimation(.interpolatingSpring(stiffness: 1000, damping: 20)) {
                btnScale = 1.0
            }
        }
    }
}

struct FSLoginOptionView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.idleBackground
                .ignoresSafeArea()
            FSLoginOptionView()
        }
    }
}
