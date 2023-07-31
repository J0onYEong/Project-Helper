//
//  FirstScreen.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/07/28.
//

import SwiftUI

struct FirstScreen: View {
    @State private var showingLoginOp = false
    
    var body: some View {
        ZStack {
            Color.idleBackground
                .ignoresSafeArea()
                .zIndex(0)
            GeometryReader { geo in
                FSTitleView()
                    .position(x: geo.size.width/2, y: geo.size.height/2)
                    .zIndex(1)
            }
            
            if showingLoginOp {
                FSLoginOptionView()
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                self.showingLoginOp = true
            }
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
