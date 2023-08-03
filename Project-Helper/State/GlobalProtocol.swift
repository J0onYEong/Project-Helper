//
//  GlobalProtocol.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/08/04.
//

import SwiftUI


// MARK: - Animation
protocol AnimatableView: View {
    associatedtype VS: ViewState
    
    var viewState: VS { get set }
}

protocol ViewState: CaseIterable, Identifiable, Hashable {
    static var initialState: Self { get }
    
    var desciption: String { get }
    
    var animTime: CGFloat { get }
}

extension ViewState {
    var id: UUID { UUID() }
    var animTime: CGFloat { return 0.0 }
    var desciption: String { return "desciption" }
}
