import XCTest


final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication() // переменная приложения
    
    private let unsplashWebView = "Connect ImageFeed + Unsplash | Unsplash"
    private let loginText = "f1-ks@yandex.ru"
    private let passwordText = "duqzam-4syxzo-xukseZ"
    private let loginOneButton = "Login"
    private let exitProfileButton = "ipad.and.arrow.forward"
    private let likeButton = "likeButton"
    private let returnToFeedScreen = "nav white button"
    private let fullNameUser = "Dmitry I"
    private let nicknameUser = "@f1_ks"
    private let bioUserProfile = "Здесь должно быть описание биографии"
    
    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    func testMyDemo() throws {
        
    }
    
    //MARK: - Тестируем сценарий авторизации
    func testAuth() throws {
        // тестируем сценарий авторизации:
//        let app = XCUIApplication() // ❗️разблокировать если требуется запустить только тест testAuth
        
        // Нажать кнопку авторизации
        app.buttons["Authenticate"].tap()
        
        // Подождать, пока экран авторизации открывается и загружается
        let webViewsQuery = app.webViews.webViews.webViews
        let connectImagefeedUnsplashUnsplashElement = webViewsQuery.otherElements[unsplashWebView]
        XCTAssertTrue(connectImagefeedUnsplashUnsplashElement.waitForExistence(timeout: 10))

        // Ввести данные (логин и пароль) в форму
        let loginTextField = connectImagefeedUnsplashUnsplashElement.children(matching: .textField).element // вводим Логин
        loginTextField.tap()
        loginTextField.typeText(loginText)
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))

        
        let passwordTextField = connectImagefeedUnsplashUnsplashElement.children(matching: .secureTextField).element // вводим пароль
        passwordTextField.tap()
        passwordTextField.typeText(passwordText)
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10))
        
        // Нажать кнопку логина
        webViewsQuery.buttons[loginOneButton].tap()
        
        // Подождать, пока открывается экран ленты
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
        sleep(2) // ждем 2 секунды

        // ❗️разблокировать если требуется запустить только testAuth тест и требуется его повторно запустить
        // перейдем на вкладку профиль и выйдем из профиля
//        app.tabBars["Tab Bar"].children(matching: .button).element(boundBy: 1).tap() // перейдем в меню профиля
//        sleep(2)
//        app.buttons[exitProfileButton].tap() // нажмем на кнопку выхода из профиля
//        sleep(2)
//        app.alerts["Выход"].scrollViews.otherElements.buttons["Да"].tap() // в алерте подтвердим выход из профиля
//        sleep(2)
    }
    
    //MARK: - Тестируем сценарий ленты
    
    func testFeed() throws {
        // тестируем сценарий ленты:
//        let app = XCUIApplication() // ❗️разблокировать если требуется запустить только testFeed тест
                
        // Подождать, пока открывается и загружается экран ленты
        sleep(3) // ждем 2 секунды

        // Сделать жест «смахивания» вверх по экрану для его скролла
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        sleep(2)

        // Поставить лайк в ячейке верхней картинки
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 0)
        let likeButtonPush = cellToLike.buttons[likeButton]
        likeButtonPush.tap()
        XCTAssertTrue(likeButtonPush.waitForExistence(timeout: 5))
        sleep(2) // ждем 2 секунды

        // Отменить лайк в ячейке верхней картинки
        likeButtonPush.tap()
        XCTAssertTrue(likeButtonPush.waitForExistence(timeout: 5))
        sleep(2) // ждем 2 секунды

        // Нажать на верхнюю ячейку
        let openTopCell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        openTopCell.tap()
        let imageScrollView = app.scrollViews.images.element(boundBy: 0)
        
        // Подождать, пока картинка открывается на весь экран
        sleep(2)

        // Увеличить картинку
        imageScrollView.pinch(withScale: 4, velocity: 1)
        imageScrollView.swipeLeft()
        imageScrollView.swipeDown()
        imageScrollView.swipeUp()

        // Уменьшить картинку
        imageScrollView.pinch(withScale: 0.5, velocity: -1)
        sleep(2)
        
        // Вернуться на экран ленты
        app.buttons[returnToFeedScreen].tap()
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        sleep(2)
    }
    
    //MARK: - Тестируем сценарий профиля
    
    func testProfile() throws {
        // тестируем сценарий профиля
//        let app = XCUIApplication() // ❗️разблокировать если требуется запустить только testProfile тест
        
        // Подождать, пока открывается и загружается экран ленты
        sleep(2) // ждем 2 секунды
        
        // Перейти на экран профиля
        app.tabBars["Tab Bar"].children(matching: .button).element(boundBy: 1).tap() // перейдем в меню профиля

        // Проверить, что на нём отображаются ваши персональные данные
        XCTAssertTrue(app.staticTexts[fullNameUser].exists)
        XCTAssertTrue(app.staticTexts[nicknameUser].exists)
        XCTAssertTrue(app.staticTexts[bioUserProfile].exists)
        
        // Нажать кнопку логаута
        sleep(2)
        app.buttons[exitProfileButton].tap() // нажмем на кнопку выхода из профиля
        sleep(2)
        app.alerts["Выход"].scrollViews.otherElements.buttons["Да"].tap() // в алерте подтвердим выход из профиля
        sleep(2)
        
        // Проверить, что открылся экран авторизации
        app.buttons["Authenticate"].tap()
        
        // Подождать, пока экран авторизации открывается и загружается
        let webViewsQuery = app.webViews.webViews.webViews
        let connectImagefeedUnsplashUnsplashElement = webViewsQuery.otherElements[unsplashWebView]
        XCTAssertTrue(connectImagefeedUnsplashUnsplashElement.waitForExistence(timeout: 10))
    }
}
