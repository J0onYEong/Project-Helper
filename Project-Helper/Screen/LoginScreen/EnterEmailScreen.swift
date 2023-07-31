//
//  EnterEmailScreen.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/07/23.
//

import SwiftUI

struct EnterEmailScreen: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var controller = EmailScreenController()
    @FocusState private var focusState: Bool
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            controller.bgColor
                .ignoresSafeArea()
            GeometryReader { geo in
                VStack {
                    TextField("이메일을 입력하세요", text: $controller.email, onEditingChanged: controller.editingChange)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
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
                        .keyboardType(.emailAddress)
                }
                .position(CGPoint(x: geo.size.width/2, y: geo.size.height/4))
            }
            .onAppear { focusState = true }
            .onOpenURL { controller.redirectionComplete(url: $0) }
            .onChange(of: controller.error) { showAlert = $0 != nil ? true : showAlert }
            .alert(controller.error?.description ?? "", isPresented: $showAlert) {
                Button("닫기") {
                    showAlert = false
                    controller.error = nil
                    dismiss()
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}


struct EnterEmailScreen_Previews: PreviewProvider {
    static var previews: some View {
        EnterEmailScreen()
    }
}
