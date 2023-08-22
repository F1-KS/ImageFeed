import UIKit

final class TabBarViewController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyBoard.instantiateViewController(withIdentifier: "ImagesListViewController")
        let profileViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController")
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_profile_active"), selectedImage: nil)
        imagesListViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_editorial_active"), selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
