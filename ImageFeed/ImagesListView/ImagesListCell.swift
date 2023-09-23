import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var cellImage: UIImageView!
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBAction func likeButtonClicked2(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "FavoritesYesActive") : UIImage(named: "FavoritesNoActive")
        likeButton.setImage(likeImage, for: .normal)
    }
    weak var delegate: ImagesListCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
}

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
