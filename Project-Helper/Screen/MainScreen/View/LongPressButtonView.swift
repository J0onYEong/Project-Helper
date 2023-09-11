//
//  LongPressButtonView.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/09/11.
//

import SwiftUI

struct LongPressButtonView: View {
    
    var onEndedAction: () -> ()
    
    @State private var opacityOfCircle: CGFloat = 0.0
    @State private var opacityEventTimer: Timer?
    
    private let opacityVarianceValue: CGFloat = 0.01
    private let targetOpacityOfCircle: CGFloat = 0.7
    private let timeOfFulfillOpacity: CGFloat = 0.5
    
    var body: some View {
        ZStack {
            let timesOfvariance = targetOpacityOfCircle / opacityVarianceValue
            let timerTerm = timeOfFulfillOpacity / timesOfvariance
            let pressAndDrageGesture = LongPressGesture(minimumDuration: 0.0)
                .sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .local))
            
            Circle()
                .fill(.gray.opacity(opacityOfCircle))
                .contentShape(Circle())
                .gesture(
                    pressAndDrageGesture
                        .onChanged({ _ in
                            if let timer = opacityEventTimer, timer.isValid { return; }
                            opacityEventTimer?.invalidate()
                            opacityEventTimer = Timer(timeInterval: timerTerm, repeats: true, block: { timer in
                                opacityOfCircle += opacityVarianceValue
                                if opacityOfCircle >= targetOpacityOfCircle {
                                    opacityOfCircle = targetOpacityOfCircle
                                    timer.invalidate()
                                }
                            })
                            
                            RunLoop.main.add(opacityEventTimer!, forMode: .common)
                        })
                        .onEnded({ _ in
                            
                            onEndedAction()
                            
                            opacityEventTimer?.invalidate()
                            opacityEventTimer = Timer(timeInterval: timerTerm, repeats: true, block: { timer in
                                opacityOfCircle -= opacityVarianceValue
                                if opacityOfCircle < 0 {
                                    opacityOfCircle = 0.0
                                    timer.invalidate()
                                }
                            })

                            RunLoop.main.add(opacityEventTimer!, forMode: .common)
                        })
                )
            
        }
    }
}

struct LongPressButtonView_Previews: PreviewProvider {
    static var previews: some View {
        LongPressButtonView { }
    }
}

