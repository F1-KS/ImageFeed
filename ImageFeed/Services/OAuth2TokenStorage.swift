import Foundation


final class OAuth2TokenStorage {
    
    let accessToken = "token"
    var token: String? {
        get {UserDefaults.standard.string(forKey: accessToken)}
        set {UserDefaults.standard.set(newValue, forKey: accessToken)}
    }
    
}
