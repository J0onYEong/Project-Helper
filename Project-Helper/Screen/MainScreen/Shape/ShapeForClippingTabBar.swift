//
//  ShapeForClippingTabBar.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/09/07.
//

import SwiftUI

struct RoundedTopRectangle: Shape {
    
    var curveHeight: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let widthOfShape = UIScreen.main.bounds.width
        let radius = (pow(curveHeight, 2) + pow(widthOfShape, 2)/4) / (2*curveHeight)
        //c: 탄젠트1끝 좌표까지 이어진 직선의 길이를 의미합니다.
        let c = pow(radius, 2) / (radius-curveHeight)
        //b: Shape의 바운더리에서 벗어난 탄젠트1끝 좌표의 길이를 의미합니다.
        let b = c - radius
        
        let tangent1EndPos = CGPoint(x: rect.midX, y: -b)
        let tangent2EndPos = CGPoint(x: rect.maxX, y: curveHeight)
        
        path.move(to: CGPoint(x: rect.minX, y: curveHeight))
        
        path.addArc(tangent1End: tangent1EndPos, tangent2End: tangent2EndPos, radius: radius)
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY + curveHeight))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY + curveHeight))
        path.closeSubpath()
        
        
        return path
    }
}

struct RoundedTopRectanglePart: Shape {
    var curveHeight: CGFloat
    
    var radiusOfBaseCircle: CGFloat
    
    var countOfParts: Int
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let sinValue = (UIScreen.main.bounds.width/2) / radiusOfBaseCircle
        let wholeDegree = (asin(sinValue) * 180.0 / Double.pi) * 2
        let partAngleOfDegreee = wholeDegree / CGFloat(countOfParts)
        let centerOfArc = CGPoint(x: rect.midX, y: radiusOfBaseCircle)
        let startDegreeOfAngle = -90-partAngleOfDegreee/2
        let endDegreeeOfAngle = startDegreeOfAngle+partAngleOfDegreee
        
        path.addArc(center: centerOfArc, radius: radiusOfBaseCircle, startAngle: .degrees(startDegreeOfAngle), endAngle: .degrees(endDegreeeOfAngle), clockwise: false)
        
        path.addLine(to: centerOfArc)
        
        path.closeSubpath()
        
        return path
    }
}

struct RoundedBarShape: Shape {
    var curveHeight: CGFloat
    
    var heightOfMovingBar: CGFloat
    
    var radiusOfBaseCircle: CGFloat
    
    var countOfParts: Int
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let sinValue = (UIScreen.main.bounds.width/2) / radiusOfBaseCircle
        
        let wholeDegree = (asin(sinValue) * 180.0 / Double.pi) * 2
        
        let partAngleOfDegreee = wholeDegree / CGFloat(countOfParts)
        
        let centerOfArc = CGPoint(x: rect.midX, y: radiusOfBaseCircle)
        
        let startDegreeOfAngle = -90-partAngleOfDegreee/2
        let endDegreeeOfAngle = startDegreeOfAngle+partAngleOfDegreee
        
        path.addArc(center: centerOfArc, radius: radiusOfBaseCircle, startAngle: .degrees(startDegreeOfAngle), endAngle: .degrees(endDegreeeOfAngle), clockwise: false)
        
        path.addArc(center: centerOfArc, radius: radiusOfBaseCircle-heightOfMovingBar, startAngle: .degrees(endDegreeeOfAngle), endAngle: .degrees(startDegreeOfAngle), clockwise: true)
        
        path.closeSubpath()
        
        return path
    }
}
