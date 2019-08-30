import UIKit

final class HomeDescriptionTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    func set(section: DescriptionSection) {
        titleLabel.text = section.title
        descriptionLabel.text = section.description
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        descriptionLabel.text = nil
    }
}
