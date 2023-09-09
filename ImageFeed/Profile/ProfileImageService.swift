import Foundation


//MARK: -

final class ProfileImageService {
    private (set) var avatarURL: String?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private let decoder = JSONDecoder()
    private var lastUserName: String?
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastUserName == username {return}
        task?.cancel()
        lastUserName = username
        
        let request = makeRequest(username: username)
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<UserResult, Error>) in
            guard let self = self else {return}
            switch result {
            case .success(let profileImage):
                let profileImageURL = profileImage.profileImage.medium
                self.avatarURL = profileImageURL
                completion(.success(profileImageURL))
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": profileImageURL])
            case .failure(let error):
                completion(.failure(error))
                self.lastUserName = nil
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}

extension ProfileImageService {
    
    private func makeRequest(username: String) -> URLRequest {
        
        var urlComponents = URLComponents()
        urlComponents.path = "/users/\(username)"
        guard let url = urlComponents.url(relativeTo: Constants.defaultBaseURL) else {
            assertionFailure("Failed to create URL for avatar Image")
            return URLRequest(url: URL(string: "")!)
        }
        guard let token = OAuth2TokenStorage.shared.token else {
            assertionFailure("Failed to create Token")
            return URLRequest(url: URL(string: "")!)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
