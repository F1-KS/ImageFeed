import Foundation
import UIKit

final class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mainProfile()
    }
    
    private var fullNameUserLabel: UILabel?
    private var nicknameUserLabel: UILabel?
    private var messageTextUserLabel: UILabel?
    private var profileImage: UIImage?
    
    // Жестко установим цвет StatusBar в светлый
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    private func mainProfile() {
        
        self.view.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1333333333, alpha: 1)
       
        
        //MARK: - Описание картинок в профиле
        
        let profileImage = UIImage(named: "photoUser")
        let mainProfile = UIImageView(image: profileImage)
        
        mainProfile.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainProfile)
        mainProfile.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        mainProfile.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        mainProfile.widthAnchor.constraint(equalToConstant: 70).isActive = true
        mainProfile.heightAnchor.constraint(equalToConstant: 70).isActive = true

        
        //MARK: - Описание полей Label
        
        let fullNameUserLabel = UILabel()
        fullNameUserLabel.text = "Екатерина Новикова"
        fullNameUserLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        fullNameUserLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fullNameUserLabel)
        fullNameUserLabel.leadingAnchor.constraint(equalTo: mainProfile.leadingAnchor).isActive = true
        fullNameUserLabel.topAnchor.constraint(equalTo: mainProfile.bottomAnchor, constant: 20).isActive = true
        self.fullNameUserLabel = fullNameUserLabel
        
        let nicknameUserLabel = UILabel()
        nicknameUserLabel.text = "@ekaterina_now"
        nicknameUserLabel.textColor = #colorLiteral(red: 0.6823529412, green: 0.6862745098, blue: 0.7058823529, alpha: 1)
        nicknameUserLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nicknameUserLabel)
        nicknameUserLabel.leadingAnchor.constraint(equalTo: mainProfile.leadingAnchor).isActive = true
        nicknameUserLabel.topAnchor.constraint(equalTo: fullNameUserLabel.bottomAnchor, constant: 8).isActive = true
        self.nicknameUserLabel = nicknameUserLabel
        
        let messageTextUserLabel = UILabel()
        messageTextUserLabel.text = "Hello, world!"
        messageTextUserLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        messageTextUserLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageTextUserLabel)
        messageTextUserLabel.leadingAnchor.constraint(equalTo: mainProfile.leadingAnchor).isActive = true
        messageTextUserLabel.topAnchor.constraint(equalTo: nicknameUserLabel.bottomAnchor, constant: 8).isActive = true
        self.messageTextUserLabel = messageTextUserLabel
        
        
        //MARK: - Описание кнопки выхода из профиля
        
        let profileExitButton = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        profileExitButton.tintColor = #colorLiteral(red: 0.9607843137, green: 0.4196078431, blue: 0.4235294118, alpha: 1)
        profileExitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileExitButton)
        profileExitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        profileExitButton.centerYAnchor.constraint(equalTo: mainProfile.centerYAnchor).isActive = true
    }
    
    @objc
    private func didTapButton() {
        // Решение 1
//        fullNameUserLabel?.removeFromSuperview()
//        fullNameUserLabel = nil
//
//        // Решение 2
//        for view in view.subviews {
//            if view is UILabel {
//                view.removeFromSuperview()
//            }
//        }
    }
    
}



