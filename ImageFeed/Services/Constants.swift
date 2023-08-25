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
}
