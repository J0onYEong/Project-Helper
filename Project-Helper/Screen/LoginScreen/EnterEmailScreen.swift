//
//  EnterEmailScreen.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/07/23.
//

import SwiftUI

struct EnterEmailScreen: View {
    @ObservedObject private var controller = EmailScreenController()
    
    @FocusState private var focusState: Bool
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                controller.bgColor
                    .ignoresSafeArea()
                
                VStack {
                    TextField("이메일을 입력하세요", text: $controller.email, onEditingChanged: controller.editingChange)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .focused($focusState)
                        .onSubmit { if !controller.submit() { focusState = true } }
                        .padding(20)
                        .background(
                            FoucsedBackground(active: $controller.activeAnim, lineColor: controller.lineColor, backgroundOrg: controller.bgColor, backgroundTar: .cloud, lineWidth: 4.0, fd: 0.4, sd: 0.2)
                        )
                        .padding(.horizontal, 20)
                        .overlay {
                            Text(controller.submitVar.warningStr)
                                .font(Font.system(size: 15, weight: .bold))
                                .foregroundColor(.softWarning)
                                .offset(CGSize(width: 0, height: -50))
                                .scaleEffect(controller.submitVar.scaleAmount)
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
}


struct EnterEmailScreen_Previews: PreviewProvider {
    static var previews: some View {
        EnterEmailScreen()
    }
}
