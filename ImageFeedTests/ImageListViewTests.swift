import XCTest
@testable import ImageFeed

final class ImageListViewTests: XCTestCase {
    
    //    //MARK: - № 1 Тестируем
    func testViewControllerCallsViewDidLoad() {
        //Given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.viewImagesListVC = viewController
        
        //When
        _ = viewController.view
        
        //Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    //MARK: - № 2 Тестируем
    func testListPhotosCount() throws {
        //Given
        let imageListService = ImagesListService()
        
        //When
        let presenter = self.expectation(description: "Получаем ответ")
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { _ in
                presenter.fulfill()
            }
        imageListService.fetchPhotosNextPage()
        wait(for: [presenter], timeout: 5)
        
        //Then
        XCTAssertEqual(imageListService.photos.count, 10)
    }
}

//MARK: - Объекты-дублёры

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var viewImagesListVC: ImageFeed.ImagesListViewControllerProtocol?
    
    var viewDidLoadCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
}
