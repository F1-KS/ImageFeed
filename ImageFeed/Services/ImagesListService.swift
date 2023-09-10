import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    let fullImageURL: String
}

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let description: String?
    let likedByUser: Bool
    let urls: UrlsResult
    
    private enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case likedByUser = "liked_by_user"
        case id, width, height, description, urls
    }
}

struct UrlsResult: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small : String
    let thumb: String
}

struct LikeResult: Decodable {
    let photo: PhotoResult
}

final class ImagesListService {
    
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private let dateFormatter = ISO8601DateFormatter()
    
    
    func preparePhoto(_ photoResult: [PhotoResult]) {
        let newPhotos = photoResult.map { item in
            return Photo(
                id: item.id,
                size: CGSize(width: item.width, height: item.height),
                createdAt: dateFormatter.date(from: item.createdAt!),
                welcomeDescription: item.description,
                thumbImageURL: item.urls.thumb,
                largeImageURL: item.urls.full,
                isLiked: item.likedByUser,
                fullImageURL: item.urls.full)
        }
        self.photos.append(contentsOf: newPhotos)
    }
    
    // MARK: - fetchPhotosNextPage
    
    func fetchPhotosNextPage() {
        
        assert(Thread.isMainThread)
        if task != nil { return }
        
        let nextPage = lastLoadedPage == nil ? 0 : lastLoadedPage! + 1
        lastLoadedPage = nextPage
        guard let request = makeRequest(path: "/photos?page=\(nextPage)&&per_page=10") else {
            return assertionFailure("Нет связи с библиотекой картинок")}
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let photoResult):
                self.preparePhoto(photoResult)
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self, userInfo: ["photos" : self.photos] )
                self.task = nil
            case .failure(let error):
                self.task = nil
                print(error)
            }
        }
        self.task = task
        task.resume()
    }
    
    // MARK: - makeRequest
    
    private func makeRequest(path: String) -> URLRequest? {
        guard let baseURL = URL(string: path, relativeTo: Constants.defaultBaseURL) else {
            assertionFailure("url is nil")
            return nil
        }
        
        var request = URLRequest(url: baseURL)
        guard let token = OAuth2TokenStorage.shared.token else {
            assertionFailure("token is nil)")
            return nil
        }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    // MARK: -
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread) // все операции с photos выполнять на главном потоке
        guard let token = OAuth2TokenStorage.shared.token  else {
            return assertionFailure("Error like request")}
        let method = isLike ?  "DELETE" : "POST"
        var request = URLRequest.makeHTTPRequest(
            path: "/photos/\(photoId)/like",
            httpMethod: method,
            baseURL: Constants.defaultBaseURL)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(_):
                if let index = self.photos.firstIndex(where: {$0.id == photoId}) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: !photo.isLiked,
                        fullImageURL: photo.fullImageURL)
                    self.photos[index] = newPhoto
                }
                completion (.success(()))
            case .failure(let error):
                completion (.failure(error))
            }
        }
        task.resume()
    }
}


