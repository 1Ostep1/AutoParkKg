//
//  PhoneAuthorizationViewModel.swift
//  AutoParkKg
//
//  Created by Iusupov Ramazan on 14/12/22.
//

import Foundation
import FirebaseAuth

class PhoneAuthorizationViewModel: ObservableObject {
    private let authService: AuthService
    
    @Published public var phoneNumber: String = "+996505211102"
    @Published public var verificationCode: String = ""
    
    public init(authService: AuthService) {
        self.authService = authService
    }
    
    convenience init() {
        self.init(authService: AuthService())
    }
    
    func signInWithPhoneNumber(completion: @escaping (Bool) -> Void) {
        authService.signInWithPhoneNumber(phoneNumber) { result in
            if case .success = result {
                completion(true)
            }
        }
    }
    
    func verificatePhoneNumber() {
        authService.verificatePhoneNumber(with: verificationCode) { result in
            print(result)
        }
    }
}
