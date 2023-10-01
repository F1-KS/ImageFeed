import Foundation

enum Constants {
    static let accessKey = "65tyYxZbAmH16moEzFZdIMKz1bftUNe9Wegzqn2TY24"
    static let secretKey = "2kh9yN0VN1c5R_rhTOmLFw88yoTVj1RgneIiYq8mQTw"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static var defaultBaseURL: URL {
        guard let url = URL(string: "https://api.unsplash.com") else {
            preconditionFailure("Не удалось получить доступ к unsplash.com")
        }
        return url
    }
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let nativeUnsplashAuthorizeURLString = "/oauth/authorize/native"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    var defaultBaseURL: URL
    let unsplashAuthorizeURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, unsplashAuthorizeURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.unsplashAuthorizeURLString = unsplashAuthorizeURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 defaultBaseURL: Constants.defaultBaseURL,
                                 unsplashAuthorizeURLString: Constants.unsplashAuthorizeURLString)
    }
}
