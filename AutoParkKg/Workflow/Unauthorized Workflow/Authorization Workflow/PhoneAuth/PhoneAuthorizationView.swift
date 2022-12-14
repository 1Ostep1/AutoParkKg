//
//  PhoneAuthorizationView.swift
//  AutoParkKg
//
//  Created by Iusupov Ramazan on 14/12/22.
//

import Foundation
import SwiftUI

struct PhoneAuthorizationView: View {
    @StateObject var viewModel: PhoneAuthorizationViewModel
    
    @State var isShowingDetailView = false
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: PhoneVerificationView(viewModel: viewModel), isActive: $isShowingDetailView) {
                    TextField("Номер телефона", text: $viewModel.phoneNumber)
                        .frame(height: 150)
                    
                    Button {
                        viewModel.signInWithPhoneNumber { res in
                            isShowingDetailView = res
                        }
                    } label: {
                        Text("Sign In")
                    }
                    .padding()
                }
            }
        }
    }
}

struct PhoneVerificationView: View {
    @ObservedObject var viewModel: PhoneAuthorizationViewModel
    
    var body: some View {
        VStack {
            TextField("Код подтверждения", text: $viewModel.verificationCode)
            
            Spacer()
            
            Button {
                viewModel.verificatePhoneNumber()
            } label: {
                Text("Sign In")
            }
            .padding()
        }
    }
}
