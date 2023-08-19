import Foundation
import UIKit
import ProgressHUD
import SwiftKeychainWrapper

//MARK: -

final class SplashViewController: UIViewController {
    
    private let oAuth2Service = OAuth2Service.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private var isFirstLaunch = true
    
    private let splashLogoImage: UIImageView = {
        let image = UIImage(named: "Vector")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mainSplash()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstLaunch {
            if oAuth2TokenStorage.token != nil {
                guard let token = oAuth2TokenStorage.token else { return }
                fetchProfile(token: token)
            } else {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                guard let authViewController = storyBoard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {return}
                authViewController.delegate = self
                authViewController.modalPresentationStyle = .fullScreen
                self.present(authViewController, animated: true)
            }
        }
        isFirstLaunch = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func mainSplash() {
        
        self.view.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1333333333, alpha: 1)
        
        //MARK: - Констрейнты
        
        func applyConstraints() {
            NSLayoutConstraint.activate([
                splashLogoImage.heightAnchor.constraint(equalToConstant: 78),
                splashLogoImage.widthAnchor.constraint(equalToConstant: 75),
                splashLogoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                splashLogoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
        
        func addSubview() {
            view.addSubview(splashLogoImage)
            splashLogoImage.translatesAutoresizingMaskIntoConstraints = false
            applyConstraints()
        }
    }
    
    //MARK: -
    
    private func checkAuthToken() {
        if oAuth2TokenStorage.token != nil {
            guard let token = oAuth2TokenStorage.token else {
                return
            }
            UIBlockingProgressHUD.show() // показать индикатор загрузки
            fetchProfile(token: token)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            guard let authViewController =
                    storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
                return
            }
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            self.present(authViewController, animated: true)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func fetchOAuthToken(_ code: String) {
        oAuth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.switchToTabBarController()
                ProgressHUD.dismiss() // скрыть индикатор загрузки
            case .failure:
                ProgressHUD.dismiss() // скрыть индикатор загрузки
            }
        }
    }
}

//MARK: -

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
    
}

//MARK: -

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show() // показать индикатор загрузки
            self.fetchOAuth2Token(code)
        }
    }
    
    private func fetchOAuth2Token(_ code: String) {
        oAuth2Service.fetchOAuthToken(code) { [ weak self ] result in
            guard let self = self else {return}
            switch result {
            case .success(let token):
                print("token - \(token)")
                self.switchToTabBarController()
                self.oAuth2TokenStorage.token = token
                self.fetchProfile(token: token)
                UIBlockingProgressHUD.dismiss()
            case .failure(let errorFetchOAuth2Token):
                self.showAlertOAuth2Token(with: errorFetchOAuth2Token)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    // MARK: -
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else {
                return
            }
            UIBlockingProgressHUD.dismiss() // скрыть индикатор загрузки
            switch result {
            case .success(let profile):
                self.profileImageService.fetchProfileImageURL(username: profile.username) { _ in }
                self.switchToTabBarController()
            case .failure(let errorFetchProfile):
                UIBlockingProgressHUD.dismiss() // скрыть индикатор загрузки
                self.showAlertProfile(with: errorFetchProfile)
                break
            }
        }
    }
    
    // MARK: -
    
    private func showAlertProfile(with errorFetchProfile: Error) {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось получить Профиль пользователя",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAlertOAuth2Token(with errorFetchOAuth2Token: Error) {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось получить Токен",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
}
