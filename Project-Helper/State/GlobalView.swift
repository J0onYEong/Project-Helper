//
//  GlobalView.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/08/03.
//

import SwiftUI

struct ImageCircle: View {
    var systemName: String
    var lineColor: Color
    
    var body: some View {
        
        GeometryReader { geo in
            ZStack {
                Circle()
                    .fill(.cloud)
                Circle()
                    .strokeBorder(lineColor, lineWidth: geo.size.width/20)
                Image(systemName: systemName)
                    .resizable()
                    .scaledToFit()
                    .padding(geo.size.width/4)
            }
            .position(x: geo.size.width/2, y: geo.size.height/2)
        }
        .aspectRatio(contentMode: .fit)
        .foregroundColor(.black)
    }
}
