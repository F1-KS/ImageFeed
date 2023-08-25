import UIKit

final class ImagesListCell: UITableViewCell {

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var cellImage: UIImageView!
    
    static let reuseIdentifier = "ImagesListCell"
}
