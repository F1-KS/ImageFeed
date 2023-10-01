import XCTest
@testable import ImageFeed

final class WebViewTests: XCTestCase {

    //MARK: - Тестируем связь контроллера и презентера
    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenterWebView = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) //behaviour verification
        print("Результат теста: \(presenter.viewDidLoadCalled)")
    }
    
    //MARK: - Тест, вызывает ли презентер после вызова presenter.viewDidLoad() метод loadRequest вьюконтроллера
    func testPresenterCallsLoadRequest() {
        //given
        let viewController = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenterWebView = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(viewController.loadCalled)
        print("Результат теста: \(viewController.loadCalled)")
    }
    
    //MARK: - Тестируем, что если значение прогресса меньше единицы, то метод возвращает false
    func testProgressVisibleWhenLessThenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertFalse(shouldHideProgress)
        print("Результат теста: \(shouldHideProgress)")
    }
    
    //MARK: -
    func testProgressHiddenWhenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertTrue(shouldHideProgress)
        print("Результат теста: \(shouldHideProgress)")
    }
    
    //MARK: - Тестируем, что ссылка, полученная из метода authURL класса AuthHelper, содержит все необходимые компоненты
    func testAuthHelperAuthURL() {
        //given
        let Constants = AuthConfiguration.standard
        let authHelper = AuthHelper(Constants: Constants)
        
        //when
        let url = authHelper.authURL()
        let urlString = url.absoluteString
        
        //then
        XCTAssertTrue(urlString.contains(Constants.unsplashAuthorizeURLString))
        XCTAssertTrue(urlString.contains(Constants.accessKey))
        XCTAssertTrue(urlString.contains(Constants.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(Constants.accessScope))
    }
    
    //MARK: - Тестируем, что AuthHelper корректно распознаёт код из ссылки
    
    func testCodeFromURL() {
        //given
        var urlComponents = URLComponents(string: Constants.nativeUnsplashAuthorizeURLString)!
        urlComponents.queryItems = [
               URLQueryItem(name: "code", value: "test code")
        ]
        let url = urlComponents.url!
        let authHelper = AuthHelper()
        
        //when
        let code = authHelper.code(from: url)
        let testCodeValue = "test code"

        //then
        if code == testCodeValue {
            print("Результат теста: ✅")
        } else {
            print("Результат теста: ❌")
        }
        XCTAssertEqual(code, testCodeValue)
    }
}

//MARK: - Объекты-дублёры

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) { }
    func code(from url: URL) -> String? { return nil }
}

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenterWebView: WebViewPresenterProtocol?
    var loadCalled: Bool = false
    
    func load(request: URLRequest) {
        loadCalled = true
    }
    
    func setProgressValue(_ newValue: Float) { }
    func setProgressHidden(_ isHidden: Bool) { }
}
