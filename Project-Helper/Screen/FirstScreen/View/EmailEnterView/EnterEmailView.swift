//
//  EnterEmailView.swift
//  Project-Helper
//
//  Created by 최준영 on 2023/07/23.
//

import SwiftUI

enum EnterEmailViewState: ViewState {
    case disappear, appear, active, inactive, submitSuccess, congestion
    
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
        case .submitSuccess:
            return ""
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
    
    @State private var isDisabled = true
    
    static private let orgOffset = CGSize(width: 1000, height: 0)
    static private let tarOffset = CGSize(width: 0, height: 0)
    
    //State & Controller
    @ObservedObject private var controller = EnterEmailViewController()
    @FocusState private var focusState: Bool
    
    //TF configuration
    private let fontSize: CGFloat = 17.0
    private let tfHeight: CGFloat = 20.0
    
    //active 애니메이션 진행 시간
    private let fd: CGFloat = 0.4
    private let sd: CGFloat = 0.4
    private var totalAnimTime: CGFloat { fd+sd }
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                TextField(controller.placeHolderString, text: $controller.email)
                    .font(Font.system(size: fontSize))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .focused($focusState)
                    .disabled(isDisabled)
                    .keyboardType(.emailAddress)
                    .onSubmit {
                        if controller.submit() { viewState = .submitSuccess }
                        else { focusState = true}
                    }
                    .frame(height: tfHeight)
                    .padding(.vertical, 10)
                Spacer()
                
                if controller.showingDeleteBtn {
                    Button { controller.onDeleteBtnPressed() } label: {
                        Image(systemName: "x.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(controller.deleteBtnColor)
                            .padding(.vertical, 7)
                    }
                    .transition(.scale)   
                }
            }
            .frame(height: tfHeight+20)
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(
                FoucsedBackgroundView(viewState: $fbViewState, lineColor: controller.lineColor, backgroundOrg: .clear, backgroundTar: .itemBlockColor, lineWidth: 4.0, fd: fd, sd: sd)
            )
            .padding(.horizontal, 20)
            .overlay {
                Text(controller.wrongFormatNoti.text)
                    .font(Font.system(size: 15, weight: .bold))
                    .foregroundColor(.errorTextColor)
                    .offset(CGSize(width: 0, height: -50))
                    .scaleEffect(controller.wrongFormatNoti.scaleAmount)
            }
            .position(CGPoint(x: geo.size.width/2, y: geo.size.height/4))
            .offset(mainViewOffset)
        }
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
            case .submitSuccess:
                submitSuccess()
            case .congestion:
                return
            }
        }
        .onChange(of: controller.error) { controller.showAlert = $0 != nil ? true : controller.showAlert }
        .onChange(of: controller.email) { inputStr in withAnimation { controller.showingDeleteBtn = !inputStr.isEmpty } }
        .onChange(of: controller.focusReqFromComtroller) { state in
            if state {
                focusState = true
                controller.focusReqFromComtroller = false
            }
        }
        .onChange(of: isDisabled) { focusState = !$0}
        .alert(controller.error?.description ?? "", isPresented: $controller.showAlert) { Button("닫기") {
                controller.showAlert = false
                controller.error = nil
                
                //인증에 실패하였음으로 다시 입력을 요청한다.
                viewState = .active
            } }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

// MARK: - Animation
extension EnterEmailView {
    func disappear() { mainViewOffset = Self.orgOffset }
    func appear() { mainViewOffset = Self.tarOffset }
    func active() {
        isDisabled = false
        //FocusedBackground뷰상태 변경
        fbViewState = .active
        Timer.scheduledTimer(withTimeInterval: totalAnimTime, repeats: false) { _ in
            self.controller.showPlaceHolder()
        }
    }
    func inactive() {
        isDisabled = true
        controller.resetAllConfig()
        //FocusedBackground뷰상태 변경
        fbViewState = .inactive
    }
    func submitSuccess() {
        inactive()
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
