//
//  NSCustomCell.swift
//  Cashier
//
//  Created by Saikiran .
//  Copyright © 2016 Sample. All rights reserved.
//

import UIKit

class NSCustomCell: UICollectionViewCell {
	
	var isHeightCalculated : Bool = false
	
	@IBOutlet var label: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		//self.layer.borderWidth = 1.0
		

		
	}
	
	func addRightBorder()  {
		
		let layer = CALayer()
		layer.frame = CGRect(x: self.frame.size.width-1, y: 0, width: 1, height: self.frame.height);
		layer.backgroundColor = UIColor(colorLiteralRed: 104/255.0, green: 129/255.0, blue: 152/255.0, alpha: 1.0).cgColor

		//self.layer.addSublayer(layer)

	}
	
	override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
		//Exhibit A - We need to cache our calculation to prevent a crash.
	

		if !isHeightCalculated  && false {
			setNeedsLayout()
			layoutIfNeeded()
			let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
			var newFrame = layoutAttributes.frame
			newFrame.size.height = CGFloat(ceilf(Float(size.height)))
			//layoutAttributes.frame = newFrame
			
			let maximumLabelSize = CGSize(width: label.frame.width, height: CGFloat.greatestFiniteMagnitude)
			
			let reqsize = label.sizeThatFits(maximumLabelSize)
			
			if reqsize.height > label.frame.size.height {
				newFrame.size.height = CGFloat(ceilf(Float(reqsize.height)))
				layoutAttributes.frame = newFrame

			}
			
			
			
			isHeightCalculated = true

		}
		return layoutAttributes
	}
	
	
	

}
