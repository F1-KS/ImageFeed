import Foundation

let accessKey = "65tyYxZbAmH16moEzFZdIMKz1bftUNe9Wegzqn2TY24"
let secretKey = "2kh9yN0VN1c5R_rhTOmLFw88yoTVj1RgneIiYq8mQTw"
let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
let accessScope = "public+read_user+write_likes"
var defaultBaseURL: URL {
    guard let url = URL(string: "https://api.unsplash.com") else {
        preconditionFailure("Не удалось получить доступ к unsplash.com")
    }
    return url
}
    
    //MARK: - URL
    

