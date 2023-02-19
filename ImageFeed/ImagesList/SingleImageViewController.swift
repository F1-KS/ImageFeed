import Foundation
import UIKit


final class SingleImageViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    
//MARK: - «Научим» SingleViewController показывать разные картинки, не инициируя загрузку view
    var image: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
   
} // end final class SingleImageViewController
