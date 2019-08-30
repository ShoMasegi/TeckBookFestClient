import UIKit

final class HomeCoverTableViewCell: UITableViewCell {
    @IBOutlet private weak var coverImageView: UIImageView! {
        didSet {
            coverImageView.layer.cornerRadius = 6
        }
    }

    func set(section: CoverSection) {
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
    }
}
