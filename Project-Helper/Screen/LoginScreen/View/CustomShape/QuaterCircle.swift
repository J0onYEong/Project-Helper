//
//  QuaterCircle.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/07/25.
//

import SwiftUI

struct QuaterCircle: Shape {
    
    var degree: Double
    
    var animatableData: Double {
        get { degree }
        set { degree = newValue }
    }
    
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let center = CGPoint(x: rect.maxX, y: rect.maxY)
        let radius = rect.maxY
        
        path.move(to: center)
        path.addArc(center: center, radius: radius, startAngle: .degrees(-90), endAngle: .degrees(-90-degree), clockwise: true)
        
        path.closeSubpath()
        
        return path
    }
    
}
