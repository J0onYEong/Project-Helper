//
//  NavigationController.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/08/08.
//

import Foundation

class NavigationController<NVDestination>: ObservableObject {
    @Published var viewState: [NVDestination] = []

    /// 루트뷰를 제외한 모든 뷰를 pop하고 해당 뷰를 삽입
    func presentScreen(destination: NVDestination) {
        viewState = [destination]
    }
    
    /// 해당뷰를 Stack에 추가
    func addToStack(destination: NVDestination) {
        viewState.append(destination)
    }
    
    /// 최상단 뷰를 제거
    func popTopView() {
        let _ = viewState.popLast()
    }
    
    func clearStack() {
        viewState = []
    }
}
