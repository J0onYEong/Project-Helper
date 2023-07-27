//
//  EnterEmailScreen.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/07/23.
//

import SwiftUI

struct EnterEmailScreen: View {
    //input
    @State private var email = ""
    @State private var active = false
    
    //submit
    @State private var scaleAmount = 1.0
    private let targetScale = 1.1
    @State private var warningString = ""
    private let targetWarningString = "잘못된 이메일 형식입니다."
    
    //style
    @State private var lineColor: Color = .sunflower
    
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
                    TextField("이메일을 입력하세요", text: $email) { state in
                        if state {
                            active = true
                        }
                        
                    }
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .focused($focusState)
                        .onSubmit {
                            if !isEmailForm {
                                validationFailureConf()
                            } else {
                                validationSuccessConf()
                                
                                LoginManager.shared.createEmailLink(email: email)
                            }
                        }
                        .padding(20)
                        .background(
                            FoucsedBackground(active: $active, lineColor: lineColor, backgroundOrg: bgColor, backgroundTar: .cloud, lineWidth: 4.0, fd: 0.4, sd: 0.2)
                        )
                        .padding(.horizontal, 20)
                        .overlay {
                            Text(warningString)
                                .font(Font.system(size: 15, weight: .bold))
                                .foregroundColor(.softWarning)
                                .offset(CGSize(width: 0, height: -50))
                                .scaleEffect(scaleAmount)
                        }
                }
            }
            .position(CGPoint(x: geo.size.width/2, y: geo.size.height/4))
        }
        .onAppear {
            focusState = true
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onOpenURL { url in
            LoginManager.shared.authenticationWithLink(link: url)
        }
        
        
    }
    func validationFailureConf() {
        lineColor = .softWarning
        
        warningString = targetWarningString
        
        withAnimation(.interpolatingSpring(stiffness: 10000, damping: 20)) {
            scaleAmount = targetScale
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            scaleAmount = 1.0
        }
        
        focusState = true
    }
    
    func validationSuccessConf() {
        lineColor = .sunflower
        warningString = ""
    }
}

struct EnterEmailScreen_Previews: PreviewProvider {
    static var previews: some View {
        EnterEmailScreen()
    }
}
