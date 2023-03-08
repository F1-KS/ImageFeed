import Foundation
import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!  //1 инициализируем структуру URLComponents с указанием адреса запроса
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),                  //2 устанавливаем значение client_id — код доступа нашего приложения
            URLQueryItem(name: "redirect_uri", value: RedirectURI),             //3 устанавливаем значение redirect_uri — URI, который обрабатывает успешную авторизацию пользователя
            URLQueryItem(name: "response_type", value: "code"),                 //4 устанавливаем значение response_type — тип ответа, который мы ожидаем. Unsplash ожидает от нас значения code
            URLQueryItem(name: "scope", value: AccessScope)                     //5 устанавливаем значение scope — списка доступов, разделённых плюсом
        ]
        let url = urlComponents.url!                                            //6 поле urlComponents.url содержит нужный нам URL, используем implicit unwrap, так как если URL не сформируется, то это будет критической ошибкой
        
        let request = URLRequest(url: url)
        webView.load(request)
        webView.navigationDelegate = self
    }
    
    private let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    weak var delegate: WebViewViewControllerDelegate?
    
    @IBOutlet private var webView: WKWebView!
    @IBAction private func didTapBackButton(_ sender: Any?) {delegate?.webViewViewControllerDidCancel(self)}
    
    
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) { // 1 Мы вызываем функцию code(from:) с параметром navigationAction. Она возвращает код авторизации, если он получен
            //TODO: process code                     //2 Мы пока не обрабатываем полученный код. Оставим себе комментарий вида //TODO:, чтобы не забыть сделать это в дальнейшем. Xcode выделяет такие комментарии предупреждениями
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel) //3 Если код успешно получен, отменяем навигационное действие
        } else {
            decisionHandler(.allow) //4 Если код не получен, разрешаем навигационное действие. Возможно, пользователь просто переходит на новую страницу в рамках процесса авторизации
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,                         //1 Получаем из навигационного действия navigationAction URL
            let urlComponents = URLComponents(string: url.absoluteString),  //2 Создаём уже известную нам структуру URLComponents. Только теперь мы будем не формировать URL с помощью компонентов, а наоборот — получать значения компонентов из URL
            urlComponents.path == "/oauth/authorize/native",                //3 Проверяем, совпадает ли адрес запроса с адресом получения кода
            let items = urlComponents.queryItems,                           //4 Проверяем, есть ли в URLComponents компоненты запроса (в них должен быть код). Компонент запроса URLQueryItem — это структура, которая содержит имя компонента name и его значение value
            let codeItem = items.first(where: { $0.name == "code" })        //5 Ищем в массиве компонентов такой компонент, у которого значение name == code
        {
            return codeItem.value                                           //6 Если все проверки выше прошли успешно, возвращаем значение value найденного компонента. Иначе возвращаем nil
        } else {
            return nil
        }
    }
    
    
}

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController (_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

