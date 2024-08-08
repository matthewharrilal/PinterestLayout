//
//  PinterestLayout.swift
//  PinterestLayout
//
//  Created by Space Wizard on 7/20/24.
//

import Foundation
import UIKit

class PinterestCollectionViewLayout: UICollectionViewLayout {
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private let arraySizes: [CGFloat] = [75, 100, 240, 300, 150, 77, 88, 99]

    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.bounds.width
    }
    
    override func prepare() {
        guard let collectionView = collectionView else { return }
        cache.removeAll()
        contentHeight = 0
    
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        let itemsPerRow: Int = 2
        let spacing: CGFloat = 30
        var yOffsets: [CGFloat] = [CGFloat](repeating: spacing, count: itemsPerRow)
        
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            // Column can only equate to 0 or 1 lets us know should it be on the left or the right of the screen
            let column = item % itemsPerRow
            let itemSize: CGSize = CGSize(width: UIScreen.main.bounds.width / 3, height: arraySizes.randomElement() ?? 27)
            let totalWidth = (2 * itemSize.width) + spacing
            let xOffset: CGFloat = (contentWidth - totalWidth) / 2
            let xPosition = CGFloat(column) * (itemSize.width + spacing) + xOffset
            let yPosition = yOffsets[column] // Used to track the y position for each item in the corresponding 0 or 1 column
            
            let frame = CGRect(x: xPosition, y: yPosition, width: itemSize.width, height: itemSize.height)
            attributes.frame = frame
            cache.append(attributes)

            yOffsets[column] = yOffsets[column] + itemSize.height + spacing
            contentHeight = max(frame.maxY, contentHeight) // In case the newest item added is smaller than the previous item don't want the content height to be represantive being smaller than it is
        }
    }
    
    override var collectionViewContentSize: CGSize {
        CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        cache.filter { $0.frame.intersects(rect) }
    }
}
