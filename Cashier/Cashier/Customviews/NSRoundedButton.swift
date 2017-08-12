//
//  NSRoundedButton.swift
//  Cashier
//
//  Created by sample on 22/10/16.
//  Copyright © 2016 sample. All rights reserved.
//

import UIKit

class NSRoundedButton: UIButton {

	override func awakeFromNib() {
		
		super.awakeFromNib()
		
		self.layer.cornerRadius = self.frame.width/2;

		self.layer.borderWidth = 1.0;
		self.layer.shadowRadius = 1.0 ;
		self.layer.borderColor = UIColor.black.cgColor
		self.backgroundColor = UIColor.red
	}
	

}
