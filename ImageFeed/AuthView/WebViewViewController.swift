import UIKit
import WebKit


public protocol WebViewViewControllerProtocol: AnyObject{ // sprint_13
    var presenterWebView: WebViewPresenterProtocol? { get set } // sprint_13
    func load(request: URLRequest) // sprint_13
    func setProgressValue(_ newValue: Float) // sprint_13
    func setProgressHidden(_ isHidden: Bool) // sprint_13
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol{ // sprint_13
    
    static let shared = WebViewViewController()
    var presenterWebView: WebViewPresenterProtocol? // sprint_13
    let vVP: WebViewPresenter? = nil // sprint_13
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        presenterWebView?.viewDidLoad()
    }
    
    // Подписываемся для наблюдения
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    // Обязательно отписываемся от подписки
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
    weak var delegate: WebViewViewControllerDelegate?
    
    @IBOutlet private var webView: WKWebView!
    @IBAction private func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    @IBOutlet private var progressView: UIProgressView!
    
    //MARK: - Обработчик обновлений состояния загрузки в progressView
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            presenterWebView?.didUpdateProgressValue(webView.estimatedProgress) // sprint_13
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func setProgressValue(_ newValue: Float) { // sprint_13
        progressView.progress = newValue // sprint_13
    }
    
    func setProgressHidden(_ isHidden: Bool) { // sprint_13
        progressView.isHidden = isHidden // sprint_13
    }
    
    func load(request: URLRequest) { // sprint_13
        webView.load(request) // sprint_13
    }
    
}

// MARK: -

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
            let url = navigationAction.request.url {
            return presenterWebView?.code(from: url)
        }
        return nil
    }
}

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController (_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

//MARK: - Очищаем куки веб-браузера

extension WebViewViewController {
    
    func webViewClean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast) // очищаются cookie веб-браузера
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
