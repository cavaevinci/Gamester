import UIKit

protocol CreativeLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class CreativeLayout: UICollectionViewLayout {
    weak var delegate: CreativeLayoutDelegate?

    private var cache: [UICollectionViewLayoutAttributes] = []

    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    override func prepare() {
        guard let collectionView = collectionView else { return }

        cache.removeAll()

        let columnWidth = contentWidth / 3 // Three columns

        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0

        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)

            let photoHeight = delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath) ?? 180

            xOffset = CGFloat(item % 3) * columnWidth
            yOffset = CGFloat(item / 3) * photoHeight // Adjust yOffset based on the row index
            
            let frame = CGRect(x: xOffset, y: yOffset, width: columnWidth, height: photoHeight)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cache.append(attributes)
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }

    override var collectionViewContentSize: CGSize {
        guard let lastAttribute = cache.last else { return .zero }
        return CGSize(width: contentWidth, height: lastAttribute.frame.maxY)
    }
}
