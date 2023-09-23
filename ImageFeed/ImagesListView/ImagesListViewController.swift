import UIKit
import Kingfisher


final class ImagesListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier) // так таблица настраивается с помощью кода, но в у нас это следано через Main.storyboard
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        imageListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.updateTableViewAnimated()
                }
        imageListService.fetchPhotosNextPage()
        
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.string(from: Date()) // "3 May 2016"
        return formatter
    }()
    private let showSingleImageSegueIdentifier = "ShowSingleImage" // убераем дублирование в коде
    private var imageListService = ImagesListService.shared
    private var photosList: [Photo] = []
    private var imageListServiceObserver: NSObjectProtocol?
    
    
    @IBOutlet private var tableView: UITableView!
    
    // Жестко установим цвет StatusBar в светлый
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as? SingleImageViewController
            if let indexPath = sender as? IndexPath {
                let urlImageList = URL(string: photosList[indexPath.row].fullImageURL)
                viewController?.fullImageURL = urlImageList
                
            } else {
                super.prepare(for: segue, sender: sender)
            }
        }
    }
}


extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    } // Этот метод отвечает за действия, которые будут выполнены при тапе по ячейке таблицы
}

extension ImagesListViewController: ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let photo = photosList[indexPath.row]
        UIBlockingProgressHUD.show() // Покажем лоадер
        imageListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success:
                self.photosList = self.imageListService.photos // Синхронизируем массив картинок с сервисом
                cell.setIsLiked(isLiked: !photo.isLiked) // Изменим индикацию лайка картинки
                // Покажем, что что-то пошло не так
            case .failure(let error):
                print("imageListCellDidTapLike Error: \(error)")
                self.showErrorAlert()
            }
            UIBlockingProgressHUD.dismiss() // Уберём лоадер
        }
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось поставить лайк",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "Ок",
            style: .default))
        self.present(alert, animated: true)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) // 1 Мы использовали здесь метод, который из всех ячеек, зарегистрированных в таблице, возвращает ячейку по идентификатору, добавленному ранее.
        
        guard let imageListCell = cell as? ImagesListCell else { // 2 бы работать с ячейкой как с экземпляром класса ImagesListCell, нам надо провести приведение типов
            return UITableViewCell()
        }
        imageListCell.delegate = self
        configCell(for: imageListCell, with: indexPath) // 3
        return imageListCell // 4 Возвращаем ячейку. Возврат будет успешен, так как наша ячейка является наследником UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosList.count
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath) {
            let photos = imageListService.photos
            if indexPath.row + 1 == photos.count {
                imageListService.fetchPhotosNextPage()
            }
        }
    
    func updateTableViewAnimated() {
        let oldCount = photosList.count
        let newCount = imageListService.photos.count
        photosList = imageListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                var indexPaths: [IndexPath] = []
                for i in oldCount..<newCount {
                    indexPaths.append(IndexPath(row: i, section: 0))
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath) {
            let photos = imageListService.photos
            if indexPath.row + 1 == photos.count {
                imageListService.fetchPhotosNextPage()
            }
        }
    
}

extension ImagesListViewController {
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let stubImage = UIImage(named: "scribble.variable") else { return }
        let imageUrl = photosList[indexPath.row].thumbImageURL
        guard let url = URL(string: imageUrl) else { return }
        
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: url, placeholder: stubImage) { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        cell.setIsLiked(isLiked: photosList[indexPath.row].isLiked)
        let photo = photosList[indexPath.row]
        if let photoCreatedAt = photo.createdAt {
            cell.dateLabel.text = dateFormatter.string(from: photoCreatedAt)
        } else {
            cell.dateLabel.text = ""
        }
    }
}
