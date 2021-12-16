import Foundation
import UIKit

class NetworkManager {

    enum NetworkError: Error {
        case noData
        case corruptedData
    }

    let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    static var authorsResults = [Results]()

    let baseURL = "https://itunes.apple.com/search?term="
    
    func getAuthor(for authorName: String, completed: @escaping (Author?, String?)-> Void ){
        let endpoint = baseURL + "\(authorName)"
        guard let url = URL(string: endpoint) else {
            completed(nil, "Invalud author name")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error{
                completed(nil, "Couldn't connect to server")
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode >= 200, response.statusCode <= 399 else {
                completed(nil, "Bad response from server")
                return
            }
            
            guard let data = data else {
                completed(nil, "Couldn't load data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let authors = try decoder.decode(Author.self, from: data)
                NetworkManager.authorsResults = authors.results
                completed(authors, nil)
                
            } catch {
                completed(nil, "Couldn't decode data")
            }
        }
        task.resume()
    }

    func downloadImage(url: URL, compeletion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDownloadTask {

        let downloadTask = URLSession.shared.downloadTask(with: url) { url, response, error in
            guard let url = url else {
                compeletion(.failure(.noData))
                return
            }

            do {
                let imgData = try Data(contentsOf: url)
                compeletion(.success(imgData))


            } catch {
                compeletion(.failure(.corruptedData))
            }

        }

        downloadTask.resume()

        return downloadTask
    }

    func downloadPreview(url: String) {
        guard let url = URL(string: url) else { return }
        session.downloadTask(with: url).resume()
    }
}
