import Foundation
import UIKit


final class SingleImageViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBAction func didTapShareButton(_ sender: Any) {
        let sharingButton = UIActivityViewController(activityItems: [image as Any], applicationActivities: nil)
        present(sharingButton, animated: true)
    }
    @IBOutlet var scrollView: UIScrollView!
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - «Научим» SingleViewController показывать разные картинки, не инициируя загрузку view
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return } // сначала мы проверяем, было ли ранее загружено view. Это очень важная проверка, необходимая, чтобы не закрэшиться, если view ещё не было загружено (и, соответственно, аутлет ещё не инициализирован). Именно эта проверка не даст нам закрэшиться из prepareForSegue
            imageView.image = image // В эту точку мы не должны попадать из prepareForSegue. Мы можем попасть в неё, например, если был показан SingleImageViewController, а указатель на него был запомнен извне. Далее  — извне (например, по свайпу) в него проставляется новое изображение
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    
} // end final class SingleImageViewController

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

