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
    @FocusState private var focusState: Bool
    
    let bgColor: Color = .idleBackground
    
    private var isEmailForm: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let regex = try! NSRegularExpression(pattern: emailRegex)
        let matches = regex.matches(in: email, range: NSRange(email.startIndex..., in: email))
        return !matches.isEmpty
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                bgColor
                    .ignoresSafeArea()
                
                VStack {
                    TextField("이메일을 입력하세요", text: $email) { active = $0 }
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .focused($focusState)
                        .padding(20)
                        .background(
                            FoucsedBackground(active: $active, lineColor: .sunflower, backgroundOrg: bgColor, backgroundTar: .cloud, lineWidth: 4.0, fd: 0.4, sd: 0.2)
                        )
                        .padding(.horizontal, 20)
                        
                }
            }
            .position(CGPoint(x: geo.size.width/2, y: geo.size.height/2))
        }
        .onAppear {
            focusState = true
        }
    }
}

struct EnterEmailScreen_Previews: PreviewProvider {
    static var previews: some View {
        EnterEmailScreen()
    }
}
