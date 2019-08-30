import UIKit

final class CircleTableViewCell: UITableViewCell {
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var tagLabel: TagLabel! {
        didSet {
            tagLabel.padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        }
    }
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    func set(circle: Circle) {
        tagLabel.backgroundColor = UIColor.orange
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
