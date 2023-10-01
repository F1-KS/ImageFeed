import UIKit

public protocol ProfilePresenterProtocol { // sprint_13
    var view: ProfileViewControllerProtocol? { get set } // sprint_13
    func exitProfile()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let webVVC = WebViewViewController()
    
    func exitProfile(){
        OAuth2TokenStorage.shared.token = nil
        webVVC.webViewClean()
        guard let window = UIApplication.shared.windows.first else {fatalError("Invalid Configuration")}
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
    }
}
