import UIKit

class ResultsTVC: UITableViewCell {

    weak var networkManager: NetworkManager?

    @IBAction func downloadPreview(_ sender: Any) {
        guard let url = previewURL else { return }
        networkManager?.downloadPreview(url: url)
    }
    
    @IBOutlet var resultImage: UIImageView!
    @IBOutlet var resultLabel: UILabel!

    var imageDownloadTask: URLSessionDownloadTask?

    var previewURL: String?

    override func prepareForReuse() {
        super.prepareForReuse()

        imageDownloadTask?.cancel()
        imageDownloadTask = nil
        resultImage.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
