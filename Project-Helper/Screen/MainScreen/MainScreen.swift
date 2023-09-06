//
//  MainScreen.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/08/20.
//

import SwiftUI

protocol TabViewTabSymbol: Hashable & Identifiable & Comparable {
    var title: String { get }
    
    static subscript(_ index: Int) -> Self { get }
}

enum MainScreenTabViewTabSymbol: Int, TabViewTabSymbol {
    
    static func < (lhs: MainScreenTabViewTabSymbol, rhs: MainScreenTabViewTabSymbol) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    var id: UUID { UUID() }
    
    case projects=0, calendar=1, setting=3, users=4
    
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
        case .calendar:
            return "calendar"
        case .setting:
            return "setting"
        }
    }
}


struct MainScreen<ScreenSymbol>: View where ScreenSymbol: TabViewTabSymbol {
    
    var screenForTab: [ScreenSymbol : AnyView]
    
    var screenKeys: [ScreenSymbol] { screenForTab.keys.sorted() }
    
    @State private var selectedIndexOfTabItem = 2
    
    private let curveHeightOfTabBar: CGFloat = 10
    
    var body: some View {
        ZStack {
            Color.idleBackground
                .ignoresSafeArea()
            ZStack {
                
                VStack(spacing: 0) {
                    
                    Spacer(minLength: 0)
                    
                    ZStack {
                        GeometryReader { geo in
                            Rectangle()
                                .fill(.cc_white1)
                                .frame(height: 200)
                                .position(x: geo.size.width/2, y: geo.size.height/2+100)
                        }
                        
                        //현재 클릭된 탭아이템을 가리키는 바
                        TabViewMovingBarView(indexOfTabItem: $selectedIndexOfTabItem, countOfTabItems: 5, curveHeight: curveHeightOfTabBar)
                        
                        HStack(spacing: 0) {
                            ForEach(0..<5) { index in
                                ZStack {
                                    Rectangle()
                                        .fill(.cc_white1)
                                    if index == 2 {
                                        Text("+")
                                    } else {
                                        Text(ScreenSymbol[index].title)
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation(.easeOut(duration: 0.25)) {
                                        selectedIndexOfTabItem = index
                                    }
                                }
                            }
                        }
                        .clipShape(RoundedTopRectangle(curveHeight: curveHeightOfTabBar))
                        .padding(.top, 3)
                    }
                    .frame(height: 50)
                }
            }
        }
    }
}


//------------------------------------------------------------------------

fileprivate struct TestView: View {
    var body: some View {
        
        let tabs: [MainScreenTabViewTabSymbol : AnyView] = [
            .projects : AnyView(Rectangle().foregroundColor(.red)),
            .calendar : AnyView(Rectangle().foregroundColor(.blue)),
            .users : AnyView(Rectangle().foregroundColor(.yellow)),
            .setting : AnyView(Rectangle().foregroundColor(.purple)),
        ]
        
        
        MainScreen(screenForTab: tabs)
    }
}




struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
