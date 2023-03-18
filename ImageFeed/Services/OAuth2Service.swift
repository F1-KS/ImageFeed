import Foundation

final class OAuth2Service {
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result < String, Error>) -> Void) {
        completion(.success(""))
    }
}
