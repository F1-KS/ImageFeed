import UIKit

final class ImagesListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier) // так таблица настраивается с помощью кода, но в у нас это следано через Main.storyboard
    }
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    @IBOutlet private var tableView: UITableView!
    
}


extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { } // Этот метод отвечает за действия, которые будут выполнены при тапе по ячейке таблицы
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) // 1 Мы использовали здесь метод, который из всех ячеек, зарегистрированных в таблице, возвращает ячейку по идентификатору, добавленному ранее.
        
        guard let imageListCell = cell as? ImagesListCell else { // 2 бы работать с ячейкой как с экземпляром класса ImagesListCell, нам надо провести приведение типов
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath) // 3
        return imageListCell // 4 Возвращаем ячейку. Возврат будет успешен, так как наша ячейка является наследником UITableViewCell
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
}

extension ImagesListViewController {
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return
        }
        
        cell.dateLabel.text = dateFormatter.string(from: Date())
        cell.cellImage.image = image
        
        // ставим лайк на каждую вторую картинку
        let isLiked = indexPath.row % 2 == 0
        let likeImage = isLiked ? UIImage(named: "Favorites Yes Active") : UIImage(named: "Favorites No Active")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
    
}
