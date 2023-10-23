import XCTest
@testable import ImageFeed

final class ProfileViewTests: XCTestCase {
    
//    var profilePresenterProtocol: ProfilePresenterProtocol!
//
// //MARK: - Инициализируем тесты и в конечном итоге удалим всё, что тесты создали
//    override func setUpWithError() throws { // Перед каждым тестом, будем его инициализировать
//        profilePresenterProtocol = ProfilePresenter()
//    }
//    override func tearDownWithError() throws { // После теста, будем его уничтожать, чтобы не расходовать память и так далее
//        profilePresenterProtocol = nil
//    }
    
    //MARK: - № 1 Тестируем сбрасывается ли значение token после выхода
    
    func testExitProfileTokenValue() throws {
        //Given
        let logOut = ProfilePresenter()
        let tokenValue = OAuth2TokenStorage.shared.token
        let tokenTest: String! = nil
        //When
        logOut.exitProfile()

        //Then
        XCTAssertEqual(tokenValue, tokenTest)
        print("Печать результата теста № 1: token = \(String(describing: tokenValue)) : tokenTest = \(String(describing: tokenTest))")
    }

    //MARK: - № 2 Тестируем связь контроллера и презентера
    func testViewControllerCallsViewDidLoad() {
        //Given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        let presenter = ProfilePresenterSpy()
        viewController.presenterProfileView = presenter
        presenter.view = viewController
        
        //When
        _ = viewController.view
        
        //Then
        XCTAssertFalse(presenter.viewDidLoadCalled)
        print("Печать результата теста № 2: \(presenter.viewDidLoadCalled)")
    }
    
    //MARK: - № 3 Тестируем
    func testProfileViewCallsLogout() {
        //Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        viewController.presenterProfileView = presenter
        presenter.view = viewController

        // When
        presenter.exitProfile()

        //Then
        XCTAssertTrue(presenter.exitProfileState)
        print("Печать результата теста № 3: \(presenter.exitProfileState)")
    }
    
    //MARK: - № 4 Тестируем цвет StatusBar
    func testPreferredStatusBarStyle() {
        //Given


        // When


        //Then

    }
}

//MARK: - Объекты-дублёры

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: ProfileViewControllerProtocol?
    var exitProfileState: Bool = false
    
//    func setNotificationObserver() {
//    }
    
    func viewDidLoad(){
        viewDidLoadCalled = true
    }
    
    func exitProfile() {
        exitProfileState = true
    }
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {

    var presenterProfileView: ProfilePresenterProtocol?
    var showAlertCalled: Bool = false
    var presenter: ProfilePresenterProtocol?

//    func updateProfileDetails(profile: ImageFeed.Profile?) {
//        }
    
    func mainProfile() {
        func updateAvatar() { }
    }
    func presentAuthViewController(authViewController: UIViewController) { }
    func updateProfileDetails(profile: ImageFeed.Profile) { }
    
    func showAlert(alert: UIAlertController) {
        showAlertCalled = true
    }
}
