//
//  UserDefaults.swift
//  AutoParkKg
//
//  Created by Iusupov Ramazan on 14/12/22.
//

import Foundation
import SwiftUI

public extension UserDefaults {
    enum UserDefaultsName: String {
        case verificationId
    }
 
    func setValue(_ value: Any?, forKey key: UserDefaultsName) {
        setValue(value, forKey: key.rawValue)
    }
    
    func getString(forKey key: UserDefaultsName) -> String {
        string(forKey: key.rawValue)!
    }
    
    func getBoolean(forKey key: UserDefaultsName) -> Bool {
        bool(forKey: key.rawValue)
    }
    
    func getInteger(forKey key: UserDefaultsName) -> Int {
        integer(forKey: key.rawValue)
    }
    
    func getDouble(forKey key: UserDefaultsName) -> Double {
        double(forKey: key.rawValue)
    }
}
