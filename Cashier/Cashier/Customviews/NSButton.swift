//
//  NSButton.swift
//  Cashier
//
//  Created by Saikiran.
//  Copyright © 2016 Sample. All rights reserved.
//

import UIKit

class NSButton: UIButton {

    var indexPath : IndexPath?
    
	@IBInspectable var  cornerRadius : Int = 20
    @IBInspectable var  enableRoundedCornors : Bool = false

	override func awakeFromNib() {
		
		super.awakeFromNib()
        if enableRoundedCornors {
        self.layer.cornerRadius = self.frame.width/2;
		self.layer.borderColor = UIColor.black.cgColor;

        }
        else {
		self.layer.cornerRadius = CGFloat(cornerRadius);
			self.layer.borderColor = BORDER_COLOR.cgColor;

        }
		if cornerRadius != 0 {
			self.layer.borderWidth = 1.0;
			self.layer.shadowRadius = 1.0 ;

		}
		
	}


}
