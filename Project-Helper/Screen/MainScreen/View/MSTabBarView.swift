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
    private var imageBoxWidth: CGFloat { heightOfBar * 0.7 }
    private var imageTopPadding: CGFloat { heightOfBar * 0.25 }
    
    //Constant value
    private let longPressCircleDiameter: CGFloat = 5.0
    private let countOfTabs: Int = 5
    private let movingDurationOfBar = 0.25
    
    //State
    @State private var offsetYOfMovingBar: CGFloat = -3.5
    @State private var barOffsetDisappearWaitTimer: Timer?
    
    var body: some View {
        ZStack {
            //TabItems
            ZStack {
                
                //각도오차로 인해 약간 빈틈이 발생함, 아래뷰로 가려줌
                RoundedTopRectangle(curveHeight: curveHeight)
                    .foregroundColor(.cc_white1)
                
                ForEach(0..<5) { index in
                    ZStack {
                        RoundedTopRectanglePart(curveHeight: curveHeight, radiusOfBaseCircle: radiusOfBaseCircle, countOfParts: countOfTabs)
                            .foregroundColor(.cc_white1)
                        
                        let isSelected = selectedIndex == index
                        let imageName = isSelected ? ScreenSymbol[index].clickedStateSystemImageName : ScreenSymbol[index].idleStateSystemImageName
                        
                        VStack {
                            LongPressButtonView { withAnimation(.easeOut(duration: movingDurationOfBar)) { selectedIndex = index } } label: {
                                Image(systemName: imageName)
                                    .resizable()
                                    .foregroundColor(isSelected ? .cc_red1 : .black)
                                    .padding(longPressCircleDiameter)
                            }
                            .frame(width: imageBoxWidth+longPressCircleDiameter, height: imageBoxWidth+longPressCircleDiameter)
                            .padding(.top, imageTopPadding)
                            Spacer()
                        }
                    }
                    .frame(height: heightOfBar)
                    .rotationEffect(.degrees(degreeOfPart * CGFloat(index-2)), anchor: UnitPoint(x: 0.5, y: centerPosOfBaseCircle.y / heightOfBar))
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
            
            barOffsetDisappearWaitTimer?.invalidate()
            
            barOffsetDisappearWaitTimer = Timer(timeInterval: movingDurationOfBar+1.0, repeats: false) { _ in
                withAnimation(.linear(duration: 0.5)) { offsetYOfMovingBar = -3.5 }
            }
            RunLoop.main.add(barOffsetDisappearWaitTimer!, forMode: .common)
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
