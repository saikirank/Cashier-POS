//
//  NSReceiptCollectionLayout.swift
//  Cashier
//
//  Created by Saikiran.
//  Copyright © 2016 Sample. All rights reserved.
//

import UIKit

class NSReceiptCollectionLayout: UICollectionViewFlowLayout {

	
	var size : CGSize = CGSize.zero
	override init() {
		
		 super.init()
		self.scrollDirection = .vertical;
		self.minimumInteritemSpacing = 0; // 40;
		self.minimumLineSpacing = 0;//40;
		
	}
	
	convenience init(size: CGSize) {
		
		self.init()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	
	override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		
		let layoutAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath)
		layoutAttributes.frame = CGRect(x: 0.0, y: 0.0, width: collectionViewContentSize.width, height: collectionViewContentSize.height);
		layoutAttributes.zIndex = -1;

		return layoutAttributes
	}


}
