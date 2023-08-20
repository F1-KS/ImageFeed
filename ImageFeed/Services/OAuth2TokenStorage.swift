import Foundation
import SwiftKeychainWrapper
import UIKit


final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    private init() {print("Синглтон инициализирован")}
    private let keyChain = KeychainWrapper.standard
    private let bearerToken = "bearerToken"
    
    var token: String? {
        get {
            keyChain.string(forKey: bearerToken)
        }
        set {
            if let token = newValue {
                keyChain.set(token, forKey: bearerToken)
            } else {
                keyChain.removeObject(forKey: bearerToken)
            }
        }
    }
}
