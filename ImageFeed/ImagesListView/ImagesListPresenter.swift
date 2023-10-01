import UIKit

protocol ImagesListPresenterProtocol {

}

final class ImageListPresenter: ImagesListPresenterProtocol {

    private var imageListServiceObserver: NSObjectProtocol?
    private var imageListService = ImagesListService.shared

        func viewDidLoad() {

    }
}
