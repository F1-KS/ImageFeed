import Foundation

private let AccessKey = "65tyYxZbAmH16moEzFZdIMKz1bftUNe9Wegzqn2TY24"
private let SecretKey = "2kh9yN0VN1c5R_rhTOmLFw88yoTVj1RgneIiYq8mQTw"
private let RedirectURI = "https://unsplash.com/@f1_ks"
private let AccessScope = "public+read_user+write_likes"
private var DefaultBaseURL: URL {
    guard let url = URL(string: "https://unsplash.com") else {
        preconditionFailure("Не удалось получить доступ к unsplash.com")
    }
    return url
}
    
    //MARK: - URL
    

