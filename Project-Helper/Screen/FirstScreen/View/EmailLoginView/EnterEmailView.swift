//
//  EnterEmailView.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/07/23.
//

import SwiftUI

enum EnterEmailViewState: ViewState {
    case disappear, appear, active, inactive, congestion
    
    static var initialState: EnterEmailViewState { .disappear }
    
    var desciption: String {
        switch self {
        case .disappear:
            return "disappear"
        case .appear:
            return "appear"
        case .active:
            return "active"
        case .inactive:
            return "inactive"
        case .congestion:
            return "congestion"
        }
    }
    
}

struct EnterEmailView: AnimatableView {    
    //Animation
    @Binding var viewState: EnterEmailViewState
    @State private var fbViewState: FoucsedBackgroundViewState = .initialState
    @State private var mainViewOffset = orgOffset
    
    static private let orgOffset = CGSize(width: 1000, height: 0)
    static private let tarOffset = CGSize(width: 0, height: 0)
    
    //
    @ObservedObject private var controller = EnterEmailViewController()
    @FocusState private var focusState: Bool
    @State private var showAlert = false
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                TextField("이메일을 입력하세요", text: $controller.email, onEditingChanged: controller.editingChange)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .focused($focusState)
                    .onSubmit { if !controller.submit() { focusState = true } }
                    .padding(20)
                    .background(
                        FoucsedBackgroundView(viewState: $fbViewState, lineColor: controller.lineColor, backgroundOrg: controller.bgColor, backgroundTar: .cloud, lineWidth: 4.0, fd: 0.4, sd: 0.2)
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
            .offset(mainViewOffset)
        }
        .onOpenURL { controller.redirectionComplete(url: $0) }
        .onChange(of: controller.error) { showAlert = $0 != nil ? true : showAlert }
        .alert(controller.error?.description ?? "", isPresented: $showAlert) {
            Button("닫기") {
                showAlert = false
                controller.error = nil
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onChange(of: viewState) { state in
            switch state {
            case .disappear:
                disappear()
            case .appear:
                appear()
            case .active:
                active()
            case .inactive:
                inactive()
            case .congestion:
                return
            }
        }
    }
}


// MARK: - Animation
extension EnterEmailView {
    func disappear() {
//        focusState = false
//        fbViewState = .inactive
        mainViewOffset = Self.orgOffset
    }
    
    func appear() {
        mainViewOffset = Self.tarOffset
    }
    
    func active() {
        focusState = true
        fbViewState = .active
    }
    
    func inactive() {
        focusState = false
        fbViewState = .inactive
    }
    
}


fileprivate struct TestView: View {
    @State private var state: EnterEmailViewState = .initialState
    var body: some View {
        ZStack {
            Color.idleBackground
                .ignoresSafeArea()
            
            EnterEmailView(viewState: $state)

            VStack {
                Spacer()
                Spacer()
                HStack { ForEach(EnterEmailViewState.allCases, id: \.self) { st in Button(st.desciption) { state = st } } }
                Spacer()
            }
        }
    }
}


struct EnterEmailView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
