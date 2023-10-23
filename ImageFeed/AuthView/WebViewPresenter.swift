import UIKit
import WebKit

public protocol WebViewPresenterProtocol { // sprint_13
    var view: WebViewViewControllerProtocol? { get set } // sprint_13
    func viewDidLoad() // sprint_13
    func didUpdateProgressValue(_ newValue: Double) // sprint_13
    func code(from url: URL) -> String?
}


final class WebViewPresenter: WebViewPresenterProtocol {
    // sprint_13
    weak var view: WebViewViewControllerProtocol? // sprint_13
    var authHelper: AuthHelperProtocol // sprint_13
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
    
    func viewDidLoad() {
        
        let request = authHelper.authRequest() // sprint_13
        didUpdateProgressValue(0) // sprint_13
        view?.load(request: request) // sprint_13
    }
    
    func didUpdateProgressValue(_ newValue: Double) { // sprint_13
        let newProgressValue = Float(newValue) // sprint_13
        view?.setProgressValue(newProgressValue) // sprint_13
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue) // sprint_13
        view?.setProgressHidden(shouldHideProgress) // sprint_13
    }
    
    func shouldHideProgress(for value: Float) -> Bool { // sprint_13
        abs(value - 1.0) <= 0.0001
    }
}
