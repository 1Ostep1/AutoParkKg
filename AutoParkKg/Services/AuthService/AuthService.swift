//
//  AuthService.swift
//  AutoParkKg
//
//  Created by Iusupov Ramazan on 14/12/22.
//

import Foundation
import FirebaseAuth

public final class AuthService {
    
    public init() {
        
    }
    
    public func signInWithPhoneNumber(_ phoneNum: String, completion: @escaping (Result<Void, Error>) -> Void) {
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNum, uiDelegate: nil) { verificationID, error in
                if let error = error {
                    debugPrint("\(error.localizedDescription) at line: \(#line) at file: \(#file)")
                    completion(.failure(error))
                    return
                }
                
                UserDefaults.standard.setValue(verificationID, forKey: .verificationId)
                completion(.success(()))
            }
    }
    
    public func verificatePhoneNumber(with verificationCode: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        let verificationID = UserDefaults.standard.getString(forKey: .verificationId)

        let credential = PhoneAuthProvider.provider().credential(
          withVerificationID: verificationID,
          verificationCode: verificationCode
        )
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                completion(.failure(error))
            }
            
            if let authResult = authResult {
                completion(.success(authResult))
            }
        }
    }
}
