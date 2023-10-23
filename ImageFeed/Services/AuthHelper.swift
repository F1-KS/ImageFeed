import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
}

class AuthHelper: AuthHelperProtocol {
    
    let constants: AuthConfiguration
    
    init(Constants: AuthConfiguration = .standard) {
        self.constants = Constants
    }
    
    func authRequest() -> URLRequest {
        let url = authURL()
        return URLRequest(url: url)
    }
    
    func code(from url: URL) -> String? {
        if
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == Constants.nativeUnsplashAuthorizeURLString,
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    func authURL() -> URL {
        var urlComponents = URLComponents(string: constants.unsplashAuthorizeURLString)!  //1 инициализируем структуру URLComponents с указанием адреса запроса
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: constants.accessKey),                  //2 устанавливаем значение client_id — код доступа нашего приложения
            URLQueryItem(name: "redirect_uri", value: constants.redirectURI),             //3 устанавливаем значение redirect_uri — URI, который обрабатывает успешную авторизацию пользователя
            URLQueryItem(name: "response_type", value: "code"),                 //4 устанавливаем значение response_type — тип ответа, который мы ожидаем. Unsplash ожидает от нас значения code
            URLQueryItem(name: "scope", value: constants.accessScope)                     //5 устанавливаем значение scope — списка доступов, разделённых плюсом
        ]
        return urlComponents.url! //6 поле urlComponents.url содержит нужный нам URL, используем implicit unwrap, так как если URL не сформируется, то это будет критической ошибкой
    }
}
