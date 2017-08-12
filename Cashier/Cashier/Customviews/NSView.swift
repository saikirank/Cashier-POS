//
//  NSView.swift
//  Cashier
//
//  Created by Saikiran.
//  Copyright © 2016 Sample. All rights reserved.
//

import UIKit

@IBDesignable
class NSView: UIView {

	@IBInspectable var  cornerRadius : Int = 25
	override func awakeFromNib() {
		
		super.awakeFromNib()
		
		self.layer.cornerRadius = CGFloat(cornerRadius);
		self.layer.borderWidth = 1.0;
		self.layer.borderColor = BORDER_COLOR.cgColor;
		//self.layer.shadowRadius = 1.0 ;

	}
	
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
