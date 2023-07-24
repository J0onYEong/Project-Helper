//
//  EnterEmailScreen.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/07/23.
//

import SwiftUI

struct EnterEmailScreen: View {
    @State private var email = ""
    @State private var active = false
    
    private var isEmailForm: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let regex = try! NSRegularExpression(pattern: emailRegex)
        let matches = regex.matches(in: email, range: NSRange(email.startIndex..., in: email))
        return !matches.isEmpty
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                TextField("Enter email", text: $email) { active = $0 }
                    .padding(20)
                    .background(
                        FoucsedBackground(active: $active, color: .orange, lineWidth: 2.0, fd: 0.5, sd: 0.3)
                    )
            }
            .position(CGPoint(x: geo.size.width/2, y: geo.size.height/2))
        }
    }
}

struct EnterEmailScreen_Previews: PreviewProvider {
    static var previews: some View {
        EnterEmailScreen()
    }
}
