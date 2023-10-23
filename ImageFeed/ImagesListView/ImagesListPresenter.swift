import UIKit

protocol ImagesListPresenterProtocol {
    var viewImagesListVC: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class ImageListPresenter: ImagesListPresenterProtocol {
    
    private var imageListServiceObserver: NSObjectProtocol?
    private let imageListService = ImagesListService.shared
    var viewImagesListVC: ImagesListViewControllerProtocol?
    
    func viewDidLoad() {
        imageListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.viewImagesListVC?.updateTableViewAnimated()
                }
        imageListService.fetchPhotosNextPage()
    }
}
