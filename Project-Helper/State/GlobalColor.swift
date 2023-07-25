//
//  GlobalColor.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/07/25.
//

import SwiftUI

extension ShapeStyle where Self == Color {
    static var idleBackground: Color { hexToColor(hex: "#34495e") }
    static var sunflower: Color {  hexToColor(hex: "#FFC312") }
    static var hotPink1: Color { hexToColor(hex: "#ff9ff3") }
    static var cloud: Color { hexToColor(hex: "#ecf0f1") }
    
    private static func hexToColor(hex: String) -> Color! {
        var cleanedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cleanedHex.hasPrefix("#") {
            cleanedHex.remove(at: cleanedHex.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cleanedHex).scanHexInt64(&rgbValue)

        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0

        return Color(UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0))
    }
}

