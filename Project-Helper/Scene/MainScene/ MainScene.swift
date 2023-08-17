//
//   MainScene.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/08/08.
//

import SwiftUI

struct MainScene: View {
    @StateObject private var controller = MainSceneController()
    
    //FirstScreen
    @State private var firstScreenState: FirstScreenState = .congestion
    
    var body: some View {
        NavigationStack(path: $controller.viewState) {
            Text("")
                .navigationDestination(for: MSDestination.self) { state in
                    switch state {
                    case .first:
                        FirstScreen(forTest: $firstScreenState)
                            .navigationBarBackButtonHidden()
                    case .main:
                        Text("main")
                            .navigationBarBackButtonHidden()
                    }
                }
        }
        .environmentObject(controller)
        .onAppear {
            controller.addToStack(destination: .first)
            //FirstScreen-------------------------------------------------
            //타이틀 색변화 애니메이션
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                firstScreenState = .take1
            }
            
            //로그인 창으로 이동
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
                firstScreenState = .take2
            }
            //------------------------------------------------------------
            
            
            
        }
    }
}

struct MainScene_Previews: PreviewProvider {
    static var previews: some View {
        MainScene()
    }
}
