//
//  LongPressButtonView.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/09/11.
//

import SwiftUI

struct LongPressButtonView<Label>: View where Label: View {
    
    var actionWhenPressGestureEnded: () -> ()
    
    var label: () -> Label
    
    //backgroundCircle
    @State private var opacityOfCircle: CGFloat = 0.0
    @State private var circleOpacityEventTimer: Timer?
    
    //label
    @State private var scaleValueOfLabel: CGFloat = 1.0
    @State private var labelScaleEventTimer: Timer?
    
    //constant of label
    private let labelScaleVarianceValue: CGFloat = 0.01
    private let targetScaleOfLabel: CGFloat = 0.9
    private let timeOfFulfillLabelScale: CGFloat = 0.5
    
    //constant of circle
    private let circleOpacityVarianceValue: CGFloat = 0.01
    private let targetOpacityOfCircle: CGFloat = 0.5
    private let timeOfFulfillCircleOpacity: CGFloat = 0.5
    
    //Gesture
    let pressAndDrageGesture = LongPressGesture(minimumDuration: 0.0)
        .sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .local))
    
    //caculation property
    private var circleOpacitytimesOfvariance: CGFloat { targetOpacityOfCircle / circleOpacityVarianceValue }
    private var circleOpacityTimerIntetval: CGFloat { timeOfFulfillCircleOpacity / circleOpacitytimesOfvariance }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.gray.opacity(opacityOfCircle))
                .contentShape(Circle())
                .gesture(
                    pressAndDrageGesture
                        .onChanged({ _ in
                            labelScaleDecreaseStart()
                            circleOpacityIncreaseStart()
                        })
                        .onEnded({ _ in
                            actionWhenPressGestureEnded()
                            
                            labelScaleIncreaseStart()
                            circleOpacityDecreaseStart()
                        })
                )
            
            label()
                .scaleEffect(scaleValueOfLabel)
                .allowsHitTesting(false)
        }
    }
    
    //label
    func labelScaleDecreaseStart() {
        let labelScaletimesOfvariance: CGFloat = (1-targetScaleOfLabel) / labelScaleVarianceValue
        let labelScaleTimerIntetval: CGFloat = timeOfFulfillLabelScale / labelScaletimesOfvariance
        
        if let timer = labelScaleEventTimer, timer.isValid { return; }
        labelScaleEventTimer?.invalidate()
        labelScaleEventTimer = Timer(timeInterval: labelScaleTimerIntetval, repeats: true, block: { timer in
            scaleValueOfLabel -= labelScaleVarianceValue
            if scaleValueOfLabel <= targetScaleOfLabel {
                scaleValueOfLabel = targetScaleOfLabel
                timer.invalidate()
            }
        })
        
        RunLoop.main.add(labelScaleEventTimer!, forMode: .common)
    }
    
    func labelScaleIncreaseStart() {
        labelScaleEventTimer?.invalidate()
        withAnimation(.interpolatingSpring(stiffness: 500, damping: 20)) {
            scaleValueOfLabel = 1.0
        }
    }
    
    //circle
    func circleOpacityIncreaseStart() {
        if let timer = circleOpacityEventTimer, timer.isValid { return; }
        circleOpacityEventTimer?.invalidate()
        circleOpacityEventTimer = Timer(timeInterval: circleOpacityTimerIntetval, repeats: true, block: { timer in
            opacityOfCircle += circleOpacityVarianceValue
            if opacityOfCircle >= targetOpacityOfCircle {
                opacityOfCircle = targetOpacityOfCircle
                timer.invalidate()
            }
        })
        
        RunLoop.main.add(circleOpacityEventTimer!, forMode: .common)
    }
    
    func circleOpacityDecreaseStart() {
        circleOpacityEventTimer?.invalidate()
        circleOpacityEventTimer = Timer(timeInterval: circleOpacityTimerIntetval, repeats: true, block: { timer in
            opacityOfCircle -= circleOpacityVarianceValue
            if opacityOfCircle < 0 {
                opacityOfCircle = 0.0
                timer.invalidate()
            }
        })

        RunLoop.main.add(circleOpacityEventTimer!, forMode: .common)
    }
}

struct LongPressButtonView_Previews: PreviewProvider {
    static var previews: some View {
        LongPressButtonView { } label: {
            Image(systemName: "person.circle")
                .resizable()
                .padding(5)
        }
        .frame(width: 40, height: 40)
    }
}

