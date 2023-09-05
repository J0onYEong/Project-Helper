//
//  MainScreen.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/08/20.
//

import SwiftUI

protocol TabViewTabSymbol: Hashable & Identifiable {
    var title: String { get }
}

enum MainScreenTabViewTabSymbol: TabViewTabSymbol {
    var id: UUID { UUID() }
    
    case projects, calendar, setting, users
    
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


struct MainSceneTabViewOutLineShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let curveStartPosOfY = rect.maxY/10
        
        path.move(to: CGPoint(x: rect.maxX, y: curveStartPosOfY))
        
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.minY), control: CGPoint(x: rect.maxX*3/4, y: rect.minY))
        
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: curveStartPosOfY), control: CGPoint(x: rect.maxX/4, y: rect.minY))
        
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        
        path.closeSubpath()
        
        return path
    }
}


struct MainScreen<ScreenSymbol>: View where ScreenSymbol: TabViewTabSymbol {
    
    var screenForTab: [ScreenSymbol : AnyView]
    
    var body: some View {
        ZStack {
            Color.idleBackground
                .ignoresSafeArea()
            ZStack {
                
                VStack(spacing: 0) {
                    
                    let tabItemWidth = UIScreen.main.bounds.width/5
                    
                    Spacer(minLength: 0)
                    
                    HStack(spacing: 0) {
                        Rectangle()
                        Rectangle()
                            .foregroundColor(.red)
                        Rectangle()
                        Rectangle()
                            .foregroundColor(.red)
                        Rectangle()
                        
                    }
                    .frame(height: 50)
                    .clipShape(MainSceneTabViewOutLineShape())
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
