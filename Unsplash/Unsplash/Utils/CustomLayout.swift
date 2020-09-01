//
//  CustomLayout.swift
//  Unsplash
//
//  Created by Nha Pham on 8/31/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import UIKit

protocol CustomLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, sizeOfPhotoAtIndexPath indexPath: IndexPath) -> CGSize
}

protocol CustomLayoutHeaderDelegate: class {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize
}

final class CustomLayout: UICollectionViewLayout {

    weak var delegate: CustomLayoutDelegate!
    weak var headerDelegate: CustomLayoutHeaderDelegate?
    var numberOfColumns = 2
    var cellPadding: CGFloat = 5
    var headerAttributes: UICollectionViewLayoutAttributes = {
        let headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                                            with: IndexPath(item: 0, section: 0))
        headerAttributes.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        return headerAttributes
    }()

    var cache = [UICollectionViewLayoutAttributes]()
    var contentHeight: CGFloat = 0

    var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        return collectionView.bounds.width
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        
        guard let collectionView = collectionView else {
            return
        }
        
        if let headerDelegate = headerDelegate {
            let headerSize = headerDelegate.collectionView(collectionView,
                                                            layout: self,
                                                            referenceSizeForHeaderInSection: 0)
            headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                                                with: IndexPath(item: 0, section: 0))
            headerAttributes.frame = CGRect(x: 0, y: 0, width: headerSize.width, height: headerSize.height)
        }
        
        var yOffset = [CGFloat](repeating: headerAttributes.frame.origin.x + headerAttributes.frame.height, count: numberOfColumns)
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffest = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffest.append(CGFloat(column) * columnWidth)
        }

        var column = 0

        for item in 0..<collectionView.numberOfItems(inSection: 0) {

            let indexPath = IndexPath(item: item, section: 0)

            let photoSize = delegate.collectionView(collectionView, sizeOfPhotoAtIndexPath: indexPath)

            let cellWidth = columnWidth
            var cellHeight = photoSize.height * ( cellWidth / photoSize.width )
            cellHeight = cellPadding * 2 + cellHeight
            let frame = CGRect(x: xOffest[column], y: yOffset[column], width: cellWidth, height: cellHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + cellHeight

            if numberOfColumns > 1 {
                var isColumnChanged = false
                for index in (1..<numberOfColumns).reversed() {
                    if yOffset[index] >= yOffset[index - 1] {
                        column = index - 1
                        isColumnChanged = true
                    } else {
                        break
                    }
                }

                if isColumnChanged {
                    continue
                }
            }

            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        if headerAttributes.size.height != 0 {
             visibleLayoutAttributes.append(headerAttributes)
        }
        return visibleLayoutAttributes
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String,
                                                       at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            return headerAttributes
        default:
            return nil
        }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
