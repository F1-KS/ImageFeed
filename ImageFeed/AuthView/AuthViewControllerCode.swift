///`` Верстка AuthViewController кодом
///`` Верстка AuthViewController кодом
///`` Верстка AuthViewController кодом
///`` Верстка AuthViewController кодом
///
import UIKit

final class AuthViewControllerCode: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        authLogOn()
    }
    
    private var authButtonIn: UIButton?
    
    // Жестко установим цвет StatusBar в светлый
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func authLogOn() {
        
        self.view.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1333333333, alpha: 1)
        
        //MARK: - Констрейнты
        
        func applyConstraints() {
            NSLayoutConstraint.activate([
                authLogOn.widthAnchor.constraint(equalToConstant: 60),
                authLogOn.heightAnchor.constraint(equalToConstant: 60),
                authLogOn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                authLogOn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                
                authButtonIn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -111),
                authButtonIn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                authButtonIn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                authButtonIn.heightAnchor.constraint(equalToConstant: 48)
            ])
        }
        
        func addSubview() {
            
            view.addSubview(authLogOn)
            authLogOn.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(authButtonIn)
            authButtonIn.translatesAutoresizingMaskIntoConstraints = false
            
            applyConstraints()
        }
        
        
        //MARK: - Описание логотипа
        
        let authImage = UIImage(named: "auth_screen_logo_svg")
        let authLogOn = UIImageView(image: authImage)
        
        
        //MARK: - Описание конопки Войти
        
        let authButtonIn: UIButton = {
            let authButtonIn = UIButton(frame: CGRect(x: 0, y: 0, width: 343, height: 48))
            authButtonIn.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) // кнопка белого цвета
            authButtonIn.layer.cornerRadius = 16 // закругленные края на 16
            authButtonIn.layer.masksToBounds = true
            authButtonIn.setTitle("Войти", for: .normal) // надпись на конопке
            authButtonIn.setTitleColor(UIColor(red: 0.1019607843, green: 0.1058823529, blue: 0.1333333333, alpha: 1), for: .normal) // цвет надписи на кнопке
            authButtonIn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17) // шрифт надписи на кнопке
            authButtonIn.addTarget(self, action: #selector(didTapAuthButtonIn), for: .touchUpInside)
            return authButtonIn }()
        
        addSubview() // Вызов констрейнтов
    }
    
    //MARK: - Описание действия кнопки Войти
    
    @objc
    private func didTapAuthButtonIn() {
        print("Button is tapped")
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
