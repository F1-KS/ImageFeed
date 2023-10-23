import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject{ // sprint_13
    var presenterProfileView: ProfilePresenterProtocol? { get set } // sprint_13
    func mainProfile()
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    var presenterProfileView: ProfilePresenterProtocol?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mainProfile()
    }
    
    private var fullNameUserLabel: UILabel?
    private var nicknameUserLabel: UILabel?
    private var messageTextUserLabel: UILabel?
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileService = ProfileService.shared
    private var profilePresenter = ProfilePresenter()
    // Жестко установим цвет StatusBar в светлый
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func mainProfile() {
        
        self.view.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1333333333, alpha: 1)
        
        //MARK: - Констрейнты
        
        func applyConstraints() {
            NSLayoutConstraint.activate([
                fullNameUserLabel.leadingAnchor.constraint(equalTo: mainProfileImage.leadingAnchor),
                fullNameUserLabel.topAnchor.constraint(equalTo: mainProfileImage.bottomAnchor, constant: 20),
                profileExitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                profileExitButton.centerYAnchor.constraint(equalTo: mainProfileImage.centerYAnchor),
                nicknameUserLabel.leadingAnchor.constraint(equalTo: mainProfileImage.leadingAnchor),
                nicknameUserLabel.topAnchor.constraint(equalTo: fullNameUserLabel.bottomAnchor, constant: 8),
                messageTextUserLabel.leadingAnchor.constraint(equalTo: mainProfileImage.leadingAnchor),
                messageTextUserLabel.topAnchor.constraint(equalTo: nicknameUserLabel.bottomAnchor, constant: 8),
                mainProfileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                mainProfileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                mainProfileImage.widthAnchor.constraint(equalToConstant: 70),
                mainProfileImage.heightAnchor.constraint(equalToConstant: 70)
                
            ])
        }
        
        func addSubview() {
            view.addSubview(fullNameUserLabel)
            fullNameUserLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(mainProfileImage)
            mainProfileImage.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(nicknameUserLabel)
            nicknameUserLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(messageTextUserLabel)
            messageTextUserLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(profileExitButton)
            profileExitButton.translatesAutoresizingMaskIntoConstraints = false
            
            applyConstraints()
        }
        
        //MARK: - Описание картинок в профиле
        
        let profileImage = UIImage(named: "PhotoUser")
        lazy var mainProfileImage: UIImageView = {
            let imageView = UIImageView(image: profileImage)
            return imageView
        }()
        
        //MARK: - Описание полей Label
        
        lazy var fullNameUserLabel: UILabel = {
            let fullNameUserLabel = UILabel()
            fullNameUserLabel.text = "Екатерина Новикова"
            fullNameUserLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.fullNameUserLabel = fullNameUserLabel
            return fullNameUserLabel }()
        
        lazy var nicknameUserLabel: UILabel = {
            let nicknameUserLabel = UILabel()
            nicknameUserLabel.text = "@ekaterina_now"
            nicknameUserLabel.textColor = #colorLiteral(red: 0.6823529412, green: 0.6862745098, blue: 0.7058823529, alpha: 1)
            self.nicknameUserLabel = nicknameUserLabel
            return nicknameUserLabel }()
        
        lazy var messageTextUserLabel: UILabel = {
            let messageTextUserLabel = UILabel()
            messageTextUserLabel.text = "Hello, world!"
            messageTextUserLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.messageTextUserLabel = messageTextUserLabel
            return messageTextUserLabel }()
        
        //MARK: - Описание кнопки выхода из профиля
        
        lazy var profileExitButton: UIButton = {
            let profileExitButton = UIButton.systemButton(
                with: UIImage(systemName: "ipad.and.arrow.forward")!,
                target: self,
                action: #selector(Self.didTapExitProfileButton)
            )
            profileExitButton.tintColor = #colorLiteral(red: 0.9607843137, green: 0.4196078431, blue: 0.4235294118, alpha: 1)
            return profileExitButton }()
        
        addSubview() // Вызов констрейнтов
        
        //MARK: - Обновляем аватарку
        
        func updateAvatar() {
            guard
                let profileImageURL = ProfileImageService.shared.avatarURL,
                let url = URL(string: profileImageURL) else { return }
            let processor = RoundCornerImageProcessor(cornerRadius: 35)
            mainProfileImage.kf.indicatorType = .activity
            mainProfileImage.kf.setImage(with: url,
                                         placeholder: UIImage(named: "placeholder.jpeg"),
                                         options: [.processor(processor),.cacheSerializer(FormatIndicatedCacheSerializer.png)])
            let cache = ImageCache.default
            cache.clearDiskCache()
            cache.clearMemoryCache()
            
        }
        
        updateProfileDetails(profile: profileService.profile)
        
        func updateProfileDetails(profile: Profile?) {
            guard let profile = profile else {return}
            self.fullNameUserLabel?.text = profile.name
            self.nicknameUserLabel?.text = profile.loginName
            self.messageTextUserLabel?.text = profile.bio
        }
        
        updateAvatar()
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard self != nil else { return }
                updateAvatar()
            }
    }
    
    //MARK: - Описание действия кнопки выхода из профиля пользователя
    
    @objc
    private func didTapExitProfileButton() {
        let alert = UIAlertController(title: "Выход", message: "Выйти из Вашего профиля?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            profilePresenter.exitProfile()
        }))
        
        alert.addAction(UIAlertAction(title: "Нет", style: .default))
        self.present(alert, animated: true)
    }
}
