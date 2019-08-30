import UIKit

final class TagLabel: UILabel {
    var padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    var actualSize: CGSize {
        return CGSize(
            width: frame.size.width + padding.left + padding.right,
            height: frame.size.height + padding.top + padding.bottom
        )
    }

    override var intrinsicContentSize: CGSize {
        var intrinsicContentSize = super.intrinsicContentSize
        intrinsicContentSize.height += padding.top + padding.bottom
        intrinsicContentSize.width += padding.left + padding.right
        return intrinsicContentSize
    }

    override func drawText(in rect: CGRect) {
        let newRect = rect.inset(by: padding)
        super.drawText(in: newRect)
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
    }
}
