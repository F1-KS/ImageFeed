import Foundation
import UIKit


final class SingleImageViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    
//MARK: - «Научим» SingleViewController показывать разные картинки, не инициируя загрузку view
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return } // сначала мы проверяем, было ли ранее загружено view. Это очень важная проверка, необходимая, чтобы не закрэшиться, если view ещё не было загружено (и, соответственно, аутлет ещё не инициализирован). Именно эта проверка не даст нам закрэшиться из prepareForSegue
            imageView.image = image // В эту точку мы не должны попадать из prepareForSegue. Мы можем попасть в неё, например, если был показан SingleImageViewController, а указатель на него был запомнен извне. Далее  — извне (например, по свайпу) в него проставляется новое изображение
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
   
} // end final class SingleImageViewController
