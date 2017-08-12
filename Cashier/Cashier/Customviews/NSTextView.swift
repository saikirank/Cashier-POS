//
//  NSTextView.swift
//  Cashier
//
//  Created by Saikiran.
//  Copyright © 2016 c. All rights reserved.
//

import UIKit
@IBDesignable
class NSTextView: UITextView {

	@IBInspectable var  cornerRadius : Int = 15
	override func awakeFromNib() {
		
		super.awakeFromNib()
		
		self.layer.cornerRadius = CGFloat(cornerRadius);
		self.layer.borderWidth = 1.0;
		self.layer.borderColor = BORDER_COLOR.cgColor;
		self.layer.shadowRadius = 1.0 ;
		
	}


}
