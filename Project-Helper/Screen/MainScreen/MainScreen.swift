//
//  MainScreen.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/08/20.
//

import SwiftUI


protocol TabViewTabSymbol: Hashable & Identifiable & Comparable {
    var title: String { get }
    
    var idleStateSystemImageName: String { get }
    
    var clickedStateSystemImageName: String { get }
    
    static subscript(_ index: Int) -> Self { get }
}

enum MainScreenTabViewTabSymbol: Int, TabViewTabSymbol {
    
    static func < (lhs: MainScreenTabViewTabSymbol, rhs: MainScreenTabViewTabSymbol) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    var id: UUID { UUID() }
    
    case projects=0, calendar=1, addProject=2, users=3, setting=4
    
    static subscript(_ index: Int) -> Self {
        guard let caseItem = Self(rawValue: index) else {
            fatalError("MainScreenTabViewTabSymbol 잘못된 인덱스 전달")
        }
        return caseItem
    }
    
    var title: String {
        switch self {
        case .projects:
            return "projects"
        case .users:
            return "users"
        case .addProject:
            return "addProject"
        case .calendar:
            return "calendar"
        case .setting:
            return "setting"
        }
    }
    
    var idleStateSystemImageName: String {
        switch self {
        case .projects:
            return "list.bullet.circle"
        case .users:
            return "person.2.circle"
        case .addProject:
            return "plus.circle"
        case .calendar:
            return "calendar.circle"
        case .setting:
            return "gearshape.circle"
        }
    }
    
    var clickedStateSystemImageName: String {
        switch self {
        case .projects:
            return "list.bullet.circle.fill"
        case .users:
            return "person.2.circle.fill"
        case .addProject:
            return "plus.circle.fill"
        case .calendar:
            return "calendar.circle.fill"
        case .setting:
            return "gearshape.circle.fill"
        }
    }
}



struct MainScreen: View  {
    
    @State private var selectedIndexOfTabItem = 0
    
    private let curveHeightOfTabBar: CGFloat = 10
    private let heightOfTabBar: CGFloat = 50
    
    var body: some View {
        ZStack {
            Color.idleBackground
                .ignoresSafeArea()
            ZStack {
                
                Rectangle()
                    .fill(.pointColor1)
                    .padding(.bottom, heightOfTabBar-curveHeightOfTabBar)
                
                VStack(spacing: 0) {
                    
                    Spacer(minLength: 0)
                    
                    ZStack {
                        GeometryReader { geo in
                            Rectangle()
                                .fill(.cc_white1)
                                .frame(height: 200)
                                .position(x: geo.size.width/2, y: geo.size.height/2+100)
                        }
                        
                        MainScreenTabBarView<MainScreenTabViewTabSymbol>(selectedIndex: $selectedIndexOfTabItem, heightOfBar: heightOfTabBar, curveHeight: curveHeightOfTabBar)
                    }
                    .frame(height: heightOfTabBar)
                }
            }
        }
    }
}


//------------------------------------------------------------------------

fileprivate struct TestView: View {
    var body: some View {
        
//        let tabs: [MainScreenTabViewTabSymbol : AnyView] = [
//            .projects : AnyView(Rectangle().foregroundColor(.red)),
//            .calendar : AnyView(Rectangle().foregroundColor(.blue)),
//            .users : AnyView(Rectangle().foregroundColor(.yellow)),
//            .setting : AnyView(Rectangle().foregroundColor(.purple)),
//        ]
//
        
        MainScreen()
    }
}




struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
