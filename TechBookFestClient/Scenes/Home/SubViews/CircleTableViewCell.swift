import UIKit
import Nuke

final class CircleTableViewCell: UITableViewCell {
    @IBOutlet private weak var thumbnailImageView: UIImageView! {
        didSet {
            thumbnailImageView.layer.cornerRadius = 6
        }
    }
    @IBOutlet private weak var tagLabel: TagLabel! {
        didSet {
            tagLabel.padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        }
    }
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    func set(circle: Circle) {
        if let url = URL(string: circle.imageUrl) {
            Nuke.loadImage(with: url, into: thumbnailImageView)
        }
        tagLabel.backgroundColor = circle.circleType.color
        tagLabel.text = circle.position
        nameLabel.text = circle.title
        categoryLabel.text = circle.category
        descriptionLabel.text = circle.description
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        tagLabel.backgroundColor = UIColor.clear
        tagLabel.text = nil
        nameLabel.text = nil
        categoryLabel.text = nil
        descriptionLabel.text = nil
    }
}
