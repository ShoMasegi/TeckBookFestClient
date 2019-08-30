import UIKit
import Nuke

final class HomeCoverTableViewCell: UITableViewCell {
    @IBOutlet private weak var coverImageView: UIImageView!

    func set(section: CoverSection) {
        guard let url = URL(string: section.imageUrl) else { return }
        Nuke.loadImage(with: url, into: coverImageView)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
    }
}
