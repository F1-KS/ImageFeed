import Foundation

let AccessKey = "65tyYxZbAmH16moEzFZdIMKz1bftUNe9Wegzqn2TY24"
let SecretKey = "2kh9yN0VN1c5R_rhTOmLFw88yoTVj1RgneIiYq8mQTw"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"
var DefaultBaseURL: URL {
    guard let url = URL(string: "https://api.unsplash.com") else {
        preconditionFailure("Не удалось получить доступ к unsplash.com")
    }
    return url
}
    
    //MARK: - URL
    

