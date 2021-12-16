import UIKit

class ResultVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    let queue = DispatchQueue(
        label: "ImageDownload",
        qos: .userInteractive,
        attributes: .concurrent
    )
    
    private let imageCache = NSCache<AnyObject, UIImage>()
    
    var authorLabelText: String?
    var networkManager: NetworkManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorNameLabel?.text = authorLabelText
        tableView.delegate = self
        tableView.dataSource = self
        progressView.progress = 0.0
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        networkManager = NetworkManager(session: session)
        
        networkManager.getAuthor(for: authorLabelText ?? "") { (authors, errorMessage) in
            guard authors != nil else {
                print("no answer")
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NetworkManager.authorsResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ResultsTVC
        
        cell.resultLabel.text = NetworkManager.authorsResults[indexPath.row].trackName
        cell.backgroundColor = UIColor.clear
        
        cell.networkManager = networkManager
        
        cell.previewURL = NetworkManager.authorsResults[indexPath.row].previewUrl
        
        if let imageURL = URL(string:  NetworkManager.authorsResults[indexPath.row].artworkUrl100 ?? "") {
            
            let imgDownloadTask = networkManager.downloadImage(url: imageURL) { result in
                switch result {
                case .success(let data):
                    let img = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.resultImage.image = img
                    }
                case .failure(let error):
                    print(error)
                }
            }
            cell.imageDownloadTask = imgDownloadTask
        }
        
        return cell
    }
}

extension ResultVC: URLSessionDelegate, URLSessionTaskDelegate, URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print(#function)
        DispatchQueue.main.async {
            self.progressView.progress = 0.0
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print(#function)
        
        DispatchQueue.main.async {
            self.progressView.progress = Float(totalBytesExpectedToWrite / totalBytesWritten)
        }
        print(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
    }
}
