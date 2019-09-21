import UIKit

final class CircleDetailViewController: UIViewController, StoryboardInstantiable {
    private lazy var collectionViewLayout: CollectionViewLayout = {
        let layout = CollectionViewLayout()
        layout.delegate = self
        return layout
    }()

    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            collectionView.collectionViewLayout = collectionViewLayout
            collectionView.registerFromNib(CircleDetailImageCollectionViewCell.self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension CircleDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CircleDetailImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
}

extension CircleDetailViewController: CollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout: CollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .zero
    }

    func collectionView(columnFor section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout: CollectionViewLayout,
                        headerHeightFor section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout: CollectionViewLayout,
                        footerHeightFor section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
}
