//
//  GlobalExtension.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/07/25.
//

import SwiftUI


// MARK: - Color
extension ShapeStyle where Self == Color {
    //Global Color
    static var idleBackground: Color { Self.cc_white2 }
    static var itemBlockColor: Color { Self.cc_white1 }
    static var errorTextColor: Color { Self.cc_red1 }
    static var pointColor1: Color { Self.cc_blue1 }
    static var pointColor2: Color { Self.cc_blue2 }
    
    static var sunflower: Color {  hexToColor(hex: "#f1c40f") }
    static var hotPink1: Color { hexToColor(hex: "#ff9ff3") }
    static var heavyPink: Color { hexToColor(hex: "#f368e0") }
    static var cloud: Color { hexToColor(hex: "#ecf0f1") }
    static var placeHolder1: Color { hexToColor(hex: "#bdc3c7") }
    static var waterBlue: Color { hexToColor(hex: "#a29bfe" )}
    static var mintChocolate: Color { hexToColor(hex: "#1dd1a1") }
    static var prettyPurple: Color { hexToColor(hex: "#5f27cd") }
    static var pastelRed: Color { hexToColor(hex: "#ff6b6b") }
    static var skyblue1: Color { hexToColor(hex: "#48dbfb") }
    
    //컨셉 컬러(white mode)
    static var cc_blue1: Color { hexToColor(hex: "#235FD9") }
    static var cc_blue2: Color { hexToColor(hex: "#044BD9") }
    static var cc_white1: Color { hexToColor(hex: "#F0F2F2") }
    static var cc_white2: Color { hexToColor(hex: "#DFE4F2") }
    static var cc_red1: Color { hexToColor(hex: "#F20505") }
    
    
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


// MARK: - Font
extension Font {
    static func blackHansSans(_ size: CGFloat) -> Font {
        .custom("BlackHanSans-Regular", size: size)
    }
    
    enum CustomWeight {
        case bold, light, regular
    }
    
    static func rowdies(_ size: CGFloat, weight: CustomWeight) -> Font {
        switch weight {
        case .bold:
            return .custom("Rowdies-Bold", size: size)
        case .light:
            return .custom("Rowdies-Light", size: size)
        case .regular:
            return .custom("Rowdies-Regular", size: size)
        }
    }
}


// MARK: - Text
extension Text {
    public func withGradient(gradient: LinearGradient) -> some View {
        self.overlay {
            gradient
                .mask(self)
        }
    }
}


// MARK: - String
extension Array where Element == String {
    struct StringWithId: Identifiable {
        let id: Int
        var str: String
    }
    
    func mapArrayWithId() -> Array<StringWithId> {
        self.enumerated().map { index, element in
            StringWithId(id: index, str: element)
        }
    }
}
