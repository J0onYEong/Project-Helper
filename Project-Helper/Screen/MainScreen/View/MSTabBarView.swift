//
//  MSTabBarView.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/09/07.
//

import SwiftUI

struct MainScreenTabBarView<ScreenSymbol>: View where ScreenSymbol: TabViewTabSymbol {
    
    @Binding var selectedIndex: Int
    
    var heightOfBar: CGFloat
    
    var curveHeight: CGFloat = 10.0
    
    //계산 영역-----------------------------------
    private var radiusOfBaseCircle: CGFloat {
        (pow(curveHeight, 2) + pow(UIScreen.main.bounds.width, 2)/4) / (2*curveHeight)
    }
    
    private var centerPosOfBaseCircle: CGPoint {
        CGPoint(x: UIScreen.main.bounds.width/2, y: radiusOfBaseCircle)
    }
    
    private var degreeOfPart: CGFloat {
        let sinValue = (UIScreen.main.bounds.width/2) / radiusOfBaseCircle
        let wholeDegreeOfAngle = (asin(sinValue) * 180.0 / Double.pi) * 2
        return wholeDegreeOfAngle / CGFloat(countOfTabs)
    }
    //------------------------------------------
    
    //연산 프로퍼티
    private var imageBoxSize: CGFloat { heightOfBar * 0.5 }
    private var imageTopPadding: CGFloat { heightOfBar * 0.25 }
    
    //Constant value
    private let countOfTabs: Int = 5
    
    //State
    @State private var offsetYOfMovingBar: CGFloat = -3.5
    @State private var barOffsetDisappearWaitTimer: Timer?
    
    var body: some View {
        ZStack {
            //TabItems
            ZStack {
                ForEach(0..<5) { index in
                    ZStack {
                        RoundedTopRectanglePart(curveHeight: curveHeight, radiusOfBaseCircle: radiusOfBaseCircle, countOfParts: countOfTabs)
                            .foregroundColor(.cc_white1)
                        
                        let isSelected = selectedIndex == index
                        let imageName = isSelected ? ScreenSymbol[index].clickedStateSystemImageName : ScreenSymbol[index].idleStateSystemImageName
                        
                        VStack {
                            Image(systemName: imageName)
                                .resizable()
                                .animation(nil, value: isSelected)
                                .foregroundColor(isSelected ? .cc_red1 : .black)
                                .aspectRatio(1, contentMode: .fit)
                                .frame(width: imageBoxSize)
                                .padding(.top, imageTopPadding)
                            Spacer()
                        }
                    }
                    .frame(height: heightOfBar)
                    .rotationEffect(.degrees(degreeOfPart * CGFloat(index-2)), anchor: UnitPoint(x: 0.5, y: centerPosOfBaseCircle.y / heightOfBar))
                    .onTapGesture {
                        let movingDuration = 0.25
                        
                        withAnimation(.linear(duration: movingDuration)) {
                            selectedIndex = index
                        }
                        
                        barOffsetDisappearWaitTimer?.invalidate()
                        
                        barOffsetDisappearWaitTimer = Timer(timeInterval: movingDuration+1.0, repeats: false) { _ in
                            withAnimation(.linear(duration: 0.5)) {
                                offsetYOfMovingBar = -3.5
                            }
                        }
                        
                        RunLoop.main.add(barOffsetDisappearWaitTimer!, forMode: .common)
    
                    }
                }
            }
            
            //MovingBar
            RoundedBarShape(curveHeight: curveHeight, heightOfMovingBar: 3, radiusOfBaseCircle: radiusOfBaseCircle, countOfParts: countOfTabs)
                .foregroundColor(.cc_red1)
                .allowsHitTesting(false)
                .offset(x: 0, y: offsetYOfMovingBar)
                .rotationEffect(.degrees(degreeOfPart * CGFloat(selectedIndex-2)), anchor: UnitPoint(x: 0.5, y: centerPosOfBaseCircle.y / heightOfBar))
        }
        .frame(height: heightOfBar)
        .clipShape(RoundedTopRectangle(curveHeight: curveHeight))
        .onChange(of: selectedIndex) { _ in
            offsetYOfMovingBar = 0.0
        }
    }
}


fileprivate struct TestView: View {
    
    @State private var selectedIndex = 0
    
    var body: some View {
        MainScreenTabBarView<MainScreenTabViewTabSymbol>(selectedIndex: $selectedIndex,  heightOfBar: 50)
    }
}


struct MainScreenTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
